using Avalonia;
using Avalonia.Media.Imaging;
using Avalonia.Platform;
using System.Runtime.InteropServices;

namespace UnchartedWaters.Gui;

/// <summary>Turns a sheet of palette indices into a bitmap.</summary>
public static class TileRenderer
{
    /// <summary>Render an index sheet with the given colour ramp.</summary>
    /// <remarks>
    /// Returns nothing when the bitmap cannot be made, for example when
    /// the size is out of range.  A broken block of tiles should not stop
    /// the editor from working.
    /// </remarks>
    public static Bitmap? Render(byte[] sheet, int width, int height, uint[] ramp)
    {
        if (width <= 0 || height <= 0)
        {
            return null;
        }

        try
        {
            return RenderCore(sheet, width, height, ramp);
        }
        catch (Exception)
        {
            return null;
        }
    }

    private static Bitmap RenderCore(byte[] sheet, int width, int height, uint[] ramp)
    {
        var stride = width * 4;
        byte[] pixels = new byte[stride * height];

        for (var y = 0; y < height; y++)
        {
            for (var x = 0; x < width; x++)
            {
                var index = sheet[y * width + x] & 0x0F;
                var color = ramp[index];
                var target = y * stride + x * 4;
                pixels[target + 0] = (byte)(color >> 16);
                pixels[target + 1] = (byte)(color >> 8);
                pixels[target + 2] = (byte)color;
                pixels[target + 3] = 0xFF;
            }
        }

        var bitmap = new WriteableBitmap(
            new PixelSize(width, height),
            new Vector(96, 96),
            PixelFormat.Rgba8888,
            AlphaFormat.Premul);

        // The locked framebuffer hands out a raw pointer plus the row stride,
        // which may be padded, so copy one row at a time.
        using (var buffer = bitmap.Lock())
        {
            var destination = buffer.Address;
            var rowBytes = buffer.RowBytes;

            for (var y = 0; y < height; y++)
            {
                Marshal.Copy(
                    pixels,
                    y * stride,
                    destination + (y * rowBytes),
                    Math.Min(stride, rowBytes));
            }
        }

        return bitmap;
    }
}
