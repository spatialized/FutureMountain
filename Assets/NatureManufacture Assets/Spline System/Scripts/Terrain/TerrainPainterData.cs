// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [CreateAssetMenu(fileName = "TerrainPainterData", menuName = "NatureManufacture/TerrainPainterData", order = 1)]
    public class TerrainPainterData : ScriptableObject, IProfile<TerrainPainterData>
    {
        public enum TerrainCarveQualityEnum
        {
            VeryLow = 256,
            Low = 512,
            Medium = 1024,
            High = 2048,
            VeryHigh = 4096
        }

        public enum CameraViewEnum
        {
            Top,
            Bottom,
        }


        [Tooltip("Select the quality level for the terrain carving: VeryLow (256), Low (512), Medium (1024), High (2048), VeryHigh (4096)")] [SerializeField]
        private TerrainCarveQualityEnum terrainCarveQuality = TerrainCarveQualityEnum.Medium;
        //[SerializeField] private CameraViewEnum cameraView = CameraViewEnum.Top;

        [SerializeField] private int toolbarInt = 0;


        [HideInInspector, SerializeField] private List<Terrain> terrainsUnder;
        [HideInInspector, SerializeField] private int currentWorkTerrain;
        
        [SerializeField] private float brushAdditionalSize;
        
        

        [SerializeField] private AnimationCurve terrainCarve;
        [Range(0.001f, 4f)] [SerializeField] private float smooth;
        
        [SerializeField] private AnimationCurve terrainCarveStamp;
        [Range(0.001f, 4f)] [SerializeField] private float smoothStamp;
        [SerializeField] private Texture2D stampTexture;

        
        

        [SerializeField] private List<TerrainNoiseParameters> terrainNoiseParametersListCarve;


        [SerializeField] private float distanceClearFoliage;
        [SerializeField] private float distanceClearFoliageTrees;


        public List<TerrainNoiseParameters> TerrainNoiseParametersListCarve
        {
            get => terrainNoiseParametersListCarve;
            set => terrainNoiseParametersListCarve = value;
        }

        [SerializeField] private List<TerrainLayerData> terrainLayersData;

        public List<TerrainLayerData> TerrainLayersData
        {
            get => terrainLayersData;
            set => terrainLayersData = value;
        }

        public int ToolbarInt
        {
            get => toolbarInt;
            set => toolbarInt = value;
        }

        public static string[] ToolbarStrings { get; set; } = new string[]
        {
            "Carve",
            "Stamp",
            "Paint",
            "Manage Foliage"
        };

        public float Smooth
        {
            get => smooth;
            set => smooth = value;
        }

        public AnimationCurve TerrainCarve
        {
            get => terrainCarve;
            set => terrainCarve = value;
        }

        public float DistanceClearFoliage
        {
            get => distanceClearFoliage;
            set => distanceClearFoliage = value;
        }

        public float DistanceClearFoliageTrees
        {
            get => distanceClearFoliageTrees;
            set => distanceClearFoliageTrees = value;
        }

        public float BrushAdditionalSize
        {
            get => brushAdditionalSize;
            set => brushAdditionalSize = value;
        }

        public Terrain WorkTerrain
        {
            get
            {
                TerrainsUnder.RemoveAll(item => item == null);
                return TerrainsUnder.Count <= CurrentWorkTerrain ? null : TerrainsUnder[CurrentWorkTerrain];
            }
        }

        public List<Terrain> TerrainsUnder
        {
            get => terrainsUnder;
            set => terrainsUnder = value;
        }

        public int CurrentWorkTerrain
        {
            get => currentWorkTerrain;
            set => currentWorkTerrain = value;
        }

        public TerrainCarveQualityEnum TerrainCarveQuality
        {
            get => terrainCarveQuality;
            set => terrainCarveQuality = value;
        }

        public AnimationCurve TerrainCarveStamp
        {
            get => terrainCarveStamp;
            set => terrainCarveStamp = value;
        }

        public float SmoothStamp
        {
            get => smoothStamp;
            set => smoothStamp = value;
        }

        public Texture2D StampTexture
        {
            get => stampTexture;
            set => stampTexture = value;
        }

        /*  public CameraViewEnum CameraView
          {
              get => cameraView;
              set => cameraView = value;
          }*/

        //constructor with default values for new TerrainPainterData
        public TerrainPainterData()
        {
            terrainCarveQuality = TerrainCarveQualityEnum.Medium;
            //  cameraView = CameraViewEnum.Top;
            toolbarInt = 0;


            terrainsUnder = new List<Terrain>();
            currentWorkTerrain = 0;
            terrainCarve = new AnimationCurve(new Keyframe(0, 0), new Keyframe(10, -2));
            smooth = 1;
            terrainCarveStamp = new AnimationCurve(new Keyframe(0, 1), new Keyframe(10, 1));
            smoothStamp = 1;
            
            brushAdditionalSize = 20;
            terrainNoiseParametersListCarve = new List<TerrainNoiseParameters>();
            distanceClearFoliage = 1;
            distanceClearFoliageTrees = 1;
            terrainLayersData = new List<TerrainLayerData>() { new() };
        }

        public void SetProfileData(TerrainPainterData otherProfile)
        {
            TerrainCarveQuality = otherProfile.TerrainCarveQuality;
            //  CameraView = otherProfile.CameraView;
            toolbarInt = otherProfile.toolbarInt;

            //copy keyframes from other animation curve
            terrainCarve = new AnimationCurve
            {
                keys = otherProfile.terrainCarve.keys
            };
            
         

            smooth = otherProfile.smooth;
            
            terrainCarveStamp = new AnimationCurve
            {
                keys = otherProfile.terrainCarveStamp.keys
            };
            smoothStamp = otherProfile.smoothStamp;
            
            stampTexture = otherProfile.stampTexture;
            
            brushAdditionalSize = otherProfile.brushAdditionalSize;

            terrainNoiseParametersListCarve = new List<TerrainNoiseParameters>(otherProfile.terrainNoiseParametersListCarve);

            distanceClearFoliage = otherProfile.distanceClearFoliage;
            distanceClearFoliageTrees = otherProfile.distanceClearFoliageTrees;


            terrainLayersData = otherProfile.terrainLayersData;

            //copy each layer in loop with copy constructor
            terrainLayersData = new List<TerrainLayerData>();
            foreach (var layer in otherProfile.terrainLayersData)
            {
                terrainLayersData.Add(new TerrainLayerData(layer));
            }
        }

        public bool CheckProfileChange(TerrainPainterData otherProfile)
        {
            if (otherProfile == null)
                return false;

            if (TerrainCarveQuality != otherProfile.TerrainCarveQuality)
            {
                return true;
            }

            /*  if (CameraView != otherProfile.CameraView)
              {
                  return true;
              }*/

            for (int i = 0; i < terrainCarve.keys.Length; i++)
            {
                if (terrainCarve.keys[i].time == otherProfile.terrainCarve.keys[i].time &&
                    terrainCarve.keys[i].value == otherProfile.terrainCarve.keys[i].value) continue;

                return true;
            }


            if (smooth != otherProfile.smooth)
            {
                return true;
            }
            
            for (int i = 0; i < terrainCarveStamp.keys.Length; i++)
            {
                if (terrainCarveStamp.keys[i].time == otherProfile.terrainCarveStamp.keys[i].time &&
                    terrainCarveStamp.keys[i].value == otherProfile.terrainCarveStamp.keys[i].value) continue;

                return true;
            }
            
            if (smoothStamp != otherProfile.smoothStamp)
            {
                return true;
            }
            
            if (stampTexture != otherProfile.stampTexture)
            {
                return true;
            }
            

            if (brushAdditionalSize != otherProfile.brushAdditionalSize)
            {
                return true;
            }

            //check if terrain noise parameters fields are the same
            if (terrainNoiseParametersListCarve.Count != otherProfile.terrainNoiseParametersListCarve.Count)
            {
                return true;
            }

            for (int i = 0; i < terrainNoiseParametersListCarve.Count; i++)
                if (terrainNoiseParametersListCarve[i].CheckProfileChange(otherProfile.terrainNoiseParametersListCarve[i]))
                {
                    return true;
                }


            if (distanceClearFoliage != otherProfile.distanceClearFoliage)
            {
                return true;
            }

            if (distanceClearFoliageTrees != otherProfile.distanceClearFoliageTrees)
            {
                return true;
            }

            //for each layer check if it has changed
            for (int i = 0; i < terrainLayersData.Count; i++)
            {
                if (terrainLayersData.Count != otherProfile.terrainLayersData.Count || terrainLayersData[i] == null || otherProfile.terrainLayersData[i] == null) continue;
                if (terrainLayersData[i].CheckProfileChange(otherProfile.terrainLayersData[i]))
                {
                    return true;
                }
            }

            return false;
        }

        public void AddTerrain(Terrain terrain)
        {
            TerrainsUnder ??= new List<Terrain>();

            TerrainsUnder.RemoveAll(item => item == null);

            if (terrain != null && !TerrainsUnder.Contains(terrain))
            {
                TerrainsUnder.Add(terrain);
            }
        }
    }
}