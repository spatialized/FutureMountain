// /**
//  * Created by Pawel Homenko on  12/2023
//  */

using UnityEngine;

namespace NatureManufacture.RAM
{
    [CreateAssetMenu(fileName = "FenceProfile", menuName = "NatureManufacture/FenceProfile", order = 1)]
    public class WaterfallProfile : ScriptableObject, IProfile<WaterfallProfile>
    {
        [HideInInspector] [SerializeField] private GameObject gameObject;

        [SerializeField] private float triangleDensity = 8f;
        [SerializeField] private Material waterfallMaterial;
        [SerializeField] private float simulationTime = 10;
        [SerializeField] private float timeStep = 0.1f;
        [SerializeField] private float baseStrength = 10f;
        [SerializeField] private Vector2 uvScale = new(0.1f, 0.03f);
        [SerializeField] private float restitutionCoeff = 0.1f;
        [SerializeField] private float restitutionAnglelerp = 0f;
        [SerializeField] private LayerMask raycastMask = ~0;
        [SerializeField] private float blurVelocityStrength = 2f;
        [SerializeField] private int blurVelocityIterations = 2;
        [SerializeField] private int blurVelocitySize = 2;
        [SerializeField] private float blurPositionStrength = 2f;
        [SerializeField] private int blurPositionIterations = 2;
        [SerializeField] private int blurPositionSize = 2;
        [SerializeField] private float maxWaterfallDistance = 20;
        [SerializeField] private float minPointDistance = 0.5f;
        [SerializeField] private AnimationCurve terrainOffset = new(new Keyframe(0, 0), new Keyframe(0.1f, 0.1f), new Keyframe(0.9f, 0.1f), new Keyframe(1, 0));
        [SerializeField] private AnimationCurve alphaByDistance = AnimationCurve.Constant(0, 1, 1);
        [SerializeField] private float floatSpeed = 3;
        [SerializeField] private float floatSpeedWaterfallMultiplier = 3;
        [SerializeField] private float physicalDensity = 1;
        [SerializeField] private bool clipUnderTerrain = false;

        #region Connection

        [SerializeField] private float offset;

        [SerializeField] private float yOffset = 0.05f;
        [SerializeField] private float angleOffset = 0f;

        #endregion

        
        public Material WaterfallMaterial
        {
            get => waterfallMaterial;
            set => waterfallMaterial = value;
        }

        
        public float SimulationTime
        {
            get => simulationTime;
            set => simulationTime = value;
        }

        
        public float TimeStep
        {
            get => timeStep;
            set => timeStep = value;
        }

        
        public float BaseStrength
        {
            get => baseStrength;
            set => baseStrength = value;
        }

        
        public Vector2 UvScale
        {
            get => uvScale;
            set => uvScale = value;
        }

        
        public float RestitutionCoeff
        {
            get => restitutionCoeff;
            set => restitutionCoeff = value;
        }

        
        public float RestitutionAnglelerp
        {
            get => restitutionAnglelerp;
            set => restitutionAnglelerp = value;
        }

        
        public LayerMask RaycastMask
        {
            get => raycastMask;
            set => raycastMask = value;
        }


        
        public float BlurVelocityStrength
        {
            get => blurVelocityStrength;
            set => blurVelocityStrength = value;
        }

        
        public int BlurVelocityIterations
        {
            get => blurVelocityIterations;
            set => blurVelocityIterations = value;
        }

        
        public int BlurVelocitySize
        {
            get => blurVelocitySize;
            set => blurVelocitySize = value;
        }


        
        public float BlurPositionStrength
        {
            get => blurPositionStrength;
            set => blurPositionStrength = value;
        }

        
        public int BlurPositionIterations
        {
            get => blurPositionIterations;
            set => blurPositionIterations = value;
        }

        
        public int BlurPositionSize
        {
            get => blurPositionSize;
            set => blurPositionSize = value;
        }

        
        public float MaxWaterfallDistance
        {
            get => maxWaterfallDistance;
            set => maxWaterfallDistance = value;
        }

        
        public float MinPointDistance
        {
            get => minPointDistance;
            set => minPointDistance = value;
        }

        
        public AnimationCurve TerrainOffset
        {
            get => terrainOffset;
            set => terrainOffset = value;
        }

        
        public AnimationCurve AlphaByDistance
        {
            get => alphaByDistance;
            set => alphaByDistance = value;
        }

        
        public float FloatSpeed
        {
            get => floatSpeed;
            set => floatSpeed = value;
        }
        
        public float FloatSpeedWaterfallMultiplier
        {
            get => floatSpeedWaterfallMultiplier;
            set => floatSpeedWaterfallMultiplier = value;
        }

        
        public bool ClipUnderTerrain
        {
            get => clipUnderTerrain;
            set => clipUnderTerrain = value;
        }


        public float TriangleDensity
        {
            get => triangleDensity;
            set => triangleDensity = value;
        }

        public GameObject GameObject
        {
            get => gameObject;
            set => gameObject = value;
        }

        public float Offset
        {
            get => offset;
            set => offset = value;
        }

        public float YOffset
        {
            get => yOffset;
            set => yOffset = value;
        }

        public float AngleOffset
        {
            get => angleOffset;
            set => angleOffset = value;
        }

        public float PhysicalDensity
        {
            get => physicalDensity;
            set => physicalDensity = value;
        }


        public void SetProfileData(WaterfallProfile otherProfile)
        {
            WaterfallMaterial = otherProfile.WaterfallMaterial;
            TriangleDensity = otherProfile.TriangleDensity;
            SimulationTime = otherProfile.SimulationTime;
            BaseStrength = otherProfile.BaseStrength;
            TimeStep = otherProfile.TimeStep;
            UvScale = otherProfile.UvScale;
            RestitutionCoeff = otherProfile.RestitutionCoeff;
            RestitutionAnglelerp = otherProfile.RestitutionAnglelerp;
            RaycastMask = otherProfile.RaycastMask;
            BlurVelocityStrength = otherProfile.BlurVelocityStrength;
            BlurVelocityIterations = otherProfile.BlurVelocityIterations;
            BlurVelocitySize = otherProfile.BlurVelocitySize;
            BlurPositionStrength = otherProfile.BlurPositionStrength;
            BlurPositionIterations = otherProfile.BlurPositionIterations;
            BlurPositionSize = otherProfile.BlurPositionSize;
            MaxWaterfallDistance = otherProfile.MaxWaterfallDistance;
            MinPointDistance = otherProfile.MinPointDistance;
            TerrainOffset = otherProfile.TerrainOffset;
            AlphaByDistance = otherProfile.AlphaByDistance;
            FloatSpeed = otherProfile.FloatSpeed;
            FloatSpeedWaterfallMultiplier = otherProfile.FloatSpeedWaterfallMultiplier;
            PhysicalDensity = otherProfile.PhysicalDensity;
            ClipUnderTerrain = otherProfile.ClipUnderTerrain;
            
            Offset = otherProfile.Offset;
            YOffset = otherProfile.YOffset;
            AngleOffset = otherProfile.AngleOffset;
            
        }

        public bool CheckProfileChange(WaterfallProfile otherProfile)
        {
            if (WaterfallMaterial != otherProfile.WaterfallMaterial)
                return true;
            if (TriangleDensity != otherProfile.TriangleDensity)
                return true;
            if (SimulationTime != otherProfile.SimulationTime)
                return true;
            if (BaseStrength != otherProfile.BaseStrength)
                return true;
            if (TimeStep != otherProfile.TimeStep)
                return true;
            if (UvScale != otherProfile.UvScale)
                return true;
            if (RestitutionCoeff != otherProfile.RestitutionCoeff)
                return true;
            if (RestitutionAnglelerp != otherProfile.RestitutionAnglelerp)
                return true;
            if (RaycastMask != otherProfile.RaycastMask)
                return true;
            if (BlurVelocityStrength != otherProfile.BlurVelocityStrength)
                return true;
            if (BlurVelocityIterations != otherProfile.BlurVelocityIterations)
                return true;
            if (BlurVelocitySize != otherProfile.BlurVelocitySize)
                return true;
            if (BlurPositionStrength != otherProfile.BlurPositionStrength)
                return true;
            if (BlurPositionIterations != otherProfile.BlurPositionIterations)
                return true;
            if (BlurPositionSize != otherProfile.BlurPositionSize)
                return true;
            
            if (MaxWaterfallDistance != otherProfile.MaxWaterfallDistance)
                return true;
            if (MinPointDistance != otherProfile.MinPointDistance)
                return true;
          
            if (FloatSpeed != otherProfile.FloatSpeed)
                return true;
            if (FloatSpeedWaterfallMultiplier != otherProfile.FloatSpeedWaterfallMultiplier)
                return true;
            if (PhysicalDensity != otherProfile.PhysicalDensity)
                return true;
            if (ClipUnderTerrain != otherProfile.ClipUnderTerrain)
                return true;
            
            if (Offset != otherProfile.Offset)
                return true;
            if (YOffset != otherProfile.YOffset)
                return true;
            if (AngleOffset != otherProfile.AngleOffset)
                return true;
            

            return false;
        }
    }
}