using UnchartedWaters.Core;
using Xunit;

namespace UnchartedWaters.Core.Tests;

public class SnesGraphicsTests
{
    [Theory]
    [InlineData(BitsPerPixel.Two, 16)]
    [InlineData(BitsPerPixel.Four, 32)]
    [InlineData(BitsPerPixel.Eight, 64)]
    public void KnowsTheSizeOfATile(BitsPerPixel bpp, int expected)
    {
        Assert.Equal(expected, SnesGraphics.TileSize(bpp));
    }

    [Theory]
    [InlineData(BitsPerPixel.Two, 4)]
    [InlineData(BitsPerPixel.Four, 16)]
    [InlineData(BitsPerPixel.Eight, 256)]
    public void KnowsTheNumberOfShades(BitsPerPixel bpp, int expected)
    {
        Assert.Equal(expected, SnesGraphics.Shades(bpp));
    }

    [Fact]
    public void DecodesTwoBitPixelsFromTwoPlanes()
    {
        // The first row of the low plane is 0b10100000 and the matching row
        // of the high plane is 0b10000000, so the row reads 3, 0, 1, 0, 0, 0, 0, 0.
        var data = new byte[16];
        data[0] = 0b10100000;
        data[8] = 0b10000000;

        var tiles = SnesGraphics.DecodeTiles(data, BitsPerPixel.Two, 1);

        Assert.Single(tiles);
        Assert.Equal(new byte[] { 3, 0, 1, 0, 0, 0, 0, 0 }, tiles[0][..8]);
    }

    [Fact]
    public void DecodesFourBitPixelsFromTwoPlanes()
    {
        // Inside a plane four pixels share a byte, so the first byte of the
        // low plane holds the first four pixels of the row.
        var data = new byte[32];
        data[0] = 0b00011011;
        data[16] = 0b00001100;

        var tiles = SnesGraphics.DecodeTiles(data, BitsPerPixel.Four, 1);

        Assert.Single(tiles);
        //  low  0b00, 0b01, 0b10, 0b11  -> 0, 1, 2, 3
        //  high 0b00, 0b00, 0b11, 0b00  -> 0, 0, 12, 0
        Assert.Equal(new byte[] { 0, 1, 14, 3, 0, 0, 0, 0 }, tiles[0][..8]);
    }

    [Fact]
    public void DecodesEightBitPixelsOneByteAtATime()
    {
        var data = new byte[64];
        for (var i = 0; i < 64; i++)
        {
            data[i] = (byte)i;
        }

        var tiles = SnesGraphics.DecodeTiles(data, BitsPerPixel.Eight, 1);

        Assert.Single(tiles);
        Assert.Equal(Enumerable.Range(0, 64).Select(i => (byte)i).ToArray(), tiles[0]);
    }

    [Fact]
    public void KeepsThePlanesOfEachTileApart()
    {
        // A 2bpp tile is 16 bytes, so the second tile starts at byte 16.
        var data = new byte[32];
        data[0] = 0xFF;   // first tile, low plane
        data[16] = 0x0F;  // second tile, low plane

        var tiles = SnesGraphics.DecodeTiles(data, BitsPerPixel.Two, 2);

        Assert.Equal(2, tiles.Length);
        Assert.All(tiles[0][..8], v => Assert.Equal(1, v));
        Assert.Equal(new byte[] { 0, 0, 0, 0, 1, 1, 1, 1 }, tiles[1][..8]);
    }

    [Fact]
    public void StopsWhenTheDataRunsOut()
    {
        var data = new byte[20];

        var tiles = SnesGraphics.DecodeTiles(data, BitsPerPixel.Four, 4);

        Assert.Equal(4, tiles.Length);
        Assert.Null(tiles[1]);
    }

    [Fact]
    public void ComposesTilesIntoASheet()
    {
        var tiles = new[]
        {
            Enumerable.Repeat((byte)1, 64).ToArray(),
            Enumerable.Repeat((byte)2, 64).ToArray(),
        };

        var sheet = SnesGraphics.ComposeTiles(tiles, 2, 1);

        // Two columns of eight pixels and one row of eight pixels.
        Assert.Equal(16 * 8, sheet.Length);
        Assert.All(sheet[0..8], v => Assert.Equal(1, v));
        Assert.All(sheet[8..16], v => Assert.Equal(2, v));
    }
}
