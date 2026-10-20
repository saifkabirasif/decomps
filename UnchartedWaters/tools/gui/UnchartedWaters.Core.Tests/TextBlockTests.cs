using UnchartedWaters.Core;
using Xunit;

namespace UnchartedWaters.Core.Tests;

public class TextBlockTests
{
    private static RomImage BuildRom(params byte[] data)
    {
        var image = new byte[0x100];
        data.CopyTo(image, 0);
        return new RomImage(image);
    }

    [Fact]
    public void FindsNulTerminatedRuns()
    {
        var rom = BuildRom(0x41, 0x42, 0x43, 0x00, 0x44, 0x45, 0x00);

        var strings = TextScanner.Scan(rom, 0, 7);

        Assert.Equal(2, strings.Count);
        Assert.Equal("ABC", strings[0].Text);
        Assert.Equal("DE", strings[1].Text);
    }

    [Fact]
    public void IgnoresRunsThatAreTooShort()
    {
        var rom = BuildRom(0x41, 0x00, 0x42, 0x43, 0x00);

        var strings = TextScanner.Scan(rom, 0, 5);

        Assert.Single(strings);
        Assert.Equal("BC", strings[0].Text);
    }

    [Fact]
    public void ReportsTheOffsetAndTheLengthOfAString()
    {
        var rom = BuildRom(0x41, 0x42, 0x43, 0x00);

        var strings = TextScanner.Scan(rom, 0, 4);

        Assert.Equal(0, strings[0].Offset);
        Assert.Equal(3, strings[0].Length);
    }

    [Fact]
    public void ReplacesAStringInPlace()
    {
        var rom = BuildRom(0x41, 0x42, 0x43, 0x00, 0x44, 0x00);
        var entry = new TextEntry(0, "ABC");

        Assert.True(TextScanner.Replace(rom, entry, "XYZ"));

        Assert.Equal(new byte[] { 0x58, 0x59, 0x5A, 0x00, 0x44, 0x00 }, rom.WritableData[..6]);
    }

    [Fact]
    public void RefusesToGrowAStringOverTheNextOne()
    {
        // "AB" is followed directly by "CD", there is no room in between.
        var rom = BuildRom(0x41, 0x42, 0x00, 0x43, 0x44, 0x00);
        var entry = new TextEntry(0, "AB");

        Assert.False(TextScanner.Replace(rom, entry, "ABCD"));

        Assert.Equal(new byte[] { 0x41, 0x42, 0x00, 0x43, 0x44, 0x00 }, rom.WritableData[..6]);
    }

    [Fact]
    public void GrowsAStringIntoTheFreeSpaceBehindIt()
    {
        // "AB" is followed by three zero bytes and then "CD".
        var rom = BuildRom(0x41, 0x42, 0x00, 0x00, 0x00, 0x00, 0x43, 0x44, 0x00);
        var entry = new TextEntry(0, "AB");

        Assert.True(TextScanner.Replace(rom, entry, "ABCDE"));

        Assert.Equal(new byte[] { 0x41, 0x42, 0x43, 0x44, 0x45, 0x00, 0x43, 0x44, 0x00 }, rom.WritableData[..9]);
    }

    [Fact]
    public void RefusesToReplaceAStringThatIsNotTerminated()
    {
        var rom = BuildRom(0x41, 0x42, 0x43, 0x44);
        var entry = new TextEntry(0, "ABC");

        Assert.False(TextScanner.Replace(rom, entry, "XY"));
    }
}
