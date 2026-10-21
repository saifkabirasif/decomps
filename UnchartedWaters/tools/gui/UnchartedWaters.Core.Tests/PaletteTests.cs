using UnchartedWaters.Core;
using Xunit;

namespace UnchartedWaters.Core.Tests;

public class PaletteTests
{
    [Fact]
    public void DecodesA15BitColour()
    {
        var (r, g, b) = Palette.Decode(0x7FFF);

        Assert.Equal(0xF8, r);
        Assert.Equal(0xF8, g);
        Assert.Equal(0xF8, b);
    }

    [Fact]
    public void EncodesAndDecodesBackToTheSameColour()
    {
        var encoded = Palette.Encode(0xE4, 0xA4, 0x64);
        var (r, g, b) = Palette.Decode(encoded);

        Assert.Equal(0xE0, r);
        Assert.Equal(0xA0, g);
        Assert.Equal(0x60, b);
    }

    [Fact]
    public void PacksAColourIntoAnOpaqueArgbValue()
    {
        Assert.Equal(0xFF112233u, Palette.PackArgb(0x11, 0x22, 0x33));
    }

    [Fact]
    public void ReadsAPaletteLittleEndian()
    {
        // The game writes the low byte of a colour into the CGRAM before
        // the high one, so the words sit in the ROM the other way round.
        var data = new byte[Palette.Size];
        data[0] = 0xFF;
        data[1] = 0x7F;

        var rom = new RomImage(data);
        var colors = Palette.ReadPalette(rom, 0);

        Assert.Equal(16, colors.Length);
        Assert.Equal((0xF8, 0xF8, 0xF8), colors[0]);
    }

    [Fact]
    public void WritesAPaletteBackLittleEndian()
    {
        var data = new byte[Palette.Size];
        var rom = new RomImage(data);

        var colors = new (byte R, byte G, byte B)[Palette.Entries];
        colors[3] = (0xE4, 0xA4, 0x64);
        Palette.WritePalette(rom, 0, colors);

        // The low byte comes first.
        Assert.Equal(Palette.Encode(0xE4, 0xA4, 0x64) & 0xFF, data[6]);
        Assert.Equal(Palette.Encode(0xE4, 0xA4, 0x64) >> 8, data[7]);
    }

    [Fact]
    public void APaletteRoundTrips()
    {
        var rom = new RomImage(new byte[Palette.Size]);

        // The CGRAM only holds five bits per channel, so the colours have
        // to be ones the hardware can show.
        var colors = new (byte R, byte G, byte B)[Palette.Entries];
        for (var i = 0; i < colors.Length; i++)
        {
            colors[i] = ((byte)(i * 8), (byte)(248 - i * 8), (byte)(i * 8));
        }

        Palette.WritePalette(rom, 0, colors);
        var read = Palette.ReadPalette(rom, 0);

        Assert.Equal(colors, read);
    }
}
