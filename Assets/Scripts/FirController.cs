using System.Collections;
using System.Collections.Generic;
using UnityEngine.Assertions;
using UnityEngine;
using System;

/// <summary>
/// Fir controller.
/// </summary>
public class FirController : TreeController
{
    /* General */
    public bool destroyed = false;

    /* Position */
    private float treeYOffset;
    private float aggregateTreeYOffset;
    private bool initialized = false;
    public int locationID = -1;

    /* Layers */                                                                  // -- TO DO
    private bool showETLayer = true;                 
    private bool showRootsLayer = true;                  
    private bool showSoilsLayer = true;                  
    private bool showStory2Layer = true;                 
    private bool showStory1Layer = true;                 

    /* Graphics */
    ParticleSystem.MainModule mainModule;                                         // Main module
    ParticleSystem.EmissionModule emissionModule;                                 // Emission module

    /* Physics */
    private Rigidbody rigidBody;

    /// <summary>
    /// Initializes the fir.
    /// </summary>
    /// <param name="cubeTerrain">Cube terrain.</param>
    /// <param name="isAggregate">If set to <c>true</c>, parent cube is aggregate.</param>
    /// <param name="newIsFrontTree">Front tree flag</param>
    /// <param name="newTreeCarbonFactor"></param>
    /// <param name="newRootsCarbonFactor"></param>
    /// <param name="newCubeNECorner"></param>
    /// <param name="newCubeSWCorner"></param>
    public void InitializeFir(Terrain cubeTerrain, bool isAggregate, bool newIsFrontTree, float newTreeCarbonFactor, float newRootsCarbonFactor, Vector3 newCubeNECorner, Vector3 newCubeSWCorner)
    {
        /* Initialize Objects */
        treeCarbonFactor = newTreeCarbonFactor;
        rootsCarbonFactor = newRootsCarbonFactor;

        cubeNECorner = newCubeNECorner;
        cubeSWCorner = newCubeSWCorner;

        treeYOffset = settings.TreeHeightOffset;
        isFrontTree = newIsFrontTree;

        /* Initialize particle system */
        GameObject evapTrans = transform.Find("EvapTrans").gameObject;
        etParticles = evapTrans.GetComponent<ParticleSystem>();

        showParticles = true;
        particlesEnabled = false;

        mainModule = etParticles.main;
        emissionModule = etParticles.emission;

        if (!showParticles)
        {
            etParticles.Stop();
            emissionModule.rateOverTime = 0;
            particlesEnabled = false;
        }

        /* Create Rigidbody */
        //rigidBody = gameObject.GetComponent<Rigidbody>();
        //Assert.IsNotNull(rigidBody);
        //rigidBody.isKinematic = true;

        /* Position at terrain height */
        var xPos = transform.localPosition.x;
        var yPos = cubeTerrain.SampleHeight(transform.position) + settings.TreeHeightOffset;
        if (isAggregate)
            yPos = cubeTerrain.SampleHeight(transform.position) + settings.TreeHeightOffset - 1f;       // -- TEMP.
        var zPos = transform.localPosition.z;

        transform.localPosition = new Vector3(xPos, yPos, zPos);

        //gameObject.SetActive(false);
        dying = false;
        alive = false;
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
        if (!destroyed)
        {
            if (fireNodeChain.ToBeDestroyed())
            {
                if (debugTree)
                    Debug.Log(name + ".UpdateSimulation()... Fire node chain triggered fir to be destroyed at time:" + Time.time);

                Kill(true);
                fireNodeChain.ClearToBeDestroyed();
                return;
            }

            timeStep = curTimeStep;
            leafCarbon = newLeafCarbon;
            stemCarbon = newLeafCarbon;
            transpiration = newTranspiration;                   // -- Randomize between trees?

            //if (leafCarbon < maxLeafCarbon)                   // -- Unused
            //    alphaCutoff = 1f - MapValue(leafCarbon, 0f, maxLeafCarbon, 0f, 0.6f);
            //else
            //    alphaCutoff = 0.1f;

           //if (particlesEnabled)
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
    }

    public void UpdateETSimulationSpeed(float newSpeed)
    {
        mainModule.simulationSpeed = newSpeed;
    }

    /// <summary>
    /// Gets the vegetation amount for this tree.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    public float GetRootsCarbon()
    {
        float rootsAmount = 0f;

        if (!alive)
            return 0f;
        if (dying)
            return 0f;
        else
        {
            rootsAmount = rootsHeightScale * GetFullRootsDepth() * rootsCarbonFactor;
        }

        return rootsAmount;
    }

    /// <summary>
    /// Get emission module rate over time value
    /// </summary>
    /// <returns></returns>
    public float GetTranspirationVisualized()
    {
        float transAmount = 0f;

        if (!alive)
            return 0f;
        if (dying)
            return 0f;
        else
        {
            transAmount = emissionModule.rateOverTime.constant;
        }

        return transAmount;

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
            //dead = true;
            SetTreeToDead(true);
        }
    }

    /// <summary>
    /// Finishes the death process.
    /// </summary>
    public void SetTreeToDead(bool turnToLitter)
    {
        SetTreeScale(0f, 0f, false);
        SetRootsScale(0f, 0f, false);

        HideDeadTreeObjects();
        HideLODGroups();
        HideRootsObjects();
        dying = false;
        alive = false;

        if (turnToLitter)
            TurnToLitter();

        SetDestroy(true);
    }

    /// <summary>
    /// Kill tree.
    /// </summary>
    public void Kill(bool immediate)
    {
        //Debug.Log(name + ".Kill()... alive? " + alive + " immediate:" + immediate);

        if (IsAlive())
        {
            StopParticles();

            if (immediate)
            {
                //alive = false;
                //dying = false;

                //SetTreeScale(0f, 0f, false);
                //SetRootsScale(0f, 0f, false);

                //HideLODGroups();
                //HideRootsObjects();

                //Debug.Log(transform.parent.transform.parent.transform.name + ".Kill()... Killed Tree immediately, setting to destroy.. ");
                ////activeFirLocations.Remove(fir.locationID);

                //SetDestroy(true);                                       // Destroy fir object

                SetTreeToDead(false);

                return;
            }
            else
            {
                alive = false;
                dying = true;

                deathStartTime = Time.time;

                SetDeadPrefab();

                if (debugTree && debugDetailed)
                    Debug.Log(transform.parent.transform.parent.transform.name + "... " + transform.name + ".Kill() over time... immediate? "+ immediate);
            }
        }
        else
        {
            SetTreeToDead(false);

            //if (IsDying())
            //{
            //    SetTreeToDead(false);
            //}
            //else
            //{
            //    Debug.Log(name + ".Kill()... will set to destroy");
            //    SetDestroy(true);
            //}
        }
    }

    /// <summary>
    /// Adds fallen tree log at tree location.     -- TO DO
    /// </summary>
    private void TurnToLitter()
    {
        if (debugTree && debugDetailed) 
            Debug.Log(name + ".TurnToLitter()...");

        float y = UnityEngine.Random.Range(0f, 360f);                       // Choose rotation to avoid falling out of cube (0f faces East)

        if (Vector3.Distance(transform.position, cubeNECorner) < treefallPadding)
        {
            y = UnityEngine.Random.Range(90f, 180f);
        }
        else if (Vector3.Distance(transform.position, cubeSWCorner) < treefallPadding)
        {
            y = UnityEngine.Random.Range(270f, 360f);
        }
        else if (transform.position.x < cubeNECorner.x + treefallPadding)           // Close to N edge
        {
            y = UnityEngine.Random.Range(180f, 360f);
        }
        else if(transform.position.z > cubeNECorner.z - treefallPadding)            // Close to S edge
        {
            y = UnityEngine.Random.Range(90f, 270f);
        }
        else if (transform.position.x > cubeSWCorner.x - treefallPadding)           // Close to E edge
        {
            y = UnityEngine.Random.Range(0f, 180f);
        }
        else if (transform.position.z < cubeSWCorner.z + treefallPadding)           // Close to W edge
        {
            y = UnityEngine.Random.Range(270f, 450f);
        }

        Quaternion newRotation = Quaternion.Euler(90f, y, 0f);
        GameObject newDeadTree = Instantiate(deadTreePrefab, transform.position, newRotation, transform.parent.transform);
        newDeadTree.transform.localRotation = newRotation;

        float heightScale = GetTreeActualHeight() / deadTreePrefabHeight;
        float widthScale = GetTreeActualWidth() / deadTreePrefabWidth;

        newDeadTree.transform.localScale = new Vector3(widthScale, heightScale, widthScale);
        newDeadTree.transform.localScale *= 0.75f;

        newDeadTree.name = "DeadTreeLog";
        newDeadTree.tag = "Litter";

        //rigidBody.isKinematic = false;
        //Vector3 torque = Vector3.right * 1.9f;
        //rigidBody.AddTorque(torque, ForceMode.Impulse);
    }

    /// <summary>
    /// Sets the destroy flag.
    /// </summary>
    /// <param name="newState">If set to <c>true</c> new state.</param>
    private void SetDestroy(bool newState)
    {
        //Debug.Log(name+ ".SetDestroy()... "+newState+" gameObject.transform.childCount:" + gameObject.transform.childCount);
        destroyed = newState;
    }
}
