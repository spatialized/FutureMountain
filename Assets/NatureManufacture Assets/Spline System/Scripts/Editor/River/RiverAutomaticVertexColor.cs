using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM.Editor
{
    public static class RiverAutomaticVertexColor
    {
        public static void UIAutomaticVertexColors(RamSpline ramSpline)
        {
            EditorGUILayout.Space();

            EditorGUI.BeginChangeCheck();
            GUILayout.Label("Vertex Color Automatic: ", EditorStyles.boldLabel);

            ramSpline.BaseProfile.redColorCurve = EditorGUILayout.CurveField("Red color curve", ramSpline.BaseProfile.redColorCurve);
            ramSpline.BaseProfile.greenColorCurve = EditorGUILayout.CurveField("Green color curve", ramSpline.BaseProfile.greenColorCurve);
            ramSpline.BaseProfile.blueColorCurve = EditorGUILayout.CurveField("Blue color curve", ramSpline.BaseProfile.blueColorCurve);
            ramSpline.BaseProfile.alphaColorCurve = EditorGUILayout.CurveField("Alpha color curve", ramSpline.BaseProfile.alphaColorCurve);


            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(ramSpline, "Ram changed");
                ramSpline.GenerateSpline();
            }

           // EditorGUILayout.Space();
            //button for generating the ram spline for vertex color automatic alpha blend with lake polygon
          /*  if (GUILayout.Button("[PREVIEW] Generate Blend with Lakes"))
            {
                Undo.RecordObject(ramSpline, "Ram changed");
                RamVertexColors.GenerateBlendWithLakePolygon(ramSpline);
            }*/
        }
    }
}