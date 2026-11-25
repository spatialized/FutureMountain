using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public static class MeshCurveKeyFrames
    {
        public static Keyframe[] GetPointMeshCurveKeyFrames(int i, List<RamControlPoint> controlPoints)
        {
            //Debug.Log($"GetPointMeshCurveKeyFrames {i}");
            Keyframe[] keyframes;
            if (controlPoints.Count > 0 && i >= 0 && i < controlPoints.Count)
            {
                keyframes = controlPoints[i].meshCurve.keys;
            }
            else
                keyframes = new[] { new Keyframe(0, 0), new Keyframe(1, 0) };

            return keyframes;
        }
    }
}