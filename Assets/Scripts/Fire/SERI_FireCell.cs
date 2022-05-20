/* Adapted from FireCell.cs
// Fire Propagation System
// Copyright (c) 2016-2017 Lewis Ward
// author: Lewis Ward
// date  : 04/04/2017
*/

using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;
using UnityEditor;

/// <summary>
/// Fire cell in a grid, used for terrain fires.
/// </summary>
public class SERI_FireCell : MonoBehaviour, IComparable<SERI_FireCell> {
    /* Debugging */
    bool debug = false;
    //bool debugText = false;
    int id = 0;

    #region Fields
    /* Settings */
    public Vector2 gridLocation { get; set; } = new Vector2(-1, -1);
    private float fireLocationRandomness = 0.4f;
    float fireSizeVariability = 0.66f;

    /* Main */
    public List<int> patchIDList;
    private GameObjectPool pooler;
    public float fuelAmount;
    private GameObject firePrefab;              // Fire prefab 
    private GameObject[] fireList;              // Fires in cell
    private SERI_FireBox m_fireBox = null;      // used to detect collision with GameObjects that have colliders
    private float fuelThreshold = 1f;                       // -- ADD TO SIMULATION SETTINGS
    public float combustionRate;
    public bool fireInstantiated { get; set; } = false;
    public bool returnedToPool { get; set; } = false;
    private float fireSize;

    public bool setToDelete = false;
    [SerializeField]
    private bool isAlight = false;
    public bool extinguished = false;
    private Vector2[] firePositions;

    public Vector3 position { get { return transform.position; } }

    ParticleSystem[] psArr;                     // Particle system references
    ParticleSystem.MainModule[] psMainArr;                     // Particle system references

    /* Spread */
    private float iter = 0f;
    #endregion

    #region Initialization
    /// <summary>
    /// Sets up the cell data and variables
    /// </summary>
    /// <param name="fire">Fire prefab to be used</param>
    /// <param name="data">The cell data</param>
    /// <param name="terrainName">Name of the terrain</param>
    /// <param name="firesPositionsInCell">Positions within the cell to instantiate fire</param>
    public void SetupCell(GameObject fire, float newCellSize, float newFuel, string terrainName, Vector2[] firesPositionsInCell)
    {
        firePrefab = fire;
        fireList = new GameObject[firesPositionsInCell.Length];
        firePositions = firesPositionsInCell;

        fuelAmount = newFuel;

        m_fireBox = new SERI_FireBox();
        m_fireBox.Init(transform.position, terrainName);
        float boxExtents = newCellSize / 2.0f;
        m_fireBox.radius = new Vector3(boxExtents, boxExtents, boxExtents);
    }
    
    /// <summary>
    /// Set combustion rate.
    /// </summary>
    /// <param name="newCombustionRate">New combustion rate</param>
    public void SetCombustionRate(float newCombustionRate)
    {
        combustionRate = newCombustionRate;
    }

    /// <summary>
    /// Set fire size before ignition
    /// </summary>
    /// <param name="newFireSize"></param>
    public void SetFireSize(float newFireSize)
    {
        fireSize = newFireSize;
    }
    #endregion

    #region Ignition
    /// <summary>
    /// Instantiate a fire at position
    /// </summary>
    /// <param name="firePos">Position</param>
    /// <param name="newPooler">Fire GameObject/Prefab</param>
    private void InstantiateFireFromPool(Vector3 firePos, GameObjectPool newPooler)
    {
        pooler = newPooler;

        for (int i = 0; i < fireList.Length; i++)
        {
            fireList[i] = pooler.GetPooledObject();

            if (fireList[i] == null)
                Debug.Log(">> fireList i:" + i + " is null!");
            else if(fireList[i].gameObject == null)
                Debug.Log(">> fireList[i].gameObject i:" + i + " is null!");

            fireList[i].transform.position = firePos + new Vector3(firePositions[i].x, 0.0f, firePositions[i].y);
            fireList[i].transform.parent = transform;
        }

        returnedToPool = false;

        if (debug)
            DebugText(GetIter().ToString()+"("+ id.ToString()+")");
    }

    /// <summary>
    /// Ignites the fire.
    /// </summary>
    /// <param name="pooler"></param>
    /// <param name="dataControlled"></param>
    /// <param name="combustImmediately">Set extinguish state on ignition</param>
    /// <param name="newFuelAmount">Fire length in frames</param>
    /// <param name="newCombustionRate">Max. combustion rate</param>
    public void Ignite(GameObjectPool pooler, bool combustImmediately, float newFuelAmount, float newCombustionRate)
    {
        fuelAmount = newFuelAmount;
        combustionRate = newCombustionRate;

        if (combustImmediately)
            combustionRate = fuelAmount;

        if (fireInstantiated == false)
        {
            InstantiateFireFromPool(transform.position, pooler);
            IgniteAtSize(fireSize);

            fireInstantiated = true;
            isAlight = true;
        }
        else
        {
            Debug.Log(name+ ".Ignite()... fire not instantiated yet!");
        }

        if (combustImmediately)
        {
            for (int i = 0; i < fireList.Length; i++)
            {
                SERI_FireVisualManager visualMgr = fireList[i].GetComponent<SERI_FireVisualManager>();
                visualMgr.SetExtingushState();
            }
        }

        SERI_FireNodeChain chain = gameObject.GetComponent<SERI_FireNodeChain>();
        if (chain != null)
        {
            chain.Ignite(transform.position, combustionRate);
        }
    }

    /// <summary>
    /// Set fire size
    /// </summary>
    /// <param name="size"></param>
    private void IgniteAtSize(float size)
    {
        for (int i = 0; i < fireList.Length; i++)
        {
            SERI_FireVisualManager visualMgr = fireList[i].GetComponent<SERI_FireVisualManager>();
            visualMgr.SetSize(size);
            visualMgr.RandomizeFire();

            float mult = fuelAmount / combustionRate;
            float durationFactor = mult * 0.01f;
            float lifetimeMultiplier = mult * 0.01f;

            visualMgr.SetParams(durationFactor, lifetimeMultiplier);
            visualMgr.SetIgnitionState();
        }
    }
    #endregion

    #region Combustion
    /// <summary>
    /// Update combustion state
    /// </summary>
    public void RunCombustion()
    {
        bool m_extinguish = false;
        if (isAlight)
        {
            fuelAmount -= combustionRate * Time.deltaTime;        // Use fuel

            if (fuelAmount < fuelThreshold)                       // Check if threshold has been met, if so set Fire Visual Manager state
            {
                for (int i = 0; i < fireList.Length; i++)         // Extinguish fire
                {
                    SERI_FireVisualManager visualMgr = fireList[i].GetComponent<SERI_FireVisualManager>();
                    visualMgr.SetExtingushState();
                }
            }

            if (fuelAmount < fuelThreshold)                       // Set internal states when out of fuel
            {
                isAlight = false;
                m_extinguish = true;
            }
        }

        if (m_extinguish && !extinguished)
        {
            extinguished = true;

            if (m_fireBox != null)
            {
                m_fireBox = null;

                if (!returnedToPool)
                    ReturnToPool();
            }
        }
    }

    /// <summary>
    /// Run the heat up step, removing the cell's hit points until the ignition temperature is met. Used for fire spread 
    /// </summary>
    /// <param name="pooler">Game object pooler</param>
    public void Burn(GameObjectPool pooler)
    {
        if (fireInstantiated == false)
        {
            InstantiateFireFromPool(transform.position, pooler);
            fireInstantiated = true;

            for (int i = 0; i < fireList.Length; i++)
            {
                SERI_FireVisualManager visualMgr = fireList[i].GetComponent<SERI_FireVisualManager>();
                visualMgr.SetHeatState();
            }
        }

        if (!isAlight)
        {
            if (!extinguished)
            {
                isAlight = true;

                IgniteAtSize(1f);
            }
        }
    }
    #endregion

    #region Data
    /// <summary>
    /// Set patch ID
    /// </summary>
    /// <param name="newPatchIDList"></param>
    public void SetPatchIDList(List<int> newPatchIDList)
    {
        patchIDList = newPatchIDList;
    }

    /// <summary>
    /// Set fire order
    /// </summary>
    /// <param name="newIter"></param>
    public void SetIter(float newIter)
    {
        iter = newIter;
    }

    public float GetIter()
    {
        return iter;
    }
    #endregion

    #region Resetting
    /// <summary>
    /// Deletes the cell after given time
    /// </summary>
    /// <param name="time"></param>
    public void ResetCell()
    {
        if (!returnedToPool)
            ReturnToPool();

        Reset();
    }

    /// <summary>
    /// 
    /// </summary>
    private void ReturnToPool()
    {
        if (!returnedToPool)
        {
            foreach (GameObject fire in fireList)
            {
                if (fire == null)
                    continue;

                if (pooler == null)
                    continue;

                pooler.ReturnToPool(fire);
            }

            returnedToPool = true;
        }
    }

    /// <summary>
    /// Wait to delete cell
    /// </summary>
    /// <param name="delay"></param>
    /// <returns></returns>
    IEnumerator WaitToDeleteCell(float delay)
    {
        setToDelete = true;
        yield return new WaitForSeconds(delay);
        Delete();
    }

    /// <summary>
    /// Delete the fire
    /// </summary>
    private void Delete()
    {
        if (fireInstantiated)
        {
            Reset();
        }
    }
    
    /// <summary>
    /// Reset cell
    /// </summary>
    private void Reset()
    {
        fuelAmount = 0f;
        combustionRate = 0f;
        fireInstantiated = false;
        isAlight = false;
        extinguished = false;
        setToDelete = false;
        returnedToPool = false;

        //for (int i = 0; i < fireList.Length; i++)
        //{
        //    if(fireList[i])
        //    {
        //        SERI_FireVisualManager visualMgr = fireList[i].GetComponent<SERI_FireVisualManager>();
        //        visualMgr.Initialize();
        //    }
        //}
    }
    #endregion

    #region Sorting
    public int CompareTo(SERI_FireCell that)
    {
        return this.GetIter().CompareTo(that.GetIter());
    }
    #endregion

    #region Debugging

    /// <summary>
    /// Set id for debugging
    /// </summary>
    /// <param name="newID">New ID</param>
    public void SetID(int newID)
    {
        id = newID;
    }

    /// <summary>
    /// Draw debug text at position
    /// </summary>
    /// <param name="text">Text</param>
    /// <param name="worldPos">World position</param>
    /// <param name="color">Color</param>
    public void DebugText(string text)
    {
        Debug.Log(name + ".DebugText()... text:"+text);
        GameObject textObj = new GameObject();
        textObj.transform.parent = transform;

        TextMesh t = textObj.AddComponent<TextMesh>();

        t.text = text;
        t.fontSize = 30;

        t.transform.position = transform.position;

        t.transform.localEulerAngles += new Vector3(90, 0, 0);
        t.transform.localPosition += new Vector3(0f, 5f, 0f);
    }
    #endregion
}
