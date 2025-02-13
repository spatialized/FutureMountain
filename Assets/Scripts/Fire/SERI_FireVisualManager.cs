﻿/* Adapted from FireVisualManager.cs
// Fire Propagation System
// Copyright (c) 2016-2017 Lewis Ward
// author: Lewis Ward
// date  : 04/04/2017
*/

using System;
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
        if (particleSystems != null)
        {
            if (heatUp.Length > particleSystems.Length)
                Debug.LogError(gameObject.name + " FireVisualManager::heatUp of " + heatUp.Length + " > number of children with Particle Systems at:" + particleSystems.Length);

            if (ignition.Length > particleSystems.Length)
                Debug.LogError(gameObject.name + " FireVisualManager::ignition  of " + ignition.Length + " > number of children with Particle Systems at:" + particleSystems.Length);

            if (extinguish.Length > particleSystems.Length)
                Debug.LogError(gameObject.name + " FireVisualManager::extingush bigger then the number of children with Particle Systems");
        }

        Initialize();
    }

    /// <summary>
    /// Initialize fire visual manager
    /// </summary>
    public void Initialize()
    {
        if (particleSystems != null)
        {
            for (int i = 0; i < particleSystems.Length; i++)
            {
                if(particleSystems[i])
                    particleSystems[i].gameObject.SetActive(false);
            }
        }

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
            if (particleSystems != null)
            {
                for (int i = 0; i < particleSystems.Length; i++)
                    particleSystems[i].gameObject.SetActive(heatUp[i]);
            }
            heatStateSet = true;
        }
        else if (ignitionState && ignitionStateSet == false)
        {
            if (particleSystems != null)
            {
                for (int i = 0; i < particleSystems.Length; i++)
                    particleSystems[i].gameObject.SetActive(ignition[i]);
            }
            ignitionStateSet = true;
        }
        else if (extinguishState && extinguishStateSet == false)
        {
            if (particleSystems != null)
            {
                for (int i = 0; i < particleSystems.Length; i++)
                    particleSystems[i].gameObject.SetActive(extinguish[i]);
            }
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
        if (particleSystems != null)
        {
            var main = particleSystems[0].main;
            //var main = ps.main;
            //main.startSizeMultiplier *= UnityEngine.Random.Range(1f - fireSizeVariability, 1f + fireSizeVariability);   // Randomize
            main.duration = main.duration * durationFactor;
            main.startLifetimeMultiplier = lifetimeMultiplier;
        }
    }

    public void SetSize(float newSize)
    {
        size = newSize;
        if(particleSystems == null)
        {
            Debug.Log(name + ".SetSize()... Can't set size yet... m_particleSystems == null... parent:"+transform.parent+" size:" + size);
            return;
        }

        try
        {
            for (int i = 0; i < particleSystems.Length; i++)
                particleSystems[i].transform.localScale = new Vector3(size, size, size);
        }
        catch (Exception ex)
        {
            Debug.Log("FireVisualManager.SetSize()... size:"+ size+" ex: " + ex.Message);
        }
    }

    public void RandomizeFire()
    {
        if (particleSystems == null)
        {
            Debug.Log(name + ".RandomizeFires()... Can't randomize... m_particleSystems == null... parent:" + transform.parent + " size:" + size);
            return;
        }

        for (int i = 0; i < particleSystems.Length; i++)
        {
            //float size = UnityEngine.Random.Range(0.5f, 4.5f);
            //particleSystems[i].transform.localScale = new Vector3(size, size, size);

            float offset = UnityEngine.Random.Range(-1.5f, 1.5f);
            particleSystems[i].transform.localPosition = new Vector3(
                particleSystems[i].transform.localPosition.x + offset,
                particleSystems[i].transform.localPosition.y + offset,
                particleSystems[i].transform.localPosition.z);

            ParticleSystem.MainModule main = particleSystems[i].main;

            ParticleSystem.MinMaxCurve maxParticlesCurve = main.maxParticles;
            maxParticlesCurve.constant = maxParticlesCurve.constant + (int)System.Math.Round(UnityEngine.Random.Range(-5f, 5f));

            ParticleSystem.MinMaxCurve startSpeedCurve = main.startSpeed;
            startSpeedCurve.constant = startSpeedCurve.constant + UnityEngine.Random.Range(-0.5f, 0.5f);

            ParticleSystem.MinMaxCurve startLifetimeCurve = main.startLifetime;
            startLifetimeCurve.constantMin = startLifetimeCurve.constantMin + UnityEngine.Random.Range(-0.5f, 1.0f);
            startLifetimeCurve.constantMax = startLifetimeCurve.constantMax + UnityEngine.Random.Range(-0.5f, 2.5f);

            float rand = (int)System.Math.Round(UnityEngine.Random.Range(0f, 25f));
            ParticleSystem.MinMaxCurve startSizeCurve = main.startSize;
            startSizeCurve.constantMin = startSizeCurve.constantMin + rand;
            startSizeCurve.constantMax = startSizeCurve.constantMax + rand;

            //Debug.Log("particleSystems.Length:" + particleSystems.Length);
            //Debug.Log(name + ".RandomizeFires()... startSizeCurve.constantMin:" + startSizeCurve.constantMin);
            //Debug.Log(name + ".RandomizeFires()... startSizeCurve.constantMax:" + startSizeCurve.constantMax);
        }
    }
}
