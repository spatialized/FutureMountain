// /**
//  * Created by Pawel Homenko on  07/2022
//  */

using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace NatureManufacture.RAM
{
    public class RamSimulationGenerator
    {
        private RamSpline _ramSpline;

        public RamSimulationGenerator(RamSpline ramSpline)
        {
            _ramSpline = ramSpline;
        }

        public RamSpline RamSpline
        {
            get => _ramSpline;
            set => _ramSpline = value;
        }

        public void SimulateRiver(bool generate = true)
        {
            if (RamSpline.meshGo != null)
            {
                if (Application.isEditor)
                    Object.DestroyImmediate(RamSpline.meshGo);
                else
                    Object.Destroy(RamSpline.meshGo);
            }

            if (RamSpline.NmSpline.MainControlPoints.Count == 0)
            {
                Debug.Log("Add one point to start Simulating River");
                return;
            }


            var ray = new Ray();


            Vector3 lastPosition = RamSpline.transform.TransformPoint(RamSpline.NmSpline.MainControlPoints[^1].position);

            List<Vector3> positionsGenerated = new();
            if (RamSpline.NmSpline.MainControlPoints.Count > 1)
            {
                positionsGenerated.Add(RamSpline.transform.TransformPoint(RamSpline.NmSpline.MainControlPoints[^2].position));
                positionsGenerated.Add(lastPosition);
            }


            List<Vector3> samplePositionsGenerated = new() { lastPosition };

            //Debug.DrawRay(lastPosition + new Vector3(0, 3, 0), Vector3.down * 20, Color.white, 3);

            float simulatedLength = 0;
            int i = -1;
            int added = 0;
            bool end = false;

            float widthNew = RamSpline.NmSpline.MainControlPoints.Count > 0 ? RamSpline.NmSpline.MainControlPoints[^1].position.w : RamSpline.BaseProfile.width;

            do
            {
                i++;
                if (i <= 0) continue;

                Vector3 maxPosition = Vector3.zero;
                float max = float.MinValue;
                bool foundNextPosition = false;
                for (float j = RamSpline.BaseProfile.simulatedMinStepSize; j < 10; j += 0.1f)
                {
                    for (int angle = 0; angle < 36; angle++)
                    {
                        float x = j * Mathf.Cos(angle);
                        float z = j * Mathf.Sin(angle);

                        ray.origin = lastPosition + new Vector3(0, 1000, 0) + new Vector3(x, 0, z);
                        ray.direction = Vector3.down;

                        if (!Physics.Raycast(ray, out RaycastHit hit, 10000)) continue;

                        if (!(hit.distance > max)) continue;

                        bool goodPoint = true;


                        foreach (Vector3 item in positionsGenerated)
                        {
                            if (!(Vector3.Distance(item, lastPosition) > Vector3.Distance(item, hit.point) + 0.5f)) continue;

                            goodPoint = false;
                            break;
                        }

                        if (!goodPoint) continue;

                        foundNextPosition = true;
                        max = hit.distance;
                        maxPosition = hit.point;
                    }

                    if (foundNextPosition)
                        break;
                }

                if (!foundNextPosition)
                    break;

                if (maxPosition.y > lastPosition.y)
                {
                    if (RamSpline.BaseProfile.simulatedNoUp)
                        maxPosition.y = lastPosition.y;
                    if (RamSpline.BaseProfile.simulatedBreakOnUp)
                        end = true;

                    //Debug.DrawRay(maxPosition + new Vector3(0, 5, 0), ray.direction * 10, Color.red, 3);
                }
                // else
                //    Debug.DrawRay(maxPosition + new Vector3(0, 5, 0), ray.direction * 10, Color.blue, 3);


                simulatedLength += Vector3.Distance(maxPosition, lastPosition);
                if (i % RamSpline.BaseProfile.simulatedRiverPoints == 0 || RamSpline.BaseProfile.simulatedRiverLength <= simulatedLength || end)
                {
                    //Debug.DrawRay(maxPosition + new Vector3(0, 5, 0), ray.direction * 20, Color.white, 3);

                    samplePositionsGenerated.Add(maxPosition);

                    if (generate)
                    {
                        added++;

                        Vector4 newPosition = maxPosition - RamSpline.transform.position;

                        newPosition.w = widthNew + (RamSpline.BaseProfile.noiseWidth
                            ? RamSpline.BaseProfile.noiseMultiplierWidth * (Mathf.PerlinNoise(RamSpline.BaseProfile.noiseSizeWidth * added, 0) - 0.5f)
                            : 0);


                        RamSpline.NmSpline.MainControlPoints.Add(new RamControlPoint(newPosition, Quaternion.identity, 0, new AnimationCurve(RamSpline.BaseProfile.meshCurve.keys)));
                    }
                }


                positionsGenerated.Add(lastPosition);
                lastPosition = maxPosition;
            } while (RamSpline.BaseProfile.simulatedRiverLength > simulatedLength && !end);

            if (!generate)
            {
                GenerateRiver(samplePositionsGenerated);
            }
        }

        private void GenerateRiver(List<Vector3> samplePositionsGenerated)
        {
            int i;
            float widthNew = RamSpline.NmSpline.MainControlPoints.Count > 0 ? RamSpline.NmSpline.MainControlPoints[^1].position.w : RamSpline.BaseProfile.width;
            float widthNoise;

            List<List<Vector4>> positionArray = new();
            var v1 = new Vector3();
            for (i = 0; i < samplePositionsGenerated.Count - 1; i++)
            {
                widthNoise = widthNew + AddWithNoise(i);


                //Debug.DrawLine(samplePositionsGenerated[i], samplePositionsGenerated[i + 1], Color.white, 3);

                v1 = Vector3.Cross(samplePositionsGenerated[i + 1] - samplePositionsGenerated[i], Vector3.up)
                    .normalized;

                if (i > 0)
                {
                    Vector3 v2 = Vector3
                        .Cross(samplePositionsGenerated[i] - samplePositionsGenerated[i - 1], Vector3.up).normalized;
                    v1 = (v1 + v2).normalized;
                }

                //Vector3 v2 = Vector3.Cross(samplePositionsGenerated[i + 1] - samplePositionsGenerated[i], v1).normalized;

                //Debug.DrawLine(samplePositionsGenerated[i] - v1 * widthNew * 0.5f, samplePositionsGenerated[i] + v1 * widthNew * 0.5f, Color.blue, 3);

                List<Vector4> positionRow = new()
                {
                    samplePositionsGenerated[i] + v1 * (widthNoise * 0.5f),
                    samplePositionsGenerated[i] - v1 * (widthNoise * 0.5f)
                };


                positionArray.Add(positionRow);
            }

            widthNoise = widthNew + AddWithNoise(i);
            List<Vector4> positionRowLast = new()
            {
                samplePositionsGenerated[i] + v1 * (widthNoise * 0.5f),
                samplePositionsGenerated[i] - v1 * (widthNoise * 0.5f)
            };

            positionArray.Add(positionRowLast);


            var meshTerrain = new Mesh
            {
                indexFormat = IndexFormat.UInt32
            };
            List<Vector3> vertices = new();
            List<int> triangles = new();
            // List<Vector2> uv = new List<Vector2>();

            foreach (List<Vector4> positionRow in positionArray)
            foreach (Vector4 vert in positionRow)
                vertices.Add(vert);

            for (i = 0; i < positionArray.Count - 1; i++)
            {
                int count = positionArray[i].Count;
                for (int j = 0; j < count - 1; j++)
                {
                    triangles.Add(j + i * count);
                    triangles.Add(j + (i + 1) * count);
                    triangles.Add(j + 1 + i * count);

                    triangles.Add(j + 1 + i * count);
                    triangles.Add(j + (i + 1) * count);
                    triangles.Add(j + 1 + (i + 1) * count);
                }
            }


            meshTerrain.SetVertices(vertices);
            meshTerrain.SetTriangles(triangles, 0);
            // meshTerrain.SetUVs(0, uv);

            meshTerrain.RecalculateNormals();
            meshTerrain.RecalculateTangents();
            meshTerrain.RecalculateBounds();

            RamSpline.meshGo = new GameObject("TerrainMesh")
            {
                hideFlags = HideFlags.HideAndDontSave
            };
            RamSpline.meshGo.AddComponent<MeshFilter>();
            RamSpline.meshGo.transform.parent = RamSpline.transform;
            var meshRenderer = RamSpline.meshGo.AddComponent<MeshRenderer>();
            meshRenderer.sharedMaterial = new Material(Shader.Find("Debug Terrain Carve"))
            {
                color = new Color(0, 0.5f, 0)
            };


            RamSpline.meshGo.transform.position = Vector3.zero;
            RamSpline.meshGo.GetComponent<MeshFilter>().sharedMesh = meshTerrain;
        }

        private float AddWithNoise(int multiplier)
        {
            return (RamSpline.BaseProfile.noiseWidth ? RamSpline.BaseProfile.noiseMultiplierWidth * (Mathf.PerlinNoise(RamSpline.BaseProfile.noiseSizeWidth * multiplier, 0) - 0.5f) : 0);
        }
    }
}