// /**
//  * Created by Pawel Homenko on  07/2022
//  */

using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.Serialization;

namespace NatureManufacture.RAM.Editor
{
    [Serializable]
    public class LakeDebug
    {
        public bool debugNormals;

        public bool debugTangents;

        public bool debugUV0;
        public bool debugFlowmap;
        public bool debugPoints;
        public bool debugPointsConnect;
        public bool debugMesh = true;
        public float distanceToDebug = 5;

        private List<Vector3> _vertices = new();
        private List<Vector3> _normals = new();
        private List<Vector4> _tangents = new();
        private List<Vector4> _uv0 = new();
        private List<Vector2> _uv3 = new();

        private LakePolygon _lakePolygon;

        public LakeDebug(LakePolygon lakePolygon)
        {
            _lakePolygon = lakePolygon;
        }

        public void ShowDebugHandles()
        {
            Vector3[] points = new Vector3[_lakePolygon.NmSpline.MainControlPoints.Count];


            for (int i = 0; i < _lakePolygon.NmSpline.MainControlPoints.Count; i++) points[i] = (Vector3)_lakePolygon.NmSpline.MainControlPoints[i].position + _lakePolygon.transform.position;


            Handles.color = Color.white;
            //Handles.DrawPolyLine(points);

            Handles.color = new Color(1, 0, 0, 0.5f);

            for (int i = 0; i < _lakePolygon.NmSpline.PointsDown.Count; i++)
            {
                Vector3 position = _lakePolygon.transform.position;
                Vector3 handlePos = _lakePolygon.NmSpline.PointsDown[i].Position + position;
                Vector3 handlePos2 = _lakePolygon.NmSpline.PointsUp[i].Position + position;
                if (debugPointsConnect)
                    Handles.DrawLine(handlePos, handlePos2);
            }


            Handles.color = Color.blue;
/*

            points = new Vector3[_lakePolygon.NmSpline.PointsDown.Count];


            for (int i = 0; i < _lakePolygon.NmSpline.PointsDown.Count; i++)
            {
                if (debugPoints)
                    Handles.SphereHandleCap(0, _lakePolygon.NmSpline.PointsDown[i].Position + _lakePolygon.transform.position, Quaternion.identity, 0.1f,
                        EventType.Repaint);
                points[i] = _lakePolygon.NmSpline.PointsDown[i].Position + _lakePolygon.transform.position;
            }

            //Handles.DrawPolyLine(points);


            points = new Vector3[_lakePolygon.NmSpline.PointsUp.Count];

            for (int i = 0; i < _lakePolygon.NmSpline.PointsUp.Count; i++)
            {
                if (debugPoints)
                    Handles.SphereHandleCap(0, _lakePolygon.NmSpline.PointsUp[i].Position + _lakePolygon.transform.position, Quaternion.identity, 0.1f,
                        EventType.Repaint);
                points[i] = _lakePolygon.NmSpline.PointsUp[i].Position + _lakePolygon.transform.position;
            }
*/

            var style = new GUIStyle
            {
                normal =
                {
                    textColor = Color.red
                }
            };


            float distDebug = distanceToDebug * distanceToDebug;

            Vector3 camPosition = SceneView.lastActiveSceneView.camera.transform.position;

            points = new Vector3[_lakePolygon.NmSpline.Points.Count];

            for (int i = 0; i < _lakePolygon.NmSpline.Points.Count; i++)
            {
                points[i] = _lakePolygon.NmSpline.Points[i].Position + _lakePolygon.transform.position;

                Vector3 offset = points[i] - camPosition;
                float sqrLen = offset.sqrMagnitude;

                if (sqrLen > distDebug)
                    continue;

                if (debugPoints)
                {
                    Handles.SphereHandleCap(0, _lakePolygon.NmSpline.Points[i].Position + _lakePolygon.transform.position, Quaternion.identity, 0.1f,
                        EventType.Repaint);

                    Handles.Label(_lakePolygon.NmSpline.Points[i].Position + _lakePolygon.transform.position + Vector3.up * 0.2f, $"id {i} ", style);
                }
            }

            Handles.DrawPolyLine(points);


            Mesh mesh = _lakePolygon.meshFilter.sharedMesh;
            if (mesh)
            {
                mesh.GetVertices(_vertices);
                mesh.GetNormals(_normals);
                mesh.GetTangents(_tangents);
                mesh.GetUVs(0, _uv0);
                mesh.GetUVs(3, _uv3);


                for (int i = 0; i < _vertices.Count; i++)
                {
                    _vertices[i] += _lakePolygon.transform.position;

                    Vector3 offset = _vertices[i] - camPosition;
                    float sqrLen = offset.sqrMagnitude;

                    if (sqrLen > distDebug)
                        continue;

                    Handles.color = Color.green;
                    if (debugNormals) Handles.DrawLine(_vertices[i], _vertices[i] + _normals[i]);

                    Handles.color = Color.red;
                    if (debugTangents)
                        Handles.DrawLine(_vertices[i] - (Vector3)_tangents[i], _vertices[i] + (Vector3)_tangents[i]);

                    //handles orange color 
                    Handles.color = new Color(1, 0.5f, 0, 1);

                    if (debugUV0)
                    {
                        Vector3 direction = -new Vector3(_uv0[i].z, 0, _uv0[i].w);
                        Vector3 position = _vertices[i] + (debugFlowmap ? new Vector3(0, 0.1f, 0) : Vector3.zero);
                        Handles.ArrowHandleCap(0, position, Quaternion.LookRotation(direction.normalized), 0.2f,
                            EventType.Repaint);
                        Handles.DrawLine(position, position + direction);

                        Handles.DrawSolidDisc(position, Vector3.up, 0.01f);
                        //Handles.DrawLine(_vertices[i], _vertices[i] + new Vector3(_uv3[i].x, 0, _uv3[i].y) * 0.1f);

                        Handles.Label(position, $"z {_uv0[i].z:F4} w {_uv0[i].w:F4} ", style);
                    }

                    Handles.color = Color.magenta;

                    if (debugFlowmap)
                    {
                        Handles.ArrowHandleCap(0, _vertices[i], Quaternion.LookRotation(new Vector3(_uv3[i].x, 0, _uv3[i].y)), 0.2f, EventType.Repaint);

                        Handles.DrawSolidDisc(_vertices[i], Vector3.up, 0.01f);
                        //Handles.DrawLine(_vertices[i], _vertices[i] + new Vector3(_uv3[i].x, 0, _uv3[i].y) * 0.1f);

                        Handles.Label(_vertices[i], $"{_uv3[i].x:F4} {_uv3[i].y:F4}", style);
                    }
                }
            }
        }

        public void DebugOptions()
        {
            EditorGUILayout.Space();
            _lakePolygon.ShowDebug = EditorGUILayout.Toggle("Show Debug", _lakePolygon.ShowDebug);

            if (!_lakePolygon.ShowDebug) return;


            EditorGUI.indentLevel++;
            // spline.debugMesh = EditorGUILayout.Toggle("Debug Mesh", spline.debugMesh);
            distanceToDebug = EditorGUILayout.DelayedFloatField("Debug distance", distanceToDebug);
            debugMesh = EditorGUILayout.Toggle("Debug mesh data", debugMesh);
            debugTangents = EditorGUILayout.Toggle("Show tangents", debugTangents);
            // spline.debugBitangent = EditorGUILayout.Toggle("Show bitangents", spline.debugBitangent);
            debugNormals = EditorGUILayout.Toggle("Show normals", debugNormals);
            debugUV0 = EditorGUILayout.Toggle("Show UV0", debugUV0);
            debugFlowmap = EditorGUILayout.Toggle("Show flow map", debugFlowmap);
            debugPoints = EditorGUILayout.Toggle("Show points", debugPoints);
            debugPointsConnect = EditorGUILayout.Toggle("Show points connect", debugPointsConnect);

            EditorGUI.indentLevel--;


            //  if (GUILayout.Button(new GUIContent("Regenerate spline", "Recalculates whole mesh"))) _LakePolygon.r();
        }
    }
}