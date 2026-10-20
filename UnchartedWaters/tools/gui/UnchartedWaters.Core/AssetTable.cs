namespace UnchartedWaters.Core;

/// <summary>One named block of data inside the cartridge.</summary>
/// <param name="Name">The name the game uses for the block.</param>
/// <param name="Bank">The LoROM bank the data lives in.</param>
/// <param name="Address">The CPU address the data starts at inside the bank.</param>
/// <param name="Length">The size of the block in bytes.</param>
/// <param name="Flags">The last field of the record; its meaning is not known yet.</param>
public sealed record AssetEntry(
    string Name,
    int Bank,
    int Address,
    int Length,
    int Flags)
{
    /// <summary>Where the block starts inside the ROM image.</summary>
    public int FileOffset => RomImage.ToOffset(Bank, Address);

    /// <summary>Where the block ends (exclusive) inside the ROM image.</summary>
    public int EndOffset => FileOffset + Length;

    /// <summary>A short description of the block.</summary>
    public string Describe() =>
        $"bank ${Format.Hex(Bank, 2)} ${Format.Hex(Address, 4)} " +
        $"${Format.Hex(Length, 5)} bytes  file ${Format.Hex(FileOffset, 6)}";
}

/// <summary>
/// The table of named data blocks the cartridge keeps at bank $00, $F800.
///
/// Every record is 16 bytes long:
///
///     0   8 bytes   the name, NUL padded ASCII
///     8   2 bytes   the ROM bank the data lives in
///    10   2 bytes   the CPU address inside that bank
///    12   2 bytes   the length in bytes
///    14   2 bytes   flags
///
/// The numeric fields are stored little endian, which is unusual for an
/// SNES cartridge but is what the game uses.
///
/// The game looks a block up by name, so the names are the only stable
/// identifiers the cartridge offers.
/// </summary>
public static class AssetTable
{
    /// <summary>File offset of the table (bank $00, CPU $F800).</summary>
    public const int TableOffset = 0x7800;

    /// <summary>Size of one record.</summary>
    public const int RecordSize = 16;

    /// <summary>Maximum number of records the table can hold.</summary>
    public const int MaxRecords = 38;

    /// <summary>Read the table out of a ROM image.</summary>
    public static IReadOnlyList<AssetEntry> Parse(RomImage rom)
    {
        var assets = new List<AssetEntry>();
        var data = rom.Data;

        for (var index = 0; index < MaxRecords; index++)
        {
            var baseOffset = TableOffset + index * RecordSize;
            if (baseOffset + RecordSize > data.Length)
            {
                break;
            }

            var name = ReadName(data, baseOffset);
            if (name.Length == 0)
            {
                break;
            }

            var bank = ReadWordLE(data, baseOffset + 8);
            var address = ReadWordLE(data, baseOffset + 10);
            var length = ReadWordLE(data, baseOffset + 12);
            var flags = ReadWordLE(data, baseOffset + 14);

            assets.Add(new AssetEntry(name, bank, address, length, flags));
        }

        return assets;
    }

    private static int ReadWordLE(ReadOnlySpan<byte> data, int offset) =>
        data[offset] | (data[offset + 1] << 8);

    private static string ReadName(ReadOnlySpan<byte> data, int baseOffset)
    {
        var span = data.Slice(baseOffset, 8);
        var end = span.IndexOf((byte)0);
        if (end < 0)
        {
            end = span.Length;
        }

        return System.Text.Encoding.ASCII.GetString(span[..end]);
    }

    /// <summary>Find a block by its name.</summary>
    public static AssetEntry? Find(IReadOnlyList<AssetEntry> assets, string name) =>
        assets.FirstOrDefault(a => string.Equals(a.Name, name, StringComparison.Ordinal));
}
