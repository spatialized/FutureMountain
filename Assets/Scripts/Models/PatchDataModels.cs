using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Patch data frame.
/// </summary>
[Serializable]
public class PatchDataFrame : IComparable<PatchDataFrame>
{
    private int month, year;
    private int patchID;
    public float carbon { get; set; }
    public float snow { get; set; }
    public float spread { get; set; }
    public float iter { get; set; }

    /// <summary>
    /// Initializes a new instance of the <see cref="T:PatchDataFrame"/> class.
    /// </summary>
    /// <param name="newPatchID">New patch identifier.</param>
    /// <param name="newMonth">New month.</param>
    /// <param name="newYear">New year.</param>
    public PatchDataFrame(int newPatchID, int newMonth, int newYear)
    {
        patchID = newPatchID;
        month = newMonth;
        year = newYear;
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="T:PatchDataFrame"/> class.
    /// </summary>
    /// <param name="newPatchID">New patch identifier.</param>
    /// <param name="newMonth">New month.</param>
    /// <param name="newYear">New year.</param>
    /// <param name="newCarbon">New carbon.</param>
    /// <param name="newSnow">New snow.</param>
    /// <param name="newSpread">New spread.</param>
    /// <param name="newIter">New iter.</param>
    public PatchDataFrame(int newPatchID, int newMonth, int newYear, float newCarbon, float newSnow, float newSpread, float newIter)
    {
        patchID = newPatchID;
        month = newMonth;
        year = newYear;
        carbon = newCarbon;
        snow = newSnow;
        spread = newSpread;
        iter = newIter;
    }

    /// <summary>
    /// Compares patch ID of this frame to given frame's patch ID.
    /// </summary>
    /// <returns>The comparison result.</returns>
    /// <param name="that">Patch to compare to.</param>
    public int CompareTo(PatchDataFrame that)
    {
        return this.GetMonth().CompareTo(that.GetMonth());
    }

    public int GetPatchID()
    {
        return patchID;
    }

    public int GetMonth()
    {
        return month;
    }

    public int GetYear()
    {
        return year;
    }
}

/// <summary>
/// List of PatchDataFrame objects sorted by month.
/// </summary>
[Serializable]
public class PatchDataMonth : IComparable<PatchDataMonth>
{
    private int index;
    private int month, year;
    private List<PatchDataFrame> dataFrames;

    /// <summary>
    /// Initializes a new instance of the <see cref="T:PatchDataMonth"/> class.
    /// </summary>
    /// <param name="newDataFrames">New data frames.</param>
    /// <param name="newMonth">New month.</param>
    /// <param name="newYear">New year.</param>
    /// <param name="newIndex">New index.</param>
    public PatchDataMonth(List<PatchDataFrame> newDataFrames, int newMonth, int newYear, int newIndex)
    {
        dataFrames = newDataFrames;
        month = newMonth;
        year = newYear;
        index = newIndex;
    }

    public int CompareTo(PatchDataMonth that)
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

    public int GetIndex()
    {
        return index;
    }

    public List<PatchDataFrame> GetFrames()
    {
        return dataFrames;
    }

    public void ClearFrames()
    {
        dataFrames = null;
    }
}

/// <summary>
/// List of PatchDataMonth objects sorted by year.
/// </summary>
[Serializable]
public class PatchDataYear : IComparable<PatchDataYear>
{
    private int year;
    private List<PatchDataMonth> dataMonths;

    /// <summary>
    /// Initializes a new instance of the <see cref="T:PatchDataYear"/> class.
    /// </summary>
    /// <param name="newDataFrames">New data frames.</param>
    /// <param name="newYear">New year.</param>
    public PatchDataYear(List<PatchDataMonth> newDataFrames, int newYear)
    {
        dataMonths = newDataFrames;
        year = newYear;
    }

    public int CompareTo(PatchDataYear that)
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
    public PatchDataMonth GetDataForMonth(int month)
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
            Debug.Log("PatchDataYear.GetDataForMonth()... ERROR: year:" + year + " month:" + month + " dataMonths:" + dataMonths.Count);
            return null;
        }
    }

    public List<PatchDataMonth> GetMonths()
    {
        return dataMonths;
    }
}
