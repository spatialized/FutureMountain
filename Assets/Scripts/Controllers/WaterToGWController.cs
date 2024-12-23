using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

public class WaterToGWController : MonoBehaviour
{
    private float maxEmissionRate = 10f;

    private ParticleSystem ps;
    private ParticleSystem sps;
    private ParticleSystem.MainModule main;
    private ParticleSystem.EmissionModule emission;
    private ParticleSystem.MainModule spsMain;
    private ParticleSystem.EmissionModule spsEmission;
    private ParticleSystem.TrailModule trails;
    private bool playing = false;

    private bool stopping = false;
    private int startFrame = -1;
    private int endFrame = -1;

    void Start()
    {
        ps = GetComponent<ParticleSystem>();
        Assert.IsNotNull(ps);
        sps = ps.transform.Find("SubPS").GetComponent<ParticleSystem>();
        Assert.IsNotNull(sps);

        main = ps.main;
        emission = ps.emission;
        spsMain = sps.main;
        spsEmission = sps.emission;
        trails = sps.trails;
    }

    void Update()
    {
        if (stopping)
        {
            if(GameController.Instance.GetTimeIdx() >= endFrame)
            {
                Stop();
                Hide();
            }
        }
    }

    public void Play()
    {
        if (!ps)
        {
            Debug.Log(transform.parent.name+"."+name + ".WaterToGWController()... Play()... ERROR null ps!");
            return;
        }

        if (!playing) {
            ps.Play();
            playing = true;
        }
    }

    public void Stop()
    {
        ps.Clear();
        ps.Stop();
        playing = false;
        stopping = false;
    }

    public void Show()
    {
        if (!gameObject.activeSelf)
            gameObject.SetActive(true);
    }

    public void Hide()
    {
        gameObject.SetActive(false);
    }

    public bool Playing()
    {
        return playing;
    }

    public void UpdatePrecipitation(float snowValue)
    {
        int timeStep = GameController.Instance.GetTimeStep();

        if (GameController.Instance.GetTimeStep() <= 7)
        {
            if (snowValue < 0.05)
            {
                StopInFrames(timeStep * 2);
            }
            else if (snowValue <= 0.001)
            {
                StopInFrames(timeStep);
            }
            else if(playing && stopping){
                Stop();
                Play();
            }
            else if (!playing)
            {
                Show();
                Play();
            }
            else
            {
                main.startSpeed = MapValue(timeStep, 1f, 30f, 2f, 15f);
                main.startLifetime = 2.2f - MapValue(timeStep, 1f, 30f, 0.2f, 2f);
                emission.rateOverTime = MapValue(snowValue, 0f, 1f, 1f, maxEmissionRate);
                spsMain.startSpeed = MapValue(timeStep, 1f, 30f, 2f, 15f);
                spsMain.startLifetime = 2.2f - MapValue(timeStep, 1f, 30f, 0.2f, 2f);
                trails.lifetime = 0.525f - MapValue(timeStep, 1f, 30f, 0.025f, 0.5f);
            }
        }
        else
        {
            if (snowValue < 0.1)
            {
                StopInFrames(timeStep * 2);
            }
            else if (snowValue <= 0.02)
            {
                StopInFrames(timeStep);
            }
            else if (playing && stopping)
            {
                Stop();
                Play();
            }
            else if (!playing)
            {
                Show();
                Play();
            }
            else
            {
                main.startSpeed = MapValue(timeStep, 1f, 30f, 2f, 15f);
                main.startLifetime = 2.2f - MapValue(timeStep, 1f, 30f, 0.2f, 2f);
                emission.rateOverTime = MapValue(snowValue, 0f, 1f, 2f, maxEmissionRate);
                spsMain.startSpeed = MapValue(timeStep, 1f, 30f, 2f, 15f);
                spsMain.startLifetime = 2.2f - MapValue(timeStep, 1f, 30f, 0.2f, 2f);
                trails.lifetime = 0.525f - MapValue(timeStep, 1f, 30f, 0.025f, 0.5f);
            }
        }
    }

    private void StopInFrames(int frames)
    {
        if (stopping)
            return;

        startFrame = GameController.Instance.GetTimeIdx();
        endFrame = startFrame + frames;
        stopping = true;
    }

    /// <summary>
    /// Maps value from one range to another.
    /// </summary>
    /// <returns>The value.</returns>
    /// <param name="value">Value.</param>
    /// <param name="from1">From1.</param>
    /// <param name="to1">To1.</param>
    /// <param name="from2">From2.</param>
    /// <param name="to2">To2.</param>
    public static float MapValue(float value, float from1, float to1, float from2, float to2)
    {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
    }
}
