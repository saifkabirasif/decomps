using System.Text;

namespace UnchartedWaters.Core;

/// <summary>One NUL terminated string inside a block of the cartridge.</summary>
/// <param name="Offset">File offset of the first character.</param>
/// <param name="Text">The text itself, without the terminator.</param>
/// <param name="Raw">
/// The bytes of the entry as they stand in the cartridge.  Next to the
/// text there can be control codes: an escape byte $1B followed by one
/// command byte.  They belong to the entry but not to the text.
/// </param>
public sealed record TextEntry(int Offset, string Text, string Raw)
{
    /// <summary>The length of the text in bytes, without the terminator.</summary>
    public int TextLength => Encoding.Latin1.GetByteCount(Text);

    /// <summary>
    /// The length of the whole entry in bytes, text and control codes.
    /// </summary>
    public int Length => Raw.Length;

    /// <summary>How many of the bytes are control codes.</summary>
    public int ControlLength => Raw.Length - TextLength;

    /// <summary>The text with the control codes shown as they are.</summary>
    public string WithControlCodes => Raw.Replace("\r", "\\r").Replace("\n", "\\n");
}

/// <summary>
/// Finds the readable strings inside a block of the cartridge.
///
/// The game keeps its text in the clear.  A string is a run of text that
/// ends with a NUL byte.  Inside the run there can be
///
/// <list type="bullet">
/// <item>a line break, $0A,</item>
/// <item>a control code: the escape byte $1B followed by one command byte.</item>
/// </list>
///
/// The control codes are commands of the script, for example a change of
/// colour or a wait, so they are kept when a string is edited.
///
/// The strings live in the script blocks of the cartridge, so the dialogue
/// of the game can be read and changed with this.
/// </summary>
public static class TextScanner
{
    /// <summary>The byte that starts a control code.</summary>
    public const byte Escape = 0x1B;

    /// <summary>The byte that ends a string.</summary>
    public const byte Terminator = 0x00;

    /// <summary>Is this byte part of the text of a string?</summary>
    public static bool IsTextByte(byte value) =>
        value == 0x0A || (value >= 0x20 && value < 0x7F);

    /// <summary>
    /// Does the text look like words and not like a piece of the script?
    /// </summary>
    /// <remarks>
    /// The script is a stream of bytes that often happens to be printable,
    /// so a run of text only counts when it holds two letters next to each
    /// other.  That keeps the runs of the script out of the list.
    /// </remarks>
    public static bool LooksLikeText(string text)
    {
        var previousWasLetter = false;

        foreach (var c in text)
        {
            var isLetter = c is >= 'A' and <= 'Z' or >= 'a' and <= 'z';

            if (isLetter && previousWasLetter)
            {
                return true;
            }

            previousWasLetter = isLetter;
        }

        return false;
    }

    /// <summary>Scan a block for NUL terminated runs of text.</summary>
    /// <param name="rom">The image.</param>
    /// <param name="start">File offset of the first byte to look at.</param>
    /// <param name="length">How many bytes to look at.</param>
    /// <param name="minimumLength">Shortest run of text that counts as a string.</param>
    /// <param name="wordsOnly">
    /// Only report runs that hold two letters next to each other.  That
    /// keeps the runs of the script out of the list.
    /// </param>
    public static IReadOnlyList<TextEntry> Scan(
        RomImage rom,
        int start,
        int length,
        int minimumLength = 3,
        bool wordsOnly = true)
    {
        var results = new List<TextEntry>();
        var data = rom.Data;
        var end = Math.Min(start + length, data.Length);

        var at = start;
        while (at < end)
        {
            if (!IsTextByte(data[at]))
            {
                at++;
                continue;
            }

            var runStart = at;
            var text = new StringBuilder();
            var raw = new List<byte>();

            while (at < end)
            {
                var value = data[at];

                if (value == Escape && at + 1 < end)
                {
                    // A control code: the escape byte and the command byte.
                    raw.Add(value);
                    raw.Add(data[at + 1]);
                    at += 2;
                    continue;
                }

                if (IsTextByte(value))
                {
                    text.Append((char)value);
                    raw.Add(value);
                    at++;
                    continue;
                }

                break;
            }

            // A string has to end with a NUL, otherwise the run is just a
            // piece of the script.
            if (at < end && data[at] == Terminator && text.Length >= minimumLength)
            {
                var content = text.ToString();
                if (!wordsOnly || LooksLikeText(content))
                {
                    results.Add(new TextEntry(runStart, content, Encoding.Latin1.GetString(raw.ToArray())));
                }
            }
        }

        return results;
    }

    /// <summary>Replace the text of a string, keeping its control codes.</summary>
    /// <remarks>
    /// The new text is written over the old one, character by character,
    /// and the control codes of the entry stay where they are.  The text
    /// may not be longer than the old one; a longer string would push the
    /// rest of the block out of the way and the script would break.
    /// </remarks>
    public static bool Replace(RomImage rom, TextEntry entry, string text)
    {
        var data = rom.WritableData;
        var newBytes = Encoding.Latin1.GetBytes(text);
        var raw = Encoding.Latin1.GetBytes(entry.Raw);

        // How many characters of the text there are room for.
        var slots = 0;
        for (var i = 0; i < raw.Length; i++)
        {
            if (raw[i] == Escape)
            {
                // The escape and the command byte belong together.
                i++;
                continue;
            }

            if (IsTextByte(raw[i]))
            {
                slots++;
            }
        }

        if (newBytes.Length > slots)
        {
            return false;
        }

        var written = new byte[raw.Length];
        var taken = 0;
        for (var i = 0; i < raw.Length; i++)
        {
            if (raw[i] == Escape && i + 1 < raw.Length)
            {
                written[i] = raw[i];
                written[i + 1] = raw[i + 1];
                i++;
                continue;
            }

            if (IsTextByte(raw[i]))
            {
                // A shorter text is padded with spaces so that the string
                // keeps its length.
                written[i] = taken < newBytes.Length ? newBytes[taken] : (byte)' ';
                taken++;
            }
            else
            {
                written[i] = raw[i];
            }
        }

        written.CopyTo(data.AsSpan(entry.Offset));
        return true;
    }
}
