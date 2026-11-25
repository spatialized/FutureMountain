// /**
//  * Created by Pawel Homenko on  07/2022
//  */

using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;

namespace NatureManufacture.RAM.Editor
{
    public class RamSplitter
    {
        public void SplitRiver(RamSpline ramSpline, int pointID)
        {
            ramSpline.GenerateSpline();
            if (pointID < 0 || pointID >= ramSpline.NmSpline.MainControlPoints.Count)
                return;
#if UNITY_EDITOR
            Undo.RecordObject(ramSpline, "Split river");
#endif

            List<Vector4> ramFirstPoints = new List<Vector4>();
            List<Vector4> ramSecondPoints = new List<Vector4>();


            for (int i = 0; i < ramSpline.NmSpline.MainControlPoints.Count; i++)
            {
                if (i <= pointID) ramFirstPoints.Add(ramSpline.NmSpline.MainControlPoints[i].position);

                if (i >= pointID) ramSecondPoints.Add(ramSpline.NmSpline.MainControlPoints[i].position);
            }

            var ren = ramSpline.GetComponent<MeshRenderer>();


            RamSpline ramFirst = ramSpline.CreateSecondSpline(ren.sharedMaterial, ramFirstPoints, "_1", ramSpline.BaseProfile.width);
            RamSpline ramSecond = ramSpline.CreateSecondSpline(ren.sharedMaterial, ramSecondPoints, "_2", ramSpline.BaseProfile.width);


            //
            ramSecond.beginningSpline = ramFirst;
            ramSecond.beginningMinWidth = 0;
            ramSecond.beginningMaxWidth = 1;
            ramFirst.endingChildSplines.Add(ramSecond);


            ramFirst.beginningSpline = ramSpline.beginningSpline;
            ramSecond.endingSpline = ramSpline.endingSpline;


            foreach (var spline in ramSpline.endingChildSplines)
            {
                if (spline == null) return;
                spline.beginningSpline = ramSecond;
                ramSecond.endingChildSplines.Add(ramSecond);
                spline.GenerateSpline();
            }

            foreach (var spline in ramSpline.beginningChildSplines)
            {
                if (spline == null) return;
                spline.endingSpline = ramFirst;
                ramFirst.beginningChildSplines.Add(ramFirst);
                spline.GenerateSpline();
            }

            ramFirst.GenerateSpline();
            ramSecond.GenerateSpline();

            Vector3 position = ramSpline.transform.position;
            ramFirst.transform.position = position;
            ramSecond.transform.position = position;
#if UNITY_EDITOR
            Undo.DestroyObjectImmediate(ramSpline.gameObject);

            Selection.objects = new Object[] {ramFirst.gameObject, ramSecond.gameObject};
#endif
        }

        public void SplitRiverIntoTwo(RamSpline ramSpline, int pointID)
        {
            ramSpline.GenerateSpline();
            if (pointID < 0 || pointID >= ramSpline.NmSpline.MainControlPoints.Count - 1)
                return;
#if UNITY_EDITOR
            Undo.RecordObject(ramSpline, "Split river");
#endif

            List<Vector4> ramFirstPoints = new List<Vector4>();
            List<Vector4> ramSecondPoints = new List<Vector4>();
            List<Vector4> ramThreePoints = new List<Vector4>();


            for (int i = 0; i < ramSpline.NmSpline.MainControlPoints.Count; i++)
            {
                if (i <= pointID) ramFirstPoints.Add(ramSpline.NmSpline.MainControlPoints[i].position);

                if (i >= pointID)
                {
                    var vec = new Vector4(ramSpline.NmSpline.MainControlPoints[i].position.x, ramSpline.NmSpline.MainControlPoints[i].position.y, ramSpline.NmSpline.MainControlPoints[i].position.z,
                        ramSpline.NmSpline.MainControlPoints[i].position.w * 0.5f);
                    ramSecondPoints.Add(vec);
                }
            }

            var vecLast = new Vector4(ramSpline.NmSpline.MainControlPoints[pointID].position.x, ramSpline.NmSpline.MainControlPoints[pointID].position.y, ramSpline.NmSpline.MainControlPoints[pointID].position.z,
                ramSpline.NmSpline.MainControlPoints[pointID].position.w * 0.5f);


            ramThreePoints.Add(vecLast);
            vecLast = (Vector3) ramSpline.NmSpline.MainControlPoints[pointID + 1].position + ramSpline.NmSpline.MainControlPoints[pointID].position.w * 0.5f *
                ((Vector3) ramSpline.NmSpline.MainControlPoints[pointID + 1].position - ramSpline.NmSpline.ControlPointsPositionUp[pointID + 1]);
            vecLast.w = ramSpline.NmSpline.MainControlPoints[pointID].position.w * 0.5f;
            ramThreePoints.Add(vecLast);


            var ren = ramSpline.GetComponent<MeshRenderer>();
            Material sharedMaterial = ren.sharedMaterial;


            RamSpline ramFirst = ramSpline.CreateSecondSpline(sharedMaterial, ramFirstPoints, "", ramSpline.BaseProfile.width);
            RamSpline ramSecond = ramSpline.CreateSecondSpline(sharedMaterial, ramSecondPoints, "_1", ramSpline.BaseProfile.width * 0.5f);
            RamSpline ramThree = ramSpline.CreateSecondSpline(sharedMaterial, ramThreePoints, "_2", ramSpline.BaseProfile.width * 0.5f);

            RamSpline parentSpline = null;
            if (ramSpline.beginningSpline)
            {
                parentSpline = ramSpline.beginningSpline;
                ramFirst.beginningSpline = parentSpline;
                ramFirst.beginningMinWidth = ramSpline.beginningMinWidth;
                ramFirst.beginningMaxWidth = ramSpline.beginningMaxWidth;

                parentSpline.endingChildSplines.Add(ramFirst);
            }


            //
            ramSecond.beginningSpline = ramFirst;
            ramSecond.beginningMinWidth = 0.5f;
            ramSecond.beginningMaxWidth = 1;

            ramFirst.endingChildSplines.Add(ramSecond);


            ramThree.beginningSpline = ramFirst;
            ramThree.beginningMinWidth = 0;
            ramThree.beginningMaxWidth = 0.5f;


            ramFirst.endingChildSplines.Add(ramThree);

            Vector3 position = ramSpline.transform.position;
            ramFirst.transform.position = position;
            ramSecond.transform.position = position;
            ramThree.transform.position = position;

#if UNITY_EDITOR
            Undo.DestroyObjectImmediate(ramSpline.gameObject);
#endif


            ramFirst.beginningSpline = ramSpline.beginningSpline;
            ramSecond.endingSpline = ramSpline.endingSpline;

            foreach (var spline in ramSpline.endingChildSplines)
            {
                if (spline == null) return;
                spline.beginningSpline = ramSecond;
                ramSecond.endingChildSplines.Add(ramSecond);
                spline.GenerateSpline();
            }

            foreach (var spline in ramSpline.beginningChildSplines)
            {
                if (spline == null) return;
                spline.endingSpline = ramFirst;
                ramFirst.beginningChildSplines.Add(ramFirst);
                spline.GenerateSpline();
            }

            ramFirst.GenerateSpline();
            ramSecond.GenerateSpline();
            ramThree.GenerateSpline();


            if (parentSpline) parentSpline.GenerateSpline();

            ramFirst.GenerateSpline();
            ramSecond.GenerateSpline();
            ramThree.GenerateSpline();
#if UNITY_EDITOR
            Selection.objects = new Object[] {ramFirst.gameObject, ramSecond.gameObject, ramThree.gameObject};
#endif
        }
    }
}