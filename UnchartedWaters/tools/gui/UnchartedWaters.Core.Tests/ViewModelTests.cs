using UnchartedWaters.Core;
using UnchartedWaters.Gui.ViewModels;
using Xunit;

namespace UnchartedWaters.Core.Tests;

/// <summary>Tests for the parts of the editor that need the window system.</summary>
public class ViewModelTests
{
    [Fact]
    public void TheOffsetIsShownInHexadecimal()
    {
        var vm = new MainWindowViewModel();

        vm.GraphicsOffset = 0x62730;

        Assert.Equal("0x62730", vm.GraphicsOffsetText);
    }

    [Fact]
    public void TheOffsetCanBeGivenInHexadecimal()
    {
        var vm = new MainWindowViewModel();

        vm.GraphicsOffsetText = "0x62730";

        Assert.Equal(0x62730, vm.GraphicsOffset);
    }

    [Fact]
    public void TheOffsetCanBeGivenInDecimal()
    {
        var vm = new MainWindowViewModel();

        vm.GraphicsOffsetText = "403504";

        Assert.Equal(403504, vm.GraphicsOffset);
    }

    [Fact]
    public void AWrongOffsetIsIgnored()
    {
        var vm = new MainWindowViewModel();
        vm.GraphicsOffset = 16;

        vm.GraphicsOffsetText = "not a number";

        Assert.Equal(16, vm.GraphicsOffset);
    }

    [Fact]
    public void TheWholeCartridgeIsTheFirstEntry()
    {
        var vm = new MainWindowViewModel();

        // The graphics of the game sits in parts of the cartridge that the
        // table of the named blocks does not describe, so the whole
        // cartridge has to be reachable.
        var path = Path.Combine(Path.GetTempPath(), "ucw-test-cartridge.sfc");
        File.WriteAllBytes(path, new byte[0x100000]);
        try
        {
            vm.Load(path);
        }
        finally
        {
            File.Delete(path);
        }

        Assert.Equal("the whole cartridge", vm.Assets[0].Name);
    }
}
