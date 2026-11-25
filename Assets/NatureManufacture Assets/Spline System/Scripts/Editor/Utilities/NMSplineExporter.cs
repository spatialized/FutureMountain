// /**
//  * Created by Paweł Homenko
//  */

using System;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM.Editor
{
    public class NMSplineExporter
    {
        public void PointsToFile(NmSpline nmSpline)
        {
            string path = EditorUtility.SaveFilePanelInProject(
                "Save Spline Points", nmSpline.Transform.name + "Points.csv",
                "csv",
                "Save Spline " + nmSpline.Transform.name + " Points in CSV");

            if (string.IsNullOrEmpty(path))
                return;

            string fileData = "";

            for (int i = 0; i < nmSpline.MainControlPoints.Count; i++)
            {
                Vector4 v = nmSpline.MainControlPoints[i].position;
                fileData += v.x + ";" + v.y + ";" + v.z + ";" + v.w + "\n";
            }

            //foreach (Vector4 v in _spline.mainControlPoints)

            if (fileData.Length > 0)
                fileData = fileData.Remove(fileData.Length - 1, 1);

            // Debug.Log(fileData);
            File.WriteAllText(path, fileData);
        }

        public void PointsFromFile(NmSpline nmSpline)
        {
            string path = EditorUtility.OpenFilePanel("Read Spline Points from CSV", Application.dataPath, "csv");

            if (string.IsNullOrEmpty(path))
                return;

            string fileData = File.ReadAllText(path);

            string[] lines = fileData.Split(new[] {'\n'}, StringSplitOptions.RemoveEmptyEntries);

            Vector4[] vectors = new Vector4[lines.Length];

            for (int i = 0; i < vectors.Length; i++)
            {
                string[] values = lines[i].Split(new[] {';'}, StringSplitOptions.RemoveEmptyEntries);

                if (values.Length != 4)
                    Debug.LogError("Wrong file data");
                else
                    try
                    {
                        vectors[i] = new Vector4(float.Parse(values[0]), float.Parse(values[1]), float.Parse(values[2]),
                            float.Parse(values[3]));
                    }
                    catch (Exception)
                    {
                        Debug.LogError("Wrong file data");
                        return;
                    }
            }


            if (vectors.Length <= 0) return;

            foreach (Vector4 item in vectors)
                nmSpline.AddPoint(item, nmSpline.IsSnapping, nmSpline.Width);
        }
    }
}