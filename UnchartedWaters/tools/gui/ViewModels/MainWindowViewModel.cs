using System.Collections.ObjectModel;
using Avalonia.Media.Imaging;
using UnchartedWaters.Core;

namespace UnchartedWaters.Gui.ViewModels;

/// <summary>The state of the editor window.</summary>
public sealed class MainWindowViewModel : ObservableObject
{
    private readonly List<AssetEntry> _assets = new();
    private RomImage? _rom;
    private string? _filePath;
    private AssetItem? _selectedAsset;
    private Bitmap? _graphics;
    private string _status = "Open a cartridge to get started.";
    private BitsPerPixel _bitsPerPixel = BitsPerPixel.Four;
    private int _graphicsColumns = 16;
    private int _graphicsOffset;

    public MainWindowViewModel()
    {
        OpenCommand = new RelayCommand(_ => OpenRequested?.Invoke(this, EventArgs.Empty));
        SaveCommand = new RelayCommand(_ => SaveRequested?.Invoke(this, EventArgs.Empty));
        SaveAsCommand = new RelayCommand(_ => SaveAsRequested?.Invoke(this, EventArgs.Empty));
    }

    /// <summary>Raised when the user asks to open a cartridge.</summary>
    public event EventHandler? OpenRequested;

    /// <summary>Raised when the user asks to save the cartridge.</summary>
    public event EventHandler? SaveRequested;

    /// <summary>Raised when the user asks to save the cartridge under a new name.</summary>
    public event EventHandler? SaveAsRequested;

    public ObservableCollection<AssetItem> Assets { get; } = new();

    public ObservableCollection<HexRow> HexRows { get; } = new();

    public ObservableCollection<TextItem> Strings { get; } = new();

    public ObservableCollection<PaletteItem> Colors { get; } = new();

    public ObservableCollection<SpriteGroupItem> SpriteGroups { get; } = new();

    public RelayCommand OpenCommand { get; }

    public RelayCommand SaveCommand { get; }

    public RelayCommand SaveAsCommand { get; }

    public string Title
    {
        get
        {
            var name = _filePath is null ? "no cartridge" : System.IO.Path.GetFileName(_filePath);
            return $"Uncharted Waters editor - {name}";
        }
    }

    public string Status
    {
        get => _status;
        private set => Set(ref _status, value);
    }

    /// <summary>Report a problem that happened outside of an edit.</summary>
    public void ReportError(string message) => Status = message;

    public bool HasRom => _rom is not null;

    public Bitmap? Graphics
    {
        get => _graphics;
        private set => Set(ref _graphics, value);
    }

    public BitsPerPixel BitsPerPixel
    {
        get => _bitsPerPixel;
        set
        {
            if (Set(ref _bitsPerPixel, value))
            {
                RefreshGraphics();
            }
        }
    }

    public int GraphicsColumns
    {
        get => _graphicsColumns;
        set
        {
            if (Set(ref _graphicsColumns, value < 1 ? 1 : value))
            {
                RefreshGraphics();
            }
        }
    }

    /// <summary>
    /// Where inside the selected block the tile data starts.
    /// </summary>
    /// <remarks>
    /// The graphics blocks carry a header before the tiles, so the tiles
    /// are not at the start of the block.  The user can move the start by
    /// hand to find the right spot.
    /// </remarks>
    public int GraphicsOffset
    {
        get => _graphicsOffset;
        set
        {
            if (Set(ref _graphicsOffset, value < 0 ? 0 : value))
            {
                RefreshGraphics();
            }
        }
    }

    /// <summary>The offset as it is shown in the text box.</summary>
    public string GraphicsOffsetText
    {
        get => _graphicsOffset.ToString();
        set
        {
            if (int.TryParse(value, out var offset) && offset >= 0)
            {
                GraphicsOffset = offset;
            }
        }
    }

    /// <summary>What the header of the selected block says about it.</summary>
    public string BlockKind => _rom is null || SelectedAsset is null
        ? string.Empty
        : AssetHeader.Parse(_rom, SelectedAsset.Entry.FileOffset).Describe();

    public AssetItem? SelectedAsset
    {
        get => _selectedAsset;
        set
        {
            if (Set(ref _selectedAsset, value))
            {
                RefreshViews();
            }
        }
    }

    /// <summary>The tile formats the graphics view offers.</summary>
    public IReadOnlyList<string> BppOptions { get; } = new[] { "2", "4", "8" };

    /// <summary>The selected tile format, as shown in the combo box.</summary>
    public string BppSelection
    {
        get => _bitsPerPixel.ToString();
        set
        {
            if (value is not null && int.TryParse(value, out var bits) && bits is 2 or 4 or 8)
            {
                BitsPerPixel = (BitsPerPixel)bits;
            }
        }
    }

    /// <summary>How many tiles are shown per row.</summary>
    public string ColumnsText
    {
        get => _graphicsColumns.ToString();
        set
        {
            if (int.TryParse(value, out var columns) && columns >= 1)
            {
                GraphicsColumns = columns;
            }
        }
    }

    /// <summary>Load a cartridge from disk.</summary>
    public void Load(string path)
    {
        _rom = RomImage.Load(path);
        _filePath = path;
        _assets.Clear();
        Assets.Clear();

        foreach (var entry in AssetTable.Parse(_rom))
        {
            _assets.Add(entry);
            Assets.Add(new AssetItem(entry));
        }

        Status = $"{_rom.BankCount} banks, {Assets.Count} assets";
        Raise(nameof(HasRom));
        Raise(nameof(Title));

        if (Assets.Count > 0)
        {
            SelectedAsset = Assets[0];
        }
    }

    /// <summary>Save the cartridge back to disk.</summary>
    public void Save(string path)
    {
        if (_rom is null)
        {
            return;
        }

        _rom.Save(path);
        _filePath = path;
        Raise(nameof(Title));
        Status = $"saved {System.IO.Path.GetFileName(path)}";
    }

    /// <summary>The path the cartridge was loaded from.</summary>
    public string? FilePath => _filePath;

    /// <summary>Write an edited string back into the cartridge.</summary>
    public bool ApplyString(TextItem item, string text)
    {
        if (_rom is null)
        {
            return false;
        }

        if (!TextScanner.Replace(_rom, item.Entry, text))
        {
            Status = "the text does not fit into the string";
            return false;
        }

        item.Update(item.Entry with { Text = text });
        Status = "text updated";
        return true;
    }

    private void RefreshViews()
    {
        HexRows.Clear();
        Strings.Clear();
        Colors.Clear();
        SpriteGroups.Clear();
        Graphics = null;

        if (_rom is null || SelectedAsset is null)
        {
            return;
        }

        var entry = SelectedAsset.Entry;
        var start = entry.FileOffset;
        var length = Math.Min(entry.Length, _rom.Data.Length - start);

        Raise(nameof(BlockKind));

        // The sprite table only lives in the raw blocks, the others hold
        // data that is not a table of sprite groups.
        if (AssetHeader.Parse(_rom, start).IsRaw)
        {
            var index = 0;
            foreach (var group in SpriteTable.Parse(_rom, start))
            {
                SpriteGroups.Add(new SpriteGroupItem(group, index++));
            }
        }

        for (var offset = 0; offset < length; offset += 16)
        {
            var count = Math.Min(16, length - offset);
            var hex = new string[16];
            var text = new char[16];

            for (var i = 0; i < count; i++)
            {
                var value = _rom.Data[start + offset + i];
                hex[i] = value.ToString("X2");
                text[i] = value is >= 0x20 and < 0x7F ? (char)value : '.';
            }

            HexRows.Add(new HexRow(
                start + offset,
                string.Join(' ', hex[..count]),
                new string(text, 0, count)));
        }

        // The text of the game is in the script blocks, so every block is
        // looked at.  The dialogue lives in the "s_*" blocks and the user
        // interface strings in "root".
        foreach (var text in TextScanner.Scan(_rom, start, length))
        {
            Strings.Add(new TextItem(text));
        }

        RefreshGraphics();
    }

    private void RefreshGraphics()
    {
        Graphics = null;
        if (_rom is null || SelectedAsset is null)
        {
            return;
        }

        var entry = SelectedAsset.Entry;
        var start = entry.FileOffset;
        var length = Math.Min(entry.Length, _rom.Data.Length - start);
        if (length <= 0)
        {
            return;
        }

        // The tile data does not always start at the beginning of the block:
        // the graphics blocks carry a header first.  The user can move the
        // start by hand.
        var tileStart = start + GraphicsOffset;
        var tileLength = length - GraphicsOffset;
        if (tileLength <= 0)
        {
            return;
        }

        var tileSize = SnesGraphics.TileSize(BitsPerPixel);
        var tileCount = Math.Min(tileLength / tileSize, 4096);
        if (tileCount == 0)
        {
            return;
        }

        var tiles = SnesGraphics.DecodeTiles(_rom.Data.Slice(tileStart, tileCount * tileSize), BitsPerPixel, tileCount);
        var columns = Math.Min(GraphicsColumns, tileCount);
        var rows = (tileCount + columns - 1) / columns;
        var sheet = SnesGraphics.ComposeTiles(tiles, columns, rows);

        Graphics = TileRenderer.Render(sheet, columns * 8, rows * 8, BuildRamp());
    }

    /// <summary>
    /// The shades used for the tile view.  Without a known palette the tiles
    /// are drawn in a grey ramp so that the shapes are still readable.
    /// </summary>
    private uint[] BuildRamp()
    {
        var shades = SnesGraphics.Shades(BitsPerPixel);
        var ramp = new uint[16];

        for (var i = 0; i < ramp.Length; i++)
        {
            // Only the first "shades" entries exist in the current tile format.
            // The remaining entries keep a dark grey so that a wrong format
            // is visible instead of silently collapsing into the background.
            var level = i < shades ? (byte)(i * 255 / (shades - 1)) : (byte)0;
            ramp[i] = Palette.PackArgb(level, level, level);
        }

        return ramp;
    }
}
