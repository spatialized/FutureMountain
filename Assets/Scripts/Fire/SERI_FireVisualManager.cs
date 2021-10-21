/* Adapted from FireVisualManager.cs
// Fire Propagation System
// Copyright (c) 2016-2017 Lewis Ward
// author: Lewis Ward
// date  : 04/04/2017
*/

using UnityEngine;
//using System.Collections;

public class SERI_FireVisualManager : MonoBehaviour
{
    public ParticleSystem[] particleSystems;
    //[Tooltip("Should be the same number as particle systems used in the Fire, which of those particle systems should be active in the simulation's heat up step.")]
    public bool[] heatUp;
    //[Tooltip("Should be the same number as particle systems used in the Fire, which of those particle systems should be active in the simulation's ignition step.")]
    public bool[] ignition;
    //[Tooltip("Should be the same number as particle systems used in the Fire, which of those particle systems should be active in the simulation's extingush step.")]
    public bool[] extinguish;
    public bool heatState = false;
    public bool ignitionState = false;
    public bool extinguishState = false;
    public bool heatStateSet = false;
    public bool ignitionStateSet = false;
    public bool extinguishStateSet = false;

    float size = -1f;

    void OnEnable() {
        if (heatUp.Length > particleSystems.Length)
            Debug.LogError(gameObject.name + " FireVisualManager::heatUp of " + heatUp.Length + " > number of children with Particle Systems at:" + particleSystems.Length);

        if (ignition.Length > particleSystems.Length)
            Debug.LogError(gameObject.name + " FireVisualManager::ignition  of " + ignition.Length + " > number of children with Particle Systems at:" + particleSystems.Length);

        if (extinguish.Length > particleSystems.Length)
            Debug.LogError(gameObject.name + " FireVisualManager::extingush bigger then the number of children with Particle Systems");

        Initialize();
    }

    /// <summary>
    /// Initialize fire visual manager
    /// </summary>
    public void Initialize()
    {
        for (int i = 0; i < particleSystems.Length; i++)
            particleSystems[i].gameObject.SetActive(false);

        if (size > 0f)
            SetSize(size);

        heatState = false;
        ignitionState = false;
        extinguishState = false;
        heatStateSet = false;
        ignitionStateSet = false;
        extinguishStateSet = false;
    }

    void Update()
    {
        if (heatState && heatStateSet == false)
        {
            for (int i = 0; i < particleSystems.Length; i++)
                particleSystems[i].gameObject.SetActive(heatUp[i]);

            heatStateSet = true;
        }
        else if (ignitionState && ignitionStateSet == false)
        {
            for (int i = 0; i < particleSystems.Length; i++)
                particleSystems[i].gameObject.SetActive(ignition[i]);

            ignitionStateSet = true;
        }
        else if (extinguishState && extinguishStateSet == false)
        {
            for (int i = 0; i < particleSystems.Length; i++)
                particleSystems[i].gameObject.SetActive(extinguish[i]);

            extinguishStateSet = true;
        }
    }

    // brief Set the state to the heat state
    public void SetHeatState()
    {
        heatState = true;
        ignitionState = false;
        extinguishState = false;
    }

    // brief Set the state to the ignition state
    public void SetIgnitionState()
    {
        heatState = false;
        ignitionState = true;
        extinguishState = false;
    }

    // brief Set the state to the extingush state
    public void SetExtingushState()
    {
        heatState = false;
        ignitionState = false;
        extinguishState = true;
    }

    public void SetParams(float durationFactor, float lifetimeMultiplier)
    {
//        foreach (ParticleSystem ps in particleSystems)
//        {
            var main = particleSystems[0].main;
            //var main = ps.main;
            //main.startSizeMultiplier *= UnityEngine.Random.Range(1f - fireSizeVariability, 1f + fireSizeVariability);   // Randomize
            main.duration = main.duration * durationFactor;
            main.startLifetimeMultiplier = lifetimeMultiplier;
//        }
    }

    public void SetSize(float newSize)
    {
        size = newSize;
        if(particleSystems == null)
        {
            Debug.Log(name + ".SetSize()... Can't set size yet... m_particleSystems == null... parent:"+transform.parent+" size:" + size);
            return;
        }

        for (int i = 0; i < particleSystems.Length; i++)
            particleSystems[i].transform.localScale = new Vector3(size, size, size);
    }
}
