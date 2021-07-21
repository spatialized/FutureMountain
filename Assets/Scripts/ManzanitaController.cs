using System.Collections;
using System.Collections.Generic;
using UnityEngine.Assertions;
using UnityEngine;
using System;

/// <summary>
/// Fir controller.
/// </summary>
public class ManzanitaController : TreeController
{
    /* General */
    CubeController cubeController;                       // Parent cube controller

    /* Position */
    private float treeYOffset;         
    private float aggregateTreeYOffset;   
    private bool initialized = false;

    /* Layers */
    private bool showRootsLayer = true;                  // -- TO DO
   
    /* Physics */
    private Rigidbody rigidBody;

    /// <summary>
    /// Initializes the fir.
    /// </summary>
    /// <param name="parentCubeController">Parent cube controller.</param>
    /// <param name="cubeTerrain">Cube terrain.</param>
    /// <param name="isAggregate">If set to <c>true</c>, parent cube is aggregate.</param>
    /// <param name="newIsFrontTree">Front tree flag</param>
    public void InitializeFir(CubeController parentCubeController, Terrain cubeTerrain, bool isAggregate, bool newIsFrontTree)
    {
        /* Initialize Objects */
        cubeController = parentCubeController;

        treeCarbonFactor = cubeController.GetTreeCarbonFactor();
        rootsCarbonFactor = cubeController.GetRootsCarbonFactor();

        treeYOffset = settings.TreeHeightOffset;                       
        //aggregateTreeYOffset = settings.AggregateTreeHeightOffset;

        isFrontTree = newIsFrontTree;

        ///* Set Height and Width Scale */
        //InitializeScale(false);

        /* Initialize particle system */
        GameObject evapTrans = transform.Find("EvapTrans").gameObject;
        etParticles = evapTrans.GetComponent<ParticleSystem>();

        showParticles = true;
        particlesEnabled = false;

        if (!showParticles)
        {
            etParticles.Stop();
            var emission = etParticles.emission;
            emission.rateOverTime = 0;
            particlesEnabled = false;
        }

        /* Create Rigidbody */
        rigidBody = gameObject.GetComponent<Rigidbody>();
        Assert.IsNotNull(rigidBody);
        rigidBody.isKinematic = true;

        /* Place tree at terrain height */
        var xPos = transform.localPosition.x;
        var yPos = cubeTerrain.SampleHeight(transform.position) + settings.TreeHeightOffset;
        var zPos = transform.localPosition.z;

        transform.localPosition = new Vector3(xPos, yPos, zPos);
        //InitializeScale(true);
    }

    /// <summary>
    /// Update simulation state
    /// </summary>
    /// <param name="curTime">Current time.</param>
    /// <param name="curTimeStep">Current time step.</param>
    /// <param name="newTranspiration">New transpiration.</param>
    /// <param name="newLeafCarbon">New leaf carbon.</param>
    /// <param name="newStemCarbon">New stem carbon.</param>
    public void UpdateSimulation(int curTime, int curTimeStep, float newTranspiration, float newLeafCarbon, float newStemCarbon, float newRootCarbon)
    {
        timeStep = curTimeStep;
        leafCarbon = newLeafCarbon;
        stemCarbon = newLeafCarbon;
        transpiration = newTranspiration;                   // -- Randomize between trees?

        if (leafCarbon < maxLeafCarbon)
            alphaCutoff = 1f - MapValue (leafCarbon, 0f, maxLeafCarbon, 0f, 0.6f);
        else
            alphaCutoff = 0.1f;

        if(showParticles)
            SetEmissionRate(transpiration * particleEmissionFactor);

        if (showParticles && !particlesEnabled)           // Set particle system emission rate from transpiration amount
        {
            SetEmissionRate(transpiration * particleEmissionFactor);
            etParticles.Play();
            particlesEnabled = true;
        }

        if (!showParticles && particlesEnabled)           // Stop particle system
        {
            etParticles.Stop();
            SetEmissionRate(0);
            particlesEnabled = false;
        }

        if (alive)                                        // If fir is alive, update growth
            UpdateGrowth();
        else if (dying)
            UpdateDeath();
    }

    /// <summary>
    /// Gets the carbon amount represented by this tree in simulation.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    public float GetCarbonAmount()
    {
        if (!alive)
            return 0f;
        else if (dying)
            return 0f;
        else if (transform.localScale.magnitude <= 0f)
            return 0f;
        else
        {
            return treeHeightScale * GetFullTreeHeight() * treeCarbonFactor;
        }
    }

    /// <summary>
    /// Updates tree growth.
    /// </summary>
    protected void UpdateGrowth()
    {
        GrowTree();
        if (isFrontTree) GrowRoots();   // -- ADDED
    }

    /// <summary>
    /// Updates dying animation.              // -- Need to update so tree falls to ground
    /// </summary>
    protected void UpdateDeath()
    {
        float dist = (Time.time - deathStartTime) * settings.TreeDeathSpeed;

        if (dist < 1.0f)
        {
            // -- TO DO: FALL TO GROUND, ETC
        }
        else
        {
            SetTreeScale(0f, 0f, false);
            //SetRootsScale(0f, 0f);
            //HideDeadTreeObjects();
            dying = false;
            alive = false;

            //TurnToLitter();                 // -- ADDED 1/29/19
        }
    }

    /// <summary>
    /// Adds fallen tree log at tree location.     -- TO DO
    /// </summary>
    private void TurnToLitter()
    {
        //rigidBody.isKinematic = false;
        //Vector3 torque = Vector3.right * 1.9f;
        //rigidBody.AddTorque(torque, ForceMode.Impulse);
    }
}
