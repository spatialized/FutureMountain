// /**
//  * Created by Pawel Homenko on  07/2022
//  */

using System;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

#if VEGETATION_STUDIO_PRO
using AwesomeTechnologies;
using AwesomeTechnologies.VegetationSystem;
using AwesomeTechnologies.VegetationSystem.Biomes;
#endif

#if VEGETATION_STUDIO
using AwesomeTechnologies;
using AwesomeTechnologies.VegetationStudio;
#endif


namespace NatureManufacture.RAM
{
    [Serializable]
    public sealed class RamVegetationStudioIntegration
    {
        public float biomMaskResolution = 0.5f;
        public float vegetationMaskSize = 3;
        public float vegetationBlendDistance = 1f;
#if VEGETATION_STUDIO_PRO
        public BiomeMaskArea biomeMaskArea;
#endif
        public bool refreshMask = false;


        public float vegetationMaskPerimeter = 5;
#if VEGETATION_STUDIO
    public VegetationMaskArea vegetationMaskArea;

#endif

        private RamSpline _ramSpline;

        public RamVegetationStudioIntegration(RamSpline ramSpline)
        {
            _ramSpline = ramSpline;
        }

        public void RegenerateVegetationMask()
        {
#if VEGETATION_STUDIO
        vegetationMaskArea.AdditionalGrassPerimiterMax = vegetationMaskPerimeter;
        vegetationMaskArea.AdditionalLargeObjectPerimiterMax = vegetationMaskPerimeter;
        vegetationMaskArea.AdditionalObjectPerimiterMax = vegetationMaskPerimeter;
        vegetationMaskArea.AdditionalPlantPerimiterMax = vegetationMaskPerimeter;
        vegetationMaskArea.AdditionalTreePerimiterMax = vegetationMaskPerimeter;
        vegetationMaskArea.GenerateHullNodes(vegetationMaskArea.ReductionTolerance);

        _ramSpline.GenerateSpline();
        List<Vector3> worldSpacePointList = new();
        for (int i = 0; i < _ramSpline.pointsUp.Count; i += 5)
        {
            Vector3 position =
 _ramSpline.transform.TransformPoint(_ramSpline.pointsUp[i]) + (_ramSpline.transform.TransformPoint(_ramSpline.pointsUp[i]) - _ramSpline.transform.TransformPoint(_ramSpline.pointsDown[i])).normalized * vegetationMaskPerimeter;

            worldSpacePointList.Add(position);
        }
        for (int i = 0; i < _ramSpline.pointsDown.Count; i += 5)
        {
            int ind = _ramSpline.pointsDown.Count - i - 1;
            Vector3 position =
 _ramSpline.transform.TransformPoint(_ramSpline.pointsDown[ind]) + (_ramSpline.transform.TransformPoint(_ramSpline.pointsDown[ind]) - _ramSpline.transform.TransformPoint(_ramSpline.pointsUp[ind])).normalized * vegetationMaskPerimeter;
            worldSpacePointList.Add(position);
        }

        vegetationMaskArea.ClearNodes();

        for (var i = 0; i <= worldSpacePointList.Count - 1; i++)
        {
            vegetationMaskArea.AddNodeToEnd(worldSpacePointList[i]);
        }
        vegetationMaskArea.UpdateVegetationMask();
#endif
        }

        public void RegenerateBiomeMask(bool checkAuto = true)
        {
#if VEGETATION_STUDIO_PRO
            if (checkAuto && !refreshMask)
                return;

            if (biomeMaskArea == null)
                return;


            List<bool> disableEdges = new List<bool>();
            List<Vector3> worldspacePointList = new List<Vector3>();
            for (int i = 0; i < _ramSpline.NmSpline.PointsUp.Count; i += (int) (1 / (float) biomMaskResolution))
            {
                Vector3 position =
                    _ramSpline.transform.TransformPoint(_ramSpline.NmSpline.PointsUp[i].Position) +
                    (_ramSpline.transform.TransformPoint(_ramSpline.NmSpline.PointsUp[i].Position) - _ramSpline.transform.TransformPoint(_ramSpline.NmSpline.PointsDown[i].Position)).normalized * vegetationMaskSize;

                worldspacePointList.Add(position);

                if (i == 0 || (i + (int) (1 / (float) biomMaskResolution)) >= _ramSpline.NmSpline.PointsUp.Count)
                {
                    disableEdges.Add(true);
                }
                else
                {
                    disableEdges.Add(false);
                }
            }

            for (int i = 0; i < _ramSpline.NmSpline.PointsDown.Count; i += (int) (1 / (float) biomMaskResolution))
            {
                int ind = _ramSpline.NmSpline.PointsDown.Count - i - 1;
                Vector3 position =
                    _ramSpline.transform.TransformPoint(_ramSpline.NmSpline.PointsDown[ind].Position) +
                    (_ramSpline.transform.TransformPoint(_ramSpline.NmSpline.PointsDown[ind].Position) - _ramSpline.transform.TransformPoint(_ramSpline.NmSpline.PointsUp[ind].Position)).normalized * vegetationMaskSize;
                worldspacePointList.Add(position);

                if (i == 0 || (i + (int) (1 / (float) biomMaskResolution)) >= _ramSpline.NmSpline.PointsDown.Count)
                {
                    disableEdges.Add(true);
                }
                else
                {
                    disableEdges.Add(false);
                }
            }

            biomeMaskArea.ClearNodes();

            biomeMaskArea.AddNodesToEnd(worldspacePointList.ToArray(), disableEdges.ToArray());


            //these have default values but you can set them if you want a different default setting
            biomeMaskArea.BlendDistance = vegetationBlendDistance;
            biomeMaskArea.NoiseScale = 5;
            biomeMaskArea.UseNoise = true;

            if (_ramSpline.currentProfile != null)
            {
                biomeMaskArea.BiomeType = (BiomeType) _ramSpline.currentProfile.biomeType;
            }
            else
                biomeMaskArea.BiomeType = BiomeType.River;


            biomeMaskArea.UpdateBiomeMask();
#endif
        }

        public void VegetationStudioEditorUI()
        {
#if UNITY_EDITOR
#if VEGETATION_STUDIO
            EditorGUILayout.Space();
            GUILayout.Label("Vegetation Studio: ", EditorStyles.boldLabel);
            _ramSpline.RamVegetationStudioIntegration.vegetationMaskPerimeter =
                EditorGUILayout.FloatField("Vegetation Mask Perimeter", _ramSpline.RamVegetationStudioIntegration.vegetationMaskPerimeter);
            if (_ramSpline.RamVegetationStudioIntegration.vegetationMaskArea == null && GUILayout.Button("Add Vegetation Mask Area"))
            {
                _ramSpline.RamVegetationStudioIntegration.vegetationMaskArea = _ramSpline.gameObject.AddComponent<VegetationMaskArea>();
                _ramSpline.RamVegetationStudioIntegration.RegenerateVegetationMask(_ramSpline);
            }
            if (_ramSpline.RamVegetationStudioIntegration.vegetationMaskArea != null && GUILayout.Button("Calculate hull outline"))
            {

                _ramSpline.RamVegetationStudioIntegration.RegenerateVegetationMask(_ramSpline);
            }
#endif
#if VEGETATION_STUDIO_PRO
            EditorGUILayout.Space();
            GUILayout.Label("Vegetation Studio Pro: ", EditorStyles.boldLabel);
            vegetationMaskSize = EditorGUILayout.FloatField("Vegetation Mask Size", vegetationMaskSize);
            vegetationBlendDistance =
                EditorGUILayout.FloatField("Vegetation Blend Distance", vegetationBlendDistance);
            biomMaskResolution = EditorGUILayout.Slider("Mask Resolution", biomMaskResolution, 0.1f, 1);
            if (biomeMaskArea != null)
                refreshMask = EditorGUILayout.Toggle("Auto Refresh Biome Mask", refreshMask);

            if (GUILayout.Button("Add Vegetation Biome Mask Area"))
            {
                _ramSpline.GenerateSpline();
                if (biomeMaskArea == null)
                {
                    biomeMaskArea = _ramSpline.GetComponentInChildren<BiomeMaskArea>();
                    if (biomeMaskArea == null)
                    {
                        GameObject maskObject = new GameObject("MyMask");
                        maskObject.transform.SetParent(_ramSpline.transform);
                        biomeMaskArea = maskObject.AddComponent<BiomeMaskArea>();
                        biomeMaskArea.BiomeType = BiomeType.River;
                    }
                }

                if (biomeMaskArea == null)
                    return;

                RegenerateBiomeMask(false);
            }
#endif

#endif
        }
    }
}