using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public static class WaterfallDebugger
    {
        public static void ShowBaseDebug(List<List<WaterfallSimulator.MeshSimulation>> simulationPoints, Vector3 position)
        {
         
            if (simulationPoints == null)
                return;

            Vector3 camPosition = SceneView.lastActiveSceneView.camera.transform.position;
            var style = new GUIStyle
            {
                normal =
                {
                    textColor = Color.red
                }
            };

            for (int i = 0; i < simulationPoints.Count; i++)
            {
                for (int s = 1; s < simulationPoints[i].Count; s++)
                {
                    Vector3 calculatedPositionOne = simulationPoints[i][s - 1].Position + position;
                    Vector3 calculatedPositionTwo = simulationPoints[i][s].Position + position;

                    Handles.color = s % 2 == 0 ? Color.green : Color.red;
                    Handles.DrawLine(calculatedPositionOne, calculatedPositionTwo);

                    Vector3 offset = calculatedPositionOne - camPosition;
                    float sqrLen = offset.sqrMagnitude;

                    if (sqrLen > 10)
                        continue;

                    if (Vector3.Distance(calculatedPositionOne, camPosition) > 10)
                        continue;

                    //Handles.Label(calculatedPositionOne, waterfall.AllSimulationPoints[i][s - 1].Velocity + " " + waterfall.AllSimulationPoints[i][s - 1].Velocity.magnitude, style);
                    Handles.Label(calculatedPositionOne, Vector3.Distance(calculatedPositionOne, calculatedPositionTwo).ToString(), style);

                    //Handles.color = Color.blue;
                    //Handles.DrawLine(calculatedPositionOne, calculatedPositionOne + waterfall.AllSimulationPoints[i][s - 1].Velocity.normalized);
                }
            }
        }

        public static void DrawLineDebug(Vector3 position, List<Vector3> vertices, List<Vector3> normals, List<Vector3> tangents, List<Vector3> binormals)
        {
            for (int i = 0; i < vertices.Count; i++)
            {
                Debug.DrawLine(vertices[i] + position, vertices[i] + position + normals[i], Color.blue, 3);
                Debug.DrawLine(vertices[i] + position, vertices[i] + position + tangents[i], Color.red, 3);
                Debug.DrawLine(vertices[i] + position, vertices[i] + position + binormals[i], Color.yellow, 3);
            }
        }
    }
}