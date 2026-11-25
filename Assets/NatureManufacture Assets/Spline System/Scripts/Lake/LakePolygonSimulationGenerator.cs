// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System;
using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using UnityEngine.Serialization;

namespace NatureManufacture.RAM
{
    public static class LakePolygonSimulationGenerator
    {
        public static void Simulation(LakePolygon lakePolygon)
        {
            if (lakePolygon.NmSpline.MainControlPoints.Count == 0)
                return;

#if UNITY_EDITOR
            Undo.RegisterCompleteObjectUndo(lakePolygon, "Simulate lake");
            Undo.RegisterCompleteObjectUndo(lakePolygon.transform, "Simulate lake");
            if (lakePolygon.meshFilter != null)
                Undo.RegisterCompleteObjectUndo(lakePolygon.meshFilter, "Simulate lake");
#endif

            lakePolygon.LastGenerationPoint = lakePolygon.NmSpline.MainControlPoints[0];
            lakePolygon.LastGenerationPosition = lakePolygon.transform.position;

            List<Vector3> vectorPoints = new() { lakePolygon.transform.TransformPoint(lakePolygon.LastGenerationPoint.position) };
            bool tooClose;
            Vector3 point;
            List<Vector3> newPoints = new();

            foreach (Vector3 vec in vectorPoints)
            {
                for (int angle = 0; angle <= 360; angle += lakePolygon.angleSimulation)
                {
                    Vector3 direction = new Vector3(Mathf.Cos(angle * Mathf.Deg2Rad), 0, Mathf.Sin(angle * Mathf.Deg2Rad)).normalized;
                    var ray = new Ray(vec, direction);


                    if (Physics.Raycast(ray, out RaycastHit hit, lakePolygon.checkDistanceSimulation))
                    {
                        point = hit.point;
                    }
                    else
                    {
                        point = ray.origin + ray.direction * 50;
                    }

                    tooClose = IsPointTooClose(point, vectorPoints, lakePolygon) || IsPointTooClose(point, newPoints, lakePolygon);

                    if (tooClose) continue;

                    Vector3 newPoint = point + direction * lakePolygon.depthOffsetSimulation;


                    newPoints.Add(newPoint);
                }
            }


            vectorPoints.AddRange(newPoints);

            if (lakePolygon.removeFirstPointSimulation)
                vectorPoints.RemoveAt(0);

            lakePolygon.NmSpline.MainControlPoints.Clear();

            for (int i = 0; i < vectorPoints.Count; i++)
            {
                Vector3 vec = vectorPoints[i];
                lakePolygon.NmSpline.AddPoint(lakePolygon.transform.InverseTransformPoint(vec), lakePolygon.snapToTerrain);
            }

            lakePolygon.GeneratePolygon();
        }

        private static bool IsPointTooClose(Vector3 point, List<Vector3> points, LakePolygon lakePolygon)
        {
            foreach (Vector3 item in points)
            {
                if (Vector3.Distance(point, item) < lakePolygon.closeDistanceSimulation)
                {
                    return true;
                }
            }

            return false;
        }

        public static void RemoveAllPoints(LakePolygon lakePolygon, bool restoreGenerationPoint = false)
        {
            RamControlPoint ramControlPoint = lakePolygon.NmSpline.MainControlPoints[0];

            lakePolygon.NmSpline.RemovePoints();
            lakePolygon.meshFilter.sharedMesh = null;

            if (!restoreGenerationPoint) return;

            lakePolygon.NmSpline.MainControlPoints.Add(lakePolygon.LastGenerationPoint ?? ramControlPoint);
            lakePolygon.transform.position = lakePolygon.LastGenerationPosition;
        }
    }
}