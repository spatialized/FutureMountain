using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

/// <summary>
/// Soil controller.
/// </summary>
public class SoilController : MonoBehaviour {
	private bool debug = true;

    /* Graphics */
    public Renderer frontSoilRend;         // Renderer for front soil plane
    public Material frontSoilMaterial;     // Soil material for front plane
    private Renderer sideRSoilRend;         // Renderer for (right) side plane
    private Material sideRSoilMaterial;		// Soil material for (right) side plane

    public List<Renderer> ssRenderers;
    public List<Material> ssMaterials;
    private List<Material> moistureMaterials;
    // Soil block top/bottom relative to the Soil object's transform (same geometry across CC cubes; tune here).
    private const float SoilTopOffset = 5f;
    private const float SoilBottomOffset = -15f;
    public List<Renderer> gwRenderers;
    public List<Material> gwMaterials;
    private List<float> gwHeights;

    /* Color */
    //private Vector4 gwWet = new Vector4(0.6f, 0.75f, 0.6f, 0.5f);           // H S V A
    //private Vector4 gwDry = new Vector4(1f, 0.3f, 0.2f, 1f);
    private Vector4 gwWet = new Vector4(0.6f, 0.85f, 0.75f, 0.5f);  // H S V A
    private Vector4 gwDry = new Vector4(0.1f, 0.3f, 0.33f, 1f);
    //private Vector4 gwDry = new Vector4(0.583f, 0.404f, 0.426f, 1f);

    private Color gwDryColor;             // Groundwater wet color
    private Color gwWetColor;             // Groundwater dry color

	/* Simulation Parameters */
	public float evaporation;				 // Soil moisture evaporation
	public float waterAccess;				 // Vegetation access to water in (surface) soil 
	public float depthToGW;					 // Depth to ground water
    public float soilProfileDepthMeters = 20f;  // Vertical metres the soil-profile mesh represents; maps depthToGW -> water-table height. Set to the profile's real depth (e.g. 12 for a 12 m cube).
	public float soilCarbon;				 // Soil carbon storage (Note: hardly changes in ex. cubes) (X)

	/* Visualization Settings */
    public float WaterAccessMin { get; set; }       // Low end of waterAccess data values (set from data)
    public float WaterAccessMax { get; set; }       // High end of waterAccess data values (set from data)

    public float DepthToGWMin { get; set; }         // Low end of depthToGW data values (set from data)
    public float DepthToGWMax { get; set; }         // High end of depthToGW data values (set from data)
    private float deepSoilTopYPos = 2f;             // Top end of deep soil 
    private float deepSoilBottomYPos = -8f;        // Bottom end of deep soil 
    public float maxDeepSoilShininess = 0.7f;      // Max. soil shininess
    public float minDeepSoilShininess = 0.0f;      // Min. soil shininess
 //   public float maxDeepSoilShininess = 0.95f;      // Max. soil shininess
 //   public float minDeepSoilShininess = 0.33f;      // Min. soil shininess
    public float maxShallowSoilShininess = 0.9f;    // Max. soil shininess
    public float minShallowSoilShininess = 0.33f;   // Min. soil shininess

    /// <summary>
    /// Start this instance.
    /// </summary>
	void Start () {
            Transform frontT = transform.Find("FrontPlane");                // Front cut face (may be deleted on som
            if (frontT != null)
            {
                    frontSoilRend = frontT.GetComponent<Renderer>();
                    if (frontSoilRend != null)
                            frontSoilMaterial = frontSoilRend.materials[0];
            }

            Transform sideT = transform.Find("SidePlaneR");                 // Right side face (may be absent)
            if (sideT != null)
            {
                    sideRSoilRend = sideT.GetComponent<Renderer>();
                    if (sideRSoilRend != null)
                            sideRSoilMaterial = sideRSoilRend.materials[0];
            }

        ssRenderers = new List<Renderer>();
        ssMaterials = new List<Material>();

        /* Initialize Surface Soil Objects */
        bool done = false;
        int idx = 1;

        // Collect every surface-soil mesh by name PREFIX. CC cubes name them "SurfaceSoil2_1" etc. (with a
        // suffix), so the old exact "SurfaceSoil"+idx lookup found nothing and never drove their material.
        foreach (Transform child in transform)
        {
            if (!child.name.StartsWith("SurfaceSoil")) continue;
            Renderer rend = child.GetComponent<Renderer>();
            if (rend == null) continue;
            ssRenderers.Add(rend);
            ssMaterials.Add(rend.materials[0]);
        }

        // Collect all soil-face meshes that carry the moisture shader (surface + deep + front/side),
        // excluding groundwater. Materials without the shader's properties just ignore the SetFloat calls.
        moistureMaterials = new List<Material>();
        foreach (Transform child in transform)
        {
            if (child.name.StartsWith("GroundWater")) continue;
            Renderer r = child.GetComponent<Renderer>();
            if (r != null) moistureMaterials.Add(r.materials[0]);
        }

        gwRenderers = new List<Renderer>();
        gwMaterials = new List<Material>();
        gwHeights = new List<float>();

        /* Initialize Groundwater Objects */
        done = false;
        idx = 1;
        while (!done)                                                  // Find all groundwater objects in cube soil
        {
            string gwName = "GroundWater" + idx;

            try
            {
                GameObject gw = transform.Find(gwName).gameObject;     // Surface soil mesh 1
                Renderer rend = gw.GetComponent<Renderer>();
                Material material = rend.materials[0];

                material.SetFloat("_Metallic", 0f);
                material.SetFloat("_Smoothness", 0.5f);

                gwRenderers.Add(rend);
                gwMaterials.Add(material);
                gwHeights.Add(gw.transform.localPosition.y);
                idx++;
            }
            catch (System.NullReferenceException e)
            {
                //Debug.Log(name + "  While loop ended... No gwName:" + gwName + " err:" + e);
                done = true;
            }
        }

        gwWetColor = Color.HSVToRGB(gwWet.x, gwWet.y, gwWet.z);
        gwWetColor.a = gwWet.w;
        gwDryColor = Color.HSVToRGB(gwDry.x, gwDry.y, gwDry.z);
        gwWetColor.a = gwDry.w;
    }

    /// <summary>
    /// Updates the simulation state.
    /// </summary>
    /// <param name="curTime">Current time.</param>
    /// <param name="curTimeStep">Current time step.</param>
    /// <param name="newWaterAccess">New water access.</param>
    /// <param name="newDepthToGW">New depth to gw.</param>
    // newRootDepthMeters: overstory rooting depth (m) for this cube/time. Drives the shader's _RootZoneDepth so
    // the moisture-patch band reaches exactly as deep as the roots. Pass < 0 to keep the material's authored value.
    public void UpdateSimulation(int curTime, int curTimeStep, float newWaterAccess, float newDepthToGW, float newRootDepthMeters = -1f)
	{
		waterAccess = newWaterAccess;
		depthToGW = newDepthToGW;

		float shallowSoilShininess;
		float deepSoilShininess;

		if (waterAccess < WaterAccessMax)
        {
			if(waterAccess > WaterAccessMin)
				shallowSoilShininess = MathUtil.MapValue(waterAccess, WaterAccessMin, WaterAccessMax, minShallowSoilShininess, maxShallowSoilShininess);
			else 
				shallowSoilShininess = minShallowSoilShininess;
		} 
        else 
        {
			shallowSoilShininess = maxShallowSoilShininess;
		}

		if (depthToGW < DepthToGWMax) 
        {
			if(depthToGW > DepthToGWMin)
				deepSoilShininess = MathUtil.MapValue(waterAccess, DepthToGWMin, DepthToGWMax, minDeepSoilShininess, maxDeepSoilShininess);
			else 
				deepSoilShininess = minDeepSoilShininess;
		}
        else 
        {
			deepSoilShininess = maxDeepSoilShininess;
		}

        //Debug.Log("SoilController.UpdateSimulation()... depthToGW:" + depthToGW+" deepSoilShininess:" + deepSoilShininess);
        //frontSoilMaterial.SetFloat("_Glossiness", deepSoilShininess);               // 0: driest    1: wettest 
        
        // deep-soil shininess kept for the front face if it still exists (FrontPlane may be deleted)
          if (frontSoilMaterial != null)
              frontSoilMaterial.SetFloat("_Metallic", deepSoilShininess);

          foreach (Material m in ssMaterials)
              m.SetFloat("_Glossiness", shallowSoilShininess);

          // ----- Central Coast soil-moisture shader -----
          // vegAccessWater -> top root-zone wetness (0..1)
          float moisture01 = (WaterAccessMax > WaterAccessMin)
              ? Mathf.Clamp01((waterAccess - WaterAccessMin) / (WaterAccessMax - WaterAccessMin))
              : 0.5f;

          // Water-table height = ABSOLUTE depth-to-groundwater mapped onto the soil profile, so it is physically
          // positioned (9.5 m in a 20 m profile = middle, not the surface) and still tracks the data. Per-cube
          // range-normalization was wrong here: it pushed 20803's barely-varying 9.4 m water table to the top.
            float waterLevel01 = Mathf.Clamp01(1f - depthToGW / Mathf.Max(soilProfileDepthMeters, 0.01f));

            // Root-zone depth as a fraction of the profile. The moisture patches in the shader are confined to
            // this upper band, so deeper roots => patches reach deeper. Clamped to a visible minimum.
            bool hasRootDepth = newRootDepthMeters > 0f;
            float rootZone01 = hasRootDepth
                ? Mathf.Clamp(newRootDepthMeters / Mathf.Max(soilProfileDepthMeters, 0.01f), 0.05f, 1f)
                : -1f;

            if (moistureMaterials != null)
            {
                foreach (Material m in moistureMaterials)
                {
                    m.SetFloat("_RootMoisture", moisture01);
                    m.SetFloat("_WaterLevel", waterLevel01);
                    if (hasRootDepth) m.SetFloat("_RootZoneDepth", rootZone01);
                }
            }
          

        UpdateGroundwater();                // Update groundwater objects' color
    }

    /// <summary>
    /// Updates the groundwater color.
    /// </summary>
    private void UpdateGroundwater()
    {
        int count = 0;
        foreach (Material m in gwMaterials)
        {
            float yPos = gwHeights[count];
            float gwPos = Mathf.Clamp(MathUtil.MapValue(depthToGW, DepthToGWMin, DepthToGWMax, 0f, 0.75f), 0f, 0.75f);      // Normalize groundwater depth level, leaving room for permannt groundwatr
            float objPos = 1f - Mathf.Clamp(MathUtil.MapValue(yPos, deepSoilBottomYPos, deepSoilTopYPos, 0f, 1f), 0f, 1f);      // Find normalized object y pos
            float diff = gwPos - objPos;        // Calculate difference
            //float diff = objPos - gwPos;        // Calculate difference

            if (diff >= 0)                      // If positive, then object is above groundwater level 
            {
                m.color = gwDryColor;           // Set to wet color
                m.SetFloat("_Metallic", 1f);
            }
            else if (diff < -0.2f)              // If negative, then object is below groundwater level 
            {
                m.color = gwWetColor;           // Set to dry color
                m.SetFloat("_Metallic", 0f);
            }
            else                                // If negative, fade object to wet as value decreases
            {
                float pos = Mathf.Clamp(MathUtil.MapValue(diff, -0.2f, 0f, 0f, 1f), 0f, 1f);
                m.color = Color.Lerp(gwWetColor, gwDryColor, pos);
                float metallicAmount = pos;
                m.SetFloat("_Metallic", metallicAmount);
            }
            count++;
        }
    }

    /// <summary>
    /// Set initial simulation values
    /// </summary>
    /// <param name="curTimeStep">Current time step.</param>
    /// <param name="newWaterAccess">New water access.</param>
    /// <param name="newDepthToGW">New depth to gw.</param>
    public void UpdateParams(int curTimeStep, float newWaterAccess, float newDepthToGW, float newRootDepthMeters = -1f)
	{
//		timeStepFreq = newTimeStepFreq;
		UpdateSimulation(-1, curTimeStep, newWaterAccess, newDepthToGW, newRootDepthMeters);
	}

    /// <summary>
    /// Sets the minimum max ranges.
    /// </summary>
    /// <param name="newMinWaterAccess">New minimum water access.</param>
    /// <param name="newMaxWaterAccess">New max water access.</param>
    /// <param name="newMinDepthToGW">New minimum depth to gw.</param>
    /// <param name="newMaxDepthToGW">New max depth to gw.</param>
    public void SetMinMaxRanges(float newMinWaterAccess, float newMaxWaterAccess, float newMinDepthToGW, float newMaxDepthToGW)
    {
        WaterAccessMin = newMinWaterAccess;         // Set Min. waterAccess 
        WaterAccessMax = newMaxWaterAccess;         // Set Max. waterAccess 

        DepthToGWMin = newMinDepthToGW;           // Set Min. depthToGW
        DepthToGWMax = newMaxDepthToGW;           // Set Max. depthToGW
    }

}
