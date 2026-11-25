// /**
//  * Created by Pawel Homenko on  07/2022
//  */

using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public class RamMeshPartGenerator
    {
        private const int NumberOfUVChannels = 5;
        private readonly RamSpline _ramSpline;
        private Vector3[] vertices;
        private Vector3[] normals;
        private List<List<Vector4>> uvLists;
        private Mesh baseMesh;
        private Color[] vertexColors;
        private MeshRenderer meshRenderer;

        public RamMeshPartGenerator(RamSpline ramSpline, Mesh splineMesh)
        {
            baseMesh = splineMesh;

            _ramSpline = ramSpline;

            vertices = baseMesh.vertices;
            normals = baseMesh.normals;

            uvLists = new List<List<Vector4>>();
            for (int i = 0; i < NumberOfUVChannels; i++)
            {
                uvLists.Add(new List<Vector4>());
                baseMesh.GetUVs(i, uvLists[i]);
            }


            vertexColors = baseMesh.colors;


            meshRenderer = _ramSpline.GetComponent<MeshRenderer>();
        }

        public void GenerateMeshParts()
        {
            foreach (Transform item in _ramSpline.meshesPartTransforms)
                if (item != null)
                    Object.DestroyImmediate(item.gameObject);


            meshRenderer.enabled = false;

            int segments = _ramSpline.NmSpline.Points.Count - 1;
            int verticesLinesPart = Mathf.RoundToInt(segments / (float)_ramSpline.meshPartsCount);


            for (int mp = 0; mp < _ramSpline.meshPartsCount; mp++)
            {
                GameObject go = CreateGameObject(mp);

                _ramSpline.meshesPartTransforms.Add(go.transform);

                AddMeshRenderer(go);


                var mf = go.AddComponent<MeshFilter>();
                var meshPart = new Mesh();
                meshPart.Clear();

                List<Vector3> verticesPart = new();
                List<Vector3> normalsPart = new();
                List<List<Vector4>> uvPartLists = new();
                for (int i = 0; i < NumberOfUVChannels; i++)
                {
                    uvPartLists.Add(new List<Vector4>());
                }

                List<Color> colorsPart = new();
                List<int> trianglesPart = new();

                List<int> vertexIndices = new();

                int offset = 0;
                int newVertIndex;

                for (int i = 0; i <= segments - 1 && i < (mp + 1) * verticesLinesPart; i++)
                {
                    int vertsCount = _ramSpline.BaseProfile.vertsInShape * _ramSpline.NmSpline.Points[i].Density;
                    int vertsCountNext = _ramSpline.BaseProfile.vertsInShape * _ramSpline.NmSpline.Points[i + 1].Density;

                    if (i < mp * verticesLinesPart)
                    {
                        offset += vertsCount;
                        continue;
                    }

                    if (vertsCount < vertsCountNext)
                    {
                        int difference = vertsCountNext / vertsCount;

                        for (int l = 0; l < vertsCountNext - 1; l += 1)
                        {
                            int a = offset + l / difference;
                            int b = offset + vertsCount + l;
                            int c = offset + vertsCount + l + 1;

                            newVertIndex = NewVertIndex(a, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(b, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(c, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                        }

                        for (int l = 0; l < vertsCount - 1; l += 1)
                        {
                            int a = offset + l;
                            int c = offset + l + 1;
                            int b = offset + vertsCount + (l + 1) * difference;


                            newVertIndex = NewVertIndex(a, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(b, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(c, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                        }
                    }
                    else if (vertsCount > vertsCountNext)
                    {
                        int difference = vertsCount / vertsCountNext;

                        for (int l = 0; l < vertsCountNext - 1; l += 1)
                        {
                            int a = offset + (l + 1) * difference;
                            int b = offset + vertsCount + l;
                            int c = offset + vertsCount + l + 1;

                            newVertIndex = NewVertIndex(a, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(b, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(c, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                        }

                        for (int l = 0; l < vertsCount - 1; l += 1)
                        {
                            int a = offset + l;
                            int c = offset + +l + 1;
                            int b = offset + vertsCount + l / difference;

                            newVertIndex = NewVertIndex(a, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(b, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(c, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                        }
                    }
                    else
                    {
                        for (int l = 0; l < vertsCount - 1; l += 1)
                        {
                            int a = offset + l;
                            int b = offset + l + vertsCount;
                            int c = offset + l + 1 + vertsCount;
                            int d = offset + l + 1;

                            newVertIndex = NewVertIndex(a, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(b, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(c, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);

                            newVertIndex = NewVertIndex(c, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(d, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                            newVertIndex = NewVertIndex(a, vertexIndices, verticesPart, colorsPart, normalsPart, uvPartLists);
                            trianglesPart.Add(newVertIndex);
                        }
                    }

                    offset += vertsCount;
                }


                if (verticesPart.Count <= 0) continue;

                Vector3 pivotChange = verticesPart[0];
                for (int j = 0; j < verticesPart.Count; j++) verticesPart[j] -= pivotChange;

                go.transform.position += pivotChange;

                meshPart.SetVertices(verticesPart);
                meshPart.SetTriangles(trianglesPart, 0);
                meshPart.SetNormals(normalsPart);

                for (int i = 0; i < NumberOfUVChannels; i++)
                {
                    meshPart.SetUVs(i, uvPartLists[i]);
                }

                meshPart.SetColors(colorsPart);

                meshPart.RecalculateTangents();
                mf.mesh = meshPart;
            }
        }

        private GameObject CreateGameObject(int mp)
        {
            var go = new GameObject(_ramSpline.gameObject.name + "- Mesh part " + mp);
            go.transform.SetParent(_ramSpline.transform, false);
            go.transform.localPosition = Vector3.zero;
            go.transform.localEulerAngles = Vector3.zero;
            go.transform.localScale = Vector3.one;
            return go;
        }

        private void AddMeshRenderer(GameObject go)
        {
            var meshRendererPart = go.AddComponent<MeshRenderer>();

            meshRendererPart.sharedMaterial = meshRenderer.sharedMaterial;
            meshRendererPart.receiveShadows = _ramSpline.BaseProfile.receiveShadows;
            meshRendererPart.shadowCastingMode = _ramSpline.BaseProfile.shadowCastingMode;
        }

        private int NewVertIndex(int curVertIndex, List<int> vertexIndices, List<Vector3> verticesPart, List<Color> colorsPart, List<Vector3> normalsPart, List<List<Vector4>> uvPart)
        {
            int newVertIndex;
            if (!vertexIndices.Contains(curVertIndex))
            {
                newVertIndex = vertexIndices.Count;

                vertexIndices.Add(curVertIndex);
                verticesPart.Add(vertices[curVertIndex]);
                colorsPart.Add(vertexColors[curVertIndex]);
                normalsPart.Add(normals[curVertIndex]);

                for (int i = 0; i < uvLists.Count; i++)
                {
                    if (uvLists[i].Count == 0)
                        continue;

                    uvPart[i].Add(uvLists[i][curVertIndex]);
                }
            }
            else
            {
                newVertIndex = vertexIndices.IndexOf(curVertIndex);
            }

            return newVertIndex;
        }
    }
}