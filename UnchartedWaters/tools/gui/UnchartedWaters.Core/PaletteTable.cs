namespace UnchartedWaters.Core;

/// <summary>
/// The palettes of the cartridge.
///
/// A palette is sixteen 15 bit colours stored little endian, so 32
/// bytes.  The palettes are kept one after the other; an unused palette
/// is sixteen zero words.
///
/// An unused palette and the padding that fills the rest of the
/// cartridge look alike, so the empty rows at the two ends of a run are
/// trimmed before the run is judged.  A table may still hold empty rows
/// in its middle.
/// </summary>
public static class PaletteTable
{
    /// <summary>A table has to hold at least this many palettes.</summary>
    private const int MinRows = 8;

    /// <summary>A table has to hold at least this many used palettes.</summary>
    private const int MinUsed = 4;

    /// <summary>One palette of a table.</summary>
    /// <param name="Index">Where it sits in the table.</param>
    /// <param name="Offset">Its file offset in the cartridge.</param>
    public sealed record Slot(int Index, int Offset);

    /// <summary>A run of palettes in the cartridge.</summary>
    /// <param name="Start">File offset of the first palette.</param>
    /// <param name="End">File offset just past the last palette.</param>
    /// <param name="Palettes">The palettes of the run.</param>
    /// <param name="Used">How many palettes of the run are used.</param>
    public sealed record Found(int Start, int End, IReadOnlyList<Slot> Palettes, int Used);

    /// <summary>Find the palettes of the cartridge, longest table first.</summary>
    public static IReadOnlyList<Found> Find(RomImage rom)
    {
        var data = rom.Data;
        var tables = new List<Found>();

        var offset = 0;
        while (offset + Palette.Size <= data.Length)
        {
            if (!IsPaletteLike(data, offset))
            {
                offset += 2;
                continue;
            }

            var start = offset;
            while (offset + Palette.Size <= data.Length && IsPaletteLike(data, offset))
            {
                offset += Palette.Size;
            }

            var end = offset;

            // Trim the empty rows at the two ends of the run.
            while (start < end && IsEmpty(data, start))
            {
                start += Palette.Size;
            }

            while (end > start && IsEmpty(data, end - Palette.Size))
            {
                end -= Palette.Size;
            }

            var count = (end - start) / Palette.Size;
            var used = 0;
            for (var i = 0; i < count; i++)
            {
                if (!IsEmpty(data, start + i * Palette.Size))
                {
                    used++;
                }
            }

            if (count >= MinRows && used >= MinUsed)
            {
                var slots = new List<Slot>(count);
                for (var i = 0; i < count; i++)
                {
                    slots.Add(new Slot(i, start + i * Palette.Size));
                }

                tables.Add(new Found(start, end, slots, used));
            }
        }

        tables.Sort((a, b) => b.Palettes.Count.CompareTo(a.Palettes.Count));
        return tables;
    }

    /// <summary>Could the bytes at this offset be a palette?</summary>
    private static bool IsPaletteLike(ReadOnlySpan<byte> data, int offset)
    {
        if (offset < 0 || offset + Palette.Size > data.Length)
        {
            return false;
        }

        if (data[offset] != 0 || data[offset + 1] != 0)
        {
            return false;
        }

        for (var i = 0; i < Palette.Entries; i++)
        {
            var word = data[offset + i * 2] | (data[offset + i * 2 + 1] << 8);
            if (word > 0x7FFF)
            {
                return false;
            }
        }

        return true;
    }

    /// <summary>Is this palette sixteen zero words?</summary>
    private static bool IsEmpty(ReadOnlySpan<byte> data, int offset)
    {
        for (var i = 0; i < Palette.Size; i++)
        {
            if (data[offset + i] != 0)
            {
                return false;
            }
        }

        return true;
    }

    /// <summary>Read the colours of a palette of the table.</summary>
    public static (byte R, byte G, byte B)[] Read(RomImage rom, Slot slot) =>
        Palette.ReadPalette(rom, slot.Offset);

    /// <summary>Write the colours of a palette of the table.</summary>
    public static void Write(RomImage rom, Slot slot, IReadOnlyList<(byte R, byte G, byte B)> colours) =>
        Palette.WritePalette(rom, slot.Offset, colours);
}
