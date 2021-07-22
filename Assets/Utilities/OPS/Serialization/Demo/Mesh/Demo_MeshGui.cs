using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using UnityEngine;

/// <summary>
/// Gui Component, used for generating, saving and loading cubes.
/// </summary>
public class Demo_MeshGui : MonoBehaviour
{
    public GameObject CubePrefab;

    /// <summary>
    /// Create 10 new cubes with random sizes.
    /// Serialize the mesh and save it to a file.
    /// </summary>
    public void GenerateCubes()
    {
        int x = Random.Range(2, 8);
        int y = Random.Range(2, 8);
        int z = Random.Range(2, 8);
        Mesh mesh = null;
        for (int i = 0; i < 10; i++)
        {
            GameObject newCube = Instantiate(CubePrefab, new Vector3(Random.Range(-10, 10), Random.Range(-3, 3), Random.Range(-10, 10)), new Quaternion(0, 0, 0, 0));
            RoundedCube roundedCube = newCube.GetComponent<RoundedCube>();
            roundedCube.xSize = x;
            roundedCube.ySize = y;
            roundedCube.zSize = z;
            roundedCube.Generate();

            mesh = roundedCube.GetComponent<MeshFilter>().mesh;
        }

        FileStream stream = new FileStream("OPS_Mesh.ser", FileMode.Create);
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();
        OPS.Serialization.IO.Serializer.SerializeToStream(stream, mesh);
        stopwatch.Stop();
        stream.Close();
        
        UnityEngine.Debug.Log("Save Mesh: Size: " + mesh.bounds + " ElapsedMilliseconds: " + stopwatch.ElapsedMilliseconds);
    }

    /// <summary>
    /// Create 10 Cubes basing on the last saved mesh.
    /// </summary>
    public void LoadCubes()
    {
        if(!File.Exists("OPS_Mesh.ser"))
        {
            UnityEngine.Debug.LogError("OPS_Mesh.ser does not exits. Please use first generate!");
        }

        
        FileStream stream = new FileStream("OPS_Mesh.ser", FileMode.Open);
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();
        Mesh mesh = OPS.Serialization.IO.Serializer.DeSerializeFromStream<Mesh>(stream);
        stopwatch.Stop();
        stream.Close();

        UnityEngine.Debug.Log("Load Mesh: Size: " + mesh.bounds + " ElapsedMilliseconds: " + stopwatch.ElapsedMilliseconds);

        for (int i = 0; i < 10; i++)
        {
            GameObject newCube = Instantiate(CubePrefab, new Vector3(Random.Range(-10, 10), Random.Range(-3, 3), Random.Range(-10, 10)), new Quaternion(0, 0, 0, 0));
            RoundedCube roundedCube = newCube.GetComponent<RoundedCube>();
            roundedCube.Load(mesh);
        }
    }
}
