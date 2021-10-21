using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

/// <summary>
/// Soil controller.
/// </summary>
public class SoilController : MonoBehaviour {
	private bool debug = true;

	/* Particle System */
	public bool showParticles = false;      // Particles visible
	public bool particlesEnabled = false;   // Particles enabled   
    private ParticleSystem evapParticles;   // Vapor particle system

	/* Graphics */
	private Renderer frontSoilRend;         // Renderer for front soil plane
    private Material frontSoilMaterial;     // Soil material for front plane
    private Renderer sideRSoilRend;         // Renderer for (right) side plane
    private Material sideRSoilMaterial;		// Soil material for (right) side plane

    private List<Renderer> ssRenderers;
    private List<Material> ssMaterials;
    private List<Renderer> gwRenderers;
    private List<Material> gwMaterials;
    private List<float> gwHeights;

    /* Color */
    private Vector4 gwWet = new Vector4(0.6f, 0.75f, 0.6f, 0.5f);           // H S V A
    private Vector4 gwDry = new Vector4(1f, 0.404f, 0.426f, 0.583f);
    //private Vector4 gwDry = new Vector4(0.583f, 0.404f, 0.426f, 1f);

    private Color gwDryColor;             // Groundwater wet color
    private Color gwWetColor;             // Groundwater dry color
	private float gwHue;
	private float gwSaturation;
	private float gwBrightness;
	private bool gwWetState = true;       // -- OBSOLETE     

	private float gwColorTransitionLength = 1f;
	private float gwColorTransitionStart;
	private bool gwColorTransition = false;

	/* Simulation Parameters */
	public float evaporation;				 // Soil moisture evaporation
	public float waterAccess;				 // Vegetation access to water in (surface) soil 
	public float depthToGW;					 // Depth to ground water
	public float soilCarbon;				 // Soil carbon storage (Note: hardly changes in ex. cubes) (X)

	/* Visualization Settings */
    public float WaterAccessMin { get; set; }       // Low end of waterAccess data values (set from data)
    public float WaterAccessMax { get; set; }       // High end of waterAccess data values (set from data)

    private float depthToGWDryThreshold;            // Level under which groundwater pockets "dry up" in visualization (set from data)  -- OBSOLETE
    public float depthToGWThresholdFactor = 0.33f;  //  Factor used to calculate threshold from depthToGW Min and Max Values    -- OBSOLETE
    public float DepthToGWMin { get; set; }         // Low end of depthToGW data values (set from data)
    public float DepthToGWMax { get; set; }         // High end of depthToGW data values (set from data)
    private float deepSoilTopYPos = 2f;             // Top end of deep soil 
    private float deepSoilBottomYPos = -15f;        // Bottom end of deep soil 
    public float maxDeepSoilShininess = 0.65f;      // Max. soil shininess
    public float minDeepSoilShininess = 0.0f;      // Min. soil shininess
 //   public float maxDeepSoilShininess = 0.95f;      // Max. soil shininess
 //   public float minDeepSoilShininess = 0.33f;      // Min. soil shininess
    public float maxShallowSoilShininess = 0.8f;    // Max. soil shininess
    public float minShallowSoilShininess = 0.33f;   // Min. soil shininess

    /// <summary>
    /// Start this instance.
    /// </summary>
	void Start () {
		/* Create particle systems */
//		evapParticles = gameObject.GetComponent<ParticleSystem>();		// -- TESTING   NOT WORKING

		GameObject front = transform.Find("FrontPlane").gameObject;		// Front side soil
		frontSoilRend = front.GetComponent<Renderer>();
        Assert.IsNotNull(frontSoilRend);

        frontSoilMaterial = frontSoilRend.materials[0];         
//		frontSoilMaterial.SetFloat("_Metallic", metallicAmount);    	// -- ADDED
//		GameObject sideL = transform.Find("SidePlaneL").gameObject;		// Left side soil (X)
//		sideLSoilRend = front.GetComponent<Renderer>();
//		sideLSoilMaterial = sideRSoilRend.materials[0];
		GameObject sideR = transform.Find("SidePlaneR").gameObject;		// Right side soil
		sideRSoilRend = front.GetComponent<Renderer>();
        Assert.IsNotNull(sideRSoilRend);

        sideRSoilMaterial = sideRSoilRend.materials[0];

//		GameObject back = transform.Find("BackPlane").gameObject;		// Back side soil (X)
//		backSoilRend = front.GetComponent<Renderer>();
//		backSoilMaterial = sideRSoilRend.materials[0];

        ssRenderers = new List<Renderer>();
        ssMaterials = new List<Material>();

        /* Initialize Surface Soil Objects */
        bool done = false;
        int idx = 1;
        while(!done)
        {
            string ssName = "SurfaceSoil" + idx;
            //Debug.Log(name + "  Will add ssName:" + ssName);

            try
            {
                GameObject ss = transform.Find(ssName).gameObject;     // Surface soil mesh 1
                Renderer rend = ss.GetComponent<Renderer>();
                Material material = rend.materials[0];
                
                ssRenderers.Add(rend);
                ssMaterials.Add(material);
                idx++;
            }
            catch(System.NullReferenceException e)
            {
                //Debug.Log(name+"  While loop ended... No ssName:" + ssName+" err:"+e);
                done = true;
            }
        }

        gwRenderers = new List<Renderer>();
        gwMaterials = new List<Material>();
        gwHeights = new List<float>();

        /* Initialize Groundwater Objects */
        done = false;
        idx = 1;
        while (!done)
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
    public void UpdateSimulation(int curTime, int curTimeStep, float newWaterAccess, float newDepthToGW)
	{
		waterAccess = newWaterAccess;				
		depthToGW = newDepthToGW;

		float shallowSoilShininess;
		float deepSoilShininess;

		if (waterAccess < WaterAccessMax)
        {
			if(waterAccess > WaterAccessMin)
				shallowSoilShininess = MapValue (waterAccess, WaterAccessMin, WaterAccessMax, minShallowSoilShininess, maxShallowSoilShininess);
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
				deepSoilShininess = MapValue (waterAccess, DepthToGWMin, DepthToGWMax, minDeepSoilShininess, maxDeepSoilShininess);
			else 
				deepSoilShininess = minDeepSoilShininess;
		}
        else 
        {
			deepSoilShininess = maxDeepSoilShininess;
		}

        //Debug.Log("SoilController.UpdateSimulation()... depthToGW:" + depthToGW+" deepSoilShininess:" + deepSoilShininess);
        //frontSoilMaterial.SetFloat("_Glossiness", deepSoilShininess);               // 0: driest    1: wettest 
        frontSoilMaterial.SetFloat("_Metallic", deepSoilShininess);               // 0: driest    1: wettest 
                                                                                    //frontSoilMaterial.SetFloat("_Metallic", deepSoilShininess);         
                                                                                    //sideRSoilMaterial.SetFloat ("_Shininess", deepSoilShininess);

        foreach (Material m in ssMaterials)
        {
            m.SetFloat("_Glossiness", shallowSoilShininess);                    // 0: driest    1: wettest 
        }
        //foreach (Material m in ssMaterials)
        //{
        //    m.SetFloat("_Metallic", shallowSoilShininess);                    // 0: driest    1: wettest 
        //}

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
            float gwPos = 1f - Mathf.Clamp(MapValue(depthToGW, DepthToGWMin, DepthToGWMax, 0f, 1f), 0f, 1f);      // Normalize groundwater depth level and flip to find g.w. height
            float objPos = Mathf.Clamp(MapValue(yPos, deepSoilBottomYPos, deepSoilTopYPos, 0f, 1f), 0f, 1f);      // Find normalized object y pos
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
                float pos = Mathf.Clamp(MapValue(diff, -0.2f, 0f, 0f, 1f), 0f, 1f);
                m.color = Color.Lerp(gwWetColor, gwDryColor, pos);
                float metallicAmount = pos;
                m.SetFloat("_Metallic", metallicAmount);
            }
            count++;
        }
    }

    /// <summary>
    /// Updates the GWC olor transition.
    /// </summary>
    private void UpdateGWColorTransition()
    {
        float t = Time.time - gwColorTransitionStart;

        if (debug) 
            Debug.Log(gameObject.name + " SoilController.UpdateGWColorTransition()..." + " gwColorTransitionLength: " + gwColorTransitionLength + " t: " + t + " waterAccess: " + waterAccess + " depthToGW:" + depthToGW);

        if (!gwWetState)
        {                                     // Moving from wet to dry
            if (t < gwColorTransitionLength)
            {
                foreach (Material m in gwMaterials)
                {
                    m.color = Color.Lerp(gwDryColor, gwWetColor, t);
                }
            }
            else
            {
                foreach (Material m in gwMaterials)
                {
                    m.color = gwWetColor;
                }

                gwWetState = true;
                gwColorTransition = false;
            }
        }
        else
        {                                           // Moving from dry to wet 
            if (t < gwColorTransitionLength)
            {
                foreach (Material m in gwMaterials)
                {
                    m.color = Color.Lerp(gwWetColor, gwDryColor, t);
                }
            }
            else
            {
                foreach (Material m in gwMaterials)
                {
                    if(debug) Debug.Log(">>   gwColorTransition dry to wet finished... m.color? " + m.color);

                    m.color = gwDryColor;
                }
                gwWetState = false;
                gwColorTransition = false;
            }
        }
    }

    /// <summary>
    /// Set initial simulation values
    /// </summary>
    /// <param name="curTimeStep">Current time step.</param>
    /// <param name="newWaterAccess">New water access.</param>
    /// <param name="newDepthToGW">New depth to gw.</param>
    public void UpdateParams(int curTimeStep, float newWaterAccess, float newDepthToGW)
	{
//		timeStepFreq = newTimeStepFreq;
		UpdateSimulation(-1, curTimeStep, newWaterAccess, newDepthToGW);
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
        depthToGWDryThreshold = (DepthToGWMax - DepthToGWMin) * depthToGWThresholdFactor + DepthToGWMin;             // Level under which groundwater pockets "dry up" in visualization  
    }

    /// <summary>
    /// Maps value from one range to another.
    /// </summary>
    /// <returns>The value.</returns>
    /// <param name="value">Value.</param>
    /// <param name="from1">From1.</param>
    /// <param name="to1">To1.</param>
    /// <param name="from2">From2.</param>
    /// <param name="to2">To2.</param>
	public static float MapValue (float value, float from1, float to1, float from2, float to2) {
		return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
	}
}
