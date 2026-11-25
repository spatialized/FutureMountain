// /**
//  * Created by Pawel Homenko on  07/2022
//  */

using System;
using UnityEditor;
using UnityEngine;
using UnityEngine.Events;
using Object = UnityEngine.Object;

namespace NatureManufacture.RAM.Editor
{
    public class NmSplineManager
    {
        public NmSplineManager(NmSpline nmSpline, string name)
        {
            NmSpline = nmSpline;
            NmSpline.NmSplineChanged ??= new UnityEvent();
            _name = name;
        }

        private bool _splineChanged = false;

        public Action<int> AdditionalPointUI { get; set; }

        private string _name = "";

        private Rect _pointWindowRect = new Rect(50, 5, 340, 120);
        private readonly Rect position = new Rect(0, 0, 10000, 10000);
        private NmSpline NmSpline { get; }


        public void PointsUI()
        {
            if (GUILayout.Button("Add point at end"))
            {
                NmSpline.AddPointAtEnd();
                NmSpline.NmSplineChanged?.Invoke();
            }

            if (GUILayout.Button("Remove last point"))
            {
                NmSpline.RemoveLastPoint();
                NmSpline.NmSplineChanged?.Invoke();
            }

            if (GUILayout.Button(new GUIContent("Remove all points", "Removes all points"))) NmSpline.RemovePoints();

            if (GUILayout.Button(new GUIContent("Reverse all points", "Reverses all points"))) NmSpline.ReversePoints();

            for (int i = 0; i < NmSpline.MainControlPoints.Count; i++)
            {
                GUILayout.Label("Point: " + i, EditorStyles.boldLabel);
                EditorGUI.indentLevel++;

                PointGUI(i);

                EditorGUILayout.Space();
                EditorGUI.indentLevel--;
            }
        }

        private void PointGUI(int i)
        {
            if (NmSpline.MainControlPoints.Count <= i)
                return;

            EditorGUILayout.BeginHorizontal();
            if (NmSpline.UseWidth)
            {
                NmSpline.MainControlPoints[i].position = EditorGUILayout.Vector4Field("", NmSpline.MainControlPoints[i].position);
                if (NmSpline.MainControlPoints[i].position.w <= 0)
                {
                    Vector4 vec4 = NmSpline.MainControlPoints[i].position;
                    vec4.w = 0;
                    NmSpline.MainControlPoints[i].position = vec4;
                }
            }
            else
            {
                NmSpline.MainControlPoints[i].position = EditorGUILayout.Vector3Field("", NmSpline.MainControlPoints[i].position);
            }

            if (GUILayout.Button(new GUIContent("A", "Add point after this point"), GUILayout.MaxWidth(20)))
            {
                NmSpline.AddPointAfter(i);
                NmSpline.NmSplineChanged?.Invoke();

                NmSpline.SelectedPosition = i + 1;
            }

            if (GUILayout.Button(new GUIContent("R", "Remove this Point"), GUILayout.MaxWidth(20)))
            {
                NmSpline.RemovePoint(i);
                NmSpline.NmSplineChanged?.Invoke();


                if (NmSpline.SelectedPosition == i)
                    NmSpline.SelectedPosition--;
            }

            if (NmSpline.SelectedPosition != i && GUILayout.Toggle(NmSpline.SelectedPosition == i, new GUIContent("S", "Select point"), "Button",
                    GUILayout.MaxWidth(20)))
                NmSpline.SelectedPosition = i;

            EditorGUILayout.EndHorizontal();

            if (NmSpline.UseRotation)
            {
                EditorGUILayout.BeginHorizontal();
                if (NmSpline.MainControlPoints.Count > i)
                    NmSpline.MainControlPoints[i].rotation =
                        Quaternion.Euler(EditorGUILayout.Vector3Field("", NmSpline.MainControlPoints[i].rotation.eulerAngles));
                if (GUILayout.Button(new GUIContent("    Clear rotation    ", "Clear Rotation")))
                {
                    NmSpline.MainControlPoints[i].rotation = Quaternion.identity;
                    NmSpline.NmSplineChanged?.Invoke();
                }


                EditorGUILayout.EndHorizontal();
            }
            else
                NmSpline.MainControlPoints[i].rotation = Quaternion.identity;

            if (NmSpline.UsePointSnap)
                if (NmSpline.MainControlPoints.Count > i)
                    NmSpline.MainControlPoints[i].snap =
                        EditorGUILayout.Toggle("Snap to terrain", NmSpline.MainControlPoints[i].snap == 1)
                            ? 1
                            : 0;

            if (NmSpline.UseMeshCurve)
                if (NmSpline.MainControlPoints.Count > i)
                    NmSpline.MainControlPoints[i].meshCurve =
                        EditorGUILayout.CurveField("Mesh curve", NmSpline.MainControlPoints[i].meshCurve);


            if (NmSpline.MainControlPoints.Count > i)
            {
                if (NmSpline.UseSplinePointDensity)
                    NmSpline.MainControlPoints[i].additionalDensityU = Mathf.NextPowerOfTwo(EditorGUILayout.IntSlider("Triangles Density U", (int)NmSpline.MainControlPoints[i].additionalDensityU, 1, 32));
                if (NmSpline.UseSplineWidthDensity)
                    NmSpline.MainControlPoints[i].additionalDensityV = Mathf.NextPowerOfTwo(EditorGUILayout.IntSlider("Triangles Density V", (int)NmSpline.MainControlPoints[i].additionalDensityV, 1, 32));
            }

            foreach (NmSplineDataBase data in NmSpline.AdditionalDataList)
            {
                data.ShowUI(i);
            }

            AdditionalPointUI?.Invoke(i);
        }

        private void PointWindow(int id)
        {
            if (NmSpline.SelectedPosition < 0 || NmSpline.MainControlPoints.Count <= NmSpline.SelectedPosition) return;

            EditorGUI.BeginChangeCheck();
            EditorGUILayout.Space();
            PointGUI(NmSpline.SelectedPosition);


            GUI.DragWindow(position);
            HandleUtility.Repaint();


            if (EditorGUI.EndChangeCheck())
            {
                if (NmSpline.SelectedPosition < 0 || NmSpline.MainControlPoints.Count <= NmSpline.SelectedPosition) return;
                if (NmSpline != null)
                {
                    NmSpline.NmSplineChanged.Invoke();
                }
            }
        }


        private void InSceneUIPoint()
        {
            if (NmSpline.SelectedPosition < 0 || NmSpline.MainControlPoints.Count <= NmSpline.SelectedPosition) return;

            Handles.BeginGUI();

            GUI.backgroundColor = new Color(0.2f, 0.2f, 0.2f, 0.99f);
            string label = _name + " Point " + NmSpline.SelectedPosition;

            _pointWindowRect = GUILayout.Window(0, _pointWindowRect, PointWindow, label);

            Handles.EndGUI();
        }


        public void SceneGUI(Object objectToUndo, bool blockFirstPoint = false, bool blockLastPoint = false, bool windowOnly = false)
        {
            NmSpline.CheckForNanRotation();

            InSceneUIPoint();

            if (windowOnly)
                return;

            NmSplineSceneGUI.SplineSceneGUI(NmSpline, objectToUndo, blockFirstPoint, blockLastPoint, ref _splineChanged);
        }
    }
}