using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [CreateAssetMenu(fileName = "FenceProfile", menuName = "NatureManufacture/FenceProfile", order = 1)]
    public class FenceProfile : ScriptableObject, IProfile<FenceProfile>
    {
        public enum LengthTypeEnum
        {
            Spline,
            Mesh
        }

        [HideInInspector] [SerializeField] private GameObject gameObject;

        [SerializeField] private float triangleDensity = 8f;
        [SerializeField] private float distanceMultiplier = 1;
        [SerializeField] private float additionalDistance;


        [SerializeField] private bool bendMeshes;

        [SerializeField] private bool normalFromTerrain = false;
        [SerializeField] private float normalFromTerrainNormalTolerance = 30;
        [SerializeField] private AnimationCurve normalFromTerrainCurve = AnimationCurve.Linear(0, 0.8f, 0.4f, 0);


        [SerializeField] private FenceObjectProbability firstSpan = new();
        [SerializeField] private FenceObjectProbability lastSpan = new();

        [SerializeField] private List<FenceObjectProbability> posts = new();


        [SerializeField] private int postRandomType;

        [SerializeField] private List<FenceObjectProbability> spans = new();
        [SerializeField] private int spanRandomType;

        [SerializeField] private LengthTypeEnum lengthType = LengthTypeEnum.Spline;

        [SerializeField] private bool scaleMesh = true;
        [SerializeField] private bool scaleMeshUnified = true;
        [SerializeField] private bool holdUp;
        [SerializeField] private bool randomSeed = true;
        [SerializeField] private int seed;

        [SerializeField] private Vector3 offset;
        
        
        [SerializeField] private LayerMask raycastMask = ~0;
        
        
        public enum BendNormalCalculationTypeEnum
        {
          Default,
          Unity,
          None
        }
        
        [SerializeField] private BendNormalCalculationTypeEnum bendNormalCalculationType = BendNormalCalculationTypeEnum.Default;
        [SerializeField] private float bendSmoothingAngle = 90;
        [SerializeField] private bool bendWeldVertices = true;
      


        public float TriangleDensity
        {
            get => triangleDensity;
            set => triangleDensity = value;
        }

        public float DistanceMultiplier
        {
            get => distanceMultiplier;
            set => distanceMultiplier = value;
        }

        public float AdditionalDistance
        {
            get => additionalDistance;
            set => additionalDistance = value;
        }

        public bool BendMeshes
        {
            get => bendMeshes;
            set => bendMeshes = value;
        }

        public List<FenceObjectProbability> Posts
        {
            get => posts;
            set => posts = value;
        }

        public int PostRandomType
        {
            get => postRandomType;
            set => postRandomType = value;
        }

        public List<FenceObjectProbability> Spans
        {
            get => spans;
            set => spans = value;
        }

        public int SpanRandomType
        {
            get => spanRandomType;
            set => spanRandomType = value;
        }


        public bool ScaleMesh
        {
            get => scaleMesh;
            set => scaleMesh = value;
        }

        public bool HoldUp
        {
            get => holdUp;
            set => holdUp = value;
        }

        public GameObject GameObject
        {
            get => gameObject;
            set => gameObject = value;
        }

        public int Seed
        {
            get => seed;
            set => seed = value;
        }

        public bool RandomSeed
        {
            get => randomSeed;
            set => randomSeed = value;
        }

        public FenceObjectProbability FirstSpan
        {
            get => firstSpan;
            set => firstSpan = value;
        }

        public FenceObjectProbability LastSpan
        {
            get => lastSpan;
            set => lastSpan = value;
        }

        public bool ScaleMeshUnified
        {
            get => scaleMeshUnified;
            set => scaleMeshUnified = value;
        }

        public LengthTypeEnum LengthType
        {
            get => lengthType;
            set => lengthType = value;
        }

        public Vector3 Offset
        {
            get => offset;
            set => offset = value;
        }

        public bool NormalFromTerrain
        {
            get => normalFromTerrain;
            set => normalFromTerrain = value;
        }



        public float NormalFromTerrainNormalTolerance
        {
            get => normalFromTerrainNormalTolerance;
            set => normalFromTerrainNormalTolerance = value;
        }

        public AnimationCurve NormalFromTerrainCurve
        {
            get => normalFromTerrainCurve;
            set => normalFromTerrainCurve = value;
        }

        public LayerMask RaycastMask
        {
            get => raycastMask;
            set => raycastMask = value;
        }

        public BendNormalCalculationTypeEnum BendNormalCalculationType
        {
            get => bendNormalCalculationType;
            set => bendNormalCalculationType = value;
        }

        public float BendSmoothingAngle
        {
            get => bendSmoothingAngle;
            set => bendSmoothingAngle = value;
        }

        public bool BendWeldVertices
        {
            get => bendWeldVertices;
            set => bendWeldVertices = value;
        }

        public void SetProfileData(FenceProfile otherProfile)
        {
            triangleDensity = otherProfile.triangleDensity;
            distanceMultiplier = otherProfile.distanceMultiplier;
            additionalDistance = otherProfile.additionalDistance;
            bendMeshes = otherProfile.bendMeshes;
            normalFromTerrain = otherProfile.normalFromTerrain;
            normalFromTerrainNormalTolerance = otherProfile.normalFromTerrainNormalTolerance;
            normalFromTerrainCurve = otherProfile.normalFromTerrainCurve;
            postRandomType = otherProfile.postRandomType;
            spanRandomType = otherProfile.spanRandomType;
            lengthType = otherProfile.lengthType;
            scaleMesh = otherProfile.scaleMesh;
            scaleMeshUnified = otherProfile.scaleMeshUnified;
            holdUp = otherProfile.holdUp;
            seed = otherProfile.seed;
            randomSeed = otherProfile.randomSeed;
            offset = otherProfile.offset;

            firstSpan = new FenceObjectProbability(otherProfile.firstSpan);
            lastSpan = new FenceObjectProbability(otherProfile.lastSpan);

            posts.Clear();
            spans.Clear();

            foreach (var post in otherProfile.posts)
            {
                posts.Add(new FenceObjectProbability(post));
            }

            foreach (var span in otherProfile.spans)
            {
                spans.Add(new FenceObjectProbability(span));
            }
            
            raycastMask = otherProfile.raycastMask;
            
            bendNormalCalculationType = otherProfile.bendNormalCalculationType;
            bendSmoothingAngle = otherProfile.bendSmoothingAngle;
            bendWeldVertices = otherProfile.bendWeldVertices;
            
            
        }

        public bool CheckProfileChange(FenceProfile otherProfile)
        {
            if (triangleDensity != otherProfile.triangleDensity)
            {
                return true;
            }

            if (distanceMultiplier != otherProfile.distanceMultiplier)
            {
                return true;
            }

            if (additionalDistance != otherProfile.additionalDistance)
            {
                return true;
            }

            if (bendMeshes != otherProfile.bendMeshes)
            {
                return true;
            }

            if (normalFromTerrain != otherProfile.normalFromTerrain)
            {
                return true;
            }

  

            if (normalFromTerrainNormalTolerance != otherProfile.normalFromTerrainNormalTolerance)
            {
                return true;
            }


            if (postRandomType != otherProfile.postRandomType)
            {
                return true;
            }


            if (spanRandomType != otherProfile.spanRandomType)
            {
                return true;
            }

            if (lengthType != otherProfile.lengthType)
            {
                return true;
            }

            if (scaleMesh != otherProfile.scaleMesh)
            {
                return true;
            }

            if (scaleMeshUnified != otherProfile.scaleMeshUnified)
            {
                return true;
            }

            if (holdUp != otherProfile.holdUp)
            {
                return true;
            }

            if (seed != otherProfile.seed)
            {
                return true;
            }

            if (randomSeed != otherProfile.randomSeed)
            {
                return true;
            }

            if (offset != otherProfile.offset)
            {
                return true;
            }

            if (firstSpan.gameObject != otherProfile.firstSpan.gameObject)
            {
                return true;
            }

            if (lastSpan.gameObject != otherProfile.lastSpan.gameObject)
            {
                return true;
            }
            
            if (raycastMask != otherProfile.raycastMask)
            {
                return true;
            }
            
            if (bendNormalCalculationType != otherProfile.bendNormalCalculationType)
            {
                return true;
            }
            
            if (bendSmoothingAngle != otherProfile.bendSmoothingAngle)
            {
                return true;
            }
            
            if (bendWeldVertices != otherProfile.bendWeldVertices)
            {
                return true;
            }
            


            return false;
        }
    }
}