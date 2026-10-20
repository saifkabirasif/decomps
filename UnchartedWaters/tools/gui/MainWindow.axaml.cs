using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Markup.Xaml;
using Avalonia.Platform.Storage;
using UnchartedWaters.Gui.ViewModels;

namespace UnchartedWaters.Gui;

public partial class MainWindow : Window
{
    private readonly MainWindowViewModel _viewModel = new();

    public MainWindow()
    {
        InitializeComponent();
        DataContext = _viewModel;

        _viewModel.OpenRequested += OnOpen;
        _viewModel.SaveRequested += OnSave;
        _viewModel.SaveAsRequested += OnSaveAs;
    }

    /// <summary>
    /// Open a cartridge that was named on the command line.
    /// </summary>
    /// <remarks>
    /// This makes it possible to start the editor with a ROM already open,
    /// which is handy for testing and for screenshots.
    /// </remarks>
    public void OpenFromCommandLine(string path)
    {
        try
        {
            _viewModel.Load(path);
        }
        catch (Exception ex)
        {
            _viewModel.ReportError($"could not open {path}: {ex.Message}");
        }
    }

    private void InitializeComponent() => AvaloniaXamlLoader.Load(this);

    private async void OnOpen(object? sender, EventArgs e)
    {
        var file = await PickFileAsync("Open the cartridge", save: false);
        if (file is null)
        {
            return;
        }

        try
        {
            _viewModel.Load(file.Path.LocalPath);
        }
        catch (Exception ex)
        {
            await ShowErrorAsync(ex.Message);
        }
    }

    private async void OnSave(object? sender, EventArgs e)
    {
        if (_viewModel.FilePath is null)
        {
            OnSaveAs(sender, e);
            return;
        }

        try
        {
            _viewModel.Save(_viewModel.FilePath);
        }
        catch (Exception ex)
        {
            await ShowErrorAsync(ex.Message);
        }
    }

    private async void OnSaveAs(object? sender, EventArgs e)
    {
        var file = await PickFileAsync("Save the cartridge", save: true);
        if (file is null)
        {
            return;
        }

        try
        {
            _viewModel.Save(file.Path.LocalPath);
        }
        catch (Exception ex)
        {
            await ShowErrorAsync(ex.Message);
        }
    }

    private async Task<IStorageFile?> PickFileAsync(string title, bool save)
    {
        var files = await StorageProvider.OpenFilePickerAsync(new FilePickerOpenOptions
        {
            Title = title,
            AllowMultiple = false,
            FileTypeFilter = new[]
            {
                new FilePickerFileType("SNES cartridge")
                {
                    Patterns = new[] { "*.sfc", "*.smc", "*.SFC", "*.SMC" },
                },
            },
        });

        if (files.Count > 0)
        {
            return files[0];
        }

        var target = await StorageProvider.SaveFilePickerAsync(new FilePickerSaveOptions
        {
            Title = title,
            SuggestedFileName = "Uncharted Waters (USA).sfc",
            FileTypeChoices = new[]
            {
                new FilePickerFileType("SNES cartridge")
                {
                    Patterns = new[] { "*.sfc" },
                },
            },
        });

        return target;
    }

    private async Task ShowErrorAsync(string message)
    {
        var window = new Window
        {
            Title = "Something went wrong",
            Width = 420,
            Height = 140,
            WindowStartupLocation = WindowStartupLocation.CenterOwner,
            Content = new TextBlock
            {
                Text = message,
                Margin = new Avalonia.Thickness(16),
                TextWrapping = Avalonia.Media.TextWrapping.Wrap,
            },
        };

        await window.ShowDialog(this);
    }
}
