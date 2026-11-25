using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace NatureManufacture.RAM
{
    public class NmSplineDataNoiseStrength : NmSplineData<float>
    {
        public override string GetName => "Noise Strength";

        public override float GetBaseValue => 1f;

        public override float LerpData(float a, float b, float lerp)
        {
            return Mathf.Lerp(a, b, lerp);
        }


        public override void ShowHandle(NmSpline nmSpline, int i, Vector3 handlePos, Quaternion handleRot, float handleSize)
        {
#if UNITY_EDITOR
            
            float value = MainControlPointsData[i];
            Handles.color = Handles.xAxisColor;

            value = Handles.ScaleSlider(value,
                handlePos, new Vector3(0, 0.5f, 0),
                Quaternion.Euler(-90, 0, 0), handleSize, 0.01f);

            if (value <= 0)
                value = 0.00001f;

            MainControlPointsData[i] = value;

#endif
        }
    }
}