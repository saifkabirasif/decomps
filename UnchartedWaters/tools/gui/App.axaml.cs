using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Markup.Xaml;

namespace UnchartedWaters.Gui;

public partial class App : Application
{
    public override void Initialize() => AvaloniaXamlLoader.Load(this);

    public override void OnFrameworkInitializationCompleted()
    {
        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            var window = new MainWindow();
            desktop.MainWindow = window;

            // A path on the command line is opened straight away, so that the
            // editor can be started with a cartridge already loaded.
            var path = TryGetRomPath(desktop.Args ?? Array.Empty<string>());
            if (path is not null)
            {
                window.OpenFromCommandLine(path);
            }
        }

        base.OnFrameworkInitializationCompleted();
    }

    /// <summary>Pick the first argument that looks like a cartridge.</summary>
    private static string? TryGetRomPath(string[] args)
    {
        foreach (var arg in args)
        {
            if (arg.StartsWith('-'))
            {
                continue;
            }

            if (File.Exists(arg))
            {
                return arg;
            }
        }

        return null;
    }
}
