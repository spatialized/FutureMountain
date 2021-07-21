using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class HorizonControllerExample : MonoBehaviour
{
    /// <summary>
    /// This Script is an example of how you can change Horizon[ON]'s parameters in runtime. In most cases you would probably only need to change a few parameters(e.g. fog amount or snow amount).
    /// However, you can do more if you need it. Changing the mask offset to quickly switch to a different environment might be useful sometimes. Doing this will save you from having to create multiple materials.
    /// You could store different values for different levels in a file and load the values when you need them(or just randomize them on level load), instead of having a tons of materials in your project.
    /// This is just an example, of course you can change all values Horizon[On] via script, eg. you could change the glossiness values to simulate wetness which we dont do in this example.
    /// </summary>

    public GameObject horizonParent; // The parent, only used for enabling/disabling the entire horizon.
    public GameObject horizonBaked; // The transform that has all the meshes which have the displacement baked as children. We want to enable it in case the displacement amount is at maximum. 
    public GameObject horizonDisplaced; // The transform that has all the displacement meshes as children. We need it to disable it in case the displacement amount is 0. 
    public GameObject horizonFlat; // The transform that has all the flat meshes as children. We enable it in case the displacement amount is 0.
    public Material[] horizonMaterials; // The materials used by Horizon[ON]. We need to propagate the value changes through all of them.
    public int materialUsedAsReference; // Which of the materials will be taken for initializing the original values on start(We need to take a material that is on an active Horizon[ON] gameobject).
    public Material terrainMaterial; // Usually you would use a proper terrain shader for your closup terrain(I highly recommend RTP). But of course i can not include a 3rd party product. So we are missusing the Horizon[ON] Object shader for our closup terrain.
    public GameObject objectSwitchGroup; // The Decoration Objects... used to disable them if the horizon topology changes, as the objects are fitted to a specific offset and displacement amount.

    [Range(500, 1500)] public float maskScrollSpeed; // How fast we can offset the mask texture.
    [Range(0.5f, 1.5f)] public float layerScrollSpeed = 1; // How fast we can offset the layer textures.

    public float maxDisplacement = 200; // The maximum amount of displacement in meters.
    [Range(100, 500)] public float dispChangeSpeed = 300; // How fast we can change the displacement.

    public float snowHeightWinter = 68; // This is used to bring down the snow from the mountains to the whole scene in winter.
    public float snowHeightTransitionWinter = 760; // This is used to bring down the snow from the mountains to the whole scene in winter.

    public bool allowKeyboardInput = false;

    Vector4 mapScaleOffset, layer1ScaleOffset, layer2ScaleOffset, layer3ScaleOffset, layer4ScaleOffset; // The current texture offsets for the mask and the layers.
    float displacementAmount, globalNormalMapIntensity, detailNormalMapIntensity, fogAmount, snowAmount, snowHeight, snowHeightTransition, waterWaves; // The current displacement/bumpmap intensity, fog and snow amount values.

    // The Original Values
    Vector4 mOrig, l1Orig, l2Orig, l3Orig, l4Orig;
    float dispOrig, gnmOrig, dnmOrig, fogOrig, snowOrig, snowHOrig, snowHTOrig, wavesOrig;

    bool specialkey = false; // Is the shift key pressed?


    void Start()
    {
        // Getting the original Values on Start (Note: this assumes that all materials have the same feature set, which should almost always be the case, if not checking would need to be a bit more complex)
        if (horizonMaterials[materialUsedAsReference].HasProperty("_MapScaleOffset")) mapScaleOffset = horizonMaterials[materialUsedAsReference].GetVector("_MapScaleOffset");
        if (horizonMaterials[materialUsedAsReference].HasProperty("_BaseColormap_ST")) layer1ScaleOffset = horizonMaterials[materialUsedAsReference].GetVector("_BaseColormap_ST");
        if (horizonMaterials[materialUsedAsReference].HasProperty("_BlendColorMap1_ST")) layer2ScaleOffset = horizonMaterials[materialUsedAsReference].GetVector("_BlendColorMap1_ST");
        if (horizonMaterials[materialUsedAsReference].HasProperty("_BlendColormap2_ST")) layer3ScaleOffset = horizonMaterials[materialUsedAsReference].GetVector("_BlendColormap2_ST");
        if (horizonMaterials[materialUsedAsReference].HasProperty("_BlendColormap3_ST")) layer4ScaleOffset = horizonMaterials[materialUsedAsReference].GetVector("_BlendColormap3_ST");
        if (horizonMaterials[materialUsedAsReference].HasProperty("_GlobalNormalmapIntensity")) globalNormalMapIntensity = horizonMaterials[materialUsedAsReference].GetFloat("_GlobalNormalmapIntensity");
        if (horizonMaterials[materialUsedAsReference].HasProperty("_DetailNormalmapIntensity")) detailNormalMapIntensity = horizonMaterials[materialUsedAsReference].GetFloat("_DetailNormalmapIntensity");
        if (horizonMaterials[materialUsedAsReference].HasProperty("_OverlayFogAmount")) fogAmount = horizonMaterials[materialUsedAsReference].GetFloat("_OverlayFogAmount");
        //if (horizonMaterials[materialUsedAsReference].HasProperty("_SnowAmount")) snowAmount = horizonMaterials[materialUsedAsReference].GetFloat("_SnowAmount");
        if (horizonMaterials[materialUsedAsReference].HasProperty("_SnowHeight")) snowHeight = horizonMaterials[materialUsedAsReference].GetFloat("_SnowHeight");
        if (horizonMaterials[materialUsedAsReference].HasProperty("_SnowHeightTransition")) snowHeightTransition = horizonMaterials[materialUsedAsReference].GetFloat("_SnowHeightTransition");
        if (horizonMaterials[materialUsedAsReference].HasProperty("_WaterWaves")) waterWaves = horizonMaterials[materialUsedAsReference].GetFloat("_WaterWaves");
        for (int i = 0; i < horizonMaterials.Length; i++) // Not all Materials neccesarily have Displacement so we need to loop and find the first one that has displacement
        {
            if (horizonMaterials[i].HasProperty("_Parallax"))
            {
                displacementAmount = horizonMaterials[i].GetFloat("_Parallax");
                break;
            }
        }
        if (terrainMaterial.HasProperty("_OverlayFogAmount")) { terrainMaterial.SetFloat("_OverlayFogAmount", fogAmount); }
        //if (terrainMaterial.HasProperty("_SnowAmount")) { terrainMaterial.SetFloat("_SnowAmount", snowAmount); }
        if (terrainMaterial.HasProperty("_SnowHeight")) { terrainMaterial.SetFloat("_SnowHeight", snowHeight); }
        if (terrainMaterial.HasProperty("_SnowHeightTransition")) { terrainMaterial.SetFloat("_SnowHeightTransition", snowHeightTransition); }
        // Saving the original values so we can reset them if needed
        mOrig = mapScaleOffset;
        l1Orig = layer1ScaleOffset;
        l2Orig = layer2ScaleOffset;
        l3Orig = layer3ScaleOffset;
        l4Orig = layer4ScaleOffset;
        dispOrig = displacementAmount;
        gnmOrig = globalNormalMapIntensity;
        dnmOrig = detailNormalMapIntensity;
        fogOrig = fogAmount;
        snowOrig = snowAmount;
        snowHOrig = snowHeight;
        snowHTOrig = snowHeightTransition;
        wavesOrig = waterWaves;
    } //=========================================================================================================

    void OnDisable()
    {
        EnableHorizon(); // Reenabling Horizon[ON] in case it was disabled while pressing stop in Unity
        Reset(); // Resetting the values when we stop playmode. You could disable this and use the playmode to find the right settings for your scenes(in the Tools section of the Horizon[On] Master you can set if it gets updated by materials).
    } 
    public void EnableHorizon()
    {
        if (horizonParent != null) horizonParent.SetActive(true);
        if (objectSwitchGroup != null) if (mapScaleOffset == mOrig && layer1ScaleOffset == l1Orig) objectSwitchGroup.SetActive(true);
    }
    public void DisableHorizon()
    {
        if (horizonParent != null) horizonParent.SetActive(false);
        if (objectSwitchGroup != null) objectSwitchGroup.SetActive(false);
    }



    void Update() // Mapping some functions to keys
    {
        if (mapScaleOffset != mOrig || layer1ScaleOffset != l1Orig || displacementAmount != dispOrig) objectSwitchGroup.SetActive(false);
        else if (horizonParent.activeInHierarchy) objectSwitchGroup.SetActive(true);

        if (allowKeyboardInput)
        {
            if (Input.GetKeyDown(KeyCode.H)) { DisableHorizon(); }
            else if (Input.GetKeyUp(KeyCode.H)) { EnableHorizon(); }

            // Check for SpecialKey
            if (Input.GetKey(KeyCode.LeftShift)) specialkey = true;
            else specialkey = false;

            // Reset All
            if (Input.GetKey(KeyCode.R)) Reset();

            // Move & Scale Horizonmask
            if (!specialkey)
            {
                // Scroll Horizonmask
                if (Input.GetKey(KeyCode.A)) { ScrollMaskLeftRight(+1); }
                if (Input.GetKey(KeyCode.D)) { ScrollMaskLeftRight(-1); }
                if (Input.GetKey(KeyCode.W)) { ScrollMaskUpDown(+1); }
                if (Input.GetKey(KeyCode.S)) { ScrollMaskUpDown(-1); }
                // Scale Horizonmask
                if (Input.GetKey(KeyCode.X)) { ScaleMask(+1); }
                if (Input.GetKey(KeyCode.Y)) { ScaleMask(-1); }
                // Displacement
                if (Input.GetKey(KeyCode.E)) { Displace(+1); }
                if (Input.GetKey(KeyCode.Q)) { Displace(-1); }
            }
            else
            {
                // Scroll Horizonmaps
                if (Input.GetKey(KeyCode.A)) { ScrollMapsLeftRight(+1); }
                if (Input.GetKey(KeyCode.D)) { ScrollMapsLeftRight(-1); }
                if (Input.GetKey(KeyCode.W)) { ScrollMapsUpDown(+1); }
                if (Input.GetKey(KeyCode.S)) { ScrollMapsUpDown(-1); }
                // Scale Horizonmaps
                if (Input.GetKey(KeyCode.X)) { ScaleMaps(-1); }
                if (Input.GetKey(KeyCode.Y)) { ScaleMaps(+1); }
                // Normalmap intesity
                if (Input.GetKey(KeyCode.E)) { Bump(+1); }
                if (Input.GetKey(KeyCode.Q)) { Bump(-1); }
            }

            if (Input.GetKey(KeyCode.Alpha1)) Fog(-1);
            if (Input.GetKey(KeyCode.Alpha2)) Fog(+1);

            if (Input.GetKey(KeyCode.Alpha3)) Snow(-1);
            if (Input.GetKey(KeyCode.Alpha4)) Snow(+1);
        }
    } //=========================================================================================================


    // Functions to offset/scale the mask texture:
    public void ScrollMaskLeftRight(float direction)
    {
        float pos = mapScaleOffset.z;
        pos += Time.deltaTime * maskScrollSpeed * direction;
        mapScaleOffset = new Vector4(mapScaleOffset.x, mapScaleOffset.y, pos, mapScaleOffset.w);
        MaskScaleOffset(mapScaleOffset);
    }
    public void ScrollMaskUpDown(float direction)
    {
        float pos = mapScaleOffset.w;
        pos += Time.deltaTime * maskScrollSpeed * direction;
        mapScaleOffset = new Vector4(mapScaleOffset.x, mapScaleOffset.y, mapScaleOffset.z, pos);
        MaskScaleOffset(mapScaleOffset);
    }
    public void ScaleMask(float direction)
    {
        float scale = mapScaleOffset.x;
        scale += Time.deltaTime * maskScrollSpeed * 12 * direction;
        scale = Mathf.Clamp(scale, 5000, 30000);
        mapScaleOffset = new Vector4(scale, scale, 0, 0);
        MaskScaleOffset(mapScaleOffset);
    }//===================================================================================================================================================================
    void MaskScaleOffset(Vector4 scaleOffset)
    {
        foreach (Material m in horizonMaterials) { if (m.HasProperty("_MapScaleOffset")) m.SetVector("_MapScaleOffset", scaleOffset); }
        SwitchHorizonType();
    }//===================================================================================================================================================================


    // Functions to offset/scale the layer textures:
    public void ScrollMapsLeftRight(float direction)
    {
        float pos1 = layer1ScaleOffset.z;
        pos1 += Time.deltaTime * (layerScrollSpeed * 0.1f) * layer1ScaleOffset.x * direction;
        float pos2 = layer2ScaleOffset.z;
        pos2 += Time.deltaTime * (layerScrollSpeed * 0.1f) * layer2ScaleOffset.x * direction;
        float pos3 = layer3ScaleOffset.z;
        pos3 += Time.deltaTime * (layerScrollSpeed * 0.1f) * layer3ScaleOffset.x * direction;
        float pos4 = layer4ScaleOffset.z;
        pos4 += Time.deltaTime * (layerScrollSpeed * 0.1f) * layer4ScaleOffset.x * direction;
        layer1ScaleOffset = new Vector4(layer1ScaleOffset.x, layer1ScaleOffset.y, pos1, layer1ScaleOffset.w);
        layer2ScaleOffset = new Vector4(layer2ScaleOffset.x, layer2ScaleOffset.y, pos2, layer2ScaleOffset.w);
        layer3ScaleOffset = new Vector4(layer3ScaleOffset.x, layer3ScaleOffset.y, pos3, layer3ScaleOffset.w);
        layer4ScaleOffset = new Vector4(layer4ScaleOffset.x, layer4ScaleOffset.y, pos4, layer4ScaleOffset.w);
        MapsScaleOffset(layer1ScaleOffset, layer2ScaleOffset, layer3ScaleOffset, layer4ScaleOffset);
    }
    public void ScrollMapsUpDown(float direction)
    {
        float pos1 = layer1ScaleOffset.w;
        pos1 += Time.deltaTime * (layerScrollSpeed * 0.1f) * layer1ScaleOffset.x * direction;
        float pos2 = layer2ScaleOffset.w;
        pos2 += Time.deltaTime * (layerScrollSpeed * 0.1f) * layer2ScaleOffset.x * direction;
        float pos3 = layer3ScaleOffset.w;
        pos3 += Time.deltaTime * (layerScrollSpeed * 0.1f) * layer3ScaleOffset.x * direction;
        float pos4 = layer4ScaleOffset.w;
        pos4 += Time.deltaTime * (layerScrollSpeed * 0.1f) * layer4ScaleOffset.x * direction;
        layer1ScaleOffset = new Vector4(layer1ScaleOffset.x, layer1ScaleOffset.y, layer1ScaleOffset.z, pos1);
        layer2ScaleOffset = new Vector4(layer2ScaleOffset.x, layer2ScaleOffset.y, layer1ScaleOffset.z, pos2);
        layer3ScaleOffset = new Vector4(layer3ScaleOffset.x, layer3ScaleOffset.y, layer1ScaleOffset.z, pos3);
        layer4ScaleOffset = new Vector4(layer4ScaleOffset.x, layer4ScaleOffset.y, layer1ScaleOffset.z, pos4);
        MapsScaleOffset(layer1ScaleOffset, layer2ScaleOffset, layer3ScaleOffset, layer4ScaleOffset);
    }
    public void ScaleMaps(float direction)
    {
        float scale1 = layer1ScaleOffset.x;
        scale1 += Time.deltaTime * layerScrollSpeed * 0.1f * 6 * l1Orig.x * l1Orig.x * direction;
        scale1 = Mathf.Clamp(scale1, l1Orig.x / 2, l1Orig.x * 2);
        float scale2 = layer2ScaleOffset.x;
        scale2 += Time.deltaTime * layerScrollSpeed * 0.1f * 6 * l2Orig.x * l2Orig.x * direction;
        scale2 = Mathf.Clamp(scale2, l2Orig.x / 2, l2Orig.x * 2);
        float scale3 = layer3ScaleOffset.x;
        scale3 += Time.deltaTime * layerScrollSpeed * 0.1f * 3 * l3Orig.x * l3Orig.x * direction;
        scale3 = Mathf.Clamp(scale3, l3Orig.x / 2, l3Orig.x * 2);
        float scale4 = layer4ScaleOffset.x;
        scale4 += Time.deltaTime * layerScrollSpeed * 0.1f * 0.8f * l4Orig.x * l4Orig.x * direction;
        scale4 = Mathf.Clamp(scale4, l4Orig.x / 2, l4Orig.x * 2);
        layer1ScaleOffset = new Vector4(scale1, scale1, 0, 0);
        layer2ScaleOffset = new Vector4(scale2, scale2, 0, 0);
        layer3ScaleOffset = new Vector4(scale3, scale3, 0, 0);
        layer4ScaleOffset = new Vector4(scale4, scale4, 0, 0);
        MapsScaleOffset(layer1ScaleOffset, layer2ScaleOffset, layer3ScaleOffset, layer4ScaleOffset);
        ResetMaskPos();
    } //===================================================================================================================================================================
    void MapsScaleOffset(Vector4 scaleOffsetLayer1, Vector4 scaleOffsetLayer2, Vector4 scaleOffsetLayer3, Vector4 scaleOffsetLayer4)
    {
        foreach (Material m in horizonMaterials)
        {
            if (m.HasProperty("_BaseColormap_ST")) { m.SetVector("_BaseColormap_ST", scaleOffsetLayer1); }
            if (m.HasProperty("_BlendColorMap1_ST")) { m.SetVector("_BlendColorMap1_ST", scaleOffsetLayer2); }
            if (m.HasProperty("_BlendColormap2_ST")) { m.SetVector("_BlendColormap2_ST", scaleOffsetLayer3); }
            if (m.HasProperty("_BlendColormap3_ST")) { m.SetVector("_BlendColormap3_ST", scaleOffsetLayer4); }
        }
        SwitchHorizonType();
    }
    void ResetMaskPos() // When we scale the maps, the offset gets resetted as it would be more complex(but definitely doable) to scale from the offsetted center in the textures.
    {
        mapScaleOffset = new Vector4(mapScaleOffset.x, mapScaleOffset.y, 0, 0);
        foreach (Material m in horizonMaterials) { if (m.HasProperty("_MapScaleOffset")) m.SetVector("_MapScaleOffset", mapScaleOffset); }
        SwitchHorizonType();
    } //===================================================================================================================================================================


    // Function to change the displacement amount.
    public void Displace(float direction)
    {
        displacementAmount += Time.deltaTime * dispChangeSpeed* direction;
        displacementAmount = Mathf.Clamp(displacementAmount, 0, maxDisplacement);
        foreach (Material m in horizonMaterials) { if (m.HasProperty("_Parallax")) m.SetFloat("_Parallax", displacementAmount); }
        SwitchHorizonType();
    }//===================================================================================================================================================================


    public void SwitchHorizonType()
    {
        if (MapsAreAtDefaultValues())
        {
            horizonBaked.SetActive(true);
            horizonDisplaced.SetActive(false);
            horizonFlat.SetActive(false);
        }
        else if (displacementAmount > 0)
        {
            horizonBaked.SetActive(false);
            horizonDisplaced.SetActive(true);
            horizonFlat.SetActive(false);
        }
        else
        {
            horizonBaked.SetActive(false);
            horizonDisplaced.SetActive(false);
            horizonFlat.SetActive(true);
        }
    }//===================================================================================================================================================================

    // Function to change the bump amount.
    public void Bump(float direction)
    {
        globalNormalMapIntensity += Time.deltaTime * 0.9f * direction;
        globalNormalMapIntensity = Mathf.Clamp(globalNormalMapIntensity, 0, 1);
        detailNormalMapIntensity += Time.deltaTime * 0.9f * direction;
        detailNormalMapIntensity = Mathf.Clamp(globalNormalMapIntensity, 0, dnmOrig);
        foreach (Material m in horizonMaterials)
        {
            if (m.HasProperty("_GlobalNormalmapIntensity")) { m.SetFloat("_GlobalNormalmapIntensity", globalNormalMapIntensity); }
            if (m.HasProperty("_DetailNormalmapIntensity")) { m.SetFloat("_DetailNormalmapIntensity", detailNormalMapIntensity); }
        }
    }//===================================================================================================================================================================


    // Function to change the fog amount.
    public void Fog(float direction)
    {
        fogAmount += Time.deltaTime * 0.25f * direction;
        fogAmount = Mathf.Clamp(fogAmount, 0, 1);
        
        foreach (Material m in horizonMaterials)
        {
            if (m.HasProperty("_OverlayFogAmount")) { m.SetFloat("_OverlayFogAmount", fogAmount); }
        }
        if (terrainMaterial.HasProperty("_OverlayFogAmount")) { terrainMaterial.SetFloat("_OverlayFogAmount", fogAmount); }
    }//===================================================================================================================================================================


    // Function to change the snow amount.
    public void Snow(float direction)
    {
        snowAmount += Time.deltaTime * 0.2f * direction;
        snowAmount = Mathf.Clamp(snowAmount, 0, 1);
        snowHeight = Mathf.Lerp(snowHOrig, snowHeightWinter, snowAmount);
        snowHeightTransition = Mathf.Lerp(snowHTOrig, snowHeightTransitionWinter, snowAmount);

        foreach (Material m in horizonMaterials)
        {
            //if (m.HasProperty("_SnowAmount")) { m.SetFloat("_SnowAmount", snowAmount); }
            if (m.HasProperty("_SnowHeight")) { m.SetFloat("_SnowHeight", snowHeight); }
            if (m.HasProperty("_SnowHeightTransition")) { m.SetFloat("_SnowHeightTransition", snowHeightTransition); }
            if (m.HasProperty("_WaterWaves")) { m.SetFloat("_WaterWaves", 0.25f-(snowAmount*0.25f)); }
        }
        //if (terrainMaterial.HasProperty("_SnowAmount")) { terrainMaterial.SetFloat("_SnowAmount", snowAmount); }
        if (terrainMaterial.HasProperty("_SnowHeight")) { terrainMaterial.SetFloat("_SnowHeight", snowHeight); }
        if (terrainMaterial.HasProperty("_SnowHeightTransition")) { terrainMaterial.SetFloat("_SnowHeightTransition", snowHeightTransition); }
    }//===================================================================================================================================================================


    // Function to reset the values to how they were on start.
    public void Reset()
    {
        if (horizonBaked != null) horizonBaked.SetActive(true);
        if (horizonDisplaced != null) horizonDisplaced.SetActive(false);
        if (horizonFlat != null) horizonFlat.SetActive(false);

        mapScaleOffset = mOrig;
        layer1ScaleOffset = l1Orig;
        layer2ScaleOffset = l2Orig;
        layer3ScaleOffset = l3Orig;
        layer4ScaleOffset = l4Orig;
        displacementAmount = dispOrig;
        globalNormalMapIntensity = gnmOrig;
        detailNormalMapIntensity = dnmOrig;
        fogAmount = fogOrig;
        snowAmount = snowOrig;
        snowHeight = snowHOrig;
        snowHeightTransition = snowHTOrig;
        waterWaves = wavesOrig;

        foreach (Material m in horizonMaterials)
        {
            if (m.HasProperty("_MapScaleOffset")) m.SetVector("_MapScaleOffset", mapScaleOffset);
            if (m.HasProperty("_BaseColormap_ST")) m.SetVector("_BaseColormap_ST", layer1ScaleOffset);
            if (m.HasProperty("_BlendColorMap1_ST")) m.SetVector("_BlendColorMap1_ST", layer2ScaleOffset);
            if (m.HasProperty("_BlendColormap2_ST")) m.SetVector("_BlendColormap2_ST", layer3ScaleOffset);
            if (m.HasProperty("_BlendColormap3_ST")) m.SetVector("_BlendColormap3_ST", layer4ScaleOffset);
            if (m.HasProperty("_Parallax")) m.SetFloat("_Parallax", displacementAmount);
            if (m.HasProperty("_GlobalNormalmapIntensity")) m.SetFloat("_GlobalNormalmapIntensity", globalNormalMapIntensity);
            if (m.HasProperty("_DetailNormalmapIntensity")) m.SetFloat("_DetailNormalmapIntensity", detailNormalMapIntensity);
            if (m.HasProperty("_OverlayFogAmount")) m.SetFloat("_OverlayFogAmount", fogAmount);
            //if (m.HasProperty("_SnowAmount")) m.SetFloat("_SnowAmount", snowAmount);
            if (m.HasProperty("_SnowHeight")) m.SetFloat("_SnowHeight", snowHeight);
            if (m.HasProperty("_SnowHeightTransition")) m.SetFloat("_SnowHeightTransition", snowHeightTransition);
            if (m.HasProperty("_WaterWaves")) m.SetFloat("_WaterWaves", 0.25f - (snowAmount * 0.25f));
        }
        if (terrainMaterial.HasProperty("_OverlayFogAmount")) { terrainMaterial.SetFloat("_OverlayFogAmount", fogAmount); }
        //if (terrainMaterial.HasProperty("_SnowAmount")) { terrainMaterial.SetFloat("_SnowAmount", snowAmount); }
        if (terrainMaterial.HasProperty("_SnowHeight")) terrainMaterial.SetFloat("_SnowHeight", snowHeight);
        if (terrainMaterial.HasProperty("_SnowHeightTransition")) terrainMaterial.SetFloat("_SnowHeightTransition", snowHeightTransition);
    }
    public bool MapsAreAtDefaultValues()
    {
        if ( mapScaleOffset == mOrig && layer1ScaleOffset == l1Orig && displacementAmount == dispOrig) return true;
        else return false;
    }


    //Functions to be called from UI buttons:
    public void ScrollMaskLeft() { ScrollMaskLeftRight(+1); }
    public void ScrollMaskRight() { ScrollMaskLeftRight(-1); }
    public void ScrollMaskUp() { ScrollMaskUpDown(+1); }
    public void ScrollMaskDown() { ScrollMaskUpDown(-1); }
    public void ScaleMaskUp() { ScaleMask(+1); }
    public void ScaleMaskDown() { ScaleMask(-1); }

    public void ScrollMapsLeft() { ScrollMapsLeftRight(+1); }
    public void ScrollMapsRight() { ScrollMapsLeftRight(-1); }
    public void ScrollMapsUp() { ScrollMapsUpDown(+1); }
    public void ScrollMapsDown() { ScrollMapsUpDown(-1); }
    public void ScaleMapsUp() { ScaleMaps(+1); }
    public void ScaleMapsDown() { ScaleMaps(-1); }

    public void DisplacePlus() { Displace(+1); }
    public void DisplaceMinus() { Displace(-1); }
    public void BumpPlus() { Bump(+1); }
    public void BumpMinus() { Bump(-1); }

    public void FogPlus() { Fog(+1); }
    public void FogMinus() { Fog(-1); }
    public void SnowPlus() { Snow(+1); }
    public void SnowMinus() { Snow(-1); }
}