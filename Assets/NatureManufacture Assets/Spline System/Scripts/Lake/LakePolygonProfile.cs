using UnityEngine;
using UnityEngine.Rendering;

namespace NatureManufacture.RAM
{
 

    [CreateAssetMenu(fileName = "LakePolygonProfile", menuName = "NatureManufacture/LakePolygonProfile", order = 1)]
    public class LakePolygonProfile : ScriptableObject, IProfile<LakePolygonProfile>
    {
        #region basic

        //public GameObject gameObject;
        public Material lakeMaterial;
        public float uvScale = 1;
        public float maximumTriangleAmount = 200;
        public float maximumTriangleSize = 50;
        public float triangleDensity = 8;
        public bool receiveShadows;
        public ShadowCastingMode shadowCastingMode = ShadowCastingMode.Off;
        public LayerMask snapMask = ~0;

        [field: SerializeField] public float NormalFromRaycastLerp { get; set; } = 1;

        [field: SerializeField] public bool NormalFromRaycast { get; set; }

        #endregion


        #region depth

        public bool depthEnabled = false;
        public AnimationCurve waveCurve = new AnimationCurve(new Keyframe(0, 0), new Keyframe(5, 1), new Keyframe(10, 0.5f));
        public AnimationCurve depthCurve = new AnimationCurve(new Keyframe(0, 0), new Keyframe(1, 1), new Keyframe(10, 10));
        // public AnimationCurve directionalAngleCurve = new AnimationCurve(new Keyframe(0, 1), new Keyframe(180, 0));
        public int depthSmoothAmount  = 1;
        public int automaticDirectionalMapSmoothAmount = 1;
        public bool smoothDistance;
        public int directionalMapRaysAngle = 90;
        public int directionalMapRaysAmount = 24;

        #endregion

        #region flowmap

        public enum FlowmapType
        {
            Central,
            Directional
        }

        public FlowmapType automaticFlowmapType = FlowmapType.Central;
        public Vector2 automaticFlowmapDirection = new Vector2(0, 1);
        public float automaticFlowMapScale = 0.2f;
        public float automaticFlowMapDistance = 10;
        public float automaticFlowMapDistanceBlend = 10;
        public bool automaticFlowMapSmooth = true;
        public int automaticFlowMapSmoothAmount = 1;
        public bool noiseFlowMap;
        public float noiseMultiplierFlowMap = 1f;
        public float noiseSizeXFlowMap = 0.2f;
        public float noiseSizeZFlowMap = 0.2f;
        
        public float floatSpeed = 3;
        public float physicalDensity = 1;

        #endregion


        #region vertexColor

        public AnimationCurve redColorCurve = new AnimationCurve(new Keyframe(0, 0), new Keyframe(1, 0));
        public AnimationCurve greenColorCurve = new AnimationCurve(new Keyframe(0, 0), new Keyframe(1, 0));
        public AnimationCurve blueColorCurve = new AnimationCurve(new Keyframe(0, 0), new Keyframe(1, 0));
        public AnimationCurve alphaColorCurve = new AnimationCurve(new Keyframe(0, 1), new Keyframe(1, 1));

        #endregion

        [SerializeField] private TerrainPainterData terrainPainterData;


        public int biomeType;


        public TerrainPainterData PainterData
        {
            get => terrainPainterData;
            set => terrainPainterData = value;
        }

        public void SetProfileData(LakePolygonProfile otherProfile)
        {
            lakeMaterial = otherProfile.lakeMaterial;

            uvScale = otherProfile.uvScale;
            depthCurve = otherProfile.depthCurve;
            waveCurve = otherProfile.waveCurve;
            depthEnabled = otherProfile.depthEnabled;
            //directionalAngleCurve = otherProfile.directionalAngleCurve;
            depthSmoothAmount = otherProfile.depthSmoothAmount;
            automaticDirectionalMapSmoothAmount = otherProfile.automaticDirectionalMapSmoothAmount;
            smoothDistance = otherProfile.smoothDistance;
            directionalMapRaysAngle = otherProfile.directionalMapRaysAngle;
            directionalMapRaysAmount = otherProfile.directionalMapRaysAmount;


            maximumTriangleAmount = otherProfile.maximumTriangleAmount;
            maximumTriangleSize = otherProfile.maximumTriangleSize;
            triangleDensity = otherProfile.triangleDensity;
            snapMask = otherProfile.snapMask;

            NormalFromRaycast = otherProfile.NormalFromRaycast;
            NormalFromRaycastLerp = otherProfile.NormalFromRaycastLerp;


            receiveShadows = otherProfile.receiveShadows;
            shadowCastingMode = otherProfile.shadowCastingMode;

            automaticFlowmapType = otherProfile.automaticFlowmapType;
            automaticFlowmapDirection = otherProfile.automaticFlowmapDirection;

            automaticFlowMapScale = otherProfile.automaticFlowMapScale;
            automaticFlowMapDistance = otherProfile.automaticFlowMapDistance;
            automaticFlowMapDistanceBlend = otherProfile.automaticFlowMapDistanceBlend;
            automaticFlowMapSmooth = otherProfile.automaticFlowMapSmooth;
            automaticFlowMapSmoothAmount = otherProfile.automaticFlowMapSmoothAmount;

            noiseFlowMap = otherProfile.noiseFlowMap;
            noiseMultiplierFlowMap = otherProfile.noiseMultiplierFlowMap;
            noiseSizeXFlowMap = otherProfile.noiseSizeXFlowMap;
            noiseSizeZFlowMap = otherProfile.noiseSizeZFlowMap;
            
            floatSpeed = otherProfile.floatSpeed;
            physicalDensity = otherProfile.physicalDensity;

            redColorCurve = otherProfile.redColorCurve;
            greenColorCurve = otherProfile.greenColorCurve;
            blueColorCurve = otherProfile.blueColorCurve;
            alphaColorCurve = otherProfile.alphaColorCurve;

            PainterData = otherProfile.PainterData;
        }

        public bool CheckProfileChange(LakePolygonProfile otherProfile)
        {
            if (uvScale != otherProfile.uvScale)
                return true;
            if (maximumTriangleAmount != otherProfile.maximumTriangleAmount)
                return true;
            if (maximumTriangleSize != otherProfile.maximumTriangleSize)
                return true;
            if (triangleDensity != otherProfile.triangleDensity)
                return true;

            if (snapMask != otherProfile.snapMask)
                return true;

            if (NormalFromRaycast != otherProfile.NormalFromRaycast)
                return true;
            if (NormalFromRaycastLerp != otherProfile.NormalFromRaycastLerp)
                return true;


            if (otherProfile.receiveShadows != receiveShadows)
                return true;
            if (otherProfile.shadowCastingMode != shadowCastingMode)
                return true;

            if (depthEnabled != otherProfile.depthEnabled)
                return true;
            if (depthSmoothAmount != otherProfile.depthSmoothAmount)
                return true;
            if (automaticDirectionalMapSmoothAmount != otherProfile.automaticDirectionalMapSmoothAmount)
                return true;
            if (smoothDistance != otherProfile.smoothDistance)
                return true;
            if (directionalMapRaysAngle != otherProfile.directionalMapRaysAngle)
                return true;
            if (directionalMapRaysAmount != otherProfile.directionalMapRaysAmount)
                return true;


            if (automaticFlowmapType != otherProfile.automaticFlowmapType)
                return true;
            if (automaticFlowmapDirection != otherProfile.automaticFlowmapDirection)
                return true;
            if (automaticFlowMapScale != otherProfile.automaticFlowMapScale)
                return true;
            if (automaticFlowMapDistance != otherProfile.automaticFlowMapDistance)
                return true;
            if (automaticFlowMapDistanceBlend != otherProfile.automaticFlowMapDistanceBlend)
                return true;
            if (automaticFlowMapSmooth != otherProfile.automaticFlowMapSmooth)
                return true;
            if (automaticFlowMapSmoothAmount != otherProfile.automaticFlowMapSmoothAmount)
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
            if (physicalDensity != otherProfile.physicalDensity)
                return true;
            
            if (PainterData != otherProfile.PainterData)
                return true;


            return false;
        }
    }
}