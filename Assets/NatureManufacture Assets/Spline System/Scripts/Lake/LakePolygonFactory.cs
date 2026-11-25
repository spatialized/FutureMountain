using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace NatureManufacture.RAM
{
    public static class LakePolygonFactory
    {
       

        public static LakePolygon CreatePolygon(Material material, List<Vector3> positions = null)
        {
            var gameObject = new GameObject("Lake Polygon")
            {
                layer = LayerMask.NameToLayer("Water")
            };

            var meshRenderer = gameObject.AddComponent<MeshRenderer>();
            meshRenderer.receiveShadows = false;
            meshRenderer.shadowCastingMode = ShadowCastingMode.Off;
#if UNITY_EDITOR
            meshRenderer.receiveGI = ReceiveGI.Lightmaps;
#endif

            var polygon = gameObject.AddComponent<LakePolygon>();

            polygon.NmSpline = polygon.GetComponentInParent<NmSpline>();
            polygon.NmSpline.SetData(polygon.snapToTerrain ? 1 : 0, 1, true, false, false, true, false, false, false);
#if UNITY_EDITOR
            var flags = StaticEditorFlags.ContributeGI;

            GameObjectUtility.SetStaticEditorFlags(gameObject, flags);
#endif


            if (material != null)
                meshRenderer.sharedMaterial = material;

            if (positions != null)
                for (int i = 0; i < positions.Count; i++)
                    polygon.NmSpline.AddPoint(positions[i], polygon.snapToTerrain);

            return polygon;
        }
    }
}