namespace UnchartedWaters.Core;

/// <summary>
/// The cartridge image of "Uncharted Waters" (USA).
///
/// The game is a 1 MiB LoROM cartridge: 32 banks of 32 KiB, with bank N
/// mapped at $N:8000-$FFFF.  The mapping was verified against the
/// cartridge's own header and by comparing the emulator's view of memory
/// with the file image.
/// </summary>
public sealed class RomImage
{
    /// <summary>Size of one LoROM bank in bytes.</summary>
    public const int BankSize = 0x8000;

    private readonly byte[] _data;

    public RomImage(byte[] data)
    {
        _data = data;
    }

    /// <summary>The raw ROM bytes.</summary>
    public ReadOnlySpan<byte> Data => _data;

    /// <summary>
    /// The raw ROM bytes with write access.  The editor edits the image in
    /// place and writes it back when the user saves.
    /// </summary>
    public byte[] WritableData => _data;

    /// <summary>The number of 32 KiB banks in the image.</summary>
    public int BankCount => _data.Length / BankSize;

    /// <summary>Load an image from disk.</summary>
    public static RomImage Load(string path) => new(File.ReadAllBytes(path));

    /// <summary>Write the image to disk.</summary>
    public void Save(string path) => File.WriteAllBytes(path, _data);

    /// <summary>Convert a bank/address pair into a file offset.</summary>
    public static int ToOffset(int bank, int address)
    {
        if (address < 0x8000)
        {
            throw new ArgumentOutOfRangeException(
                nameof(address),
                "LoROM only maps $8000-$FFFF to the cartridge");
        }

        return bank * BankSize + (address - 0x8000);
    }

    /// <summary>The bank a file offset belongs to.</summary>
    public static int ToBank(int offset) => offset / BankSize;

    /// <summary>The CPU address a file offset is mapped at.</summary>
    public static int ToAddress(int offset) => 0x8000 + (offset % BankSize);

    /// <summary>Format a file offset the way the tools do.</summary>
    public static string DescribeOffset(int offset) =>
        $"bank ${ToBank(offset):02X}:${ToAddress(offset):04X}";

    /// <summary>Read a big endian 16 bit word.</summary>
    public ushort ReadWord(int offset) =>
        (ushort)((_data[offset] << 8) | _data[offset + 1]);

    /// <summary>Read a little endian 16 bit word.</summary>
    public ushort ReadWordLE(int offset) =>
        (ushort)(_data[offset] | (_data[offset + 1] << 8));

    /// <summary>Write a big endian 16 bit word.</summary>
    public void WriteWord(int offset, ushort value)
    {
        _data[offset] = (byte)(value >> 8);
        _data[offset + 1] = (byte)value;
    }

    /// <summary>Write a little endian 16 bit word.</summary>
    public void WriteWordLE(int offset, ushort value)
    {
        _data[offset] = (byte)value;
        _data[offset + 1] = (byte)(value >> 8);
    }
}
