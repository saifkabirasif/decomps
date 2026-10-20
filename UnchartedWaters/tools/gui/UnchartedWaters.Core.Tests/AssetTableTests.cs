using UnchartedWaters.Core;
using Xunit;

namespace UnchartedWaters.Core.Tests;

public class AssetTableTests
{
    /// <summary>
    /// The asset table lives at bank $00, $F800.  These bytes are taken from
    /// the original cartridge and must not change.
    /// </summary>
    private static readonly byte[] TableBytes =
    {
        0x72, 0x6F, 0x6F, 0x74, 0x00, 0x00, 0x00, 0x00, // "root"
        0x01, 0x00, 0x00, 0x80, 0xAE, 0x75, 0x00, 0x00,
        0x73, 0x67, 0x64, 0x61, 0x74, 0x61, 0x00, 0x00, // "sgdata"
        0x01, 0x00, 0xAE, 0xF5, 0x88, 0x12, 0x00, 0x00,
        0x66, 0x64, 0x61, 0x74, 0x61, 0x00, 0x00, 0x00, // "fdata"
        0x02, 0x00, 0x36, 0x88, 0xD8, 0x37, 0x00, 0x00,
    };

    private static RomImage BuildRom()
    {
        var data = new byte[0x8000];
        TableBytes.CopyTo(data, AssetTable.TableOffset);
        return new RomImage(data);
    }

    [Fact]
    public void ParsesTheRecordsOfTheTable()
    {
        var assets = AssetTable.Parse(BuildRom());

        Assert.Equal(3, assets.Count);
        Assert.Equal(new[] { "root", "sgdata", "fdata" }, assets.Select(a => a.Name));
    }

    [Fact]
    public void ReadsTheNumericFieldsLittleEndian()
    {
        var assets = AssetTable.Parse(BuildRom());

        var root = assets[0];
        Assert.Equal(1, root.Bank);
        Assert.Equal(0x8000, root.Address);
        Assert.Equal(0x75AE, root.Length);
        Assert.Equal(0, root.Flags);
    }

    [Fact]
    public void ComputesTheFileOffsetFromTheBankAndAddress()
    {
        var assets = AssetTable.Parse(BuildRom());

        // Bank 1, $8000 is the start of the first 32 KiB bank after the
        // header, which the file layout puts at $008000.
        Assert.Equal(0x008000, assets[0].FileOffset);
        Assert.Equal(0x00F5AE, assets[1].FileOffset);
        Assert.Equal(0x010836, assets[2].FileOffset);
    }

    [Fact]
    public void FindsABlockByItsName()
    {
        var assets = AssetTable.Parse(BuildRom());

        var found = AssetTable.Find(assets, "fdata");

        Assert.NotNull(found);
        Assert.Equal(0x010836, found!.FileOffset);
    }

    [Fact]
    public void ReturnsNothingForAnUnknownName()
    {
        var assets = AssetTable.Parse(BuildRom());

        Assert.Null(AssetTable.Find(assets, "nope"));
    }

    [Fact]
    public void StopsAtTheFirstEmptyRecord()
    {
        var data = new byte[0x8000];
        var rom = new RomImage(data);

        Assert.Empty(AssetTable.Parse(rom));
    }
}
