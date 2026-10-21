namespace UnchartedWaters.Core;

/// <summary>One frame of a sprite animation.</summary>
/// <param name="Tile">The tile the frame uses.</param>
/// <param name="Offset">The position offset of the frame.</param>
public sealed record SpriteFrame(byte Tile, byte Offset);

/// <summary>
/// One group of sprites inside the "sgdata" block.
///
/// A group is a fixed size record of 51 bytes.  The first seven bytes hold
/// the parameters of the group, the eighth one is a back pointer to the
/// byte in front of the record and the ninth one is the id of the group.
/// What follows is a list of animation frames, two bytes each, ended by
/// $FF.  The rest of the record is padding.
/// </summary>
public sealed record SpriteGroup(
    int Offset,
    byte[] Parameters,
    byte Id,
    IReadOnlyList<SpriteFrame> Frames)
{
    /// <summary>The id of the group as the game calls it.</summary>
    public string GroupName => $"${Id:X2}";

    /// <summary>The tiles the animation steps through.</summary>
    /// <remarks>
    /// A group without any frames has no tiles, so this list can be empty.
    /// </remarks>
    public IReadOnlyList<byte> Tiles => Frames.Select(f => f.Tile).Distinct().ToArray();
}

/// <summary>
/// The table of sprite groups at the start of the "sgdata" block.
///
/// The block starts with the five byte header of every asset and then
/// holds twenty records of 51 bytes.  The groups come in sets of five that
/// share an id, and the record after the last one is empty, which marks
/// the end of the table.
/// </summary>
public static class SpriteTable
{
    /// <summary>Size of the header in front of the records.</summary>
    public const int HeaderSize = 5;

    /// <summary>Size of one group record.</summary>
    public const int RecordSize = 0x33;

    /// <summary>Number of parameter bytes in front of the frames.</summary>
    public const int ParameterSize = 7;

    /// <summary>Offset of the id byte inside a record.</summary>
    public const int IdOffset = 8;

    /// <summary>Offset of the first frame inside a record.</summary>
    public const int FramesOffset = 9;

    /// <summary>The byte that ends the list of frames.</summary>
    public const byte Terminator = 0xFF;

    /// <summary>
    /// Read the sprite groups out of a block.
    /// </summary>
    /// <param name="rom">The image.</param>
    /// <param name="offset">File offset of the block.</param>
    public static IReadOnlyList<SpriteGroup> Parse(RomImage rom, int offset)
    {
        var groups = new List<SpriteGroup>();
        var data = rom.Data;

        for (var index = 0; ; index++)
        {
            var record = offset + HeaderSize + index * RecordSize;
            if (record + RecordSize > data.Length)
            {
                break;
            }

            // An empty record ends the table.
            if (IsEmpty(data, record))
            {
                break;
            }

            groups.Add(ParseRecord(data, record));
        }

        return groups;
    }

    private static bool IsEmpty(ReadOnlySpan<byte> data, int record)
    {
        for (var i = 0; i < RecordSize; i++)
        {
            if (data[record + i] != 0)
            {
                return false;
            }
        }

        return true;
    }

    private static SpriteGroup ParseRecord(ReadOnlySpan<byte> data, int record)
    {
        var parameters = data.Slice(record, ParameterSize).ToArray();
        var id = data[record + IdOffset];

        var frames = new List<SpriteFrame>();
        var at = record + FramesOffset;
        while (at + 1 < record + RecordSize && data[at] != Terminator)
        {
            frames.Add(new SpriteFrame(data[at], data[at + 1]));
            at += 2;
        }

        return new SpriteGroup(record, parameters, id, frames);
    }
}
