using UnchartedWaters.Core;
using Xunit;

namespace UnchartedWaters.Core.Tests;

public class PaletteTableTests
{
    /// <summary>Build a run of palettes; colour zero is transparent.</summary>
    private static byte[] MakeTable(int count, ushort fill = 0x1234)
    {
        var data = new byte[count * Palette.Size];
        for (var palette = 0; palette < count; palette++)
        {
            for (var colour = 1; colour < Palette.Entries; colour++)
            {
                var word = fill;
                var at = palette * Palette.Size + colour * 2;
                data[at] = (byte)(word & 0xFF);
                data[at + 1] = (byte)(word >> 8);
            }
        }

        return data;
    }

    /// <summary>Put the table at an offset in a smaller cartridge image.</summary>
    private static byte[] MakeRom(byte[] table, int at = 0x1000)
    {
        var data = new byte[0x8000];
        Array.Copy(table, 0, data, at, table.Length);
        return data;
    }

    [Fact]
    public void FindsARunOfPalettes()
    {
        var rom = new RomImage(MakeRom(MakeTable(8)));

        var tables = PaletteTable.Find(rom);

        var table = Assert.Single(tables);
        Assert.Equal(0x1000, table.Start);
        Assert.Equal(8, table.Palettes.Count);
        Assert.Equal(8, table.Used);
    }

    [Fact]
    public void DoesNotTakePaddingForATable()
    {
        var rom = new RomImage(new byte[0x8000]);

        Assert.Empty(PaletteTable.Find(rom));
    }

    [Fact]
    public void AShortRunIsNotATable()
    {
        var rom = new RomImage(MakeRom(MakeTable(4)));

        Assert.Empty(PaletteTable.Find(rom));
    }

    [Fact]
    public void ReadsAndWritesAPaletteOfTheTable()
    {
        var rom = new RomImage(MakeRom(MakeTable(8)));
        var table = Assert.Single(PaletteTable.Find(rom));
        var slot = table.Palettes[2];

        var colours = PaletteTable.Read(rom, slot);
        Assert.Equal((byte)0xA0, colours[1].R);

        colours[1] = (0xF8, 0x00, 0x00);
        PaletteTable.Write(rom, slot, colours);

        var again = PaletteTable.Read(rom, slot);
        Assert.Equal((0xF8, 0x00, 0x00), again[1]);
        // Changing one palette must not touch its neighbours.
        Assert.Equal((byte)0xA0, PaletteTable.Read(rom, table.Palettes[1])[1].R);
    }

    [Fact]
    public void FindsTheKnownTableOfTheOriginalCartridge()
    {
        var path = FindOriginalCartridge();
        if (path is null)
        {
            return; // the cartridge is not part of the repository
        }

        var rom = RomImage.Load(path);
        var tables = PaletteTable.Find(rom);

        Assert.NotEmpty(tables);
        Assert.Equal(0x012526, tables[0].Start);
        Assert.True(tables[0].Palettes.Count >= 60);
        // The first palette is the one the introduction shows.
        var colours = PaletteTable.Read(rom, tables[0].Palettes[0]);
        Assert.Equal((0x00, 0x00, 0x00), colours[0]);
        Assert.Equal((0x98, 0x50, 0x20), colours[1]);
    }

    /// <summary>Look for the cartridge in a .games folder above the tests.</summary>
    private static string? FindOriginalCartridge()
    {
        const string name = "Uncharted Waters (USA).sfc";
        var folder = new DirectoryInfo(AppContext.BaseDirectory);
        while (folder is not null)
        {
            var candidate = Path.Combine(folder.FullName, ".games", name);
            if (File.Exists(candidate))
            {
                return candidate;
            }

            folder = folder.Parent;
        }

        return null;
    }
}
