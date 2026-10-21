using UnchartedWaters.Gui;
using Xunit;

namespace UnchartedWaters.Core.Tests;

/// <summary>
/// Tests for the bridge to the memory search helper.
///
/// The helper itself is Python and is tested over there; these tests cover
/// the parts that live in the editor.
/// </summary>
public class MemorySearchTests
{
    [Fact]
    public void ReadsTheResultOfTheHelper()
    {
        const string json = """
        {
          "needle": "Navigator",
          "frames": 120,
          "keys": [],
          "hits": [
            {
              "memoryOffset": 35530,
              "memoryAddress": "$8BCA",
              "text": "Navigator: ",
              "blocks": [
                {
                  "name": "root",
                  "fileOffset": 60362,
                  "assetOffset": 27594,
                  "bank": 1,
                  "address": 60362
                }
              ]
            }
          ]
        }
        """;

        var hits = MemorySearch.Parse(json);

        var hit = Assert.Single(hits);
        Assert.Equal("$8BCA", hit.MemoryAddress);
        Assert.Equal(35530, hit.MemoryOffset);
        Assert.Equal("Navigator: ", hit.Text);

        var block = Assert.Single(hit.Blocks);
        Assert.Equal("root", block.Name);
        Assert.Equal(27594, block.AssetOffset);
        Assert.Equal(1, block.Bank);
    }

    [Fact]
    public void ReadsAResultWithoutAnyBlocks()
    {
        const string json = """
        {
          "needle": "gone",
          "hits": [
            { "memoryOffset": 16, "memoryAddress": "$0010", "text": "gone", "blocks": [] }
          ]
        }
        """;

        var hits = MemorySearch.Parse(json);

        var hit = Assert.Single(hits);
        Assert.Empty(hit.Blocks);
        Assert.Contains("not in the cartridge", hit.Describe);
    }

    [Fact]
    public void ReadsAResultWithoutAnyHits()
    {
        var hits = MemorySearch.Parse("""{ "needle": "x", "hits": [] }""");

        Assert.Empty(hits);
    }

    [Fact]
    public void ShowsThePlaceOfABlock()
    {
        var block = new MemoryBlock("root", 0xEBCA, 0x6BCA, 1, 0xEBCA);

        // The bank and the address have to be padded with zeros, the C#
        // number format "02X" would print the zero and the two as a
        // digit placeholder and a literal.
        Assert.Equal("root +6BCA (bank $01:$EBCA)", block.Describe);
    }

    [Fact]
    public void FindsTheHelperInTheRepository()
    {
        // The editor looks for the tools folder above itself, so running
        // from the build output of the repository has to find it.
        var tools = MemorySearch.FindToolsFolder();

        Assert.NotNull(tools);
        Assert.True(File.Exists(Path.Combine(tools!, "memsearch.py")));
    }
}
