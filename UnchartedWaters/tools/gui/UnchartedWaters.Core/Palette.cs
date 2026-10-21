namespace UnchartedWaters.Core;

/// <summary>
/// The SNES colour format and the palette helpers around it.
///
/// A colour is stored as 15 bits: five bits of blue, five of green and
/// five of red, in the order 0bbbbggggrrrrrrrr.
///
/// The cartridge keeps the colours of a palette as sixteen 16 bit words.
/// The game writes them into the CGRAM low byte first, so in the ROM they
/// are stored little endian.
/// </summary>
public static class Palette
{
    /// <summary>Number of entries in the CGRAM.</summary>
    public const int CgramEntries = 256;

    /// <summary>Number of colours in one palette.</summary>
    public const int Entries = 16;

    /// <summary>Size of one palette in bytes.</summary>
    public const int Size = Entries * 2;

    /// <summary>Convert a 15 bit BGR555 value into 8 bit components.</summary>
    public static (byte R, byte G, byte B) Decode(int bgr555)
    {
        var r = (bgr555 & 0x1F) << 3;
        var g = (bgr555 >> 5 & 0x1F) << 3;
        var b = (bgr555 >> 10 & 0x1F) << 3;
        return ((byte)r, (byte)g, (byte)b);
    }

    /// <summary>Convert 8 bit components into a 15 bit BGR555 value.</summary>
    public static int Encode(byte r, byte g, byte b) =>
        (r >> 3) | ((g >> 3) << 5) | ((b >> 3) << 10);

    /// <summary>
    /// Read one palette out of the cartridge.
    /// </summary>
    /// <param name="rom">The image.</param>
    /// <param name="offset">File offset of the palette.</param>
    /// <remarks>
    /// The words are little endian, the game writes the low byte of a
    /// colour into the CGRAM before the high one.
    /// </remarks>
    public static (byte R, byte G, byte B)[] ReadPalette(RomImage rom, int offset)
    {
        var colors = new (byte R, byte G, byte B)[Entries];
        for (var i = 0; i < Entries; i++)
        {
            colors[i] = Decode(rom.ReadWordLE(offset + i * 2));
        }

        return colors;
    }

    /// <summary>
    /// Write one palette back into the cartridge.
    /// </summary>
    /// <param name="rom">The image.</param>
    /// <param name="offset">File offset of the palette.</param>
    /// <param name="colors">The sixteen colours to write.</param>
    public static void WritePalette(RomImage rom, int offset, IReadOnlyList<(byte R, byte G, byte B)> colors)
    {
        for (var i = 0; i < colors.Count && i < Entries; i++)
        {
            var (r, g, b) = colors[i];
            rom.WriteWordLE(offset + i * 2, (ushort)Encode(r, g, b));
        }
    }

    /// <summary>
    /// Pack 8 bit colour components into an opaque 32 bit ARGB value.
    /// </summary>
    /// <remarks>
    /// The components are widened to <see cref="uint"/> before they are
    /// shifted, otherwise the compiler would sign extend them and the top
    /// bit of the red channel would end up in the alpha channel.
    /// </remarks>
    public static uint PackArgb(byte r, byte g, byte b) =>
        0xFF000000u | ((uint)r << 16) | ((uint)g << 8) | b;

    /// <summary>Read the CGRAM out of a ROM image.</summary>
    /// <param name="rom">The image.</param>
    /// <param name="offset">File offset of the CGRAM data.</param>
    /// <param name="count">How many colours to read.</param>
    public static (byte R, byte G, byte B)[] ReadCgram(RomImage rom, int offset, int count)
    {
        var colors = new (byte R, byte G, byte B)[count];
        for (var i = 0; i < count; i++)
        {
            var value = rom.ReadWord(offset + i * 2);
            colors[i] = Decode(value);
        }

        return colors;
    }

    /// <summary>Write a colour back into the CGRAM.</summary>
    public static void WriteCgram(RomImage rom, int offset, int index, byte r, byte g, byte b) =>
        rom.WriteWord(offset + index * 2, (ushort)Encode(r, g, b));

    /// <summary>
    /// Build the four shades of a 2bpp palette entry from a 15 bit colour.
    /// </summary>
    /// <remarks>
    /// The hardware scales the five bit components of the CGRAM up to the
    /// full range, so the darker shades are the colour multiplied by a
    /// quarter, a half and three quarters.
    /// </remarks>
    public static (byte R, byte G, byte B)[] Shades(byte r, byte g, byte b)
    {
        static byte Scale(byte value, int numerator) => (byte)(value * numerator / 255);

        return new[]
        {
            (r: Scale(r, 85), g: Scale(g, 85), b: Scale(b, 85)),
            (r: Scale(r, 170), g: Scale(g, 170), b: Scale(b, 170)),
            (r: r, g: g, b: b),
            (r: (byte)255, g: (byte)255, b: (byte)255),
        };
    }
}
