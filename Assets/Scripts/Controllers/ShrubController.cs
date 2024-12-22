using UnityEngine;
using System.Collections;

public class ShrubController : MonoBehaviour
{
    public Renderer rend { get; set;  }
    public ParticleSystem pSystem { get; set;  }
    ParticleSystem.MainModule mainModule;
    ParticleSystem.EmissionModule emissionModule;
    bool initialized = false;

    public void InitializeShrub(Renderer newRend, ParticleSystem newPSystem)
    {
        rend = newRend;
        pSystem = newPSystem;

        if (pSystem == null)
        {
            Debug.Log(name+"... ERROR... Prefab has no particle system!");
            return;
        }

        mainModule = pSystem.main;
        emissionModule = pSystem.emission;

        emissionModule.enabled = true;
        emissionModule.rateOverTime = 0;

        pSystem.Play();

        initialized = true;
    }

    public void UpdateETSimulationSpeed(float newSpeed)
    {
        if (!initialized)
            return;
        if(pSystem == null)
        {
            Debug.Log(name + ".UpdateETSimulationSpeed()... null pSystem!");
            return;
        }

        ParticleSystem.MainModule main = pSystem.main;
        main.simulationSpeed = newSpeed;
    }
}
