using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace NatureManufacture.RAM
{
    public class LakeMeshPartGenerator
    {
        public void GenerateMeshParts(LakePolygon lakePolygon)
        {
            foreach (Transform item in lakePolygon.meshesPartTransforms)
                if (item != null)
                    Object.DestroyImmediate(item.gameObject);

            Mesh baseMesh = lakePolygon.currentMesh;
            int[] triangles = baseMesh.triangles;
            Vector3[] vertices = baseMesh.vertices;
            Vector3[] normals = baseMesh.normals;
            List<Vector4> uvs = new();
            baseMesh.GetUVs(0, uvs);
            List<Vector4> uvs3 = new();
            baseMesh.GetUVs(3, uvs3);
            Color[] colorsMesh = baseMesh.colors;


            lakePolygon.GetComponent<MeshRenderer>().enabled = false;

            int countTrianglePart = triangles.Length / 3;
            countTrianglePart = Mathf.CeilToInt(countTrianglePart / (float) lakePolygon.meshPartsCount) * 3;
            //Debug.Log(countTrianglePart);

            for (var i = 0; i < lakePolygon.meshPartsCount; i++)
            {
                var go = new GameObject($"{lakePolygon.gameObject.name}- Mesh part {i}");
                go.transform.SetParent(lakePolygon.transform, false);
                go.transform.localPosition = Vector3.zero;
                go.transform.localEulerAngles = Vector3.zero;
                go.transform.localScale = Vector3.one;
                go.layer = lakePolygon.gameObject.layer;

                lakePolygon.meshesPartTransforms.Add(go.transform);

                var meshRendererPart = go.AddComponent<MeshRenderer>();

                meshRendererPart.sharedMaterial = lakePolygon.GetComponent<MeshRenderer>().sharedMaterial;
                meshRendererPart.receiveShadows = lakePolygon.BaseProfile.receiveShadows;
                meshRendererPart.shadowCastingMode = lakePolygon.BaseProfile.shadowCastingMode;


                var meshFilter = go.AddComponent<MeshFilter>();
                var meshPart = new Mesh();
                meshPart.Clear();

                List<Vector3> verticesPart = new();
                List<Vector3> normalsPart = new();
                List<Vector4> uvPart = new();
                List<Vector4> uv3Part = new();
                List<Color> colorsPart = new();
                List<int> trianglesPart = new();

                int curVertIndex;
                int newVertIndex;
                int curSubVertIndex = 0;
                List<int> vertexIndices = new();


                for (int t = countTrianglePart * i; t < countTrianglePart * (i + 1) && t < triangles.Length; t++)
                {
                    curVertIndex = triangles[t];

                    if (!vertexIndices.Contains(curVertIndex))
                    {
                        newVertIndex = curSubVertIndex;

                        vertexIndices.Add(curVertIndex);
                        verticesPart.Add(vertices[curVertIndex]);
                        colorsPart.Add(colorsMesh[curVertIndex]);
                        normalsPart.Add(normals[curVertIndex]);
                        uvPart.Add(uvs[curVertIndex]);
                        uv3Part.Add(uvs3[curVertIndex]);

                        curSubVertIndex++;
                    }
                    else
                    {
                        newVertIndex = vertexIndices.IndexOf(curVertIndex);
                    }

                    trianglesPart.Add(newVertIndex);
                }

                //Debug.Log(verticesPart.Count);
                if (verticesPart.Count <= 0) continue;


                meshPart.SetVertices(verticesPart);
                meshPart.SetTriangles(trianglesPart, 0);
                meshPart.SetNormals(normalsPart);
                meshPart.SetUVs(0, uvPart);
                meshPart.SetUVs(3, uv3Part);
                meshPart.colors = colorsPart.ToArray();


                meshPart.RecalculateTangents();
                meshFilter.sharedMesh = meshPart;


                if (!lakePolygon.GenerateLod) continue;


                LodSystemGenerator.GenerateLodSystem(go, meshRendererPart.sharedMaterial, meshFilter, lakePolygon.BaseProfile.receiveShadows, lakePolygon.BaseProfile.shadowCastingMode, lakePolygon.generateLodGPU, lakePolygon.lodDistance,
                    lakePolygon.lodRefreshTime);
            }
        }
    }
}