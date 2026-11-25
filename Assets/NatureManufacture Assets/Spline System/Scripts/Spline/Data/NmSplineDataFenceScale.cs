using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace NatureManufacture.RAM
{
    public class NmSplineDataFenceScale : NmSplineData<Vector2>
    {
        public override string GetName => "Point Scale";

        public override Vector2 GetBaseValue => Vector2.one;

        public override Vector2 LerpData(Vector2 a, Vector2 b, float lerp)
        {
            return Vector2.Lerp(a, b, lerp);
        }


        public override void ShowHandle(NmSpline nmSpline, int i, Vector3 handlePos, Quaternion handleRot, float handleSize)
        {
#if UNITY_EDITOR
            Vector2 value = MainControlPointsData[i];
            Handles.color = Handles.xAxisColor;

            value.x = Handles.ScaleSlider(value.x,
                handlePos, handleRot * new Vector3(0.5f, 0, 0),
                handleRot, handleSize, 0.01f);

            if (value.x <= 0)
                value.x = 0.00001f;

            Handles.color = Handles.yAxisColor;
            value.y = Handles.ScaleSlider(value.y,
                handlePos, handleRot * new Vector3(0,0,  0.5f),
                handleRot, handleSize, 0.01f);

            if (value.y <= 0)
                value.y = 0.00001f;

            MainControlPointsData[i] = value;

#endif
        }
    }
}