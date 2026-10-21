using System.Diagnostics;
using System.Text;
using System.Text.Json;
using Avalonia.Media;
using UnchartedWaters.Core;

namespace UnchartedWaters.Gui.ViewModels;

/// <summary>One palette of the game: sixteen colours.</summary>
/// <param name="Index">Which palette of the colour memory it is.</param>
/// <param name="Colors">The sixteen colours, as red, green and blue.</param>
public sealed record CgramPalette(int Index, IReadOnlyList<(byte R, byte G, byte B)> Colors)
{
    /// <summary>The colours as the editor shows them.</summary>
    public IReadOnlyList<ColorEntry> Entries { get; init; } = Array.Empty<ColorEntry>();
}

/// <summary>One colour of a palette.</summary>
/// <param name="Index">Which colour of the palette it is.</param>
/// <param name="R">The red part.</param>
/// <param name="G">The green part.</param>
/// <param name="B">The blue part.</param>
public sealed record ColorEntry(int Index, byte R, byte G, byte B)
{
    /// <summary>The colour as a hexadecimal string.</summary>
    public string Hex => $"#{R:X2}{G:X2}{B:X2}";

    /// <summary>The colour for the window of the editor.</summary>
    public uint Argb => Palette.PackArgb(R, G, B);

    /// <summary>
    /// The colour as a brush of the window system.
    /// </summary>
    /// <remarks>
    /// A brush may only be made on the thread of the window, so it is
    /// filled in after the colours have been read.
    /// </remarks>
    public IBrush? Brush { get; set; }
}

/// <summary>
/// Reads the colours of the running game.
///
/// The work is done by tools/cgramread.py, which boots the cartridge in
/// the headless Mesen harness and reads the colour memory of the SNES.
/// The editor uses the colours to draw the tiles the way the game does.
/// </summary>
public sealed class CgramReader
{
    private const string HelperName = "cgramread.py";

    private readonly string _toolsFolder;
    private readonly string _python;

    public CgramReader(string toolsFolder, string python = "python3")
    {
        _toolsFolder = toolsFolder;
        _python = python;
    }

    /// <summary>Read the colours of the running game.</summary>
    /// <param name="romPath">The cartridge to boot.</param>
    /// <param name="cancellation">Cancels the read.</param>
    public async Task<IReadOnlyList<CgramPalette>> ReadAsync(
        string romPath,
        CancellationToken cancellation)
    {
        var helper = Path.Combine(_toolsFolder, HelperName);
        if (!File.Exists(helper))
        {
            throw new FileNotFoundException(
                $"the helper {HelperName} was not found in {_toolsFolder}");
        }

        var startInfo = new ProcessStartInfo
        {
            FileName = _python,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true,
        };

        startInfo.ArgumentList.Add(helper);
        startInfo.ArgumentList.Add("--rom");
        startInfo.ArgumentList.Add(romPath);
        startInfo.ArgumentList.Add("--json");

        using var process = new Process { StartInfo = startInfo };

        try
        {
            if (!process.Start())
            {
                throw new InvalidOperationException("the helper did not start");
            }
        }
        catch (InvalidOperationException)
        {
            throw;
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException(
                $"could not start {_python}: {ex.Message}", ex);
        }

        // The output is read line by line until the pipes close.  Reading it
        // in one go does not always finish, because the window system takes
        // over the handling of the child process signal while the editor
        // runs.
        var output = new StringBuilder();
        var errors = new StringBuilder();

        var reading = Task.WhenAll(
            ReadLinesAsync(process.StandardOutput, output),
            ReadLinesAsync(process.StandardError, errors));

        try
        {
            await reading.ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException(
                "the helper could not be read: " + ex.Message, ex);
        }

        var text = output.ToString();
        if (text.Length == 0)
        {
            throw new InvalidOperationException(
                "the helper produced no output" + Environment.NewLine + errors);
        }

        return Parse(text);
    }

    private static async Task ReadLinesAsync(StreamReader reader, StringBuilder into)
    {
        while (await reader.ReadLineAsync().ConfigureAwait(false) is { } line)
        {
            into.AppendLine(line);
        }
    }

    /// <summary>Read the palettes out of the output of the helper.</summary>
    /// <param name="json">The output of the helper.</param>
    public static IReadOnlyList<CgramPalette> Parse(string json)
    {
        using var document = JsonDocument.Parse(json);
        var palettes = new List<CgramPalette>();

        if (!document.RootElement.TryGetProperty("palettes", out var paletteArray))
        {
            return palettes;
        }

        foreach (var palette in paletteArray.EnumerateArray())
        {
            var index = palette.GetProperty("index").GetInt32();
            var colors = new List<(byte R, byte G, byte B)>();
            var entries = new List<ColorEntry>();

            foreach (var color in palette.GetProperty("colors").EnumerateArray())
            {
                var r = (byte)color[0].GetInt32();
                var g = (byte)color[1].GetInt32();
                var b = (byte)color[2].GetInt32();
                colors.Add((r, g, b));
                entries.Add(new ColorEntry(colors.Count - 1, r, g, b));
            }

            palettes.Add(new CgramPalette(index, colors) { Entries = entries });
        }

        return palettes;
    }
}
