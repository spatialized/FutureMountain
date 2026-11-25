using System;
using System.Collections.Generic;
using TriangleNet.Geometry;
using TriangleNet.Meshing;
using TriangleNet.Smoothing;
using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public static class SplineTriangulator
    {
        private static readonly ConstraintOptions Options = new() { ConformingDelaunay = true };

        private static readonly QualityOptions Quality = new() { MinimumAngle = 30 };
        private static readonly GenericMesher BaseGenericMesher = new();

        public static (List<int> indices, List<Vector3> vertices, float triangleSizeByLimit) TriangulateSpline(bool quick, float maximumTriangleSize, float maximumTriangleAmount, NmSpline spline,
            List<NmSpline> lakeHoles = null,
            bool showDebug = false)
        {
            List<int> indices = new();
            List<Vector3> vertices = new();


#if UNITY_EDITOR
            double time = EditorApplication.timeSinceStartup;
#endif

            List<Vector3> verticesList = new();
            foreach (NmSplinePoint point in spline.Points)
            {
                verticesList.Add(point.Position);
            }


            var polygon = new Polygon();


            List<Vertex> vertexes = new();


            for (int i = 0; i < verticesList.Count; i++)
            {
                //round values to 3 decimal places
                var vert = new Vertex((int)(verticesList[i].x * 100) / 100.0f, (int)(verticesList[i].z * 100) / 100.0f)
                {
                    z = (int)(verticesList[i].y * 100) / 100.0f
                };


                vertexes.Add(vert);
            }


            //generate holes from lakeHoles
            if (lakeHoles != null)
            {
                foreach (NmSpline hole in lakeHoles)
                {
                    if (hole == null || hole.Points == null || hole.Points.Count < 3)
                        continue;


                    List<Vertex> holeVertexes = new();

                    foreach (NmSplinePoint point in hole.Points)
                    {
                        Vector3 position = point.Position + hole.Transform.position - spline.Transform.position;


                        var vert = new Vertex(position.x, position.z)
                        {
                            z = position.y
                        };
                        holeVertexes.Add(vert);
                    }

                    polygon.Add(new Contour(holeVertexes), true);
                }
            }


            polygon.Add(new Contour(vertexes));

            float triangleSizeByLimit = (float)(polygon.Bounds().Height * polygon.Bounds().Width / (quick ? Mathf.Min(maximumTriangleAmount, 200) : maximumTriangleAmount)) * 1.5f;


            float triangleSize = maximumTriangleSize < triangleSizeByLimit ? triangleSizeByLimit : maximumTriangleSize;


            //var contour = new Contour(vertexes);
            //Point testP = contour.FindInteriorPoint();


            //polygon.Regions.Add(new RegionPointer(vertexes[0].x, vertexes[0].y, 1));
            //polygon.Regions.Add(new RegionPointer(testP.x, testP.y, 2));

            Quality.MaximumArea = triangleSize;


            var mesh = (TriangleNet.Mesh)BaseGenericMesher.Triangulate(polygon, Options, Quality);

            if (!quick)
            {
                mesh.Refine(Quality);

                try
                {
#if UNITY_EDITOR
                    double timeSmooth = EditorApplication.timeSinceStartup;
#endif

                    if (lakeHoles == null || lakeHoles.Count == 0)
                        new SimpleSmoother().Smooth(mesh, 100, triangleSize * 0.1f);


#if UNITY_EDITOR
                    if (showDebug)
                    {
                        //Debug.Log($"Smoothing iterations {smoothIterations}");
                        Debug.Log($"--Mesh smoothing: {(EditorApplication.timeSinceStartup - timeSmooth):F6}");
                    }
#endif
                }
                catch (Exception)
                {
                    Debug.LogError("Wrong  shape");
                }
            }

            MeshTriangulationToVertices.GenerateVerticesIndices(mesh, indices, vertices);


#if UNITY_EDITOR
            if (showDebug)
            {
                Debug.Log($"-Spline triangulation: {(EditorApplication.timeSinceStartup - time):F6}");
            }
#endif


            return (indices, vertices, triangleSizeByLimit);
        }
    }
}