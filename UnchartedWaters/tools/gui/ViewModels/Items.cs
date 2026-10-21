using UnchartedWaters.Core;

namespace UnchartedWaters.Gui.ViewModels;

/// <summary>One row of the hex view.</summary>
public sealed class HexRow
{
    public HexRow(int offset, string hex, string text)
    {
        Offset = offset;
        Hex = hex;
        Text = text;
    }

    public int Offset { get; }

    public string Hex { get; }

    public string Text { get; }
}

/// <summary>One string of the text view.</summary>
public sealed class TextItem : ObservableObject
{
    private string _text;

    public TextItem(TextEntry entry)
    {
        Entry = entry;
        _text = entry.Text;
    }

    /// <summary>The string inside the cartridge.</summary>
    public TextEntry Entry { get; private set; }

    /// <summary>File offset of the string inside the ROM image.</summary>
    public int Offset => Entry.Offset;

    /// <summary>The text of the string.</summary>
    public string Text
    {
        get => _text;
        set => Set(ref _text, value);
    }

    /// <summary>The offset as it is shown in the list.</summary>
    public string Location => $"${Offset:X6}";

    /// <summary>How many characters the string has.</summary>
    public int Length => Entry.TextLength;

    /// <summary>Show the control codes of the string, if it has any.</summary>
    public string ControlCodes => Entry.ControlLength > 0
        ? $"{Entry.ControlLength} control codes"
        : string.Empty;

    /// <summary>Take over the text after it was written into the cartridge.</summary>
    public void Update(TextEntry entry)
    {
        Entry = entry;
        _text = entry.Text;
        Raise(nameof(Text));
        Raise(nameof(Entry));
        Raise(nameof(Length));
        Raise(nameof(ControlCodes));
    }
}

/// <summary>One colour of the palette view.</summary>
public sealed class PaletteItem : ObservableObject
{
    private byte _r;
    private byte _g;
    private byte _b;

    public PaletteItem(int index, byte r, byte g, byte b)
    {
        Index = index;
        _r = r;
        _g = g;
        _b = b;
    }

    public int Index { get; }

    public byte R
    {
        get => _r;
        set => Set(ref _r, value);
    }

    public byte G
    {
        get => _g;
        set => Set(ref _g, value);
    }

    public byte B
    {
        get => _b;
        set => Set(ref _b, value);
    }

    /// <summary>The colour as the view model hands it to the view.</summary>
    public uint Color => Palette.PackArgb(R, G, B);

    /// <summary>The colour as a hexadecimal string.</summary>
    public string Hex => $"#{R:X2}{G:X2}{B:X2}";
}

/// <summary>One asset of the cartridge as it is shown in the list.</summary>
public sealed class AssetItem
{
    public AssetItem(AssetEntry entry)
    {
        Entry = entry;
    }

    public AssetEntry Entry { get; }

    public string Name => Entry.Name;

    public string Detail => Entry.Describe();

    public override string ToString() => Name;
}

/// <summary>One sprite group of the "sgdata" block.</summary>
public sealed class SpriteGroupItem
{
    public SpriteGroupItem(SpriteGroup group, int index)
    {
        Group = group;
        Index = index;
    }

    public SpriteGroup Group { get; }

    /// <summary>The position of the group in the table.</summary>
    public int Index { get; }

    /// <summary>The id the game gives the group.</summary>
    public string Id => Group.GroupName;

    /// <summary>How many animation frames the group has.</summary>
    public int FrameCount => Group.Frames.Count;

    /// <summary>The tiles the animation uses, as a short list.</summary>
    public string Tiles
    {
        get
        {
            var tiles = Group.Tiles;
            if (tiles.Count == 0)
            {
                return "none";
            }

            var range = tiles.Min() == tiles.Max()
                ? $"{tiles[0]:X2}"
                : $"{tiles.Min():X2}-{tiles.Max():X2}";

            return $"{range} ({tiles.Count} used)";
        }
    }

    /// <summary>The frames of the animation, one per entry.</summary>
    public string Frames => string.Join(" ", Group.Frames.Select(f => $"{f.Tile:X2}/{f.Offset:X2}"));

    /// <summary>The seven parameter bytes of the group.</summary>
    public string Parameters => string.Join(" ", Group.Parameters.Select(p => p.ToString("X2")));

    public override string ToString() => $"{Id} ({FrameCount} frames)";
}
