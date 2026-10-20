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

    public TextItem(int offset, string text)
    {
        Offset = offset;
        _text = text;
    }

    /// <summary>File offset of the string inside the ROM image.</summary>
    public int Offset { get; }

    /// <summary>The text of the string.</summary>
    public string Text
    {
        get => _text;
        set => Set(ref _text, value);
    }

    /// <summary>The offset as it is shown in the list.</summary>
    public string Location => $"${Offset:X6}";
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
