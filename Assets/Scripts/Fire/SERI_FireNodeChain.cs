/* Adapted from FireNodeChain.cs
// Fire Propagation System
// Copyright (c) 2016-2017 Lewis Ward
// author: Lewis Ward
// date  : 04/04/2017
*/

using UnityEngine;
using System.Collections;

public class SERI_FireNodeChain : MonoBehaviour 
{
    private bool debug = false;
    public bool initialized { get; set; } = false;
    public bool isTreeFire { get; set; } = false;
    public bool burning { get; set; } = false;
    private bool destroyObject = false;
    private bool igniteFire = false;

    private SERI_FireManager fireManager;

    [Tooltip("Higher the value, quick the fire ignites fuel")]
    public float propagationSpeed = 1000.0f;
    [Tooltip("Nodes within this chain, should have all nodes so fires start correctly")]
    public SERI_FireNode[] fireNodes = null;
    [Tooltip("Enable if GameObject should be destroyed once all nodes been set on fire, do not enable for trees!")]
    private bool destroyAfterFire = false;
    [Tooltip("Enable if GameObject should be replaced with another mesh once all nodes have been set on fire")]
    private bool replaceAfterFire = false;
    [Tooltip("The GameObject that this object should be replaced with")]
    public GameObject m_replacementMesh;
    private float combustionRate = 5.0f;
    private bool destroyedAlready = false;
    private bool replacedAlready = false;
    private bool validChain = true;

    private void Awake()
    {
        initialized = false;
    }

    /// <summary>
    /// Initialize the specified fireManager and newTreeFire.
    /// </summary>
    /// <param name="newFireManager">Fire manager.</param>
    /// <param name="treeFire">Whether fire is a tree fire.</param>
    /// <param name="destroyAfter">Whether to destroy associated fir after burning.</param>
    public void Initialize(SERI_FireManager newFireManager, bool treeFire, bool destroyAfter)
    {
        destroyAfterFire = destroyAfter;
        fireManager = newFireManager;

        if (fireManager != null)
        {
            combustionRate = fireManager.maxNodeCombustionRate;
        }

        isTreeFire = treeFire;

        // Make sure that all nodes in the chain have been assigned
        for (int i = 0; i < fireNodes.Length; i++)
        {
            if (fireNodes[i] == null)
            {
                Debug.LogError("Fire Node Chain on " + gameObject.GetComponentInParent<Transform>().name + " has missing Fire Nodes!");
                validChain = false;
                break;
            }
            else
            {
                fireNodes[i].Initialize(fireManager);
            }
        }

        initialized = true;
    }

    // Update is called once per frame
    void Update () 
    {
        if (validChain)
        {
            if(igniteFire && !burning)
            {
                PropagateFireImmediately();
                igniteFire = false;
            }

            if (destroyAfterFire && !destroyedAlready)
                DestroyAfterFire();

            if (replaceAfterFire && !replacedAlready)
                ReplaceAfterFire();
        }
        else
        {
            Debug.Log(name+".Update()... Invalid chain!  m_validChain:" + validChain+" parent name:"+transform.parent.name);
        }
    }

    /// <summary>
    /// Creates fire particle systems on the node positions
    /// </summary>
    private void PropagateFireImmediately()
    {
        for (int i = 0; i < fireNodes.Length; i++)
        {
            fireNodes[i].StartFire();

            //if (!m_fireNodes[i].isAlight)
            //    m_fireNodes[i].InstantiateFire();

            //m_fireNodes[i].Ignite();
        }
    }

    /// <summary>
    /// Find the closest node to the fire and set it alight
    /// </summary>
    /// <param name="firePosition"></param>
    public void SpreadFire(Vector3 firePosition)
    {
        float shortestDistance = float.MaxValue;
        int shortestIndex = 0;

        for (int i = 0; i < fireNodes.Length; i++)
        {
            float distance = Vector3.Distance(fireNodes[i].GetComponent<Transform>().position, firePosition);

            if (distance < shortestDistance)
            {
                shortestDistance = distance;
                shortestIndex = i;
            }
        }

        //m_fireNodes[shortestIndex].HP = 0f;
        fireNodes[shortestIndex].StartFire();

        if (debug)
            Debug.Log(name + ".StartFire()... firePosition:" + firePosition + " time:" + Time.time);
    }

    /// <summary>
    /// Ignite the node chain
    /// </summary>
    /// <param name="firePosition"></param>
    /// <param name="newCombustionRate"></param>
    public void Ignite(Vector3 firePosition, float newCombustionRate)
    {
        int frameRate = (int)(1f / Time.smoothDeltaTime);                  // Find frame length in sec
        //combustionRate = fireManager.maxNodeCombustionRate / fireLengthInFrames;   // Find combustion rate from fire frame length
        combustionRate = newCombustionRate;   // Find combustion rate from fire frame length

        for (int i = 0; i < fireNodes.Length; i++)
        {
            fireNodes[i].SetupNode(fireManager.maxNodeCombustionRate, combustionRate, frameRate);
        }

        igniteFire = true;

        if (debug)
            Debug.Log(name + ".Ignite()... firePosition:" + firePosition + " m_fireNodes.Length:" + fireNodes.Length + " initialized:" + initialized + " m_combustionRateValue:" + combustionRate+ " destroy after:"+destroyAfterFire);
    }

    /// <summary>
    /// Destroys the object once all nodes have run out of fuel
    /// </summary>
    void DestroyAfterFire()
    {
        bool allBurnt = false;

        for (int i = 0; i < fireNodes.Length; i++)    // Check all nodes have had they fuel used up
        {
            if (fireNodes[i].GetFuelAmount() <= 0.0f)
            {
                if (i == fireNodes.Length - 1)        // All have ran out of fuel
                    allBurnt = true;

                continue;
            }
            else
            {
				//Debug.Log(name + ".DestroyAfterFire()... Fire not over... m_fireNodes[i].m_fuel:"+ m_fireNodes[i].m_fuel+" time:" + Time.time);
				break;
            }
        }

        if (allBurnt)
        {
            if(isTreeFire)
            {
                destroyObject = true;
                destroyedAlready = true;

				//Debug.Log(name + ".DestroyAfterFire()... destroy tree at time:" + Time.time);
				//Reset();
			}
            else
            {
                for (int i = gameObject.transform.childCount - 1; i >= 0; i--)
                    Destroy(gameObject.transform.GetChild(i).gameObject);

                if(debug)
                Debug.Log(name + ".DestroyAfterFire()... destroy shrub at time:" + Time.time);

                Destroy(gameObject);
            }
        }
    }

    /// <summary>
    /// Replaces the object with another once all FireNode's have run out of fuel
    /// </summary>
    void ReplaceAfterFire()
    {
        bool allBurnt = false;

        // Check all nodes have had they fuel used up
        for (int i = 0; i < fireNodes.Length; i++)
        {
            if (fireNodes[i].NodeConsumed() == true)
            {
                // Got to the end, all have ran out of fuel
                if (i == fireNodes.Length - 1)
                    allBurnt = true;

                continue;                // Need to check next node
            }
            else
            {
                break;
            }
        }

        // If so, delete the gameoject and replace it
        if (allBurnt && m_replacementMesh != null)
        {
            if (m_replacementMesh != null)
            {
                Transform trans = gameObject.transform;
                Destroy(gameObject);
                Instantiate(m_replacementMesh, trans.position, trans.rotation);
            }
            else
            {
                Debug.Log("Failed to replace the gameobject");
            }

            replacedAlready = true;
        }
    }

    /// <summary>
    /// Sets whether to destroy associated fir after fire.
    /// </summary>
    /// <param name="destroyAfter">If set to <c>true</c> destroy associated fir after after fire, otherwise do nothing.</param>
    public void SetDestroyAfterFire(bool destroyAfter)
    {
        destroyAfterFire = destroyAfter;
    }

    /// <summary>
    /// Tos the be destroyed.
    /// </summary>
    /// <returns><c>true</c>, if to be destroyed, <c>false</c> otherwise.</returns>
    public bool ToBeDestroyed()
    {
        return destroyObject;
    }

    /// <summary>
    /// Tos the be destroyed.
    /// </summary>
    /// <returns><c>true</c>, if to be destroyed, <c>false</c> otherwise.</returns>
    public void ClearToBeDestroyed()
    {
        //m_destroyedAlready = true;
        destroyObject = false;
    }
}
