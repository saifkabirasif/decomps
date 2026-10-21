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
        var rom = BuildRom(0x41, 0x42, 0x43, 0x00, 0x44, 0x45, 0x46, 0x00);

        var strings = TextScanner.Scan(rom, 0, 8);

        Assert.Equal(2, strings.Count);
        Assert.Equal("ABC", strings[0].Text);
        Assert.Equal("DEF", strings[1].Text);
    }

    [Fact]
    public void IgnoresRunsThatAreTooShort()
    {
        var rom = BuildRom(0x41, 0x00, 0x42, 0x43, 0x00);

        var strings = TextScanner.Scan(rom, 0, 5, minimumLength: 2);

        Assert.Single(strings);
        Assert.Equal("BC", strings[0].Text);
    }

    [Fact]
    public void IgnoresRunsThatAreNotTerminated()
    {
        // A run that does not end with a NUL is a piece of the script.
        var rom = BuildRom(0x41, 0x42, 0x43, 0x44);

        Assert.Empty(TextScanner.Scan(rom, 0, 4));
    }

    [Fact]
    public void KeepsTheLineBreaksOfTheText()
    {
        var rom = BuildRom(0x57, 0x65, 0x0A, 0x4F, 0x6B, 0x00);

        var strings = TextScanner.Scan(rom, 0, 6);

        Assert.Single(strings);
        Assert.Equal("We\nOk", strings[0].Text);
    }

    [Fact]
    public void KeepsTheControlCodesOutOfTheText()
    {
        // An escape byte with a command byte belongs to the entry, not to
        // the text.
        var rom = BuildRom(0x41, 0x42, TextScanner.Escape, 0x57, 0x43, 0x00);

        var strings = TextScanner.Scan(rom, 0, 6);

        Assert.Single(strings);
        Assert.Equal("ABC", strings[0].Text);
        Assert.Equal(2, strings[0].ControlLength);
        Assert.Equal(5, strings[0].Length);
    }

    [Fact]
    public void ReportsTheOffsetAndTheLengthOfAString()
    {
        var rom = BuildRom(0x41, 0x42, 0x43, 0x00);

        var strings = TextScanner.Scan(rom, 0, 4);

        Assert.Equal(0, strings[0].Offset);
        Assert.Equal(3, strings[0].TextLength);
    }

    [Fact]
    public void ReplacesAStringInPlace()
    {
        var rom = BuildRom(0x41, 0x42, 0x43, 0x00, 0x44, 0x00);
        var entry = TextScanner.Scan(rom, 0, 6)[0];

        Assert.True(TextScanner.Replace(rom, entry, "XYZ"));

        Assert.Equal(new byte[] { 0x58, 0x59, 0x5A, 0x00, 0x44, 0x00 }, rom.WritableData[..6]);
    }

    [Fact]
    public void KeepsTheControlCodesWhenReplacing()
    {
        var rom = BuildRom(0x41, 0x42, TextScanner.Escape, 0x57, 0x43, 0x00);
        var entry = TextScanner.Scan(rom, 0, 6)[0];

        Assert.True(TextScanner.Replace(rom, entry, "XY"));

        Assert.Equal(
            new byte[] { 0x58, 0x59, TextScanner.Escape, 0x57, 0x20, 0x00 },
            rom.WritableData[..6]);
    }

    [Fact]
    public void PadsAShorterTextWithSpaces()
    {
        var rom = BuildRom(0x41, 0x42, 0x43, 0x00);
        var entry = TextScanner.Scan(rom, 0, 4)[0];

        Assert.True(TextScanner.Replace(rom, entry, "X"));

        Assert.Equal(new byte[] { 0x58, 0x20, 0x20, 0x00 }, rom.WritableData[..4]);
    }

    [Fact]
    public void RefusesToMakeTheTextLonger()
    {
        var rom = BuildRom(0x41, 0x42, 0x43, 0x00);
        var entry = TextScanner.Scan(rom, 0, 4)[0];

        Assert.False(TextScanner.Replace(rom, entry, "TOO LONG"));
    }
}
