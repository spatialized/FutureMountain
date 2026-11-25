// /**
//  * Created by Pawel Homenko on  07/2022
//  */

using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM.Editor
{
    [Serializable]
    public class RamDebug
    {
        public bool debug;
        public bool debugNormals;

        public bool debugTangents;

        public bool debugFlowmap;
        public bool debugPoints;
        public bool debugPointsConnect;
        public bool debugMesh = true;
        public float distanceToDebug = 5;

        private List<Vector3> _vertices = new();
        private List<Vector3> _normals = new();
        private List<Vector4> _tangents = new();
        private List<Vector2> _uv3 = new();

        private RamSpline _ramSpline;

        public RamDebug(RamSpline ramSpline)
        {
            _ramSpline = ramSpline;
        }

        public void ShowDebugHandles()
        {
            Vector3[] points = new Vector3[_ramSpline.NmSpline.MainControlPoints.Count];


            for (int i = 0; i < _ramSpline.NmSpline.MainControlPoints.Count; i++) points[i] = (Vector3)_ramSpline.NmSpline.MainControlPoints[i].position + _ramSpline.transform.position;


            Handles.color = Color.white;
            Handles.DrawPolyLine(points);

            Handles.color = new Color(1, 0, 0, 0.5f);

            for (int i = 0; i < _ramSpline.NmSpline.PointsDown.Count; i++)
            {
                Vector3 position = _ramSpline.transform.position;
                Vector3 handlePos = _ramSpline.NmSpline.PointsDown[i].Position + position;
                Vector3 handlePos2 = _ramSpline.NmSpline.PointsUp[i].Position + position;
                if (debugPointsConnect)
                    Handles.DrawLine(handlePos, handlePos2);
            }


            Handles.color = Color.blue;


            points = new Vector3[_ramSpline.NmSpline.PointsDown.Count];


            for (int i = 0; i < _ramSpline.NmSpline.PointsDown.Count; i++)
            {
                if (debugPoints)
                    Handles.SphereHandleCap(0, _ramSpline.NmSpline.PointsDown[i].Position + _ramSpline.transform.position, Quaternion.identity, 0.1f,
                        EventType.Repaint);
                points[i] = _ramSpline.NmSpline.PointsDown[i].Position + _ramSpline.transform.position;
            }

            Handles.DrawPolyLine(points);


            points = new Vector3[_ramSpline.NmSpline.PointsUp.Count];

            for (int i = 0; i < _ramSpline.NmSpline.PointsUp.Count; i++)
            {
                if (debugPoints)
                    Handles.SphereHandleCap(0, _ramSpline.NmSpline.PointsUp[i].Position + _ramSpline.transform.position, Quaternion.identity, 0.1f,
                        EventType.Repaint);
                points[i] = _ramSpline.NmSpline.PointsUp[i].Position + _ramSpline.transform.position;
            }

            Handles.DrawPolyLine(points);


            //Normals, tangents
            if (!debugMesh)
            {
                for (int i = 0; i < _ramSpline.NmSpline.Points.Count; i++)
                {
                    points[i] = _ramSpline.NmSpline.Points[i].Position + _ramSpline.transform.position;
                    Handles.color = Color.green;
                    if (debugNormals)
                    {
                        Handles.DrawLine(points[i], points[i] + _ramSpline.NmSpline.Points[i].Normal);
                    }


                    Handles.color = Color.red;
                    if (debugTangents)
                        Handles.DrawLine(points[i] - _ramSpline.NmSpline.Points[i].Tangent, points[i] + _ramSpline.NmSpline.Points[i].Tangent);
                }
            }
            else if (debugMesh)
            {
                Vector3 camPosition = SceneView.lastActiveSceneView.camera.transform.position;
                var style = new GUIStyle
                {
                    normal =
                    {
                        textColor = Color.red
                    }
                };

                Mesh mesh = _ramSpline.meshFilter.sharedMesh;
                if (mesh)
                {
                    mesh.GetVertices(_vertices);
                    mesh.GetNormals(_normals);
                    mesh.GetTangents(_tangents);
                    mesh.GetUVs(3, _uv3);

                    float distDebug = distanceToDebug * distanceToDebug;


                    for (int i = 0; i < _vertices.Count; i++)
                    {
                        _vertices[i] += _ramSpline.transform.position;

                        Vector3 offset = _vertices[i] - camPosition;
                        float sqrLen = offset.sqrMagnitude;

                        if (sqrLen > distDebug)
                            continue;

                        Handles.color = Color.green;
                        if (debugNormals)
                        {
                            style.normal.textColor = Color.green;
                            Handles.Label(_vertices[i] + _normals[i], $"{_normals[i].x:F4} {_normals[i].y:F4} {_normals[i].z:F4}", style);
                            Handles.DrawLine(_vertices[i], _vertices[i] + _normals[i]);
                        }

                        Handles.color = Color.red;
                        if (debugTangents)
                        {
                            style.normal.textColor = Color.green;
                            Handles.Label(_vertices[i] + (Vector3)_tangents[i], $"{_tangents[i].x:F4} {_tangents[i].y:F4} {_tangents[i].z:F4}", style);
                            Handles.DrawLine(_vertices[i] - (Vector3)_tangents[i], _vertices[i] + (Vector3)_tangents[i]);
                        }

                        Handles.color = Color.magenta;

                        if (debugFlowmap)
                        {
                            style.normal.textColor = Color.red;
                            Handles.DrawLine(_vertices[i], _vertices[i] + new Vector3(_uv3[i].x, _uv3[i].y, 0) * 2);
                            Handles.Label(_vertices[i] + new Vector3(_uv3[i].x, _uv3[i].y, 0) * 2, $"{_uv3[i].x:F4} {_uv3[i].y:F4}", style);
                        }
                    }
                }
            }
        }

        public void DebugOptions()
        {
            EditorGUILayout.LabelField("beginningMinWidth", $"{_ramSpline.beginningMinWidth}");
            EditorGUILayout.LabelField("beginningMaxWidth", $"{_ramSpline.beginningMaxWidth}");
            EditorGUILayout.LabelField("minMaxWidth", $"{_ramSpline.minMaxWidth}");
            EditorGUILayout.LabelField("uvBeginning", $"{_ramSpline.uvBeginning}");
            EditorGUILayout.LabelField("uvWidth", $"{_ramSpline.uvWidth}");
            EditorGUILayout.LabelField("length", $"{_ramSpline.length}");
            EditorGUILayout.LabelField("fulllength", $"{_ramSpline.fullLength}");
            EditorGUILayout.LabelField("uv2Length", $"{_ramSpline.uv2Length}");
            EditorGUILayout.LabelField("uv2Beginning", $"{_ramSpline.uv2Final - _ramSpline.uv2Length}");
            EditorGUILayout.LabelField("uv2Final", $"{_ramSpline.uv2Final}");
            EditorGUILayout.Space();
            debug = EditorGUILayout.Toggle("Show debug gizmos", debug);

            if (debug)
            {
                EditorGUI.indentLevel++;
                // spline.debugMesh = EditorGUILayout.Toggle("Debug Mesh", spline.debugMesh);
                distanceToDebug = EditorGUILayout.DelayedFloatField("Debug distance", distanceToDebug);
                debugMesh = EditorGUILayout.Toggle("Debug mesh data", debugMesh);
                debugTangents = EditorGUILayout.Toggle("Show tangents", debugTangents);
                // spline.debugBitangent = EditorGUILayout.Toggle("Show bitangents", spline.debugBitangent);
                debugNormals = EditorGUILayout.Toggle("Show normals", debugNormals);
                debugFlowmap = EditorGUILayout.Toggle("Show flow map", debugFlowmap);
                debugPoints = EditorGUILayout.Toggle("Show points", debugPoints);
                debugPointsConnect = EditorGUILayout.Toggle("Show points connect", debugPointsConnect);

                EditorGUI.indentLevel--;
            }


            EditorGUILayout.Space();
            if (GUILayout.Button("Direction and Flow map"))
            {
                Mesh mesh = _ramSpline.meshFilter.sharedMesh;
                if (mesh)
                {
                    mesh.GetUVs(3, _uv3);

                    List<Vector3> directions = _ramSpline.verticeDirection;


                    for (int i = 0; i < _uv3.Count; i++)
                    {
                        Debug.Log(_uv3[i] + " " + directions[i] + " " + (directions[i] * _uv3[i].y - new Vector3(directions[i].z, directions[i].y, -directions[i].x) * _uv3[i].x));
                    }
                }
            }

            if (GUILayout.Button(new GUIContent("Regenerate spline", "Recalculates whole mesh"))) _ramSpline.GenerateSpline();
        }
    }
}