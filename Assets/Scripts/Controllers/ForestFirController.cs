using System.Collections;
using System.Collections.Generic;
using UnityEngine.Assertions;
using UnityEngine;
using System;

/// <summary>
/// Fir controller.
/// </summary>
public class ForestFirController : MonoBehaviour {
    /* General */
    public int patchID;

    /* Position */
    private static float prefabHeight = 5f;

    /* Tree Components */
    private GameObject lod0, lod1, lod2, lod3, lod4;
    //private GameObject roots;

    /* Time */
    private float growthStartTime, deathStartTime;

    /* Growth Animation */
    private float growthSpeed = 0.075f;
    private float deathSpeed = 0.5f;
    //private float growAnimLength = 5.0f;  // -- Obsolete

    /* Simulation States */
    private bool alive = true;
    private bool growing = false;
    private bool dying = false;

    /* Simulation Parameters */
    public int timeStep;
    private float timeStepGrowthSpeedFactor = 1f / 7f;
    //public float leafCarbon;                // Leaf carbon amount
    //public float stemCarbon;                  // Stem carbon amount -- Affect tree height
    //public float rootCarbon;                // Root carbon amount
    //public float transpiration;             // Moisture evaporated from leaves

    /* Visualization Settings */
    //private float particleEmissionFactor = 2f;    // Scaling from ET value to particle emission rate

    //private float vegetationCarbonFactor = 0.66f;  // Scaling of tree/bush heights to vegetation amount (to compare with stem+leaf carbon in data)
    //private float rootsCarbonFactor = 0.0133f;    // Scaling of root height to roots amount to compare with root carbon in data

    //private float maxStemCarbon;           // Max stem carbon amount in cube data 
    //private float minStemCarbon;           // Max stem carbon amount in cube data
    //private float maxLeafCarbon;           // Max leaf carbon amount in cube data
    //private float minLeafCarbon;           // Max leaf carbon amount in cube data
    //private float maxRootCarbon;           // Max root carbon amount in cube data
    //private float minRootCarbon;           // Max root carbon amount in cube data
    //private float maxSoilCarbon;           // Max soil carbon amount in cube data        -- Unused
    //private float minSoilCarbon;           // Max soil carbon amount in cube data        -- Unused
    //private float maxTranspiration;        // Max transpiration amount in cube data
    //private float minTranspiration;        // Min transpiration amount in cube data

    /* Visualization Parameters */
    public float sizeFactor;                // Tree size
    //public float alphaCutoff;               // Leaf shader alpha cutoff (Used for visualizing leaf carbon)

    /* Particle System */
    //private ParticleSystem etParticles;
    //public bool showParticles;
    //public bool particlesEnabled;

    /* Root Structure */
    //private GameObject rootStructure;

    /* State */
    //private bool alive = true;
    //private bool growing = false;
    //private bool dying = false;

    //private bool showRoots = true;      // -- To do
   
    /* Materials */
    //public Renderer lod0Rend;
    //public Material lod0LeafMaterial;       // Leaf material for LOD 0
    //public Renderer lod1Rend;
    //public Material lod1LeafMaterial;       // Leaf material for LOD 1
    //public Renderer lod2Rend;
    //public Material lod2LeafMaterial;       // Leaf material for LOD 2
    //public Renderer lod3Rend;
    //public Material lod3LeafMaterial;       // Leaf material for LOD 3
    //public Renderer lod4Rend;
    //public Material lod4LeafMaterial;       // Leaf material for LOD 4

    /// <summary>
    /// Initialize the fir.
    /// </summary>
    //void Start () 
    public void InitializeFir() 
    {
        //showParticles = false;
        //particlesEnabled = false;

        //if(transform.parent.name == "LargeTerrain")
        sizeFactor = UnityEngine.Random.Range (0.2f, 0.25f);

        //GameObject evapTrans = transform.Find("EvapTrans").gameObject;
        //etParticles = evapTrans.GetComponent<ParticleSystem>(); 

        //if (!showParticles) {
        //    etParticles.Stop ();
        //    var emission = etParticles.emission;
        //    emission.rateOverTime = 0;
        //    particlesEnabled = false;
        //}

        //rootStructure = transform.Find("RootStructure").gameObject;

        lod0 = transform.Find("Fir_07_Forest_LOD0").gameObject;
        lod1 = transform.Find("Fir_07_Forest_LOD1").gameObject;
        lod2 = transform.Find("Fir_07_Forest_LOD2").gameObject;
        lod3 = transform.Find("Fir_07_Forest_LOD3").gameObject;
        lod4 = transform.Find("Fir_07_Forest_LOD4").gameObject;

        Assert.IsNotNull(lod0);
        Assert.IsNotNull(lod1);
        Assert.IsNotNull(lod2);
        Assert.IsNotNull(lod3);
        Assert.IsNotNull(lod4);

        //roots = transform.Find("RootStructure").gameObject;

        //showParticles = true;
    }

    /// <summary>
    /// Update growth, death and emission
    /// </summary>
    void Update () 
    {
        if (dying)
            UpdateDying();
        else if(growing)
            UpdateGrowing();
    }

    /// <summary>
    /// Starts growing tree.
    /// </summary>
    public void Grow(bool immediate)
    {
        alive = true;
        dying = false;

        if(immediate)
        {
            growing = false;
            transform.localScale = Vector3.one * sizeFactor;

            lod0.transform.localScale = Vector3.one;
            lod1.transform.localScale = Vector3.one;
            lod2.transform.localScale = Vector3.one;
            lod3.transform.localScale = Vector3.one;
            lod4.transform.localScale = Vector3.one;
            //roots.transform.localScale = Vector3.one;
        }
        else
        {
            growthStartTime = Time.time;
            growing = true;

            transform.localScale = Vector3.one * sizeFactor;

            lod0.transform.localScale = Vector3.zero;
            lod1.transform.localScale = Vector3.zero;
            lod2.transform.localScale = Vector3.zero;
            lod3.transform.localScale = Vector3.zero;
            lod4.transform.localScale = Vector3.zero;
            //roots.transform.localScale = Vector3.zero;
        }
    }

    /// <summary>
    /// Kill tree.
    /// </summary>
    public void Kill(bool immediate)
    {
        if (immediate)
        {
            alive = false;
            dying = false;
            if (growing)
                growing = false;
            transform.localScale = Vector3.zero;
            //StopParticles();
        }
        else
        {
            dying = true;
            deathStartTime = Time.time;
            if (growing)
                growing = false;
        }
    }

    /// <summary>
    /// Updates tree growth.                // -- Grow tree and roots separately (roots keep growing?)
    /// </summary>
    private void UpdateGrowing()
    {
        float dist = (Time.time - growthStartTime) * growthSpeed;

        if (dist < 1.0f)
        {
            //transform.localScale = Vector3.Lerp(Vector3.zero, Vector3.one * sizeFactor, dist);
            lod0.transform.localScale = Vector3.Lerp(Vector3.zero, Vector3.one, dist);
            lod1.transform.localScale = Vector3.Lerp(Vector3.zero, Vector3.one, dist);
            lod2.transform.localScale = Vector3.Lerp(Vector3.zero, Vector3.one, dist);
            lod3.transform.localScale = Vector3.Lerp(Vector3.zero, Vector3.one, dist);
            lod4.transform.localScale = Vector3.Lerp(Vector3.zero, Vector3.one, dist);
            //roots.transform.localScale = Vector3.Lerp(Vector3.zero, Vector3.one, dist);

            //if (!showParticles && dist >= 0.33f)
                //ShowParticles();
        }
        else
        {
            //transform.localScale = Vector3.one * sizeFactor;
            lod0.transform.localScale = Vector3.one;
            lod1.transform.localScale = Vector3.one;
            lod2.transform.localScale = Vector3.one;
            lod3.transform.localScale = Vector3.one;
            lod4.transform.localScale = Vector3.one;
            //roots.transform.localScale = Vector3.one;

            growing = false;            
        }
    }

    /// <summary>
    /// Updates dying animation.              // -- Need to update so tree falls to ground
    /// </summary>
    private void UpdateDying()
    {
        //Debug.Log("UpdateDying() tree:" + name);
        float dist = (Time.time - deathStartTime) * deathSpeed;

        if(dist < 1.0f)
        {
            transform.localScale = Vector3.Lerp(Vector3.one * sizeFactor, Vector3.zero, dist);
        }
        else
        {
            transform.localScale = Vector3.zero;
            dying = false;
            alive = false;
            //StopParticles();
        }
    }

    /// <summary>
    /// Sets the emission rate.
    /// </summary>
    /// <param name="newEmissionRate">New emission rate.</param>
    //private void SetEmissionRate(float newEmissionRate)
    //{
    //    //float emissionRate = newEmissionRate;
    //    var emission = etParticles.emission;
    //    emission.rateOverTime = (int)newEmissionRate;
    //}

    /// <summary>
    /// Update simulation state
    /// </summary>
    /// <param name="curTime">Current time.</param>
    /// <param name="curTimeStep">Current time step.</param>
    /// <param name="newTranspiration">New transpiration.</param>
    /// <param name="newLeafCarbon">New leaf carbon.</param>
    /// <param name="newStemCarbon">New stem carbon.</param>
    //public void UpdateSimulation(int curTime, int curTimeStep, float newTranspiration, float newLeafCarbon, float newStemCarbon, float newRootCarbon)
    //{
        //timeStep = curTimeStep;
        //leafCarbon = newLeafCarbon;
        //stemCarbon = newLeafCarbon;
        //transpiration = newTranspiration;                   // -- Randomize between trees?

        //if (leafCarbon < maxLeafCarbon)
        //    alphaCutoff = 1f - MapValue (leafCarbon, 0f, maxLeafCarbon, 0f, 0.6f);
        //else
        //    alphaCutoff = 0.1f;

        ////lod4LeafMaterial.SetFloat("_Cutoff", alphaCutoff);

        //if(showParticles)
        //    SetEmissionRate(transpiration * particleEmissionFactor);

        //if (showParticles && !particlesEnabled)
        //{
        //    SetEmissionRate(transpiration * particleEmissionFactor);
        //    etParticles.Play();
        //    particlesEnabled = true;
        //}

        //if (!showParticles && particlesEnabled)
        //{
        //    etParticles.Stop();
        //    SetEmissionRate(0);
        //    particlesEnabled = false;
        //}
    //}

    /// <summary>
    /// Shows the particles.
    /// </summary>
    //private void ShowParticles()
    //{
    //    SetEmissionRate(transpiration * particleEmissionFactor);
    //    etParticles.Play();
    //    showParticles = true;
    //}

    /// <summary>
    /// Hides the particles.
    /// </summary>
    //private void StopParticles()
    //{
    //    etParticles.Stop();
    //    SetEmissionRate(0);
    //    showParticles = false;
    //}

    /// <summary>
    /// Set initial simulation values
    /// </summary>
    /// <param name="curTimeStep">Current time step.</param>
    /// <param name="terrain">Landscape terrain.</param>
    //public void UpdateParams(int curTimeStep, Terrain cubeTerrain, float newTranspiration, float newLeafCarbon, float newStemCarbon, float newRootCarbon)
    public void InitParams(int curTimeStep, Terrain terrain, float newTranspiration)          // -- TO DO
    {
        var xPos = transform.localPosition.x;                                                       
        var yPos = terrain.SampleHeight(transform.position) + sizeFactor * prefabHeight;        // Place tree at terrain height
        var zPos = transform.localPosition.z;

        transform.localPosition = new Vector3 (xPos, yPos, zPos);
        transform.localScale = Vector3.one * sizeFactor;         

        //UpdateSimulation(-1, curTimeStep, newTranspiration, newLeafCarbon, newStemCarbon, newRootCarbon);
    }

    /// <summary>
    /// Gets the vegetation amount for this tree.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    //public float GetVegetationAmount()
    //{
    //    float vegetationAmount = 0f;
    //    if(!alive)
    //        return 0f;
    //    else if (dying)
    //        return 0f;
    //    else if (growing)
    //        vegetationAmount += lod4.transform.localScale.y * sizeFactor * GetGrowthAmount();
    //    else
    //        vegetationAmount += lod4.transform.localScale.y * sizeFactor;

    //    vegetationAmount *= vegetationCarbonFactor;

    //    //Debug.Log(transform.name+"... FirController.GetVegetationAmount()... Tree sizeFactor:" + sizeFactor + " vegetationAmount:" + vegetationAmount + " growing? " + growing+" upperCarbonFactor:"+upperCarbonFactor);
    //    return vegetationAmount;
    //}

    /// <summary>
    /// Gets the vegetation amount for this tree.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    //public float GetRootsAmount()
    //{
    //    float rootsAmount = 0f;

    //    if (!alive)
    //        return 0f;
    //    if (dying)
    //        return 0f;
    //    else if (growing)
    //        rootsAmount += roots.transform.localScale.y * sizeFactor * GetGrowthAmount();
    //    else
    //        rootsAmount += roots.transform.localScale.y * sizeFactor;

    //    rootsAmount *= rootsCarbonFactor;

    //    //Debug.Log("Tree sizeFactor:" + sizeFactor + " rootsAmount:" + rootsAmount+" growing? "+growing+" rootsCarbonFactor:"+rootsCarbonFactor);
    //    return rootsAmount;
    //}

    /// <summary>
    /// Gets the growth amount.
    /// </summary>
    /// <returns>The growth amount.</returns>
    private float GetGrowthAmount()
    {
        if (growing)
            return (Time.time - growthStartTime) * growthSpeed * timeStep * timeStepGrowthSpeedFactor;
        else
            return 1f;
    }

    /// <summary>
    /// Returns whether fir is alive
    /// </summary>
    /// <returns><c>true</c>, if alive was ised, <c>false</c> otherwise.</returns>
    public bool IsAlive()
    {
        return alive && !dying;
        //return alive;
    }

    /// <summary>
    /// Returns whether fir is dying
    /// </summary>
    /// <returns><c>true</c>, if dying was ised, <c>false</c> otherwise.</returns>
    public bool IsDying()
    {
        return dying;
    }

    /// <summary>
    /// Returns whether fir is growing
    /// </summary>
    /// <returns><c>true</c>, if growing was ised, <c>false</c> otherwise.</returns>
    public bool IsGrowing()
    {
        return growing;
    }
}
