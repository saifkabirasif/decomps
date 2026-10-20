namespace UnchartedWaters.Core;

/// <summary>
/// The header every named block of the cartridge starts with.
///
/// All 38 blocks of the asset table begin with the two bytes
/// <c>4C 03</c>.  What follows tells what kind of block it is:
///
/// <list type="bullet">
/// <item>
/// A block whose next two bytes are zero holds raw data: the sprite
/// graphics (<c>sgdata</c>), the font and the character names
/// (<c>fdata</c>), the character map (<c>cbmap0</c>) and the sprite
/// definitions (<c>kdata</c>).  The bytes can be used as they are.
/// </item>
/// <item>
/// Every other block holds a script.  Those blocks store their payload in
/// the cartridge's own encoded form, so their bytes are neither graphics
/// nor text and cannot be edited directly.
/// </item>
/// </list>
///
/// The script blocks are the majority: the <c>s_*</c> blocks are the
/// dialogue and the event scripts, and <c>root</c>, <c>initop</c> and
/// friends are the chapter and event logic.
/// </summary>
public static class AssetHeader
{
    /// <summary>The two bytes every block starts with.</summary>
    public static ReadOnlySpan<byte> Magic => new byte[] { 0x4C, 0x03 };

    /// <summary>Size of the magic.</summary>
    public const int MagicSize = 2;

    /// <summary>
    /// Check whether a block starts with the magic.
    /// </summary>
    /// <param name="data">The start of the block.</param>
    public static bool HasMagic(ReadOnlySpan<byte> data) =>
        data.Length >= MagicSize && data[..MagicSize].SequenceEqual(Magic);

    /// <summary>
    /// Read the header of a block.
    /// </summary>
    /// <param name="rom">The image.</param>
    /// <param name="offset">File offset of the block.</param>
    public static AssetHeaderInfo Parse(RomImage rom, int offset)
    {
        var data = rom.Data;

        if (offset < 0 || offset + MagicSize > data.Length ||
            !HasMagic(data.Slice(offset, MagicSize)))
        {
            return new AssetHeaderInfo(offset, false, false, MagicSize);
        }

        // The two bytes after the magic are zero for the raw blocks.
        var raw = offset + 4 <= data.Length &&
                  data[offset + 2] == 0 &&
                  data[offset + 3] == 0;

        return new AssetHeaderInfo(offset, true, raw, MagicSize);
    }
}

/// <summary>What the header of a block says about its content.</summary>
/// <param name="Offset">File offset of the block.</param>
/// <param name="HasMagic">Whether the block starts with the magic.</param>
/// <param name="IsRaw">Whether the block holds raw, directly usable data.</param>
/// <param name="HeaderSize">How many bytes the header takes up.</param>
public sealed record AssetHeaderInfo(int Offset, bool HasMagic, bool IsRaw, int HeaderSize)
{
    /// <summary>A short description for the editor.</summary>
    public string Describe() => !HasMagic
        ? "no header"
        : IsRaw
            ? "raw data"
            : "encoded script";
}
