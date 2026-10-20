namespace UnchartedWaters.Core;

/// <summary>
/// Small formatting helpers shared by the editor and the tools.
///
/// The C# numeric format strings do not zero pad the way the Python ones do:
/// <c>"X4"</c> prints at least four digits but leaves out the leading zeros,
/// while <c>"04X"</c> is read as a digit placeholder followed by the literal
/// text "4X".  These helpers produce the padded form the tools expect.
/// </summary>
public static class Format
{
    /// <summary>Format a number as uppercase hexadecimal, padded to a width.</summary>
    /// <param name="value">The number to format.</param>
    /// <param name="digits">How many digits the result should have.</param>
    public static string Hex(int value, int digits) =>
        value.ToString("X").PadLeft(digits, '0');

    /// <summary>Format a number as uppercase hexadecimal, padded to a width.</summary>
    /// <param name="value">The number to format.</param>
    /// <param name="digits">How many digits the result should have.</param>
    public static string Hex(long value, int digits) =>
        value.ToString("X").PadLeft(digits, '0');
}
