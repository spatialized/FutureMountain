// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System.Collections.Generic;

namespace NatureManufacture.RAM.Editor
{
    using UnityEditor;
    using UnityEngine;

#if VEGETATION_STUDIO_PRO
    using AwesomeTechnologies;
    using AwesomeTechnologies.VegetationSystem;
    using AwesomeTechnologies.VegetationSystem.Biomes;
#endif

#if VEGETATION_STUDIO
using AwesomeTechnologies;
using AwesomeTechnologies.VegetationStudio;
#endif

    public sealed class LakePolygonVegetationStudio
    {
        private LakePolygon _lakePolygon;

        public LakePolygonVegetationStudio(LakePolygon lakePolygon)
        {
            _lakePolygon = lakePolygon;
        }

        public void UIVegetationStudio()
        {
#if VEGETATION_STUDIO
        EditorGUILayout.Space();
        GUILayout.Label("Vegetation Studio: ", EditorStyles.boldLabel);
        EditorGUI.indentLevel++;
        EditorGUI.BeginChangeCheck();
        _lakePolygon.vegetationMaskResolution =
 EditorGUILayout.Slider("Mask Resolution", _lakePolygon.vegetationMaskResolution, 0.1f, 1);
        _lakePolygon.vegetationMaskPerimeter =
 EditorGUILayout.FloatField("Vegetation Mask Perimeter", _lakePolygon.vegetationMaskPerimeter);
        if (EditorGUI.EndChangeCheck())
        {
            Undo.RecordObject(_lakePolygon, "Lake curve changed");
            RegenerateVegetationStudio();
        }
        EditorGUI.indentLevel--;
        if (_lakePolygon.vegetationMaskArea == null && GUILayout.Button("Add Vegetation Mask Area"))
        {
            _lakePolygon.vegetationMaskArea = _lakePolygon.gameObject.AddComponent<VegetationMaskArea>();
            RegenerateVegetationStudio();
        }
        if (_lakePolygon.vegetationMaskArea != null && GUILayout.Button("Calculate hull outline"))
        {

            RegenerateVegetationStudio();
        }
#endif

#if VEGETATION_STUDIO_PRO
            EditorGUILayout.Space();
            GUILayout.Label("Vegetation Studio Pro: ", EditorStyles.boldLabel);

            EditorGUI.BeginChangeCheck();
            _lakePolygon.vegetationMaskSize =
                EditorGUILayout.FloatField("Vegetation Mask Size", _lakePolygon.vegetationMaskSize);
            _lakePolygon.vegetationBlendDistance =
                EditorGUILayout.FloatField("Vegetation Blend Distance", _lakePolygon.vegetationBlendDistance);
            _lakePolygon.biomMaskResolution =
                EditorGUILayout.Slider("Mask Resolution", _lakePolygon.biomMaskResolution, 0.1f, 1);

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(_lakePolygon, "Lake curve changed");
                RegenerateVegetationStudio();
            }

            if (_lakePolygon.biomeMaskArea != null)
                _lakePolygon.refreshMask = EditorGUILayout.Toggle("Auto Refresh Biome Mask", _lakePolygon.refreshMask);

            if (GUILayout.Button("Add Vegetation Biome Mask Area"))
            {
                _lakePolygon.GeneratePolygon();

                if (_lakePolygon.biomeMaskArea == null)
                {
                    GameObject maskObject = new GameObject("MyMask");
                    maskObject.transform.SetParent(_lakePolygon.transform);
                    maskObject.transform.localPosition = Vector3.zero;

                    _lakePolygon.biomeMaskArea = maskObject.AddComponent<BiomeMaskArea>();
                }

                if (_lakePolygon.biomeMaskArea == null)
                    return;

                RegenerateVegetationStudio(false);
            }

#endif
        }

        public void RegenerateVegetationStudio(bool checkAuto = true)
        {
            bool vegetationStudio = false;
            bool vegetationStudioPro = false;
#if VEGETATION_STUDIO_PRO
            vegetationStudioPro = true;

#endif
#if VEGETATION_STUDIO
vegetationStudio = true;

#endif
            if (vegetationStudioPro)
                RegenerateBiomeMask(checkAuto);
            if (vegetationStudio)
                RegenerateVegetationMask();
        }

        private void RegenerateBiomeMask(bool checkAuto = true)
        {
#if VEGETATION_STUDIO_PRO
            if (checkAuto && !_lakePolygon.refreshMask)
                return;

            if (_lakePolygon.biomeMaskArea == null)
                return;

            _lakePolygon.biomeMaskArea.BiomeType = BiomeType.Underwater;

            List<Vector3> worldspacePointList = new List<Vector3>();
            for (int i = 0; i < _lakePolygon.NmSpline.Points.Count; i += (int) (1 / (float) _lakePolygon.biomMaskResolution))
            {
                Vector3 position = _lakePolygon.transform.TransformPoint(_lakePolygon.NmSpline.Points[i].Position)
                                   + (_lakePolygon.transform.TransformPoint(_lakePolygon.NmSpline.Points[i].Position) - _lakePolygon.transform.position).normalized * _lakePolygon.vegetationMaskSize;

                worldspacePointList.Add(position);
            }


            _lakePolygon.biomeMaskArea.ClearNodes();

            for (var i = 0; i <= worldspacePointList.Count - 1; i++)
            {
                _lakePolygon.biomeMaskArea.AddNodeToEnd(worldspacePointList[i]);
            }

            //these have default values but you can set them if you want a different default setting
            _lakePolygon.biomeMaskArea.BlendDistance = _lakePolygon.vegetationBlendDistance;
            _lakePolygon.biomeMaskArea.NoiseScale = 5;
            _lakePolygon.biomeMaskArea.UseNoise = true;

            //These 3 curves holds the blend curves for vegetation and textures. they have default values;
            //biomeMaskArea.BlendCurve;
            //biomeMaskArea.InverseBlendCurve;
            //biomeMaskArea.TextureBlendCurve;

            if (_lakePolygon.currentProfile != null)
            {
                _lakePolygon.biomeMaskArea.BiomeType = (BiomeType) _lakePolygon.currentProfile.biomeType;
            }
            else
                _lakePolygon.biomeMaskArea.BiomeType = BiomeType.River;

            _lakePolygon.biomeMaskArea.UpdateBiomeMask();
#endif
        }

        private void RegenerateVegetationMask()
        {
#if VEGETATION_STUDIO
        if (_lakePolygon.vegetationMaskArea == null)
            return;

        _lakePolygon.vegetationMaskArea.AdditionalGrassPerimiterMax = _lakePolygon.vegetationMaskPerimeter;
        _lakePolygon.vegetationMaskArea.AdditionalLargeObjectPerimiterMax = _lakePolygon.vegetationMaskPerimeter;
        _lakePolygon.vegetationMaskArea.AdditionalObjectPerimiterMax = _lakePolygon.vegetationMaskPerimeter;
        _lakePolygon.vegetationMaskArea.AdditionalPlantPerimiterMax = _lakePolygon.vegetationMaskPerimeter;
        _lakePolygon.vegetationMaskArea.AdditionalTreePerimiterMax = _lakePolygon.vegetationMaskPerimeter;
        _lakePolygon.vegetationMaskArea.GenerateHullNodes(_lakePolygon.vegetationMaskArea.ReductionTolerance);

        _lakePolygon.GeneratePolygon();
        List<Vector3> worldspacePointList = new List<Vector3>();
        for (int i = 0; i < _lakePolygon.splinePoints.Count; i += (int)(1 / (float)_lakePolygon.vegetationMaskResolution))
        {
            Vector3 position = _lakePolygon.transform.TransformPoint(_lakePolygon.splinePoints[i])
        + (_lakePolygon.transform.TransformPoint(_lakePolygon.splinePoints[i]) - _lakePolygon.transform.position).normalized * _lakePolygon.vegetationMaskPerimeter;

            worldspacePointList.Add(position);
        }


        _lakePolygon.vegetationMaskArea.ClearNodes();

        for (var i = 0; i <= worldspacePointList.Count - 1; i++)
        {
            _lakePolygon.vegetationMaskArea.AddNodeToEnd(worldspacePointList[i]);
        }
        _lakePolygon.vegetationMaskArea.UpdateVegetationMask();
#endif
        }
    }
}