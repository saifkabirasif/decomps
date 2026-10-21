using UnchartedWaters.Gui.ViewModels;
using Xunit;

namespace UnchartedWaters.Core.Tests;

/// <summary>Tests for the bridge to the tool that reads the colours.</summary>
public class CgramReaderTests
{
    private const string Json = """
    {
      "palettes": [
        {
          "index": 3,
          "words": [ 0, 4435, 12921, 32767 ],
          "colors": [
            [ 0, 0, 0 ],
            [ 96, 32, 0 ],
            [ 136, 64, 48 ],
            [ 248, 248, 248 ]
          ]
        }
      ],
      "scriptPalette": {
        "address": "$0CC8",
        "words": [ 0, 1, 2, 3 ],
        "colors": [ [ 0, 0, 0 ], [ 8, 0, 0 ], [ 16, 0, 0 ], [ 24, 0, 0 ] ]
      }
    }
    """;

    [Fact]
    public void ReadsThePalettes()
    {
        var palettes = CgramReader.Parse(Json);

        var palette = Assert.Single(palettes);
        Assert.Equal(3, palette.Index);
        Assert.Equal(4, palette.Colors.Count);
        Assert.Equal(4, palette.Entries.Count);
    }

    [Fact]
    public void ReadsTheColoursOfAPalette()
    {
        var palette = CgramReader.Parse(Json)[0];

        Assert.Equal((byte)0, palette.Colors[0].R);
        Assert.Equal((byte)0, palette.Colors[0].G);
        Assert.Equal((byte)0, palette.Colors[0].B);

        Assert.Equal((byte)96, palette.Colors[1].R);
        Assert.Equal((byte)32, palette.Colors[1].G);
        Assert.Equal((byte)248, palette.Colors[3].B);
    }

    [Fact]
    public void ShowsTheColourAsAHexadecimalString()
    {
        var palette = CgramReader.Parse(Json)[0];

        Assert.Equal("#602000", palette.Entries[1].Hex);
    }

    [Fact]
    public void ReadsAnEmptyResult()
    {
        Assert.Empty(CgramReader.Parse("""{ "palettes": [] }"""));
    }
}
