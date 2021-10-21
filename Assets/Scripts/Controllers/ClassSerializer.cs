using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using UnityEngine;

public class ClassSerializer
{
    const string folderName = "BinaryLandscapeData";
    const string fileExtension = ".dat";

    /// <summary>
    /// Save the specified data.
    /// </summary>
    /// <returns>The save.</returns>
    /// <param name="data">Data.</param>
    public string Save(TerrainSimulationData data)
    {
        string folderPath = Path.Combine(Application.persistentDataPath, folderName);
        if (!Directory.Exists(folderPath))
            Directory.CreateDirectory(folderPath);

        string dataPath = Path.Combine(folderPath, data.GetName() + fileExtension);
        SaveDataArray(data, dataPath);

        PlayerPrefs.SetString("Thin_0_Warm_0", dataPath);       // -- TEMP.

        return dataPath;
    }

    /// <summary>
    /// Load data from file.
    /// </summary>
    /// <returns>The loaded data.</returns>
    public TerrainSimulationData Load(string path)
    {
        TerrainSimulationData landscapeData;

        //string[] filePaths = GetFilePaths();

        //if (filePaths.Length > 0)
        //{
            landscapeData = LoadDataArray(path);
            //landscapeData = LoadDataArray(filePaths[0]);
            return landscapeData;
        //}

        return null;
    }

    /// <summary>
    /// Saves the data array.
    /// </summary>
    /// <param name="data">Data.</param>
    /// <param name="path">Path.</param>
    static void SaveDataArray(TerrainSimulationData data, string path)
    {
        BinaryFormatter binaryFormatter = new BinaryFormatter();

        using (FileStream fileStream = File.Open(path, FileMode.OpenOrCreate))
        {
            binaryFormatter.Serialize(fileStream, data);
        }
    }

    /// <summary>
    /// Loads the data array.
    /// </summary>
    /// <returns>The data array.</returns>
    /// <param name="path">Path.</param>
    static TerrainSimulationData LoadDataArray(string path)
    {
        BinaryFormatter binaryFormatter = new BinaryFormatter();

        using (FileStream fileStream = File.Open(path, FileMode.Open))
        {
            return (TerrainSimulationData)binaryFormatter.Deserialize(fileStream);
        }
    }

    /// <summary>
    /// Gets the file paths.
    /// </summary>
    /// <returns>The file paths.</returns>
    static string[] GetFilePaths()
    {
        string folderPath = Path.Combine(Application.persistentDataPath, folderName);
        return Directory.GetFiles(folderPath, fileExtension);
    }
}
