/*
 * Changed by Pawel Homenko on  08/2022
 *
 * Optimized the code, added uv2, uv3, color support
 * Changed the weld vertices method
 * Changes in the RecalculateNormals method
 * Changes in the RecalculateTangents method
 * Changes in the UnweldVertices method
 */

/*====================================================
*
* Francesco Cucchiara - 3POINT SOFT
* http://threepointsoft.altervista.org
*
=====================================================*/

/*
 * The following code was taken from: https://schemingdeveloper.com
 *
 * Visit our game studio website: http://stopthegnomes.com
 *
 * License: You may use this code however you see fit, as long as you include this notice
 *          without any modifications.
 *
 *          You may not publish a paid asset on Unity store if its main function is based on
 *          the following code, but you may publish a paid asset that uses this code.
 *
 *          If you intend to use this in a Unity store asset or a commercial project, it would
 *          be appreciated, but not required, if you let me know with a link to the asset. If I
 *          don't get back to you just go ahead and use it anyway!
 */

using System;
using System.Collections.Generic;
using UnityEngine;

namespace TB
{
    public static class FrancNormalSolver
    {
        public static void UnweldVertices(Mesh mesh)
        {
            Vector3[] vertices = mesh.vertices;
            Vector2[] uvs = mesh.uv;
            Vector2[] uvs2 = mesh.uv2;
            Vector2[] uvs3 = mesh.uv3;
            Color[] colors = mesh.colors;


            List<Vector3> unweldedVerticesList = new();
            int[][] unweldedSubTriangles = new int[mesh.subMeshCount][];
            List<Vector2> unweldedUvsList = new();
            List<Vector2> unweldedUvs2List = new();
            List<Vector2> unweldedUvs3List = new();
            List<Color> unweldedColorsList = new();
            int currVertex = 0;

            for (int i = 0; i < mesh.subMeshCount; i++)
            {
                int[] triangles = mesh.GetTriangles(i);
                Vector3[] unweldedVertices = new Vector3[triangles.Length];
                int[] unweldedTriangles = new int[triangles.Length];
                Vector2[] unweldedUVs = new Vector2[unweldedVertices.Length];
                Vector2[] unweldedUVs2 = new Vector2[unweldedVertices.Length];
                Vector2[] unweldedUVs3 = new Vector2[unweldedVertices.Length];
                Color[] unweldedColors = new Color[unweldedVertices.Length];

                for (int j = 0; j < triangles.Length; j++)
                {
                    unweldedVertices[j] = vertices[triangles[j]]; //unwelded vertices are just all the vertices as they appear in the triangles array
                    if (uvs.Length > triangles[j])
                        unweldedUVs[j] = uvs[triangles[j]];


                    if (uvs2 != null && uvs2.Length > triangles[j])
                        unweldedUVs2[j] = uvs2[triangles[j]];


                    if (uvs3 != null && uvs3.Length > triangles[j])
                        unweldedUVs3[j] = uvs3[triangles[j]];

                    if (colors != null && colors.Length > triangles[j])
                        unweldedColors[j] = colors[triangles[j]];

                    unweldedTriangles[j] = currVertex; //the unwelded triangle array will contain global progressive vertex indexes (1, 2, 3, ...)
                    currVertex++;
                }

                unweldedVerticesList.AddRange(unweldedVertices);
                unweldedSubTriangles[i] = unweldedTriangles;
                unweldedUvsList.AddRange(unweldedUVs);
                if (uvs2 != null)
                    unweldedUvs2List.AddRange(unweldedUVs2);
                if (uvs3 != null)
                    unweldedUvs3List.AddRange(unweldedUVs3);
                if (colors != null)
                    unweldedColorsList.AddRange(unweldedColors);
            }

            //Debug.Log(unweldedVerticesList.Count);

            if (unweldedVerticesList.Count > 65000)
            {
                mesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32;
            }

            mesh.vertices = unweldedVerticesList.ToArray();
            mesh.uv = unweldedUvsList.ToArray();
            if (uvs2 is { Length: > 0 })
                mesh.uv2 = unweldedUvs2List.ToArray();
            if (uvs3 is { Length: > 0 })
                mesh.uv3 = unweldedUvs3List.ToArray();


            //Debug.Log($"unweldedVerticesList {unweldedVerticesList.Count} unweldedUvsList {unweldedUvsList.Count} colors {unweldedColorsList.Count}");

            if (colors is { Length: > 0 })
                mesh.colors = unweldedColorsList.ToArray();

            for (int i = 0; i < mesh.subMeshCount; i++)
            {
                mesh.SetTriangles(unweldedSubTriangles[i], i, false);
            }

            RecalculateTangents(mesh);
        }

        /// <summary>
        ///     Recalculate the normals of a mesh based on an angle threshold. This takes
        ///     into account distinct vertices that have the same position.
        /// </summary>
        /// <param name="mesh"></param>
        /// <param name="angle">
        ///     The smoothing angle. Note that triangles that already share
        ///     the same vertex will be smooth regardless of the angle! 
        /// </param>
        public static void RecalculateNormals(this Mesh mesh, float angle)
        {
            UnweldVertices(mesh);

            float cosineThreshold = Mathf.Cos(angle * Mathf.Deg2Rad);

            Vector3[] vertices = mesh.vertices;
            Vector3[] normals = new Vector3[vertices.Length];

            // Holds the normal of each triangle in each sub mesh.
            Vector3[][] triNormals = new Vector3[mesh.subMeshCount][];

            Dictionary<VertexKey, List<VertexEntry>> dictionary = new(vertices.Length);

            for (int subMeshIndex = 0; subMeshIndex < mesh.subMeshCount; ++subMeshIndex)
            {
                int[] triangles = mesh.GetTriangles(subMeshIndex);

                triNormals[subMeshIndex] = new Vector3[triangles.Length / 3];

                for (int i = 0; i < triangles.Length; i += 3)
                {
                    int i1 = triangles[i];
                    int i2 = triangles[i + 1];
                    int i3 = triangles[i + 2];

                    // Calculate the normal of the triangle
                    Vector3 p1 = vertices[i2] - vertices[i1];
                    Vector3 p2 = vertices[i3] - vertices[i1];
                    Vector3 normal = Vector3.Cross(p1, p2);
                    float magnitude = normal.magnitude;
                    if (magnitude > 0)
                    {
                        normal /= magnitude;
                    }

                    int triIndex = i / 3;
                    triNormals[subMeshIndex][triIndex] = normal;

                    List<VertexEntry> entry;
                    VertexKey key;

                    if (!dictionary.TryGetValue(key = new VertexKey(vertices[i1]), out entry))
                    {
                        entry = new List<VertexEntry>(4);
                        dictionary.Add(key, entry);
                    }

                    entry.Add(new VertexEntry(subMeshIndex, triIndex, i1));

                    if (!dictionary.TryGetValue(key = new VertexKey(vertices[i2]), out entry))
                    {
                        entry = new List<VertexEntry>();
                        dictionary.Add(key, entry);
                    }

                    entry.Add(new VertexEntry(subMeshIndex, triIndex, i2));

                    if (!dictionary.TryGetValue(key = new VertexKey(vertices[i3]), out entry))
                    {
                        entry = new List<VertexEntry>();
                        dictionary.Add(key, entry);
                    }

                    entry.Add(new VertexEntry(subMeshIndex, triIndex, i3));
                }
            }

            // Debug.Log($"dictionary length {dictionary.Count} vertices length {vertices.Length}");

            // Each entry in the dictionary represents a unique vertex position.

            foreach (List<VertexEntry> vertList in dictionary.Values)
            {
                for (int i = 0; i < vertList.Count; ++i)
                {
                    var sum = new Vector3();
                    VertexEntry lhsEntry = vertList[i];

                    for (int j = 0; j < vertList.Count; ++j)
                    {
                        VertexEntry rhsEntry = vertList[j];

                        if (lhsEntry.VertexIndex == rhsEntry.VertexIndex)
                        {
                            sum += triNormals[rhsEntry.MeshIndex][rhsEntry.TriangleIndex];
                        }
                        else
                        {
                            // The dot product is the cosine of the angle between the two triangles.
                            // A larger cosine means a smaller angle.
                            float dot = Vector3.Dot(
                                triNormals[lhsEntry.MeshIndex][lhsEntry.TriangleIndex],
                                triNormals[rhsEntry.MeshIndex][rhsEntry.TriangleIndex]);
                            if (dot >= cosineThreshold)
                            {
                                sum += triNormals[rhsEntry.MeshIndex][rhsEntry.TriangleIndex];
                            }
                        }
                    }

                    normals[lhsEntry.VertexIndex] = sum.normalized;
                }
            }

            mesh.normals = normals;

            //Weld back the vertices
            //WeldVertices(mesh);
        }

        public static Mesh WeldVertices(Mesh mesh)
        {
            Vector3[] vertices = mesh.vertices;
            Vector3[] normals = mesh.normals;
            Vector4[] tangents = mesh.tangents;
            Vector2[] uvs = mesh.uv;
            Vector2[] uvs2 = mesh.uv2;
            Vector2[] uvs3 = mesh.uv3;
            Color[] colors = mesh.colors;

            List<Vector3> newVertices = new();
            List<Vector3> newNormals = new();
            List<Vector4> newTangents = new();
            List<Vector2> newUVs = new();
            List<Vector2> newUVs2 = new();
            List<Vector2> newUVs3 = new();
            List<Color> newColors = new();

            Dictionary<VertexKey, int> welds = new();

            for (int i = 0; i < vertices.Length; ++i)
            {
                var key = new VertexKey(vertices[i], uvs[i]);

                if (welds.TryGetValue(key, out int index)) continue;

                index = newVertices.Count;
                welds.Add(key, index);
                newVertices.Add(vertices[i]);
                newNormals.Add(normals[i]);
                newTangents.Add(tangents[i]);
                newUVs.Add(uvs[i]);
                if (uvs2.Length > 0) newUVs2.Add(uvs2[i]);
                if (uvs3.Length > 0) newUVs3.Add(uvs3[i]);
                if (colors.Length > 0) newColors.Add(colors[i]);
            }

            int[] triangles = mesh.triangles;
            List<int> newTriangles = new(triangles.Length);
            for (int i = 0; i < triangles.Length; ++i)
            {
                newTriangles.Add(welds[new VertexKey(vertices[triangles[i]], uvs[triangles[i]])]);
            }

            
            //mesh.Clear();
                string name = mesh.name;
          mesh = new Mesh
             {
                 name = name
             };
            mesh.SetVertices(newVertices);
            mesh.SetNormals(newNormals);
            mesh.SetTangents(newTangents);
            mesh.SetUVs(0, newUVs);
            mesh.SetUVs(1, newUVs2);
            if (uvs3.Length > 0)
                mesh.SetUVs(2, newUVs3);
            if (colors.Length > 0)
                mesh.SetColors(newColors);
            mesh.SetTriangles(newTriangles, 0);
            return mesh;
        }

        private readonly struct VertexKey : IEquatable<VertexKey>
        {
            private readonly long _x;
            private readonly long _y;
            private readonly long _z;
            private readonly long _u;
            private readonly long _v;

            private const int Tolerance = 10000;
            private const long Fnv32Init = 23;
            private const long Fnv32Prime = 31;


            public VertexKey(Vector3 position)
            {
                _x = (long)(Mathf.Round(position.x * Tolerance));
                _y = (long)(Mathf.Round(position.y * Tolerance));
                _z = (long)(Mathf.Round(position.z * Tolerance));
                _u = 0;
                _v = 0;
            }

            public VertexKey(Vector3 position, Vector2 uv)
            {
                _x = (long)(Mathf.Round(position.x * Tolerance));
                _y = (long)(Mathf.Round(position.y * Tolerance));
                _z = (long)(Mathf.Round(position.z * Tolerance));
                _u = (long)(Mathf.Round(uv.x * Tolerance));
                _v = (long)(Mathf.Round(uv.y * Tolerance));
            }

            public override bool Equals(object obj)
            {
                return obj is VertexKey key && Equals(key);
            }

            public bool Equals(VertexKey other)
            {
                return _x == other._x && _y == other._y && _z == other._z &&
                       _u == other._u && _v == other._v;
            }

            public override int GetHashCode()
            {
                long rv = Fnv32Init;
                rv ^= _x;
                rv *= Fnv32Prime;
                rv ^= _y;
                rv *= Fnv32Prime;
                rv ^= _z;
                rv *= Fnv32Prime;
                rv ^= _u;
                rv *= Fnv32Prime;
                rv ^= _v;
                rv *= Fnv32Prime;

                return rv.GetHashCode();
            }
        }

        private struct VertexEntry
        {
            public readonly int MeshIndex;
            public readonly int TriangleIndex;
            public readonly int VertexIndex;

            public VertexEntry(int meshIndex, int triIndex, int vertIndex)
            {
                MeshIndex = meshIndex;
                TriangleIndex = triIndex;
                VertexIndex = vertIndex;
            }
        }


        /// <summary>
        /// Recalculates mesh tangents
        /// 
        /// For some reason the built-in RecalculateTangents function produces artifacts on dense geometries.
        /// 
        /// This implementation id derived from:
        /// 
        /// Lengyel, Eric. Computing Tangent Space Basis Vectors for an Arbitrary Mesh.
        /// Terathon Software 3D Graphics Library, 2001.
        /// http://www.terathon.com/code/tangent.html
        /// </summary>
        /// <param name="mesh"></param>
        public static void RecalculateTangents(Mesh mesh)
        {
            int[] triangles = mesh.triangles;
            Vector3[] vertices = mesh.vertices;
            Vector2[] uv = mesh.uv;
            Vector3[] normals = mesh.normals;

            int triangleCount = triangles.Length;
            int vertexCount = vertices.Length;

            Vector3[] tan1 = new Vector3[vertexCount];
            Vector3[] tan2 = new Vector3[vertexCount];

            Vector4[] tangents = new Vector4[vertexCount];

            for (int a = 0; a < triangleCount; a += 3)
            {
                int i1 = triangles[a + 0];
                int i2 = triangles[a + 1];
                int i3 = triangles[a + 2];

                Vector3 v1 = vertices[i1];
                Vector3 v2 = vertices[i2];
                Vector3 v3 = vertices[i3];

                Vector2 w1 = uv[i1];
                Vector2 w2 = uv[i2];
                Vector2 w3 = uv[i3];

                float x1 = v2.x - v1.x;
                float x2 = v3.x - v1.x;
                float y1 = v2.y - v1.y;
                float y2 = v3.y - v1.y;
                float z1 = v2.z - v1.z;
                float z2 = v3.z - v1.z;

                float s1 = w2.x - w1.x;
                float s2 = w3.x - w1.x;
                float t1 = w2.y - w1.y;
                float t2 = w3.y - w1.y;

                float div = s1 * t2 - s2 * t1;
                float r = div == 0.0f ? 0.0f : 1.0f / div;

                var sDir = new Vector3((t2 * x1 - t1 * x2) * r, (t2 * y1 - t1 * y2) * r, (t2 * z1 - t1 * z2) * r);
                var tDir = new Vector3((s1 * x2 - s2 * x1) * r, (s1 * y2 - s2 * y1) * r, (s1 * z2 - s2 * z1) * r);

                tan1[i1] += sDir;
                tan1[i2] += sDir;
                tan1[i3] += sDir;

                tan2[i1] += tDir;
                tan2[i2] += tDir;
                tan2[i3] += tDir;
            }

            for (int a = 0; a < vertexCount; ++a)
            {
                Vector3 n = normals[a];
                Vector3 t = tan1[a];

                Vector3.OrthoNormalize(ref n, ref t);
                tangents[a].x = t.x;
                tangents[a].y = t.y;
                tangents[a].z = t.z;

                tangents[a].w = (Vector3.Dot(Vector3.Cross(n, t), tan2[a]) < 0.0f) ? -1.0f : 1.0f;
            }

            mesh.tangents = tangents;
        }
    }
}