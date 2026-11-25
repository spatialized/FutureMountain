using System;
using UnityEngine;

[Serializable]
public class VertexPaintNoiseData
{
    [SerializeField] private bool isNoiseActive = false;
    [SerializeField] private float multiplier = 0.1f;
    [SerializeField] private float sizeX = 2f;
    [SerializeField] private float sizeZ = 2f;
    [SerializeField] private Texture2D vertexNoiseTexture;
    [SerializeField] private  AnimationCurve slopeCurve = new(new Keyframe(0, 1), new Keyframe(1, 1));


    public Texture2D VertexNoiseTexture
    {
        get
        {
            if (vertexNoiseTexture == null)
                vertexNoiseTexture =  Resources.Load<Texture2D>("T_RAM_River_Noise_Vertex");

            return vertexNoiseTexture;
        }
        set => vertexNoiseTexture = value;
    }

    public bool IsNoiseActive
    {
        get => isNoiseActive;
        set => isNoiseActive = value;
    }

    public float Multiplier
    {
        get => multiplier;
        set => multiplier = value;
    }

    public float SizeX
    {
        get => sizeX;
        set => sizeX = value;
    }

    public float SizeZ
    {
        get => sizeZ;
        set => sizeZ = value;
    }

    public AnimationCurve SlopeCurve
    {
        get => slopeCurve;
        set => slopeCurve = value;
    }

    public bool CheckDataChange(VertexPaintNoiseData otherNoiseData)
    {
        if (isNoiseActive != otherNoiseData.isNoiseActive)
            return true;
        if (Mathf.Approximately(multiplier, otherNoiseData.multiplier))
            return true;
        if (Mathf.Approximately(sizeX, otherNoiseData.sizeX))
            return true;
        if (Mathf.Approximately(sizeZ, otherNoiseData.sizeZ))
            return true;
        if (vertexNoiseTexture != otherNoiseData.vertexNoiseTexture)
            return true;

        return false;
    }

    public void SetNoiseData(VertexPaintNoiseData otherNoiseData)
    {
        isNoiseActive = otherNoiseData.isNoiseActive;
        multiplier = otherNoiseData.multiplier;
        sizeX = otherNoiseData.sizeX;
        sizeZ = otherNoiseData.sizeZ;
        vertexNoiseTexture = otherNoiseData.vertexNoiseTexture;
        slopeCurve = otherNoiseData.slopeCurve;
    }
}