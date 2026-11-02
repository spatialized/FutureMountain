using UnityEngine;

/// <summary>
/// Central Coast: drives a cube's falling-rain ParticleSystem from precipitation data.
/// Starts stopped (no particles) and only plays while fed a positive rain value, so rain appears
/// strictly when the data says it rains and hides together with the cube (it is a child of the cube).
/// This is a dedicated, data-driven controller, separate from the soil's WaterToGWController.
/// </summary>
[RequireComponent(typeof(ParticleSystem))]
public class RainfallController : MonoBehaviour
{
    [Tooltip("Emission rate (particles/sec) at or above the heavy-rain value below")]
    public float maxEmissionRate = 100f;
    [Tooltip("Scaled rain value at which emission reaches the max (values above are clamped)")]
    public float rainAtMax = 1f;
    [Tooltip("Scaled rain at/below which the rain stops entirely")]
    public float rainOffThreshold = 0.002f;

    private ParticleSystem ps;
    private ParticleSystem.EmissionModule emission;
    private bool playing = false;

    void Awake()
    {
        EnsurePS();
        Stop();   // start with no rain; data drives it on
    }

    // Cache the ParticleSystem lazily so this works even if the object was inactive at Awake time.
    private void EnsurePS()
    {
        if (ps == null)
        {
            ps = GetComponent<ParticleSystem>();
            if (ps != null) emission = ps.emission;
        }
    }

    /// <summary>
    /// Called each simulation step with the current (already-scaled) rain value.
    /// 0 / below threshold = stop; higher = heavier rain, up to maxEmissionRate.
    /// </summary>
    public void SetRain(float rainValue)
    {
        EnsurePS();
        if (ps == null) return;

        if (rainValue <= rainOffThreshold)
        {
            Stop();
            return;
        }

        if (!playing)
        {
            ps.Play();
            playing = true;
        }

        float t = Mathf.Clamp01(rainValue / Mathf.Max(0.0001f, rainAtMax));
        emission.rateOverTime = Mathf.Lerp(0f, maxEmissionRate, t);
    }

    public void Stop()
    {
        EnsurePS();
        if (ps != null && playing)
        {
            ps.Stop();
            ps.Clear();
        }
        playing = false;
    }
}
