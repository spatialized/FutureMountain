using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public static class LightningUtility
    {
        public static void UnwrapLightning(Mesh mesh)
        {
#if UNITY_EDITOR
            UnwrapParam.SetDefaults(out var unwrapParam);
            unwrapParam.hardAngle = 30;
            unwrapParam.angleError = 0.000001f;
            unwrapParam.areaError = 0.000001f;

            Unwrapping.GenerateSecondaryUVSet(mesh, unwrapParam);
#endif
        }
    }
}