/// <summary>
/// Shared math utilities used across controllers and UI.
/// </summary>
public static class MathUtils
{
    /// <summary>
    /// Maps a value from one range to another.
    /// </summary>
    /// <param name="value">The value to map.</param>
    /// <param name="from1">Source range min.</param>
    /// <param name="to1">Source range max.</param>
    /// <param name="from2">Target range min.</param>
    /// <param name="to2">Target range max.</param>
    /// <returns>The mapped value.</returns>
    public static float MapValue(float value, float from1, float to1, float from2, float to2)
    {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
    }
}
