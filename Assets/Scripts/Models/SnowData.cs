using System;
using UnityEngine;

/// <summary>
/// Terrain snow data frame.
/// </summary>
[Serializable]
public class SnowDataFrame
{
    int year, month, day;
    float[,,] data;
    float avgSnow;

    /// <summary>
    /// Initializes a new instance of the <see cref="T:SnowDataFrame"/> class.
    /// </summary>
    /// <param name="newDay">New day.</param>
    /// <param name="newMonth">New month.</param>
    /// <param name="newYear">New year.</param>
    /// <param name="newData">New data.</param>
    /// <param name="newAvgSnow">New average snow.</param>
    public SnowDataFrame(int newDay, int newMonth, int newYear, float[,,] newData, float newAvgSnow)
    {
        day = newDay;
        month = newMonth;
        year = newYear;
        data = newData;
        avgSnow = newAvgSnow;

        if (float.IsNaN(avgSnow))
            avgSnow = 0f;
    }

    public float[,,] GetData()
    {
        return data;
    }

    public int GetYear()
    {
        return year;
    }

    public int GetMonth()
    {
        return month;
    }

    public int GetDay()
    {
        return day;
    }

    public float GetAverageSnow()
    {
        return avgSnow;
    }
}
