using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using UnityEngine.Events;

namespace NatureManufacture.RAM
{
    public static class VertexPaintHeight
    {
        public static void RestartHeight(VertexPainterData vertexPainterData, UnityEvent onResetDrawing)
        {
            List<Vector4> vertexHeights = new();
            foreach (var item in vertexPainterData.MeshFilters)
            {
                if (item == null)
                    continue;
                Mesh mesh = item.sharedMesh;
                if (mesh == null) continue;

#if UNITY_EDITOR
                if (!string.IsNullOrEmpty(AssetDatabase.GetAssetPath(mesh)))
                {
                    mesh = Object.Instantiate(item.sharedMesh);
                    item.sharedMesh = mesh;
                }
                else
                {
#endif
                    Vector3[] vertices = mesh.vertices;
                    //get normals
                    List<Vector3> normals = new();
                    mesh.GetNormals(normals);
                    mesh.GetUVs(4, vertexHeights);
                    if (vertexHeights.Count == vertices.Length)
                    {
                        for (int i = 0; i < vertices.Length; i++)
                        {
                            vertices[i] -= normals[i] * vertexHeights[i].x;
                        }

                        mesh.vertices = vertices;
                    }
#if UNITY_EDITOR
                }
#endif

                mesh.SetUVs(4, (Vector4[])null);
            }


            vertexPainterData.OverridenVertexHeight = false;
            onResetDrawing?.Invoke();
        }

        public static void DrawVertexHeight(Mesh mesh, MeshFilter meshFilter, int vertLength, Vector3[] vertices, Vector3 hitPosition, VertexPainterData vertexPainterData)
        {
            List<Vector4> vertexHeights = new();
            mesh.GetUVs(4, vertexHeights);
            //Get normals
            List<Vector3> normals = new();
            mesh.GetNormals(normals);


            Transform transform = meshFilter.transform;
            if (vertexHeights.Count == 0)
            {
                for (int i = 0; i < vertLength; i++)
                {
                    vertexHeights.Add(Vector4.zero);
                }
            }


            Vector3 posVert;
            vertexPainterData.OverridenVertexHeight = true;
            Vector4 vertexHeightValue;
            for (int i = 0; i < vertLength; i++)
            {
                posVert = transform.TransformPoint(vertices[i]);
                float dist = Vector3.Distance(hitPosition, posVert);


                if (!(dist < vertexPainterData.DrawSize)) continue;

                vertexHeightValue = vertexHeights[i];

                float distBlend = Mathf.Clamp01((vertexPainterData.DrawSize - dist) / (vertexPainterData.DrawSize * vertexPainterData.DrawBlendSize));


                float heightChange = vertexPainterData.Height * vertexPainterData.Opacity * distBlend;
                if (Event.current.shift)
                {
                    vertexHeightValue.x -= heightChange;
                    vertices[i] -= normals[i] * heightChange;
                }
                else
                {
                    vertexHeightValue.x += heightChange;
                    vertices[i] += normals[i] * heightChange;
                }

                vertexHeights[i] = vertexHeightValue;
            }


            mesh.vertices = vertices;
            mesh.SetUVs(4, vertexHeights);
        }


        public static void ChangeVertexPosition(Vector3[] vertices, Vector3[] normals, List<Vector4> vertexData, VertexPaintNoiseData vertexPaintNoiseData = null)
        {
            if (vertexData.Count != vertices.Length && vertexPaintNoiseData == null)
                return;

            for (int i = 0; i < vertices.Length; i++)
            {
                ChangeSingleVertexPosition(vertices, normals, vertexData, vertexPaintNoiseData, i);
            }
        }

        public static void ChangeSingleVertexPosition(Vector3[] vertices, Vector3[] normals, List<Vector4> vertexData, VertexPaintNoiseData vertexPaintNoiseData, int i, Vector3 position = default,
            float additionalMultiplier = 1)
        {
            Vector3 vert = vertices[i];
            Vector3 normal = normals[i];


            if (vertexData.Count == vertices.Length)
            {
                Vector4 data = vertexData[i];

                vert += normal * data.x;
            }


            //add noise to vert based on vertexPaintNoiseData and vertexNoiseTexture
            if (vertexPaintNoiseData is { IsNoiseActive: true })
            {
                // Debug.Log(normal.y);

                var noisePosition = new Vector2(vert.x + position.x, vert.z + position.z);

                Color noise = vertexPaintNoiseData.VertexNoiseTexture.GetPixelBilinear(noisePosition.x * vertexPaintNoiseData.SizeX, noisePosition.y * vertexPaintNoiseData.SizeZ);

                //Debug.Log(normal.y);
                vert += normal * ((noise.a - 0.5f) * vertexPaintNoiseData.Multiplier * vertexPaintNoiseData.SlopeCurve.Evaluate(1 - normal.y) * additionalMultiplier);
            }

            vertices[i] = vert;
        }
    }
}