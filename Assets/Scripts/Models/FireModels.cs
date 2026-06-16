using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Data point on fire grid associated with a PatchPoint.
/// </summary>
[Serializable]
public class FireDataPoint : IComparable<FireDataPoint>
{
    public Vector2 gridLocation;
    public int patchId;
    public float spread;
    public int iter;

    /// <summary>
    /// Constructor 
    /// </summary>
    /// <param name="newGridLocation">Grid location</param>
    /// <param name="newSpread"></param>
    /// <param name="newIter"></param>
    public FireDataPoint(Vector2 newGridLocation, int newPatchId, float newSpread, int newIter)
    {
        gridLocation = newGridLocation;
        patchId = newPatchId;
        spread = newSpread;
        iter = newIter;
    }

    public Vector2 GetGridPosition()
    {
        return gridLocation;
    }

    /// <summary>
    /// Gets X coord.
    /// </summary>
    /// <returns>The x.</returns>
    public int X()
    {
        return (int)gridLocation.x;
    }

    /// <summary>
    /// Gets Y coord.
    /// </summary>
    /// <returns>The y.</returns>
    public int Y()
    {
        return (int)gridLocation.y;
    }

    public float GetSpread()
    {
        return spread;
    }

    public int GetIter()
    {
        return iter;
    }

    public int GetPatchID()
    {
        return patchId;
    }

    public int CompareTo(FireDataPoint that)
    {
        return this.GetIter().CompareTo(that.GetIter());
    }
}

/// <summary>
/// Collection of fire data points.
/// </summary>
[Serializable]
public class FireDataPointCollection
{
    public List<FireDataPoint> points;

    public FireDataPointCollection()
    {
        points = new List<FireDataPoint>();
    }

    public void AddPoint(FireDataPoint newPoint)
    {
        points.Add(newPoint);
    }

    public List<FireDataPoint> GetPoints()
    {
        return points;
    }
}

/// <summary>
/// Terrain fire data frame.
/// </summary>
public class FireDataFrame
{
    public FireDataPointCollection[,] dataGrid;
    public List<FireDataPoint> dataList;
    public int year, month, day;
    public int gridHeight;
    public int gridWidth;

    public FireDataFrame(int newDay, int newMonth, int newYear, int newGridHeight, int newGridWidth, List<FireDataPoint> newDataList, FireDataPointCollection[,] newDataGrid)
    {
        year = newYear;
        month = newMonth;
        day = newDay;
        dataGrid = newDataGrid;
        dataList = newDataList;
        gridHeight = newGridHeight;
        gridWidth = newGridWidth;
    }

    public int GetYear()
    {
        return year;
    }

    public int GetMonth()
    {
        return month;
    }

    public void SetDay(int newDay)
    {
        day = newDay;
    }

    public int GetDay()
    {
        return day;
    }

    public int GetGridHeight()
    {
        return gridHeight;
    }

    public int GetGridWidth()
    {
        return gridWidth;
    }

    public FireDataPointCollection[,] GetDataGrid()
    {
        return dataGrid;
    }

    public List<FireDataPoint> GetDataList()
    {
        return dataList;
    }

    public void OptimizeData()
    {
        FireDataPointCollection[,] newDataGrid = new FireDataPointCollection[gridWidth, gridHeight];
        List<FireDataPoint> newDataList = new List<FireDataPoint>();

        for (int x = 0; x < gridWidth; x++)
        {
            for (int y = 0; y < gridHeight; y++)
            {
                int iter = 0;
                float size = 0f;
                int patchId = -1;
                FireDataPointCollection coll = dataGrid[x, y];
                if (coll == null)
                {
                    Debug.Log("OptimizeData() WARNING coll == null?: " + (coll == null));
                    coll = new FireDataPointCollection();
                }

                if (coll.GetPoints() == null)
                {
                    Debug.Log("coll.GetPoints() == null? " + (coll.GetPoints() == null));
                    coll.points = new List<FireDataPoint>();
                }

                foreach (FireDataPoint p in coll.GetPoints())
                {
                    iter += p.GetIter();

                    float fireSizeFactor = 5f;                  // -- TO DO: MOVE TO SETTINGS
                    size += p.GetSpread() * fireSizeFactor;

                    patchId = p.patchId;
                }

                if (patchId == -1)
                {
                    Debug.Log("NO PatchId");
                }
                FireDataPointCollection newColl = new FireDataPointCollection();
                FireDataPoint fdp = new FireDataPoint(new Vector2(x, y), patchId, size, iter);
                newColl.AddPoint(fdp);
                newDataList.Add(fdp);
                newDataGrid[x, y] = newColl;
            }
        }

        dataGrid = newDataGrid;
        dataList = newDataList;
    }
}

/// <summary>
/// Terrain fire data frame record (for serialization).
/// </summary>
[Serializable]
public class FireDataFrameRecord
{
    public List<FireDataPoint> dataList;
    public int year, month, day;
    public int gridHeight;
    public int gridWidth;

    public FireDataFrameRecord(int newDay, int newMonth, int newYear, int newGridHeight, int newGridWidth, List<FireDataPoint> newDataList)
    {
        year = newYear;
        month = newMonth;
        day = newDay;
        dataList = newDataList;
        gridHeight = newGridHeight;
        gridWidth = newGridWidth;
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

    public int GetGridHeight()
    {
        return gridHeight;
    }

    public int GetGridWidth()
    {
        return gridWidth;
    }

    public FireDataPointCollection[,] GetDataGrid()
    {
        FireDataPointCollection[,] firePointGrid = new FireDataPointCollection[gridWidth, gridHeight];

        for (int x = 0; x < gridWidth; x++)
        {
            for (int y = 0; y < gridHeight; y++)
            {
                firePointGrid[x, y] = new FireDataPointCollection();
            }
        }

        foreach (FireDataPoint fdp in dataList)                                            // Loop over points in collection
        {
            if (Mathf.Abs(fdp.spread) > 0.0001) // Ignore if fire didn't spread to patch
            {
                int gridX = (int)fdp.GetGridPosition().x;
                int gridY = (int)fdp.GetGridPosition().y;
                firePointGrid[gridX, gridY].AddPoint(fdp);
            }
        }

        return firePointGrid;
    }

    public List<FireDataPoint> GetDataList()
    {
        return dataList;
    }
}
