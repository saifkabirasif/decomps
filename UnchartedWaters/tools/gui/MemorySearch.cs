using System.Diagnostics;
using System.Text;
using System.Text.Json;
using UnchartedWaters.Core;

namespace UnchartedWaters.Gui;

/// <summary>One place in the cartridge where a hit was found.</summary>
/// <param name="Name">The name of the block.</param>
/// <param name="FileOffset">The offset inside the ROM image.</param>
/// <param name="AssetOffset">The offset inside the block.</param>
/// <param name="Bank">The LoROM bank the block lives in.</param>
/// <param name="Address">The CPU address inside the bank.</param>
public sealed record MemoryBlock(
    string Name,
    int FileOffset,
    int AssetOffset,
    int Bank,
    int Address)
{
    /// <summary>Where the block is, as it is shown in the editor.</summary>
    public string Describe =>
        $"{Name} +{AssetOffset:X4} (bank ${Format.Hex(Bank, 2)}:${Format.Hex(Address, 4)})";
}

/// <summary>One hit of a search in the memory of the running game.</summary>
/// <param name="MemoryAddress">Where the text was found in the work RAM.</param>
/// <param name="MemoryOffset">The offset inside the work RAM.</param>
/// <param name="Text">The text around the hit.</param>
/// <param name="Blocks">The blocks of the cartridge the bytes came from.</param>
public sealed record MemoryHit(
    string MemoryAddress,
    int MemoryOffset,
    string Text,
    IReadOnlyList<MemoryBlock> Blocks)
{
    /// <summary>Where the text was found, as it is shown in the editor.</summary>
    public string Describe =>
        Blocks.Count > 0
            ? $"{MemoryAddress}  {string.Join(", ", Blocks.Select(b => b.Describe))}"
            : $"{MemoryAddress}  not in the cartridge";
}

/// <summary>The result of a search.</summary>
/// <param name="Hits">The hits that were found.</param>
/// <param name="Error">What went wrong, if anything.</param>
public sealed record SearchOutcome(IReadOnlyList<MemoryHit> Hits, string? Error)
{
    /// <summary>Did the search work out?</summary>
    public bool Ok => Error is null;
}

/// <summary>
/// Runs the memory search helper of the Python tooling.
///
/// The helper boots the cartridge in the headless Mesen harness and looks
/// for a string in the work RAM of the running game.  It also reports where
/// the bytes came from, which finds the strings the script splits up with
/// control codes and that cannot be read out of the cartridge directly.
/// </summary>
public sealed class MemorySearch
{
    private const string HelperName = "memsearch.py";

    private readonly string _toolsFolder;
    private readonly string _python;

    public MemorySearch(string toolsFolder, string python = "python3")
    {
        _toolsFolder = toolsFolder;
        _python = python;
    }

    /// <summary>
    /// Look for the folder that holds the Python tooling.
    /// </summary>
    /// <remarks>
    /// The environment variable UCW_TOOLS wins, then the folders above the
    /// program and the working directory are searched for the helper.
    /// </remarks>
    public static string? FindToolsFolder()
    {
        var fromEnv = Environment.GetEnvironmentVariable("UCW_TOOLS");
        if (fromEnv is not null && File.Exists(Path.Combine(fromEnv, HelperName)))
        {
            return fromEnv;
        }

        foreach (var start in new[] { AppContext.BaseDirectory, Environment.CurrentDirectory })
        {
            var found = SearchUpwards(start);
            if (found is not null)
            {
                return found;
            }
        }

        return null;
    }

    private static string? SearchUpwards(string start)
    {
        var dir = new DirectoryInfo(start);
        while (dir is not null)
        {
            var candidate = Path.Combine(dir.FullName, "UnchartedWaters", "tools");
            if (File.Exists(Path.Combine(candidate, HelperName)))
            {
                return candidate;
            }

            // The tools folder may sit next to the program as well.
            candidate = Path.Combine(dir.FullName, "tools");
            if (File.Exists(Path.Combine(candidate, HelperName)))
            {
                return candidate;
            }

            dir = dir.Parent;
        }

        return null;
    }

    /// <summary>Search the memory of the running game.</summary>
    /// <param name="romPath">The cartridge to boot.</param>
    /// <param name="needle">The text to look for.</param>
    /// <param name="keys">Keys to press before the search.</param>
    /// <param name="frames">How many frames the game should run.</param>
    /// <param name="cancellation">Cancels the search.</param>
    public async Task<SearchOutcome> RunAsync(
        string romPath,
        string needle,
        IReadOnlyList<string> keys,
        int frames,
        CancellationToken cancellation)
    {
        var helper = Path.Combine(_toolsFolder, HelperName);
        if (!File.Exists(helper))
        {
            return new SearchOutcome(Array.Empty<MemoryHit>(),
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
        startInfo.ArgumentList.Add("--find");
        startInfo.ArgumentList.Add(needle);
        startInfo.ArgumentList.Add("--frames");
        startInfo.ArgumentList.Add(frames.ToString());
        startInfo.ArgumentList.Add("--json");
        if (keys.Count > 0)
        {
            startInfo.ArgumentList.Add("--keys");
            startInfo.ArgumentList.Add(string.Join(",", keys));
        }

        using var process = new Process { StartInfo = startInfo };

        try
        {
            if (!process.Start())
            {
                return new SearchOutcome(Array.Empty<MemoryHit>(), "the helper did not start");
            }
        }
        catch (Exception ex)
        {
            return new SearchOutcome(Array.Empty<MemoryHit>(),
                $"could not start {_python}: {ex.Message}");
        }

        // The output is read line by line until the pipes close.  Reading it
        // in one go with ReadToEndAsync does not always finish, because the
        // windowing system takes over the handling of the child process
        // signal and the reader then waits for an exit that is never
        // reported.
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
            return new SearchOutcome(Array.Empty<MemoryHit>(), $"the helper failed: {ex.Message}");
        }

        var text = output.ToString();
        if (text.Length == 0)
        {
            var message = errors.ToString().Trim();
            return new SearchOutcome(Array.Empty<MemoryHit>(),
                string.IsNullOrEmpty(message) ? "the helper produced no output" : message);
        }

        try
        {
            return new SearchOutcome(Parse(text), null);
        }
        catch (Exception ex)
        {
            return new SearchOutcome(Array.Empty<MemoryHit>(), $"could not read the result: {ex.Message}");
        }
    }

    private static async Task ReadLinesAsync(StreamReader reader, StringBuilder into)
    {
        while (await reader.ReadLineAsync().ConfigureAwait(false) is { } line)
        {
            into.AppendLine(line);
        }
    }

    /// <summary>Read the result of the helper.</summary>
    /// <param name="json">The output of the helper.</param>
    public static IReadOnlyList<MemoryHit> Parse(string json)
    {
        using var document = JsonDocument.Parse(json);
        var hits = new List<MemoryHit>();

        if (!document.RootElement.TryGetProperty("hits", out var hitArray))
        {
            return hits;
        }

        foreach (var hit in hitArray.EnumerateArray())
        {
            var blocks = new List<MemoryBlock>();
            if (hit.TryGetProperty("blocks", out var blockArray))
            {
                foreach (var block in blockArray.EnumerateArray())
                {
                    blocks.Add(new MemoryBlock(
                        block.GetProperty("name").GetString() ?? "?",
                        block.GetProperty("fileOffset").GetInt32(),
                        block.GetProperty("assetOffset").GetInt32(),
                        block.GetProperty("bank").GetInt32(),
                        block.GetProperty("address").GetInt32()));
                }
            }

            hits.Add(new MemoryHit(
                hit.GetProperty("memoryAddress").GetString() ?? "?",
                hit.GetProperty("memoryOffset").GetInt32(),
                hit.GetProperty("text").GetString() ?? string.Empty,
                blocks));
        }

        return hits;
    }
}
