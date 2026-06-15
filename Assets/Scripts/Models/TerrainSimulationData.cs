using System;
using System.Collections.Generic;

/// <summary>
/// Terrain simulation data.
/// </summary>
[Serializable]
public class TerrainSimulationData
{
    List<SnowDataFrame> snowData;               // Currently unused?
    List<FireDataFrame> fireData;
    string name;

    public TerrainSimulationData(List<SnowDataFrame> newSnowData, List<FireDataFrame> newFireData, string newName)
    {
        name = newName;
        snowData = newSnowData;
        fireData = newFireData;
    }

    public List<SnowDataFrame> GetSnowData()
    {
        return snowData;
    }

    public List<FireDataFrame> GetFireData()
    {
        return fireData;
    }

    public bool HasPreloadedSnowData()
    {
        return !(snowData == null);
    }

    public string GetName()
    {
        return name;
    }
}
