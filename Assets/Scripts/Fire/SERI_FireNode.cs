/* Adapted from FireNode.cs
// Fire Propagation System
// Copyright (c) 2016-2017 Lewis Ward
// author: Lewis Ward
// date  : 04/04/2017
*/

using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// Fire node in a node chain, used for tree fires
/// </summary>
public class SERI_FireNode : MonoBehaviour
{
    SERI_FireManager fireManager;
    float defaultCombustionRate = 5.0f;

    private bool startFire = false;

    [Tooltip("Fire prefab.")]
    public GameObject firePrefab;
    private GameObject flames;
    [Tooltip("GameObjects with a FireNode script, any linked node will be heated up once this node is on fire.")]
    public List<GameObject> links = null;

    [Tooltip("Amount of fuel in the cell.")]
    [SerializeField]
    private float fuelAmount = 5.0f;
    private float fuelThreshold = 1f;
    [SerializeField]
    private float combustionRate = 5f;
    public bool isAlight = false;
    private bool extingushed = false;
    private bool clean = false;
    private SERI_FireVisualManager visualMgr = null;

    private bool initialized = false;
    ParticleSystem[] psArr;                     // Particle system references
    ParticleSystem.MainModule[] psMainArr;                     // Particle system references

    public void Initialize(SERI_FireManager newFireManager)
    {
        fireManager = newFireManager;
        initialized = true;
    }

    /// <summary>
    /// Setup fire node
    /// </summary>
    /// <param name="newFuel"></param>
    /// <param name="newCombustionRate"></param>
    public void SetupNode(float newFuel, float newCombustionRate, float frameRate)
    {
        fuelAmount = newFuel;
        combustionRate = newCombustionRate;

        //int frameRate = (int)(1f / Time.smoothDeltaTime);                        // Improve reliability by averaging over 0.5 - 1 sec

        float mult = fuelAmount / combustionRate;
        float durationFactor = mult;
        float lifetimeMultiplier = mult;


        //ParticleSystem.MainModule main = psMainArr[0];
        //main.duration = main.duration * durationFactor;
        //main.startLifetimeMultiplier = lifetimeMultiplier;


        // for (int i=0;i<psMainArr.Length;i++)
        // {
        //     ParticleSystem.MainModule main = psMainArr[i];
        //     main.duration = duration;
        //     main.startLifetime = fuelAmount / combustionRate / frameRate * 5f;
        //     main.startLifetimeMultiplier = fuelAmount / combustionRate;
        // }

        //Debug.Log(name+".SetupNode()... newFuel:" + newFuel + " newCombustionRate:" + newCombustionRate+ " mult:" + mult+" Time"+Time.time);
    }

    /// <summary>
    /// Kills the attached child particle systems
    /// </summary>
    private void KillFlames()
    {
        foreach (ParticleSystem ps in psArr)
        {
            ps.Stop();
            ps.Clear();
        }
    }

    /// <summary>
    /// Start fire in node
    /// </summary>
    public void StartFire()
    {
        startFire = true;
    }

    void Update()
    {
        if (startFire && !isAlight)
            Ignite();

        Combustion();
    }

    /// <summary>
    /// Has this node ran out of fire fuel
    /// </summary>
    /// <returns>Whether node is consumed</returns>
    public bool NodeConsumed()
    {
        if (clean == true)
            return true;
        else
            return false;
    }

    // brief Force this script to update
    public void ForceUpdate()
    {
        Update();
    }

    // brief Creates a fire of the set Fire Prefab within the Fire Manager                  // -- TO DO: OPTIMIZE USING POOLER
    // param Vector3 Position to spawn fire
    // param GameObject The fire GameObject
    private void InstantiateFire()
    {
        if (firePrefab)
        {
            flames = (GameObject)Instantiate(firePrefab, transform.position, new Quaternion(), transform);
            psArr = flames.GetComponentsInChildren<ParticleSystem>();
            psMainArr = new ParticleSystem.MainModule[psArr.Length];

            int i = 0;
            foreach(ParticleSystem ps in psArr)
            {
                psMainArr[i] = ps.main;
                i++;
            }

            isAlight = true;                // Should be set after fire extinguished
        }
        else
        {
            Debug.Log(name + ".InstantiateFire()... No fire prefab!   transform.parent^3.name:"+ transform.parent.transform.parent.transform.parent.name);
        }
    }

    /// <summary>
    /// Ignite the node
    /// </summary>
    private void Ignite()
    {
        //m_combustionRateValue = fireManager.maxNodeCombustionRate / fireLengthInFrames;   // Find combustion rate from fire frame length
        if (!extingushed)
        {
            InstantiateFire();
            startFire = false;

            if (visualMgr == null)
                visualMgr = flames.GetComponent<SERI_FireVisualManager>();

            if (visualMgr != null)
                visualMgr.SetIgnitionState();
        }
    }

    /// <summary>
    /// Run the combustion step, triggered after the fire is alight
    /// </summary>
    private void Combustion()
    {
        if (isAlight)
        {
            //Debug.Log(name + ".Combustion()...  m_fuel:" + m_fuel + " m_extinguishThreshold:" + m_extinguishThreshold + " m_combustionRateValue:" + m_combustionRateValue);
            
            fuelAmount -= combustionRate * Time.deltaTime;

            if (fuelAmount < fuelThreshold)
            {
                if (visualMgr != null)
                    visualMgr.SetExtingushState();
            }

            if (fuelAmount <= 0.0f)
            {
                isAlight = false;
                extingushed = true;

                KillFlames();
                clean = true;
            }
        }
    }

    /// <summary>
    /// Get fuel amount
    /// </summary>
    /// <returns>Fuel amount</returns>
    public float GetFuelAmount()
    {
        return fuelAmount;
    }

    /// <summary>
    /// Gets the visual manager and sets a reference to it
    /// </summary>
    //void GetVisualManager()
    //{
    //    if (visualMgr == null)
    //        visualMgr = flames.GetComponent<SERI_FireVisualManager>();
    //}
}
