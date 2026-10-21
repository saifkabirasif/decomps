using UnchartedWaters.Core;
using Xunit;

namespace UnchartedWaters.Core.Tests;

public class RomImageTests
{
    [Fact]
    public void MapsABankAndAddressToAFileOffset()
    {
        Assert.Equal(0x008000, RomImage.ToOffset(1, 0x8000));
        Assert.Equal(0x00F5AE, RomImage.ToOffset(1, 0xF5AE));
        Assert.Equal(0x010836, RomImage.ToOffset(2, 0x8836));
    }

    [Fact]
    public void RejectsAnAddressBelowTheCartridgeWindow()
    {
        Assert.Throws<ArgumentOutOfRangeException>(() => RomImage.ToOffset(1, 0x7FFF));
    }

    [Fact]
    public void ConvertsAFileOffsetBack()
    {
        Assert.Equal(1, RomImage.ToBank(0x008000));
        Assert.Equal(0x8000, RomImage.ToAddress(0x008000));
        Assert.Equal(2, RomImage.ToBank(0x010836));
        Assert.Equal(0x8836, RomImage.ToAddress(0x010836));
    }

    [Fact]
    public void ReadsAndWritesBigEndianWords()
    {
        var rom = new RomImage(new byte[8]);

        rom.WriteWord(2, 0x1234);

        Assert.Equal(0x12, rom.WritableData[2]);
        Assert.Equal(0x34, rom.WritableData[3]);
        Assert.Equal(0x1234, rom.ReadWord(2));
    }

    [Fact]
    public void ReadsAndWritesLittleEndianWords()
    {
        var rom = new RomImage(new byte[8]);

        rom.WriteWordLE(2, 0x1234);

        Assert.Equal(0x34, rom.WritableData[2]);
        Assert.Equal(0x12, rom.WritableData[3]);
        Assert.Equal(0x1234, rom.ReadWordLE(2));
    }

    [Fact]
    public void CountsTheBanksOfTheImage()
    {
        var rom = new RomImage(new byte[0x40000]);

        Assert.Equal(8, rom.BankCount);
    }
}

public class FormatTests
{
    [Theory]
    [InlineData(1, 2, "01")]
    [InlineData(0x8000, 4, "8000")]
    [InlineData(0x37D8, 5, "037D8")]
    [InlineData(0x10836, 6, "010836")]
    public void PadsHexadecimalToTheRequestedWidth(int value, int digits, string expected)
    {
        Assert.Equal(expected, Format.Hex(value, digits));
    }
}
