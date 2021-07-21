using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Assertions;

/// <summary>
/// Landscape controller.
/// </summary>
public class LandscapeTest : MonoBehaviour
{
    public Terrain t;
    public bool active = false;

    public bool patchBurned = false;
    public bool terrainBurning = false;

    [Range(0f, 1f)]
    public float regrowthAmount = 0f;
    [Range(0f, 1f)]
    public float snowWt = 1f;
    [Range(0f, 100f)]
    public float snowWeightFactor = 1f;

    [Range(0f, 1f)]
    public float s1 = 0f;
    [Range(0f, 1f)]
    public float s2 = 0f;
    [Range(0f, 1f)]
    public float s3 = 0f;
    [Range(0f, 1f)]
    public float s4 = 0f;

    //[Range(0f, 1f)]
    //public float burnWeightMax = 1f;

    private void Update()
    {
        if(active)
            UpdateLandscape();
    }

    /// <summary>
    /// Gets the terrain data frame for day in given month data.       
    /// </summary>
    /// <returns>The terrain data frame for day.</returns>
    /// <param name="day">Day to get data frame for.</param>
    /// <param name="firstMonth">Month data.</param>
    /// <param name="secondMonth">Next month data.</param>
    private void UpdateLandscape()
    {
        float[,,] splatmapData = new float[t.terrainData.alphamapWidth, t.terrainData.alphamapHeight, t.terrainData.alphamapLayers];
        float[] splatWeights = new float[t.terrainData.alphamapLayers];         // Array to record mix of texture weights 

        float snowWeight = snowWt * snowWeightFactor;

        for (int x = 0; x < t.terrainData.alphamapWidth; x++)
        {
            for (int y = 0; y < t.terrainData.alphamapHeight; y++)
            {
                splatWeights[0] = s1;                                           // Unburnt, full snow
                splatWeights[1] = s2;                                           // Unburnt, zero snow
                splatWeights[2] = s3;                                           // Burnt, full snow
                splatWeights[3] = s4;                                           // Burnt, zero snow

                float z = splatWeights.Sum();                                   // Calculate normalization factor from sum of weights (Sum of all textures weights must be 1)

                for (int i = 0; i < t.terrainData.alphamapLayers; i++)          // Loop through each terrain texture
                {
                    if (z > 0f)
                        splatWeights[i] /= z;                                   // Normalize to make sum of all texture weights = 1
                }

                for (int i = 0; i < t.terrainData.alphamapLayers; i++)          // Loop through each terrain texture
                {
                    splatmapData[x, y, i] = splatWeights[i];                    // Assign this point to the splatmap array

                    if (x + 1 < splatmapData.GetLength(0))
                    {
                        splatmapData[x + 1, y, i] = splatWeights[i];
                    }
                    if (y + 1 < splatmapData.GetLength(1))
                    {
                        splatmapData[x, y + 1, i] = splatWeights[i];
                    }
                    if (x + 1 < splatmapData.GetLength(0) && y + 1 < splatmapData.GetLength(1))
                    {
                        splatmapData[x + 1, y + 1, i] = splatWeights[i];
                    }
                }
            }
        }

        t.terrainData.SetAlphamaps(0, 0, splatmapData);
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

///// <summary>
///// Landscape controller.
///// </summary>
//public class LandscapeTest : MonoBehaviour
//{
//    public Terrain t;
//    public bool patchBurned = false;
//    public bool terrainBurning = false;
//    [Range(0f, 1f)]
//    public float regrowthAmount = 0f;
//    [Range(0f, 1f)]
//    public float snowWt = 1f;
//    [Range(0f, 100f)]
//    public float snowWeightFactor = 1f;
//    //[Range(0f, 1f)]
//    //public float burnWeightMax = 1f;

//    /// <summary>
//    /// Gets the terrain data frame for day in given month data.       
//    /// </summary>
//    /// <returns>The terrain data frame for day.</returns>
//    /// <param name="day">Day to get data frame for.</param>
//    /// <param name="firstMonth">Month data.</param>
//    /// <param name="secondMonth">Next month data.</param>
//    private void Update()
//    {
//        float[,,] splatmapData = new float[t.terrainData.alphamapWidth, t.terrainData.alphamapHeight, t.terrainData.alphamapLayers];
//        float[] splatWeights = new float[t.terrainData.alphamapLayers];     // Array to record mix of texture weights 

//        //float regrowthAmount = regrowthAmt;
//        float snowWeight = snowWt * snowWeightFactor;

//        for (int x = 0; x < t.terrainData.alphamapWidth; x++)
//        {
//            for (int y = 0; y < t.terrainData.alphamapHeight; y++)
//            {
//                //float pos = MapValue(x, 0, t.terrainData.alphamapWidth, 0f, 1f);     // Unused


//                if (snowWeight > 0.0001f)                                   // Some snow
//                {
//                    if (patchBurned)
//                    {
//                        if (terrainBurning)
//                        {
//                            splatWeights[1] = 0f;                           // Unburnt, full snow   
//                            splatWeights[0] = 0f;                           // Unburnt, zero snow
//                            splatWeights[2] = snowWeight;                   // Burnt, full snow
//                            splatWeights[3] = 1f - snowWeight;              // Burnt, zero snow
//                        }
//                        else
//                        {
//                            splatWeights[1] = snowWeight * regrowthAmount;                                               // Fully recovered, full snow
//                            splatWeights[0] = (1f - snowWeight) * regrowthAmount;                             // Fully recovered, zero snow
//                            splatWeights[2] = snowWeight * (1f-regrowthAmount);                             // Burnt, full snow
//                            splatWeights[3] = (1f - snowWeight) * (1f - regrowthAmount);           // Burnt, zero snow
//                        }

//                        if (x < 1 && y < 1)
//                            Debug.Log(name + " FIRE w/ SNOW  snowWeight:" + snowWeight + " >> s[0]:" + splatWeights[0] + " s[1]:" + splatWeights[1] + " s[2]:" + splatWeights[2] + " s[3]:" + splatWeights[3]);
//                    }
//                    else
//                    {
//                        splatWeights[1] = snowWeight;                       // Unburnt, full snow   
//                        splatWeights[0] = 1f - snowWeight;                  // Unburnt, zero snow
//                        splatWeights[2] = 0f;                               // Burnt, full snow   
//                        splatWeights[3] = 0f;                               // Burnt, zero snow

//                        if (x < 1 && y < 1)
//                            Debug.Log(name + " UNBURNT SNOW  snowWeight:" + snowWeight + " >> s[0]:" + splatWeights[0] + " s[1]:" + splatWeights[1] + " s[2]:" + splatWeights[2] + " s[3]:" + splatWeights[3]);
//                    }
//                }
//                else                                                        // No snow
//                {
//                    if (patchBurned)
//                    {
//                        if (terrainBurning)
//                        {
//                            splatWeights[1] = 0f;                           // Unburnt, full snow   
//                            splatWeights[0] = 0f;                           // Unburnt, zero snow
//                            splatWeights[2] = 0f;                           // Burnt, full snow
//                            splatWeights[3] = 1f;                           // Burnt, zero snow

//                            //if (x % 100 == 0)
//                            //    Debug.Log(name + " Frame:" + frameCt + " CURRENTLY BURNING   s[0]:" + splatWeights[0] + " s[1]:" + splatWeights[1] + " s[2]:" + splatWeights[2] + " s[3]:" + splatWeights[3]);
//                            //if (x % 100 == 0)
//                            //    Debug.Log(name + "... 3 snowValue:" + snowValue + " snowValue:" + snowValue + " snowWeight:" + snowWeight + " frameCt:" + frameCt + " terrainBurning:" + terrainBurning);
//                        }
//                        else
//                        {
//                            splatWeights[1] = 0f;                            // Fully recovered, full snow
//                            splatWeights[0] = regrowthAmount;                // Fully recovered, zero snow
//                            splatWeights[2] = 0f;                            // Burnt, full snow
//                            splatWeights[3] = 1f - regrowthAmount;           // Burnt, zero snow

//                            //if (frameCt % 10 == 0)
//                            //    Debug.Log(name + " Frame:" + frameCt + " BURNT  regrowthAmount:" + regrowthAmount + " >> s[0]:" + splatWeights[0] + " s[1]:" + splatWeights[1] + " s[2]:" + splatWeights[2] + " s[3]:" + splatWeights[3]);
//                            //if (frameCt % 10 == 0)
//                            //    Debug.Log(name + "... 4  regrowthAmount:" + regrowthAmount + " frameCt:" + frameCt + " terrainBurning:" + terrainBurning);
//                        }

//                        if (x < 1 && y < 1)
//                            Debug.Log(name + " FIRE NO SNOW  regrowthAmount:" + regrowthAmount + " >> s[0]:" + splatWeights[0] + " s[1]:" + splatWeights[1] + " s[2]:" + splatWeights[2] + " s[3]:" + splatWeights[3]);
//                    }
//                    else
//                    {
//                        splatWeights[1] = 0f;                               // Unburnt, full snow
//                        splatWeights[0] = 1f;                                // Unburnt, zero snow
//                        splatWeights[2] = 0f;                                // Burnt, full snow
//                        splatWeights[3] = 0f;                                // Burnt, zero snow

//                        if (x < 1 && y < 1)
//                            Debug.Log(name + " UNBURNT NO SNOW  regrowthAmount:" + regrowthAmount + " >> s[0]:" + splatWeights[0] + " s[1]:" + splatWeights[1] + " s[2]:" + splatWeights[2] + " s[3]:" + splatWeights[3]);
//                    }
//                }

//                float z = splatWeights.Sum();                                             // Calculate normalization factor from sum of weights (Sum of all textures weights must be 1)

//                for (int i = 0; i < t.terrainData.alphamapLayers; i++)                    // Loop through each terrain texture
//                {
//                    if (z > 0f)
//                        splatWeights[i] /= z;                                             // Normalize to make sum of all texture weights = 1
//                }

//                for (int i = 0; i < t.terrainData.alphamapLayers; i++)                  // Loop through each terrain texture
//                {
//                    splatmapData[x, y, i] = splatWeights[i];       // Assign this point to the splatmap array

//                    if (x + 1 < splatmapData.GetLength(0))
//                    {
//                        splatmapData[x + 1, y, i] = splatWeights[i];
//                    }
//                    if (y + 1 < splatmapData.GetLength(1))
//                    {
//                        splatmapData[x, y + 1, i] = splatWeights[i];
//                    }
//                    if (x + 1 < splatmapData.GetLength(0) && y + 1 < splatmapData.GetLength(1))
//                    {
//                        splatmapData[x + 1, y + 1, i] = splatWeights[i];
//                    }
//                }
//            }
//        }

//        t.terrainData.SetAlphamaps(0, 0, splatmapData);
//    }

//    /// <summary>
//    /// Maps value from one range to another.
//    /// </summary>
//    /// <returns>The value.</returns>
//    /// <param name="value">Value.</param>
//    /// <param name="from1">From1.</param>
//    /// <param name="to1">To1.</param>
//    /// <param name="from2">From2.</param>
//    /// <param name="to2">To2.</param>
//    public static float MapValue(float value, float from1, float to1, float from2, float to2)
//    {
//        return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
//    }
//}
