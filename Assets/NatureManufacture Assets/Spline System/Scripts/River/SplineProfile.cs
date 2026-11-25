using System;
using UnityEngine.Serialization;

namespace NatureManufacture.RAM
{
    using UnityEngine;
    using UnityEngine.Rendering;

    [CreateAssetMenu(fileName = "SplineProfile", menuName = "NatureManufacture/SplineProfile", order = 1)]
    public class SplineProfile : ScriptableObject, IProfile<SplineProfile>
    {
        #region basic

        public bool invertUVDirection;
        public bool normalFromRaycast;
        [SerializeField] private bool normalFromRaycastPerVertex;
        [SerializeField] private float normalFromRaycastLerp = 1;

        public bool snapToTerrain;
        public float width = 4;
        public Material splineMaterial;
        public AnimationCurve meshCurve = new AnimationCurve(new Keyframe[] { new Keyframe(0, 0), new Keyframe(1, 0) });


        public float minVal = 50;
        public float maxVal = 50;

        public int vertsInShape = 3;
        public float triangleDensity = 4;

        public float uvScale = 1;
        public bool uvUseFixedTile = false;
        public float uvFixedWidth = 4;
        public float uvFixedTileLerp = 1;
        public bool uvRotation = true;
        public LayerMask snapMask = ~0;


        public bool receiveShadows;
        public ShadowCastingMode shadowCastingMode = ShadowCastingMode.Off;

        #endregion

        #region vertexColor

        public AnimationCurve redColorCurve = new AnimationCurve(new Keyframe(0, 0), new Keyframe(1, 0));
        public AnimationCurve greenColorCurve = new AnimationCurve(new Keyframe(0, 0), new Keyframe(1, 0));
        public AnimationCurve blueColorCurve = new AnimationCurve(new Keyframe(0, 0), new Keyframe(1, 0));
        public AnimationCurve alphaColorCurve = new AnimationCurve(new Keyframe(0, 1), new Keyframe(1, 1));

        #endregion

        #region flowmap

        public AnimationCurve flowFlat = new AnimationCurve(new Keyframe[]
        {
            new Keyframe(0, 0.025f),
            new Keyframe(0.5f, 0.05f),
            new Keyframe(1, 0.025f)
        });

        public AnimationCurve flowWaterfall = new AnimationCurve(new Keyframe[]
        {
            new Keyframe(0, 0.25f),
            new Keyframe(1, 0.25f)
        });

        public bool noiseFlowMap;
        public float noiseMultiplierFlowMap = 0.1f;
        public float noiseSizeXFlowMap = 2f;
        public float noiseSizeZFlowMap = 2f;

        public float floatSpeed = 3;
        public float floatSpeedWaterfallMultiplier = 3;
        public float physicalDensity = 1;
        public float flowLerpDistance = 10;

        public float meshFlowSpeed = 1;

        #endregion


        #region vertexData

        public VertexPaintNoiseData vertexPainterNoiseData = new();

        #endregion


        #region simulation

        public float simulatedRiverLength = 100;
        public int simulatedRiverPoints = 10;
        public float simulatedMinStepSize = 1f;
        public bool simulatedNoUp;
        public bool simulatedBreakOnUp = true;

        public bool noiseWidth;
        public float noiseMultiplierWidth = 4f;
        public float noiseSizeWidth = 0.5f;

        #endregion

        [SerializeField] private TerrainPainterData terrainPainterData;


        // ReSharper disable once IdentifierTypo
        public int biomeType;

        public bool NormalFromRaycastPerVertex
        {
            get => normalFromRaycastPerVertex;
            set => normalFromRaycastPerVertex = value;
        }

        public TerrainPainterData PainterData
        {
            get => terrainPainterData;
            set => terrainPainterData = value;
        }

        public float NormalFromRaycastLerp
        {
            get => normalFromRaycastLerp;
            set => normalFromRaycastLerp = value;
        }

        public void SetProfileData(SplineProfile otherProfile)
        {
            invertUVDirection = otherProfile.invertUVDirection;
            normalFromRaycast = otherProfile.normalFromRaycast;
            normalFromRaycastPerVertex = otherProfile.normalFromRaycastPerVertex;
            normalFromRaycastLerp = otherProfile.normalFromRaycastLerp;

            snapToTerrain = otherProfile.snapToTerrain;


            width = otherProfile.width;

            meshCurve = new AnimationCurve(otherProfile.meshCurve.keys);
            flowFlat = new AnimationCurve(otherProfile.flowFlat.keys);
            flowWaterfall = new AnimationCurve(otherProfile.flowWaterfall.keys);


            splineMaterial = otherProfile.splineMaterial;

            minVal = otherProfile.minVal;
            maxVal = otherProfile.maxVal;

            //Debug.Log($"{otherProfile.triangleDensity}");
            triangleDensity = otherProfile.triangleDensity;
            vertsInShape = otherProfile.vertsInShape;
            snapMask = otherProfile.snapMask;

            uvScale = otherProfile.uvScale;
            uvUseFixedTile = otherProfile.uvUseFixedTile;
            uvFixedWidth = otherProfile.uvFixedWidth;
            uvFixedTileLerp = otherProfile.uvFixedTileLerp;

            uvRotation = otherProfile.uvRotation;

            redColorCurve = otherProfile.redColorCurve;
            greenColorCurve = otherProfile.greenColorCurve;
            blueColorCurve = otherProfile.blueColorCurve;
            alphaColorCurve = otherProfile.alphaColorCurve;

            noiseFlowMap = otherProfile.noiseFlowMap;
            noiseMultiplierFlowMap = otherProfile.noiseMultiplierFlowMap;
            noiseSizeXFlowMap = otherProfile.noiseSizeXFlowMap;
            noiseSizeZFlowMap = otherProfile.noiseSizeZFlowMap;


            floatSpeed = otherProfile.floatSpeed;
            floatSpeedWaterfallMultiplier = otherProfile.floatSpeedWaterfallMultiplier;
            physicalDensity = otherProfile.physicalDensity;
            
            flowLerpDistance = otherProfile.flowLerpDistance;
            meshFlowSpeed = otherProfile.meshFlowSpeed;


            vertexPainterNoiseData.SetNoiseData(otherProfile.vertexPainterNoiseData);


            simulatedRiverLength = otherProfile.simulatedRiverLength;
            simulatedRiverPoints = otherProfile.simulatedRiverPoints;
            simulatedMinStepSize = otherProfile.simulatedMinStepSize;
            simulatedNoUp = otherProfile.simulatedNoUp;
            simulatedBreakOnUp = otherProfile.simulatedBreakOnUp;
            noiseWidth = otherProfile.noiseWidth;
            noiseMultiplierWidth = otherProfile.noiseMultiplierWidth;
            noiseSizeWidth = otherProfile.noiseSizeWidth;

            receiveShadows = otherProfile.receiveShadows;
            shadowCastingMode = otherProfile.shadowCastingMode;


            PainterData = otherProfile.PainterData;
        }

        public bool CheckProfileChange(SplineProfile otherProfile)
        {
            if (otherProfile == null)
                return false;


            if (invertUVDirection != otherProfile.invertUVDirection)
                return true;
            if (normalFromRaycast != otherProfile.normalFromRaycast)
                return true;
            if (normalFromRaycastPerVertex != otherProfile.normalFromRaycastPerVertex)
                return true;
            if (normalFromRaycastLerp != otherProfile.normalFromRaycastLerp)
                return true;

            if (snapToTerrain != otherProfile.snapToTerrain)
                return true;

            if (width != otherProfile.width)
                return true;

            if (minVal != otherProfile.minVal)
                return true;
            if (maxVal != otherProfile.maxVal)
                return true;

            if (triangleDensity != otherProfile.triangleDensity)
                return true;
            if (vertsInShape != otherProfile.vertsInShape)
                return true;

            if (uvScale != otherProfile.uvScale)
                return true;

            if (uvUseFixedTile != otherProfile.uvUseFixedTile)
                return true;

            if (uvFixedWidth != otherProfile.uvFixedWidth)
                return true;


            if (uvFixedTileLerp != otherProfile.uvFixedTileLerp)
                return true;

            if (uvRotation != otherProfile.uvRotation)
                return true;

            if (snapMask != otherProfile.snapMask)
                return true;


            if (noiseFlowMap != otherProfile.noiseFlowMap)
                return true;

            if (noiseMultiplierFlowMap != otherProfile.noiseMultiplierFlowMap)
                return true;

            if (noiseSizeXFlowMap != otherProfile.noiseSizeXFlowMap)
                return true;

            if (noiseSizeZFlowMap != otherProfile.noiseSizeZFlowMap)
                return true;

            if (floatSpeed != otherProfile.floatSpeed)
                return true;
            
            if (floatSpeedWaterfallMultiplier != otherProfile.floatSpeedWaterfallMultiplier)
                return true;
            
            if (physicalDensity != otherProfile.physicalDensity)
                return true;
            

            if (flowLerpDistance != otherProfile.flowLerpDistance)
                return true;

            if (meshFlowSpeed != otherProfile.meshFlowSpeed)
                return true;

            if (vertexPainterNoiseData.CheckDataChange(otherProfile.vertexPainterNoiseData))
                return true;


            if (otherProfile.simulatedRiverLength != simulatedRiverLength)
                return true;
            if (otherProfile.simulatedRiverPoints != simulatedRiverPoints)
                return true;
            if (otherProfile.simulatedMinStepSize != simulatedMinStepSize)
                return true;
            if (otherProfile.simulatedNoUp != simulatedNoUp)
                return true;
            if (otherProfile.simulatedBreakOnUp != simulatedBreakOnUp)
                return true;
            if (otherProfile.noiseWidth != noiseWidth)
                return true;
            if (otherProfile.noiseMultiplierWidth != noiseMultiplierWidth)
                return true;
            if (otherProfile.noiseSizeWidth != noiseSizeWidth)
                return true;


            if (receiveShadows != otherProfile.receiveShadows)
                return true;

            if (shadowCastingMode != otherProfile.shadowCastingMode)
                return true;
            if (PainterData != otherProfile.PainterData)
                return true;

            return false;
        }
    }
}