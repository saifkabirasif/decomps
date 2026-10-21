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
    private string _searchText = string.Empty;
    private string _searchKeys = string.Empty;
    private string _searchStatus = "Search the memory of the running game for a string.";
    private bool _searching;

    public MainWindowViewModel()
    {
        OpenCommand = new RelayCommand(_ => OpenRequested?.Invoke(this, EventArgs.Empty));
        SaveCommand = new RelayCommand(_ => SaveRequested?.Invoke(this, EventArgs.Empty));
        SaveAsCommand = new RelayCommand(_ => SaveAsRequested?.Invoke(this, EventArgs.Empty));
        SearchCommand = new AsyncRelayCommand(_ => SearchAsync());
        ReadColoursCommand = new AsyncRelayCommand(_ => ReadColoursAsync());
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

    public ObservableCollection<MemoryHitItem> SearchResults { get; } = new();

    public ObservableCollection<CgramPalette> Palettes { get; } = new();

    public RelayCommand OpenCommand { get; }

    public RelayCommand SaveCommand { get; }

    public RelayCommand SaveAsCommand { get; }

    public AsyncRelayCommand SearchCommand { get; }

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
                Raise(nameof(GraphicsOffsetText));
                RefreshGraphics();
            }
        }
    }

    /// <summary>The offset as it is shown in the text box.</summary>
    /// <remarks>
    /// The offset is shown in hexadecimal, because that is how the
    /// addresses of the cartridge are written down.  A number without a
    /// prefix is read as a decimal one.
    /// </remarks>
    public string GraphicsOffsetText
    {
        get => $"0x{_graphicsOffset:X}";
        set
        {
            if (TryParseOffset(value, out var offset) && offset >= 0)
            {
                GraphicsOffset = offset;
            }
        }
    }

    /// <summary>Read an offset that may be written in hex or in decimal.</summary>
    private static bool TryParseOffset(string? text, out int offset)
    {
        offset = 0;

        if (string.IsNullOrWhiteSpace(text))
        {
            return false;
        }

        var trimmed = text.Trim();
        if (trimmed.StartsWith("0x", StringComparison.OrdinalIgnoreCase))
        {
            return int.TryParse(trimmed[2..], System.Globalization.NumberStyles.HexNumber,
                System.Globalization.CultureInfo.InvariantCulture, out offset);
        }

        return int.TryParse(trimmed, out offset);
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

        // The whole cartridge comes first.  A lot of the graphics of the
        // game sits in parts of the cartridge that the table of the named
        // blocks does not describe, and this is the only way to get at them.
        var whole = new AssetEntry(
            "the whole cartridge",
            0,
            0x8000,
            _rom.Data.Length,
            0);
        _assets.Add(whole);
        Assets.Add(new AssetItem(whole));

        foreach (var entry in AssetTable.Parse(_rom))
        {
            _assets.Add(entry);
            Assets.Add(new AssetItem(entry));
        }

        Status = $"{_rom.BankCount} banks, {Assets.Count - 1} assets";
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

    /// <summary>The text to look for in the running game.</summary>
    public string SearchText
    {
        get => _searchText;
        set => Set(ref _searchText, value);
    }

    /// <summary>
    /// The keys to press before the search, separated by commas.
    /// </summary>
    /// <remarks>
    /// The text of the game is only in the memory of the game once it has
    /// been shown, so the game has to be walked to the right place first.
    /// </remarks>
    public string SearchKeys
    {
        get => _searchKeys;
        set => Set(ref _searchKeys, value);
    }

    /// <summary>What the last search did.</summary>
    public string SearchStatus
    {
        get => _searchStatus;
        private set => Set(ref _searchStatus, value);
    }

    /// <summary>Which palette of the game the tiles are drawn with.</summary>
    public int SelectedPalette
    {
        get => _selectedPalette;
        set
        {
            if (Set(ref _selectedPalette, value < 0 ? 0 : value))
            {
                Raise(nameof(SelectedPaletteName));
                RefreshGraphics();
            }
        }
    }

    private int _selectedPalette;

    /// <summary>The name of the palette the tiles are drawn with.</summary>
    public string SelectedPaletteName =>
        Palettes.Count > 0 && SelectedPalette < Palettes.Count
            ? $"palette {SelectedPalette}"
            : "grey ramp";

    /// <summary>
    /// Read the colours of the running game and use them for the tiles.
    /// </summary>
    private async Task ReadColoursAsync()
    {
        if (_rom is null)
        {
            return;
        }

        var tools = MemorySearch.FindToolsFolder();
        if (tools is null)
        {
            Status = "The Python tooling was not found, the tiles stay grey.";
            return;
        }

        try
        {
            var romPath = Path.Combine(Path.GetTempPath(), "ucw-colours.sfc");
            await Task.Run(() => File.WriteAllBytes(romPath, _rom.WritableData));

            var reader = new CgramReader(tools);
            var palettes = await Task.Run(() => reader.ReadAsync(romPath, CancellationToken.None));

            Palettes.Clear();
            foreach (var palette in palettes)
            {
                Palettes.Add(palette);
            }

            // A brush of the window system may only be made on the thread
            // of the window, so it is filled in here, after the colours
            // have been read.
            foreach (var palette in Palettes)
            {
                foreach (var entry in palette.Entries)
                {
                    entry.Brush = new Avalonia.Media.SolidColorBrush(
                        Avalonia.Media.Color.FromRgb(entry.R, entry.G, entry.B));
                }
            }

            if (Palettes.Count > 0)
            {
                Status = $"{Palettes.Count} palettes of the game read.";
                Raise(nameof(SelectedPaletteName));
                RefreshGraphics();
            }
            else
            {
                Status = "The colours of the game could not be read.";
            }
        }
        catch (Exception ex)
        {
            Status = $"the colours could not be read: {ex.Message}";
        }
    }

    /// <summary>Read the colours of the running game.</summary>
    public AsyncRelayCommand ReadColoursCommand { get; }

    /// <summary>Is a search running at the moment?</summary>
    public bool Searching
    {
        get => _searching;
        private set => Set(ref _searching, value);
    }

    /// <summary>
    /// Look for the search text in the memory of the running game.
    /// </summary>
    private async Task SearchAsync()
    {
        SearchResults.Clear();

        if (_rom is null)
        {
            SearchStatus = "Open a cartridge first.";
            return;
        }

        if (string.IsNullOrWhiteSpace(SearchText))
        {
            SearchStatus = "Type what to look for.";
            return;
        }

        var tools = MemorySearch.FindToolsFolder();
        if (tools is null)
        {
            SearchStatus =
                "The Python tooling was not found. Set UCW_TOOLS to the folder " +
                "that holds memsearch.py.";
            return;
        }

        Searching = true;
        SearchStatus = "Running the game...";

        try
        {
            // The search has to see the changes the user made, so the
            // cartridge is written out first.  The file is written in one
            // go: the editor is busy with the window at this point and the
            // asynchronous file operations of the runtime do not always
            // finish while the window system holds the thread pool.
            var romPath = Path.Combine(Path.GetTempPath(), "ucw-search.sfc");
            await Task.Run(() => File.WriteAllBytes(romPath, _rom.WritableData));

            var keys = SearchKeys
                .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);

            var search = new MemorySearch(tools);
            var outcome = await Task.Run(() => search.RunAsync(
                romPath, SearchText, keys, 120, CancellationToken.None));

            foreach (var hit in outcome.Hits)
            {
                SearchResults.Add(new MemoryHitItem(hit));
            }

            if (!outcome.Ok)
            {
                SearchStatus = outcome.Error ?? "the search failed.";
            }
            else
            {
                SearchStatus = outcome.Hits.Count == 0
                    ? $"'{SearchText}' was not found in the memory of the game."
                    : $"{outcome.Hits.Count} hits for '{SearchText}'.";
            }
        }
        catch (Exception ex)
        {
            SearchStatus = $"the search failed: {ex.Message}";
        }
        finally
        {
            Searching = false;
        }
    }

    /// <summary>Select the asset a hit came from and show the place.</summary>
    public void GoToBlock(MemoryBlock block)
    {
        var asset = Assets.FirstOrDefault(a => a.Entry.Name == block.Name);
        if (asset is not null)
        {
            SelectedAsset = asset;
        }

        Status = $"{block.Name} at bank ${Format.Hex(block.Bank, 2)}:{Format.Hex(block.Address, 4)}";
    }

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
    /// The shades used for the tile view.
    /// </summary>
    /// <remarks>
    /// When the colours of the game have been read they are used, so that
    /// the tiles look the way they look in the game.  Without them the
    /// tiles are drawn in a grey ramp, so that the shapes are still
    /// readable.
    /// </remarks>
    private uint[] BuildRamp()
    {
        var ramp = new uint[16];

        if (SelectedPalette >= 0 && SelectedPalette < Palettes.Count)
        {
            var colors = Palettes[SelectedPalette].Colors;
            for (var i = 0; i < ramp.Length && i < colors.Count; i++)
            {
                var (r, g, b) = colors[i];
                ramp[i] = Palette.PackArgb(r, g, b);
            }

            return ramp;
        }

        var shades = SnesGraphics.Shades(BitsPerPixel);
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
