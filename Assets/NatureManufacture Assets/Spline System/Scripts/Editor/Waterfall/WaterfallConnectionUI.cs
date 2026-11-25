using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM.Editor
{
    public static class WaterfallConnectionUI
    {
        public static void ConnectionUI(Waterfall waterfall, WaterfallConnection waterfallConnection)
        {
            EditorGUI.BeginChangeCheck();
            EditorGUILayout.Space();
            GUILayout.Label("Waterfall connection: ", EditorStyles.boldLabel);
            // EditorGUI.indentLevel++;
            NmSpline spline = (NmSpline)EditorGUILayout.ObjectField("Spline", waterfallConnection.Spline, typeof(NmSpline), true);

            if (waterfallConnection.Spline == null && spline != null)
            {
                waterfallConnection.CalculateOffset(waterfall);
            }

            waterfallConnection.Spline = spline;

            if (waterfallConnection.Spline != null)
            {
                waterfall.BaseProfile.Offset = EditorGUILayout.FloatField("Offset", waterfall.BaseProfile.Offset);
                if (GUILayout.Button("Calculate offset"))
                {
                    waterfallConnection.CalculateOffset(waterfall);
                }

                waterfall.BaseProfile.YOffset = EditorGUILayout.FloatField("Y offset", waterfall.BaseProfile.YOffset);
                waterfall.BaseProfile.AngleOffset = EditorGUILayout.FloatField("Angle offset", waterfall.BaseProfile.AngleOffset);

                EditorGUILayout.Space();
                waterfallConnection.NumberOfPoints = EditorGUILayout.IntField("Number of points", waterfallConnection.NumberOfPoints);
                if (waterfallConnection.NumberOfPoints < 2)
                    waterfallConnection.NumberOfPoints = 2;

                EditorGUILayout.Space();
                waterfallConnection.ConnectionType = (WaterfallConnection.ConnectionTypeEnum)EditorGUILayout.EnumPopup("Connection type", waterfallConnection.ConnectionType);


                switch (waterfallConnection.ConnectionType)
                {
                    case WaterfallConnection.ConnectionTypeEnum.Along:
                        AlongUI(waterfallConnection);
                        break;
                    case WaterfallConnection.ConnectionTypeEnum.Across:
                        AcrossUI(waterfallConnection);
                        break;
                }

                waterfallConnection.Invert = EditorGUILayout.Toggle("Invert", waterfallConnection.Invert);

                EditorGUILayout.Space();
                waterfallConnection.AutoGetPoints = EditorGUILayout.Toggle("Auto get points", waterfallConnection.AutoGetPoints);

                //EditorGUI.indentLevel--;

                EditorGUILayout.Space();

                if (GUILayout.Button("Get points"))
                {
                    waterfallConnection.GetPointsFromSpline(waterfall);
                }

                if (EditorGUI.EndChangeCheck())
                {
                    if (waterfallConnection.Spline != null && waterfallConnection.AutoGetPoints)
                    {
                        waterfallConnection.GetPointsFromSpline(waterfall);
                    }
                }
            }
            else
            {
                waterfallConnection.FirstPoint = -1;
                waterfallConnection.LastPoint = -1;
            }
        }

        private static void AcrossUI(WaterfallConnection waterfallConnection)
        {
            waterfallConnection.ConnectionPoint = EditorGUILayout.Slider("Connection point", waterfallConnection.ConnectionPoint, 0, waterfallConnection.Spline.MainControlPoints.Count - 1);

            float firstPoint = waterfallConnection.FirstPoint;
            float lastPoint = waterfallConnection.LastPoint;
            EditorGUILayout.MinMaxSlider("Points", ref firstPoint, ref lastPoint, 0, 1);

            if (lastPoint > 0)
                lastPoint = 1;

            waterfallConnection.FirstPoint = firstPoint;
            waterfallConnection.LastPoint = lastPoint;
        }

        private static void AlongUI(WaterfallConnection waterfallConnection)
        {
            //waterfallConnection.Offset = EditorGUILayout.FloatField("Offset", waterfallConnection.Offset);
            waterfallConnection.FirstPoint = EditorGUILayout.Slider("First point", waterfallConnection.FirstPoint, 0, waterfallConnection.Spline.MainControlPoints.Count - 1);

            waterfallConnection.LastPoint = EditorGUILayout.Slider("Last point", waterfallConnection.LastPoint, 0, waterfallConnection.Spline.MainControlPoints.Count - 1);
        }


        public static void ShowConnectionOnSpline(Waterfall waterfall, WaterfallConnection waterfallConnection)
        {
            if (waterfallConnection.Spline == null) return;
            if (waterfallConnection.FirstPoint < 0 || waterfallConnection.LastPoint < 0) return;

            if (Mathf.Approximately(waterfallConnection.FirstPoint, waterfallConnection.LastPoint))
                return;

            if (waterfallConnection.FirstPoint > waterfallConnection.Spline.MainControlPoints.Count || waterfallConnection.LastPoint > waterfallConnection.Spline.MainControlPoints.Count)
                return;

            NmSpline spline = waterfallConnection.Spline;
            int count = spline.MainControlPoints.Count;


            float firstPoint = waterfallConnection.FirstPoint;
            float lasPoint = waterfallConnection.LastPoint;
            ShowPointPosition(firstPoint, spline, count, waterfall.BaseProfile.Offset);
            ShowPointPosition(lasPoint, spline, count, waterfall.BaseProfile.Offset);
        }

        private static void ShowPointPosition(float lerpValue, NmSpline spline, int count, float offset)
        {
            NmSplinePoint point = NmSpline.GetMainControlPointDataLerp(spline, lerpValue);

            Vector3 positionLerp = point.Position + spline.transform.position;


            Vector3 binormalLerp = point.Binormal * offset;


            Handles.color = Color.red;
            float size = HandleUtility.GetHandleSize(positionLerp) * 0.1f;
            Handles.SphereHandleCap(0, positionLerp, Quaternion.identity, size, EventType.Repaint);


            Handles.color = Color.green;
            Handles.DrawLine(positionLerp, positionLerp + binormalLerp);

            Handles.SphereHandleCap(0, positionLerp + binormalLerp, Quaternion.identity, size, EventType.Repaint);
        }
    }
}