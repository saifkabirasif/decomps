using UnchartedWaters.Core;
using Xunit;

namespace UnchartedWaters.Core.Tests;

public class AssetHeaderTests
{
    [Fact]
    public void RecognisesTheMagic()
    {
        var data = new byte[] { 0x4C, 0x03, 0x00, 0x00 };

        Assert.True(AssetHeader.HasMagic(data));
    }

    [Fact]
    public void RejectsDataWithoutTheMagic()
    {
        Assert.False(AssetHeader.HasMagic(new byte[] { 0x4C, 0x04 }));
        Assert.False(AssetHeader.HasMagic(new byte[] { 0x4C }));
        Assert.False(AssetHeader.HasMagic(Array.Empty<byte>()));
    }

    [Fact]
    public void ReadsARawBlock()
    {
        var data = new byte[16];
        data[0] = 0x4C;
        data[1] = 0x03;
        data[2] = 0x00;
        data[3] = 0x00;
        var rom = new RomImage(data);

        var header = AssetHeader.Parse(rom, 0);

        Assert.True(header.HasMagic);
        Assert.True(header.IsRaw);
        Assert.Equal("raw data", header.Describe());
    }

    [Fact]
    public void ReadsAnEncodedBlock()
    {
        var data = new byte[16];
        data[0] = 0x4C;
        data[1] = 0x03;
        data[2] = 0xB8;
        data[3] = 0x20;
        var rom = new RomImage(data);

        var header = AssetHeader.Parse(rom, 0);

        Assert.True(header.HasMagic);
        Assert.False(header.IsRaw);
        Assert.Equal("encoded script", header.Describe());
    }

    [Fact]
    public void ReportsAMissingHeader()
    {
        var rom = new RomImage(new byte[16]);

        var header = AssetHeader.Parse(rom, 0);

        Assert.False(header.HasMagic);
        Assert.False(header.IsRaw);
        Assert.Equal("no header", header.Describe());
    }

    [Fact]
    public void DoesNotRunPastTheEndOfTheImage()
    {
        var data = new byte[] { 0x4C, 0x03 };
        var rom = new RomImage(data);

        var header = AssetHeader.Parse(rom, 0);

        Assert.True(header.HasMagic);
        Assert.False(header.IsRaw);
    }
}
