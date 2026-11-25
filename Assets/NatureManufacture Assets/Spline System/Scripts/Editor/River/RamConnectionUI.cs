using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM.Editor
{
    public static class RamConnectionUI
    {
        public static void ParentingSplineUI(RamSpline ramSpline)
        {
            GUILayout.Label("Rivers connections", EditorStyles.boldLabel);

            ramSpline.BeginningSplineConnection.ConnectionType =
                (RamSplineConnection.ConnectionTypeEnum)EditorGUILayout.EnumPopup("Beginning connection type", ramSpline.BeginningSplineConnection.ConnectionType);


            if (ramSpline.BeginningSplineConnection.ConnectionType == RamSplineConnection.ConnectionTypeEnum.Split)
            {
                ramSpline.beginningSpline =
                    (RamSpline)EditorGUILayout.ObjectField("Beginning split spline", ramSpline.beginningSpline, typeof(RamSpline),
                        true);

                ramSpline.BeginningSplineConnection.Spline = null;
            }
            else
            {
                LakeConnectionUI("Beginning spline", ramSpline, ramSpline.BeginningSplineConnection, 0);
                ramSpline.beginningSpline = null;
            }

            RamSplineBeginningCheck(ramSpline);

            EditorGUILayout.Space();

            ramSpline.EndingSplineConnection.ConnectionType =
                (RamSplineConnection.ConnectionTypeEnum)EditorGUILayout.EnumPopup("Ending connection type", ramSpline.EndingSplineConnection.ConnectionType);

            if (ramSpline.EndingSplineConnection.ConnectionType == RamSplineConnection.ConnectionTypeEnum.Split)
            {
                ramSpline.endingSpline =
                    (RamSpline)EditorGUILayout.ObjectField("Ending split spline", ramSpline.endingSpline, typeof(RamSpline), true);
                ramSpline.EndingSplineConnection.Spline = null;
            }
            else
            {
                LakeConnectionUI("Ending spline", ramSpline, ramSpline.EndingSplineConnection, ramSpline.NmSpline.MainControlPoints.Count - 1);

                ramSpline.endingSpline = null;
            }

            RamSplineEndingCheck(ramSpline);
        }

        private static void RamSplineBeginningCheck(RamSpline ramSpline)
        {
            if (ramSpline.beginningSpline == ramSpline)
                ramSpline.beginningSpline = null;

            if (ramSpline.beginningSpline != null)
            {
                if (ramSpline.NmSpline.MainControlPoints.Count > 0 && ramSpline.beginningSpline.NmSpline.Points.Count > 0)
                {
                    ramSpline.beginningMinWidth *= ramSpline.beginningSpline.BaseProfile.vertsInShape - 1;
                    ramSpline.beginningMaxWidth *= ramSpline.beginningSpline.BaseProfile.vertsInShape - 1;
                    EditorGUILayout.MinMaxSlider("Part parent", ref ramSpline.beginningMinWidth, ref ramSpline.beginningMaxWidth,
                        0, ramSpline.beginningSpline.BaseProfile.vertsInShape - 1);
                    ramSpline.beginningMinWidth = (int)ramSpline.beginningMinWidth;
                    ramSpline.beginningMaxWidth = (int)ramSpline.beginningMaxWidth;
                    ramSpline.beginningMinWidth =
                        Mathf.Clamp(ramSpline.beginningMinWidth, 0, ramSpline.beginningSpline.BaseProfile.vertsInShape - 1);
                    ramSpline.beginningMaxWidth =
                        Mathf.Clamp(ramSpline.beginningMaxWidth, 0, ramSpline.beginningSpline.BaseProfile.vertsInShape - 1);
                    if (ramSpline.beginningMinWidth == ramSpline.beginningMaxWidth)
                    {
                        if (ramSpline.beginningMinWidth > 0)
                            ramSpline.beginningMinWidth--;
                        else
                            ramSpline.beginningMaxWidth++;
                    }

                    ramSpline.BaseProfile.vertsInShape = (int)(ramSpline.beginningMaxWidth - ramSpline.beginningMinWidth) + 1;
                    ramSpline.beginningMinWidth /= ramSpline.beginningSpline.BaseProfile.vertsInShape - 1;
                    ramSpline.beginningMaxWidth /= ramSpline.beginningSpline.BaseProfile.vertsInShape - 1;

                    RamSplineConnection.GenerateBeginningPointsFromParent(ramSpline);
                }
            }
            else
            {
                ramSpline.beginningMaxWidth = 1;
                ramSpline.beginningMinWidth = 0;
            }
        }

        private static void RamSplineEndingCheck(RamSpline ramSpline)
        {
            if (ramSpline.endingSpline == ramSpline)
                ramSpline.endingSpline = null;


            if (ramSpline.endingSpline != null)
            {
                if (ramSpline.NmSpline.MainControlPoints.Count > 1 && ramSpline.endingSpline.NmSpline.Points.Count > 0)
                {
                    ramSpline.endingMinWidth *= ramSpline.endingSpline.BaseProfile.vertsInShape - 1;
                    ramSpline.endingMaxWidth *= ramSpline.endingSpline.BaseProfile.vertsInShape - 1;

                    EditorGUILayout.MinMaxSlider("Part parent", ref ramSpline.endingMinWidth, ref ramSpline.endingMaxWidth, 0,
                        ramSpline.endingSpline.BaseProfile.vertsInShape - 1);

                    ramSpline.endingMinWidth = (int)ramSpline.endingMinWidth;
                    ramSpline.endingMaxWidth = (int)ramSpline.endingMaxWidth;
                    ramSpline.endingMinWidth = Mathf.Clamp(ramSpline.endingMinWidth, 0, ramSpline.endingSpline.BaseProfile.vertsInShape - 1);
                    ramSpline.endingMaxWidth = Mathf.Clamp(ramSpline.endingMaxWidth, 0, ramSpline.endingSpline.BaseProfile.vertsInShape - 1);
                    if (ramSpline.endingMinWidth == ramSpline.endingMaxWidth)
                    {
                        if (ramSpline.endingMinWidth > 0)
                            ramSpline.endingMinWidth--;
                        else
                            ramSpline.endingMaxWidth++;
                    }

                    ramSpline.BaseProfile.vertsInShape = (int)(ramSpline.endingMaxWidth - ramSpline.endingMinWidth) + 1;
                    ramSpline.endingMinWidth /= ramSpline.endingSpline.BaseProfile.vertsInShape - 1;
                    ramSpline.endingMaxWidth /= ramSpline.endingSpline.BaseProfile.vertsInShape - 1;

                    RamSplineConnection.GenerateEndingPointsFromParent(ramSpline);
                }
            }
            else
            {
                ramSpline.endingMaxWidth = 1;
                ramSpline.endingMinWidth = 0;
            }
        }

        private static void LakeConnectionUI(string label, RamSpline ramSpline, RamSplineConnection ramSplineConnection, int connectionPointId)
        {
            ramSplineConnection.Spline = (NmSpline)EditorGUILayout.ObjectField(label, ramSplineConnection.Spline, typeof(NmSpline), true);

            EditorGUI.indentLevel++;
            if (ramSplineConnection.Spline != null)
            {
                if (ramSplineConnection.PointToConnect < 0)
                {
                    RamSplineConnection.SetupBaseValues(ramSpline, ramSplineConnection, connectionPointId);
                }


                ramSplineConnection.PointToConnect = EditorGUILayout.Slider("Spline point to connect", ramSplineConnection.PointToConnect,
                    0, ramSplineConnection.Spline.MainControlPoints.Count - 1);

                ramSplineConnection.YOffset = EditorGUILayout.FloatField("Y offset", ramSplineConnection.YOffset);
                ramSplineConnection.BlendOffset = EditorGUILayout.FloatField("Blend offset", ramSplineConnection.BlendOffset);
            }


            ramSplineConnection.BlendDistance = EditorGUILayout.FloatField("Blend distance", ramSplineConnection.BlendDistance);
            ramSplineConnection.BlendStrength = EditorGUILayout.FloatField("Blend strength", ramSplineConnection.BlendStrength);

            ramSplineConnection.BlendCurve = EditorGUILayout.CurveField("Blend curve", ramSplineConnection.BlendCurve);
            ramSplineConnection.SideBlendCurve = EditorGUILayout.CurveField("Side blend curve", ramSplineConnection.SideBlendCurve);


            //if (GUILayout.Button("Get closest position"))
            //{
            //     FindClosestPointToLake();
            // }

            if (ramSplineConnection.Spline != null)
            {
                RamSplineConnection.SetBlendPosition(ramSpline, ramSplineConnection, connectionPointId);
            }
            else
            {
                ramSplineConnection.PointToConnect = -1;
            }

            EditorGUI.indentLevel--;
        }
    }
}