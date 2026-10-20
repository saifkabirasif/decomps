using System.Text;

namespace UnchartedWaters.Core;

/// <summary>One NUL terminated string inside a block of the cartridge.</summary>
/// <param name="Offset">File offset of the first character.</param>
/// <param name="Text">The text itself, without the terminator.</param>
public sealed record TextEntry(int Offset, string Text)
{
    /// <summary>The length of the text in bytes, without the terminator.</summary>
    public int Length => Encoding.Latin1.GetByteCount(Text);
}

/// <summary>
/// Finds the readable strings inside a block of the cartridge.
///
/// The "fdata" block of the cartridge holds the metrics of the proportional
/// font followed by the names of the characters and the places of the game,
/// each one NUL terminated.  The scanner is deliberately generic so that it
/// can be pointed at any block.
/// </summary>
public static class TextScanner
{
    /// <summary>Scan a block for NUL terminated runs of printable text.</summary>
    /// <param name="rom">The image.</param>
    /// <param name="start">File offset of the first byte to look at.</param>
    /// <param name="length">How many bytes to look at.</param>
    /// <param name="minimumLength">Shortest run that counts as a string.</param>
    public static IReadOnlyList<TextEntry> Scan(
        RomImage rom,
        int start,
        int length,
        int minimumLength = 2)
    {
        var results = new List<TextEntry>();
        var data = rom.Data;
        var end = Math.Min(start + length, data.Length);

        var runStart = -1;
        for (var offset = start; offset < end; offset++)
        {
            var value = data[offset];
            var printable = value is >= 0x20 and < 0x7F;

            if (printable)
            {
                if (runStart < 0)
                {
                    runStart = offset;
                }

                continue;
            }

            if (runStart >= 0)
            {
                var runLength = offset - runStart;
                if (value == 0 && runLength >= minimumLength)
                {
                    results.Add(new TextEntry(
                        runStart,
                        Encoding.Latin1.GetString(data.Slice(runStart, runLength))));
                }

                runStart = -1;
            }
        }

        return results;
    }

    /// <summary>Replace the text of a string, keeping it NUL terminated.</summary>
    /// <remarks>
    /// The cartridge refers to the strings by their address, so a string may
    /// only grow into the space that is free after it.  The new text is
    /// written in place and the old terminator is moved along.
    /// </remarks>
    public static bool Replace(RomImage rom, TextEntry entry, string text)
    {
        var data = rom.WritableData;
        var bytes = Encoding.Latin1.GetBytes(text);
        var terminator = entry.Offset + entry.Length;
        if (terminator >= data.Length || data[terminator] != 0)
        {
            return false;
        }

        // Find out how much room there is before the next non empty string.
        // The run of zeros that starts at the old terminator is the space
        // the new string may use.
        var limit = terminator + 1;
        while (limit < data.Length && data[limit] == 0)
        {
            limit++;
        }

        // The new text needs its own terminator, so it has to fit in the
        // room up to (but not including) the next string.
        if (bytes.Length + 1 > limit - entry.Offset)
        {
            return false;
        }

        bytes.CopyTo(data.AsSpan(entry.Offset));
        for (var i = entry.Offset + bytes.Length; i < limit; i++)
        {
            data[i] = 0;
        }

        data[entry.Offset + bytes.Length] = 0;
        return true;
    }
}
