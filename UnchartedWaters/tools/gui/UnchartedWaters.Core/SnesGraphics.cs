namespace UnchartedWaters.Core;

/// <summary>How many bits a tile uses per pixel.</summary>
public enum BitsPerPixel
{
    /// <summary>2bpp: 16 bytes per tile, 4 shades.</summary>
    Two = 2,

    /// <summary>4bpp: 32 bytes per tile, 16 shades.</summary>
    Four = 4,

    /// <summary>8bpp: 64 bytes per tile, 256 shades.</summary>
    Eight = 8,
}

/// <summary>
/// Decoder for the SNES tile formats.
///
/// The hardware stores 2bpp and 4bpp tiles as bit planes: the low plane of
/// all 64 pixels first, then the high plane.  Within a plane the pixels are
/// stored row by row from the top left to the bottom right, and the leftmost
/// pixel of a row sits in the most significant bits of its byte.  8bpp tiles
/// have no planes, they simply store one byte per pixel.
/// </summary>
public static class SnesGraphics
{
    /// <summary>The size of one tile in bytes.</summary>
    public static int TileSize(BitsPerPixel bpp) => bpp switch
    {
        BitsPerPixel.Two => 16,
        BitsPerPixel.Four => 32,
        BitsPerPixel.Eight => 64,
        _ => throw new ArgumentOutOfRangeException(nameof(bpp)),
    };

    /// <summary>The number of shades a tile format has.</summary>
    public static int Shades(BitsPerPixel bpp) => bpp switch
    {
        BitsPerPixel.Two => 4,
        BitsPerPixel.Four => 16,
        BitsPerPixel.Eight => 256,
        _ => throw new ArgumentOutOfRangeException(nameof(bpp)),
    };

    /// <summary>
    /// Decode a run of tiles into 8 bit index values, one byte per pixel.
    /// </summary>
    /// <param name="data">The tile data.</param>
    /// <param name="bpp">The format of the tiles.</param>
    /// <param name="tileCount">How many tiles to decode.</param>
    /// <returns>
    /// An array of <c>tileCount</c> tiles, each 64 bytes of palette indices.
    /// </returns>
    /// <remarks>
    /// The three formats store the pixels differently:
    ///
    /// <list type="bullet">
    /// <item>
    /// 2bpp is 16 bytes: two bit planes of eight bytes.  A plane holds one
    /// bit per pixel, so the eight pixels of a row share a single byte.
    /// </item>
    /// <item>
    /// 4bpp is 32 bytes: two bit planes of sixteen bytes, two bits per pixel
    /// in each plane.  Two pixels share a byte inside a plane.
    /// </item>
    /// <item>
    /// 8bpp is 64 bytes with no planes at all: one byte per pixel.
    /// </item>
    /// </list>
    ///
    /// Within a byte the leftmost pixel sits in the most significant bits.
    /// </remarks>
    public static byte[][] DecodeTiles(ReadOnlySpan<byte> data, BitsPerPixel bpp, int tileCount)
    {
        var size = TileSize(bpp);
        var tiles = new byte[tileCount][];

        for (var tile = 0; tile < tileCount; tile++)
        {
            var start = tile * size;
            if (start + size > data.Length)
            {
                break;
            }

            var pixels = new byte[64];

            switch (bpp)
            {
                case BitsPerPixel.Two:
                    // Two planes of eight bytes, one bit per pixel.
                    for (var row = 0; row < 8; row++)
                    {
                        var low = data[start + row];
                        var high = data[start + 8 + row];

                        for (var column = 0; column < 8; column++)
                        {
                            var shift = 7 - column;
                            var value = ((low >> shift) & 1) | (((high >> shift) & 1) << 1);
                            pixels[row * 8 + column] = (byte)value;
                        }
                    }

                    break;

                case BitsPerPixel.Four:
                    // Two planes of sixteen bytes, two bits per pixel.
                    // A plane holds eight rows of two bytes, and every byte
                    // covers four of the eight pixels of its row.
                    for (var row = 0; row < 8; row++)
                    {
                        for (var column = 0; column < 8; column++)
                        {
                            // Four pixels share a byte, so the byte index
                            // advances every fourth pixel.
                            var byteIndex = row * 2 + (column >> 2);
                            var shift = 6 - (column % 4) * 2;

                            var low = (data[start + byteIndex] >> shift) & 0x03;
                            var high = (data[start + 16 + byteIndex] >> shift) & 0x03;
                            pixels[row * 8 + column] = (byte)(low | (high << 2));
                        }
                    }

                    break;

                case BitsPerPixel.Eight:
                    // One byte per pixel, row after row.
                    for (var row = 0; row < 8; row++)
                    {
                        for (var column = 0; column < 8; column++)
                        {
                            pixels[row * 8 + column] = data[start + row * 8 + column];
                        }
                    }

                    break;

                default:
                    throw new ArgumentOutOfRangeException(nameof(bpp));
            }

            tiles[tile] = pixels;
        }

        return tiles;
    }

    /// <summary>
    /// Render tiles into a rectangle of palette indices.
    /// </summary>
    /// <param name="tiles">The decoded tiles.</param>
    /// <param name="columns">How many tiles per row.</param>
    /// <param name="rows">How many rows of tiles.</param>
    public static byte[] ComposeTiles(IReadOnlyList<byte[]> tiles, int columns, int rows)
    {
        var width = columns * 8;
        var height = rows * 8;
        var sheet = new byte[width * height];

        for (var row = 0; row < rows; row++)
        {
            for (var column = 0; column < columns; column++)
            {
                var index = row * columns + column;
                if (index >= tiles.Count)
                {
                    continue;
                }

                var tile = tiles[index];
                for (var y = 0; y < 8; y++)
                {
                    for (var x = 0; x < 8; x++)
                    {
                        sheet[(row * 8 + y) * width + column * 8 + x] = tile[y * 8 + x];
                    }
                }
            }
        }

        return sheet;
    }
}
