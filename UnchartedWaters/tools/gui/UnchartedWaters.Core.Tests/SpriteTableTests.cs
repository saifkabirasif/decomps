using UnchartedWaters.Core;
using Xunit;

namespace UnchartedWaters.Core.Tests;

public class SpriteTableTests
{
    /// <summary>
    /// The first two group records of the original cartridge, taken from
    /// the "sgdata" block.  The header is five bytes and every record is
    /// 51 bytes long.
    /// </summary>
    private static byte[] BuildBlock()
    {
        var block = new byte[SpriteTable.HeaderSize + SpriteTable.RecordSize * 3];

        // "4C 03 00 00 00"
        block[0] = 0x4C;
        block[1] = 0x03;

        // The first group: seven parameters, the back pointer 0x04, the
        // group id 0xA4 and seven frames.
        var first = SpriteTable.HeaderSize;
        block[first + 0] = 0x24;
        block[first + 1] = 0x08;
        block[first + 2] = 0x02;
        block[first + 3] = 0x0A;
        block[first + 4] = 0x02;
        block[first + 5] = 0x03;
        block[first + 6] = 0x02;
        block[first + 7] = 0x04;
        block[first + 8] = 0xA4;
        block[first + 9] = 0x1F;
        block[first + 10] = 0x09;
        block[first + 11] = 0x1F;
        block[first + 12] = 0x0A;
        block[first + 13] = 0x20;
        block[first + 14] = 0x0B;
        block[first + 15] = 0x21;
        block[first + 16] = 0x0A;
        block[first + 17] = 0x22;
        block[first + 18] = 0x09;
        block[first + 19] = 0x23;
        block[first + 20] = 0x09;
        block[first + 21] = 0x24;
        block[first + 22] = 0x08;
        block[first + 23] = SpriteTable.Terminator;

        // The second group starts 51 bytes further on.
        var second = first + SpriteTable.RecordSize;
        block[second + 7] = 0x37;
        block[second + 8] = 0xA4;
        block[second + 9] = 0x23;
        block[second + 10] = 0x09;
        block[second + 11] = SpriteTable.Terminator;

        // The third record is empty, so the table ends there.
        return block;
    }

    [Fact]
    public void ReadsTheGroupsOfTheTable()
    {
        var rom = new RomImage(BuildBlock());

        var groups = SpriteTable.Parse(rom, 0);

        Assert.Equal(2, groups.Count);
    }

    [Fact]
    public void ReadsTheParametersOfAGroup()
    {
        var rom = new RomImage(BuildBlock());

        var group = SpriteTable.Parse(rom, 0)[0];

        Assert.Equal(new byte[] { 0x24, 0x08, 0x02, 0x0A, 0x02, 0x03, 0x02 }, group.Parameters);
    }

    [Fact]
    public void ReadsTheIdOfAGroup()
    {
        var rom = new RomImage(BuildBlock());

        var group = SpriteTable.Parse(rom, 0)[0];

        Assert.Equal(0xA4, group.Id);
        Assert.Equal("$A4", group.GroupName);
    }

    [Fact]
    public void ReadsTheFramesOfAGroup()
    {
        var rom = new RomImage(BuildBlock());

        var group = SpriteTable.Parse(rom, 0)[0];

        Assert.Equal(7, group.Frames.Count);
        Assert.Equal(new SpriteFrame(0x1F, 0x09), group.Frames[0]);
        Assert.Equal(new SpriteFrame(0x24, 0x08), group.Frames[6]);
    }

    [Fact]
    public void StopsAtTheFirstEmptyRecord()
    {
        var rom = new RomImage(BuildBlock());

        // The third record is all zeros, so it ends the table.
        Assert.Equal(2, SpriteTable.Parse(rom, 0).Count);
    }

    [Fact]
    public void HandlesAnEmptyBlock()
    {
        var rom = new RomImage(new byte[0x100]);

        Assert.Empty(SpriteTable.Parse(rom, 0));
    }

    [Fact]
    public void HandlesAGroupWithoutFrames()
    {
        var block = BuildBlock();
        // Take the terminator of the first group away.
        block[SpriteTable.HeaderSize + 9] = SpriteTable.Terminator;

        var rom = new RomImage(block);

        var group = SpriteTable.Parse(rom, 0)[0];

        Assert.Empty(group.Frames);
    }

    [Fact]
    public void KnowsWhereAGroupStarts()
    {
        var rom = new RomImage(BuildBlock());

        var groups = SpriteTable.Parse(rom, 0);

        Assert.Equal(SpriteTable.HeaderSize, groups[0].Offset);
        Assert.Equal(SpriteTable.HeaderSize + SpriteTable.RecordSize, groups[1].Offset);
    }
}
