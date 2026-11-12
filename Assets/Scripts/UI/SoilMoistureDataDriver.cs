using UnityEngine;

public class SoilMoistureDataDriver : MonoBehaviour
{
    [Header("Soil Data")]
    [Range(0f, 1f)]
    public float rootMoisture = 0.4f;

    [Range(0.01f, 1f)]
    public float rootZoneDepth = 0.35f;

    [Range(0f, 1f)]
    public float waterLevel = 0.25f;

    private Renderer[] soilRenderers;
    private MaterialPropertyBlock block;

    void Awake()
    {
        // Find all Mesh Renderers under SoilSidePanel
        soilRenderers = GetComponentsInChildren<MeshRenderer>(true);

        block = new MaterialPropertyBlock();

        Debug.Log("Found soil renderers: " + soilRenderers.Length);
    }

    void Update()
    {
        foreach (Renderer renderer in soilRenderers)
        {
            renderer.GetPropertyBlock(block);

            block.SetFloat("_RootMoisture", rootMoisture);
            block.SetFloat("_RootZoneDepth", rootZoneDepth);
            block.SetFloat("_WaterLevel", waterLevel);

            renderer.SetPropertyBlock(block);
        }
    }

        public void SetSoilData(
        float moisture,
        float rootDepth,
        float groundwater)
    {
        rootMoisture = Mathf.Clamp01(moisture);
        rootZoneDepth = Mathf.Clamp(rootDepth, 0.01f, 1f);
        waterLevel = Mathf.Clamp01(groundwater);

        ApplySoilData();
    }

    private void ApplySoilData()
    {
        foreach (Renderer renderer in soilRenderers)
        {
            renderer.GetPropertyBlock(block);

            block.SetFloat("_RootMoisture", rootMoisture);
            block.SetFloat("_RootZoneDepth", rootZoneDepth);
            block.SetFloat("_WaterLevel", waterLevel);

            renderer.SetPropertyBlock(block);
        }
    }
}
