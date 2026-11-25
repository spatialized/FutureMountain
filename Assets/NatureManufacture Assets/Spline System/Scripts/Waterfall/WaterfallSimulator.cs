using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;


namespace NatureManufacture.RAM
{
    public class WaterfallSimulator
    {
        private Waterfall _waterfall;

        public struct MeshSimulation
        {
            public Vector3 Position;
            public Vector3 Normal;
            public Vector3 Binormal;
            public Vector3 Tangent;
            public float DistanceU;
            public float DistanceV;
            public Vector3 Velocity;
            public float Distance;
        }

        public List<List<MeshSimulation>> AllSimulationPoints { get; set; } = new();
        private List<Vector3> CurrentVelocities { get; set; } = new();

        private bool _isLooping = false;


        public List<List<MeshSimulation>> MakeSimulation(Waterfall waterfall)
        {
            _waterfall = waterfall;
            InitializeInitialData();
            DoSimulation();

            CleanSimulation(waterfall);

            return AllSimulationPoints;
        }


        private void CleanSimulation(Waterfall waterfall)
        {
            List<List<MeshSimulation>> cleanedSimulation = new();


            MeshSimulation meshSimulation;
            for (int i = 0; i < AllSimulationPoints.Count; i++)
            {
                Quaternion orientation = _waterfall.NmSpline.Points[i].Orientation;
                cleanedSimulation.Add(new List<MeshSimulation>());
                meshSimulation = AllSimulationPoints[i][0];
                meshSimulation.Distance = 0;
                meshSimulation.Velocity = orientation * Vector3.right * _waterfall.BaseProfile.BaseStrength;
                cleanedSimulation[i].Add(meshSimulation);
            }

            for (int i = 0; i < AllSimulationPoints.Count; i++)
            {
                // cleanedSimulation.Add(new List<MeshSimulation>());
                float dist = 0;
                for (int p = 1; p < AllSimulationPoints[i].Count; p++)
                {
                    meshSimulation = AllSimulationPoints[i][p];
                    if (Vector3.Distance(cleanedSimulation[i][^1].Position, meshSimulation.Position) > waterfall.BaseProfile.MinPointDistance)
                    {
                        dist += Vector3.Distance(cleanedSimulation[i][^1].Position, meshSimulation.Position);
                        meshSimulation.Distance = dist;
                        cleanedSimulation[i].Add(meshSimulation);
                    }


                    if (dist > waterfall.BaseProfile.MaxWaterfallDistance)
                        break;
                }

                //Debug.Log("Distance: " + dist);
            }

            double simulationBlur = Time.realtimeSinceStartupAsDouble;
            SimulationBlur(cleanedSimulation);
            if (waterfall.BaseDebug)
                Debug.Log("Simulation Blur: " + (Time.realtimeSinceStartupAsDouble - simulationBlur));


            AllSimulationPoints = cleanedSimulation;
        }

        private void SimulationBlur(List<List<MeshSimulation>> simulationPoints)
        {
            if (_waterfall.BaseProfile.BlurPositionIterations == 0)
                return;
            if (_waterfall.BaseProfile.BlurPositionSize == 0)
                return;
            if (_waterfall.BaseProfile.BlurPositionStrength == 0)
                return;

            List<List<(float position, Vector3 normal)>> blurredYValues = new();

            for (int it = 0; it < _waterfall.BaseProfile.BlurPositionIterations; it++)
            {
                for (int i = 0; i < simulationPoints.Count; i++)
                {
                    blurredYValues.Add(new List<(float position, Vector3 normal)>());

                    for (int j = 0; j < simulationPoints[i].Count; j++)
                    {
                        (float position, Vector3 normal) blurredY = GaussianBlur2D(simulationPoints, i, j, _waterfall.BaseProfile.BlurPositionStrength, _waterfall.BaseProfile.BlurPositionSize,
                            _waterfall.NmSpline.IsLooping);
                        blurredYValues[i].Add(blurredY);
                    }
                }

                for (int i = 0; i < simulationPoints.Count; i++)
                {
                    for (int j = 1; j < simulationPoints[i].Count; j++)
                    {
                        MeshSimulation simulationPoint = simulationPoints[i][j];
                        simulationPoint.Position = new Vector3(simulationPoint.Position.x, blurredYValues[i][j].position, simulationPoint.Position.z);
                        simulationPoint.Normal = blurredYValues[i][j].normal;
                        simulationPoints[i][j] = simulationPoint;
                    }
                }

                blurredYValues.Clear();
            }

            if (_waterfall.NmSpline.IsLooping)
            {
                for (int i = 0; i < simulationPoints[0].Count; i++)
                {
                    if (i < simulationPoints[^1].Count)
                    {
                        MeshSimulation meshSimulation = simulationPoints[^1][i];
                        meshSimulation.Position = simulationPoints[0][i].Position;
                        meshSimulation.Normal = simulationPoints[0][i].Normal;
                        simulationPoints[^1][i] = meshSimulation;
                    }
                }
            }
        }

        private static (float position, Vector3 normal) GaussianBlur2D(List<List<MeshSimulation>> points, int i, int j, float strength, int size, bool loop)
        {
            float sum = 0;
            Vector3 sumNormal = Vector3.zero;
            float weightSum = 0;

            for (int di = -size; di <= size; di++)
            {
                for (int dj = -size; dj <= size; dj++)
                {
                    int idxI = i + di;
                    int idxJ = j + dj;


                    if (!loop)
                    {
                        idxI = Mathf.Clamp(idxI, 0, points.Count - 1);
                    }
                    else
                    {
                        idxI = idxI < 0 ? points.Count + idxI : idxI % points.Count;
                    }

                    idxJ = Mathf.Clamp(idxJ, 0, points[idxI].Count - 1);


                    float weight = Mathf.Exp(-0.5f * (Mathf.Pow(di / strength, 2) + Mathf.Pow(dj / strength, 2)));
                    //check for error

                    sum += points[idxI][idxJ].Position.y * weight;
                    sumNormal += points[idxI][idxJ].Normal * weight;

                    weightSum += weight;
                }
            }

            return (sum / weightSum, sumNormal / weightSum);
        }


        private static int ClampListPos(ICollection list, int pos)
        {
            if (pos < 0) pos = list.Count - 1;

            if (pos > list.Count)
                pos = 1;
            else if (pos > list.Count - 1) pos = 0;

            return pos;
        }


        private void DoSimulation()
        {
            Vector3 position = _waterfall.transform.position;
            HashSet<int> pointsHit = new();
            int t = 0;
            //Debug.Log(System.Convert.ToString(_waterfall.BaseProfile.RaycastMask.value,2));
            // Iterating over simulation time
            for (float time = 0; time <= _waterfall.BaseProfile.SimulationTime; time += _waterfall.BaseProfile.TimeStep)
            {
                for (int i = 0; i < _waterfall.NmSpline.Points.Count; i++)
                {
                    if (pointsHit.Contains(i))
                        continue;

                    MeshSimulation currentPosition = CalculateMeshSimulation(AllSimulationPoints, i, t, position, out Vector3 newVelocity, out MeshSimulation newMeshSimulation);


                    Vector3 direction = (newMeshSimulation.Position - currentPosition.Position).normalized;

                    Ray ray = new(currentPosition.Position + position, direction);

                    if (_waterfall.BaseProfile.ClipUnderTerrain)
                    {
                        var pos = new Vector3(ray.origin.x, 0, ray.origin.z);
                        foreach (Terrain terrain in Terrain.activeTerrains)
                        {
                            Vector3 terrainPos = terrain.GetPosition();
                            if (!terrain.terrainData.bounds.Contains(pos - terrainPos))
                                continue;

                            float sampleHeight = ray.origin.y;
                            if (terrain.SampleHeight(pos) + terrainPos.y > sampleHeight)
                            {
                                pointsHit.Add(i);
                            }

                            break;
                        }
                    }

                    float distance = (newMeshSimulation.Position - currentPosition.Position).magnitude;

                    // Check if the raycast hits an object
                    if (Physics.Raycast(ray, out RaycastHit hit, distance, _waterfall.BaseProfile.RaycastMask, QueryTriggerInteraction.Ignore))
                    {
                        //Debug.Log($"hit {hit.collider.name}");
                        Vector3 reflectedVector = Vector3.Reflect(newVelocity, hit.normal);
                        reflectedVector *= _waterfall.BaseProfile.RestitutionCoeff;


                        newVelocity = Vector3.Lerp(reflectedVector, new Vector3(newVelocity.x, reflectedVector.y, newVelocity.z), _waterfall.BaseProfile.RestitutionAnglelerp);

                        if (_waterfall.BaseDebug)
                        {
                            Debug.DrawRay(hit.point, hit.normal * 0.2f, Color.magenta, 5f);
                            Debug.DrawRay(ray.origin, ray.direction * 0.2f, Color.blue, 5f);
                            Debug.DrawRay(hit.point, reflectedVector * 0.2f, Color.cyan, 5f);
                        }

                        newMeshSimulation.Position = hit.point - position; // + hit.normal * _waterfall.BaseProfile.TerrainOffset;
                        newMeshSimulation.Velocity = newVelocity;

                        //Debug.Log(newVelocity.magnitude);

                        //pointsHit.Add(i);

                        newMeshSimulation.Position += newMeshSimulation.Normal.normalized * _waterfall.BaseProfile.TerrainOffset.Evaluate(i / (float)_waterfall.NmSpline.Points.Count);
                    }

/*
                            
                    if (newMeshSimulation.Velocity.magnitude < 1f)
                    {
                        newVelocity = newMeshSimulation.Velocity.normalized * 1f;
                        newMeshSimulation.Velocity = newVelocity;
                    }
*/
                   /* if (true)
                    {
                        var pos = new Vector3(ray.origin.x, 0, ray.origin.z);
                        foreach (Terrain terrain in Terrain.activeTerrains)
                        {
                            Vector3 terrainPos = terrain.GetPosition();
                            if (!terrain.terrainData.bounds.Contains(pos - terrainPos))
                                continue;


                            float sampleHeight = ray.origin.y;
                            if (terrain.SampleHeight(pos) + terrainPos.y > sampleHeight)
                            {
                                float offset = _waterfall.BaseProfile.TerrainOffset.Evaluate(i / (float)_waterfall.NmSpline.Points.Count);
                                newMeshSimulation.Position = new Vector3(newMeshSimulation.Position.x, terrain.SampleHeight(pos) + terrainPos.y + offset - position.y, newMeshSimulation.Position.z);
                            }

                            break;
                        }
                    }*/


                    // + Vector3.up * 0.1f;


                    CurrentVelocities[i] = newVelocity;
                    AllSimulationPoints[i].Add(newMeshSimulation);
                }

                BlurVelocities();
                t++;

                // If all raycasts hit an object, end simulation
                if (pointsHit.Count == _waterfall.NmSpline.Points.Count)
                    break;
            }
        }

        private MeshSimulation CalculateMeshSimulation(List<List<MeshSimulation>> allSimulationPoints, int i, int t, Vector3 position, out Vector3 newVelocity, out MeshSimulation newMeshSimulation)
        {
            MeshSimulation currentSimulation = allSimulationPoints[i][t];
            //currentSimulation.Velocity = newVelocity;

            Vector3 velocity = CurrentVelocities[i];
            newVelocity = velocity + Physics.gravity * _waterfall.BaseProfile.TimeStep;

            Vector3 newPosition = currentSimulation.Position + newVelocity * _waterfall.BaseProfile.TimeStep;


            /*if (Physics.Raycast(testPosition + Vector3.up, Vector3.down, out RaycastHit checkHitUnderTerrain, 3, _waterfall.BaseProfile.RaycastMask, QueryTriggerInteraction.Ignore))
            {
                if (checkHitUnderTerrain.point.y > testPosition.y)
                {
                    //  newPosition = checkHitUnderTerrain.point - position + 0.1f * Vector3.up;
                }
            }*/


            newMeshSimulation = new()
            {
                Position = newPosition,
                Normal = Vector3.Cross(velocity, currentSimulation.Binormal).normalized,
                Binormal = currentSimulation.Binormal,
                Tangent = velocity,
                DistanceU = currentSimulation.DistanceU + Vector3.Distance(newPosition, currentSimulation.Position),
                // DistanceV = i == 0 ? 0 : newSimulationPoints[^1].DistanceV + Vector3.Distance(newPosition, newSimulationPoints[^1].Position),
                DistanceV = currentSimulation.DistanceV,
                Velocity = newVelocity
            };
            allSimulationPoints[i][t] = currentSimulation;
            return currentSimulation;
        }


        private void BlurVelocities()
        {
            List<Vector3> blurredVelocities = new(CurrentVelocities.Count);

            for (int it = 0; it < _waterfall.BaseProfile.BlurVelocityIterations; it++)
            {
                for (int i = 0; i < CurrentVelocities.Count; i++)
                {
                    Vector3 blurredDirection = RamMath.GaussianBlur(CurrentVelocities, i, _waterfall.BaseProfile.BlurVelocityStrength, _waterfall.BaseProfile.BlurVelocitySize, _isLooping);
                    blurredDirection.y = CurrentVelocities[i].y;
                    blurredVelocities.Add(blurredDirection);
                }

                if (_isLooping)
                    blurredVelocities[^1] = blurredVelocities[0];

                CurrentVelocities.Clear();
                CurrentVelocities.AddRange(blurredVelocities);
                blurredVelocities.Clear();
            }
        }


        private void InitializeInitialData()
        {
            CurrentVelocities.Clear();
            AllSimulationPoints.Clear();

            _isLooping = _waterfall.NmSpline.IsLooping;

            for (int i = 0; i < _waterfall.NmSpline.Points.Count; i++)
            {
                AllSimulationPoints.Add(new List<MeshSimulation>());
                Vector3 binormal = _waterfall.NmSpline.Points[i].Binormal;
                Quaternion orientation = _waterfall.NmSpline.Points[i].Orientation;

                AllSimulationPoints[i].Add(new MeshSimulation()
                {
                    Position = _waterfall.NmSpline.Points[i].Position,
                    Normal = _waterfall.NmSpline.Points[i].Normal,
                    Tangent = binormal,
                    Binormal = -_waterfall.NmSpline.Points[i].Tangent,
                    DistanceU = 0,
                    DistanceV = _waterfall.NmSpline.Points[i].Distance,
                    Velocity = orientation * Vector3.right * _waterfall.BaseProfile.BaseStrength
                });

                CurrentVelocities.Add((orientation * Vector3.right * _waterfall.BaseProfile.BaseStrength));
            }
        }
    }
}