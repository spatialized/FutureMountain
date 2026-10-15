using System.Collections;
using System.Collections.Generic;
using UnityEngine;


// Central Coast effect manager: holds all effect parameters now, and (later) coordinates which effects
// show by view level + platform. MonoBehaviour -> just put it on a GameObject in the CC scene.
public class EffectManager : MonoBehaviour
{
    [System.Serializable]
    public class ETSettings
    {
        [Header("ET vapor — wind response")]
        [Range(0f, 10f)]  public float windNoiseFactor = 0.5f;
        [Range(0f, 10f)] public float maxWindNoiseStrength = 2f;
        [Range(0f, 5f)]  public float windForceFactor = 0.3f;
        [Header("ET vapor — emission")]
        [Range(0f, 100f)] public float treeEmissionFactor = 10f;   // emission rate = transpiration * this (CC firs)
    }

    public ETSettings et = new ETSettings();
    // Later: ViewLevel + per-cube coordination + other effect sections live here too.
}
