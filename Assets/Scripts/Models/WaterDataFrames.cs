using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Water data frame.
/// </summary>
[Serializable]
public class WaterDataFrame : IComparable<WaterDataFrame>
{
    public int index;
    public int year, month, day;
    public float QBase { get; set; }
    public float QWarm1 { get; set; }
    public float QWarm2 { get; set; }
    public float QWarm4 { get; set; }
    public float QWarm6 { get; set; }
    public float precipitation { get; set; }

    /// <summary>
    /// Initializes a new instance of the <see cref="T:WaterDataFrame"/> class.
    /// </summary>
    /// <param name="newYear">New year.</param>
    /// <param name="newMonth">New month.</param>
    /// <param name="newDay">New day.</param>
    /// <param name="newPrecipitation">New precipitation.</param>
    /// <param name="newQBase">New base streamflow.</param>
    /// <param name="newIndex">New index.</param>
    public WaterDataFrame(int newYear, int newMonth, int newDay, float newPrecipitation, float newQBase, float newQWarm1, float newQWarm2, float newQWarm4, float newQWarm6, int newIndex)
    {
        index = newIndex;
        year = newYear;
        month = newMonth;
        day = newDay;
        QBase = newQBase;
        QWarm1 = newQWarm1;
        QWarm2 = newQWarm2;
        QWarm4 = newQWarm4;
        QWarm6 = newQWarm6;
        precipitation = newPrecipitation;
    }

    public int CompareTo(WaterDataFrame that)
    {
        return this.GetIndex().CompareTo(that.GetIndex());
    }

    /// <summary>
    /// Gets the streamflow for the given warming index.
    /// </summary>
    /// <returns>The streamflow for warming index.</returns>
    /// <param name="warmIdx">Warming index.</param>
    public float GetStreamflowForWarmingIdx(int warmIdx)
    {
        switch (warmIdx)
        {
            case 0:
                return QBase;
            case 1:
                return QWarm1;
            case 2:
                return QWarm2;
            case 3:
                return QWarm4;
            case 4:
                return QWarm6;
            default:
                return QBase;
        }
    }

    public int GetDay()
    {
        return day;
    }

    public int GetMonth()
    {
        return month;
    }

    public int GetYear()
    {
        return year;
    }

    public int GetIndex()
    {
        return index;
    }
}

/// <summary>
/// List of WaterDataFrame objects sorted by month.
/// </summary>
[Serializable]
public class WaterDataMonth : IComparable<WaterDataMonth>
{
    public int index;
    public int month, year;
    public List<WaterDataFrame> dataFrames;

    /// <summary>
    /// Initializes a new instance of the <see cref="T:WaterDataMonth"/> class.
    /// </summary>
    /// <param name="newDataFrames">New data frames.</param>
    /// <param name="newMonth">New month.</param>
    /// <param name="newYear">New year.</param>
    public WaterDataMonth(List<WaterDataFrame> newDataFrames, int newMonth, int newYear)
    {
        dataFrames = newDataFrames;
        month = newMonth;
        year = newYear;
    }

    public int CompareTo(WaterDataMonth that)
    {
        return this.GetMonth().CompareTo(that.GetMonth());
    }

    public int GetMonth()
    {
        return month;
    }

    public int GetYear()
    {
        return year;
    }

    public WaterDataFrame GetDataForDay(int day)
    {
        if (day < 0 || day > dataFrames.Count)
            return null;
        else
            return dataFrames[day - 1];
    }

    public List<WaterDataFrame> GetFrames()
    {
        return dataFrames;
    }
}

/// <summary>
/// List of WaterDataMonth objects sorted by year.
/// </summary>
[Serializable]
public class WaterDataYear : IComparable<WaterDataYear>
{
    public int year;
    public List<WaterDataMonth> dataMonths;

    public WaterDataYear(List<WaterDataMonth> newDataFrames, int newYear)
    {
        dataMonths = newDataFrames;
        year = newYear;
    }

    public int CompareTo(WaterDataYear that)
    {
        return this.GetYear().CompareTo(that.GetYear());
    }

    public int GetYear()
    {
        return year;
    }

    /// <summary>
    /// Gets the data for month.
    /// </summary>
    /// <returns>The data for month.</returns>
    /// <param name="month">Month.</param>
    public WaterDataMonth GetDataForMonth(int month)
    {
        if (dataMonths.Count < 12)                       // Check for incomplete year data
        {
            if (dataMonths[0].GetMonth() > 1)
            {
                int startMonth = dataMonths[0].GetMonth();
                month = month - startMonth + 1;
            }
        }

        if (month > 0 && month <= dataMonths.Count)
        {
            return dataMonths[month - 1];
        }
        else
        {
            Debug.Log("WaterDataYear.GetDataForMonth()... ERROR: year:" + year + " month:" + month + " dataMonths:" + dataMonths.Count);
            return null;
        }
    }

    public List<WaterDataMonth> GetMonths()
    {
        return dataMonths;
    }

    /// <summary>
    /// Get total precipitation for year.
    /// </summary>
    /// <returns></returns>
    public float GetTotalPrecipitation()
    {
        float result = 0f;
        foreach (WaterDataMonth month in dataMonths)
        {
            foreach (WaterDataFrame frame in month.GetFrames())
            {
                result += frame.precipitation;
            }
        }
        return result;
    }

    /// <summary>
    /// Get total streamflow.
    /// </summary>
    /// <returns></returns>
    public float GetTotalStreamflow(int warmIdx)
    {
        float result = 0f;
        foreach (WaterDataMonth month in dataMonths)
        {
            foreach (WaterDataFrame frame in month.GetFrames())
            {
                result += frame.GetStreamflowForWarmingIdx(warmIdx);
            }
        }
        return result;
    }
}
