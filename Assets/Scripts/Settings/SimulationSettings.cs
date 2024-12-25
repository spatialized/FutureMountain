using System.Collections;
using UnityEngine;

/// <summary>
/// Tree settings class.
/// </summary>
public class SimulationSettings : MonoBehaviour
{
    /* Build Settings */
    [Header("Data")]
    [Tooltip("Load Cube Data Only (for testing)")]
    public bool CubeDataOnly = false;                   // Only load cube data (true) or run landscape simulation (false)
    public bool BuildForWeb = true;                     // Build for web (TO DO)

    /* Fire Settings */
    [Header("Fire")]
    [Tooltip("Pause simulation automatically during fire")]
    public bool AutoPauseOnFire = false;                  // Pause simulation during fire
    [Tooltip("Minimum fire length in frames (when Auto Pause Off)")]
    public int MinFireFrameLength = 6;                    // Minimum fire frame length
    [Tooltip("Length of fire in seconds (when Auto Pause On)")]
    public float MaxFireLengthInSec = 3f;                 // Cube fire length in sec.
    [Tooltip("Simulation time step above which immediate fire is triggered (i.e. no fire spread) (when Auto Pause Off)")]
    public int ImmediateFireTimeThreshold = 10;           // Simulation time step above which immediate fire is triggered (i.e. no fire spread)

    /* Vegetation Settings */
    [Header("Population")]
    [Tooltip("Minimum trees at front of each cube")]
    public int MinFrontTrees = 2;                       // Min. trees at front of each cube
    [Tooltip("Maximum number of grown trees per cube")]
    public int MaxTrees = 40;                           // Maximum number of grown trees in cube
    [Tooltip("Maximum number of grown shrubs per cube")]
    public int MaxShrubs = 100;                         // Maximum number of grown shrubs in cube
    [Tooltip("Multiplier for max. trees and max. shrubs when building for web")]
    public float WebBuildMaxVegMultiplier = 0.5f;       // Multiplier for max. trees and max. shrubs when building for web

    [Header("Distribution")]
    [Tooltip("Minimum tree spacing")]
    public float TreeMinSpacing = 0.5f;                 // Tree min. spacing
    [Tooltip("Distance from edge at which trees start growing")]
    public float CubeTreePadding = 5f;                  // Distance from edge at which trees start growing
    [Tooltip("Distance from edge at which trees start growing (Aggregate Cube)")]
    public float AggregateTreePadding = 6f;             // Distance from edge at which trees start growing (Aggregate Cube)

    [Header("Carbon")]
    [Tooltip("Stem + leaf carbon per m. of tree height (lower value means more trees)")]
    public float TreeCarbonFactor = 0.033f;              // Stem + leaf carbon per m. of tree height (lower => more trees)
    [Tooltip("Carbon per m. of root height")]
    public float RootsCarbonFactor = 0.01f;              // Carbon per m. of root height
    [Tooltip("Stem + leaf carbon per m. of shrub height  (lower means more shrubs)")]
    public float ShrubCarbonFactor = 0.01f;              // Stem + leaf carbon per m. of shrub height  (lower => more shrubs)
    [Tooltip("Aggregate Cube Stem + leaf carbon per m. of tree height (lower means more trees)")]
    public float CubeATreeCarbonFactor = 0.018f;         // Aggregate Cube Stem + leaf carbon per m. of tree height (lower => more trees)
    [Tooltip("Aggregate Cube Carbon per m. of root height")]
    public float CubeARootsCarbonFactor = 0.005f;        // Aggregate Cube Carbon per m. of root height
    [Tooltip("Aggregate Cube Stem + leaf carbon per m. of shrub height  (lower means more shrubs)")]
    public float CubeAShrubCarbonFactor = 0.005f;        // Aggregate Cube Stem + leaf carbon per m. of shrub height  (lower => more shrubs)
    [Tooltip("Multiplier for carbon factor variables when building for web")]
    public float WebBuildCarbonMultiplier = 2f;          // Multiplier for carbon factor variables when building for web

    [Header("Emission")]
    [Tooltip("Tree particle emission factor")]
    public float TreeParticleEmissionFactor = 1.2f;              // Tree particle emission factor
    public float AggregateShrubParticleEmissionFactor = 0.33f;   // Shrub particle emission factor for Aggregate Cube
    public float ShrubParticleEmissionFactor = 0.15f;            // Shrub particle emission factor for normal Cubes

    [Header("Geometry")]
    [Tooltip("Tree Height Offset (m.) from Sample Cube terrain")]
    public float TreeHeightOffset = 5f;                  // Tree Height Offset (m.) from Sample Cube terrain   
    [Tooltip("Shrub Height Offset (m.) from Sample Cube terrain")]
    public float ShrubHeightOffset = 0.1f;               // Shrub Height Offset (m.) from Sample Cube terrain

    public float MinTreeFullHeightScale = 0.7f;          // Min. tree grown height scale
    public float MaxTreeFullHeightScale = 0.9f;          // Max. tree grown height scale
    public float MinTreeFullWidth = 1f;                  // Min. tree grown width scale
    public float MaxTreeFullWidth = 1.25f;               // Max. tree grown width scale
    public float TreeWidthVariability = 0.3f;            // Variability of tree width from height

    [Header("Roots")]
    public float MinRootsFullHeightScale = 1.4f;         // Min. tree grown height scale
    public float MaxRootsFullHeightScale = 1.8f;         // Max. tree grown height scale
    public float MinRootsFullWidth = 1.4f;               // Min. tree grown width scale
    public float MaxRootsFullWidth = 1.8f;               // Max. tree grown width scale

    public float RootsGrowthSpeedFactor = 0.0025f;       // Root Y growth increment
    public float RootsSizeRatio = 0.8f;                  // Root height / width ratio
    public float RootsYOffsetFactor = 0f;                // Roots height to Y offset scaling
    public float RootsWidthVariability = 0.2f;           // Variability of tree width from height

    [Header("Time")]
    public float TreeGrowthSpeedFactor = 0.00033f;       // Growth speed factor
    public float TreeDeathSpeed = 0.1f;                  // Death speed 
    public float DeadTreeShrinkFactor = 0.045f;          // Percent to shrink dead tree litter by each frame

    /* Side-by-Side Mode Settings*/
    [Header("Side-by-Side Mode")]
    public float SideBySideModeXOffsetAggregate = 100f;            // Spacing between Side-by-Side Cubes
    public float SideBySideModeXOffset = 80f;            // Spacing between Side-by-Side Cubes
    /* UI */
    [Header("UI")]
    public int MessageFramesLength = 90;                 // Message length (in frames)                       
    public float MessageMinLength = 8f;                  // Message min. length (in sec.)                       

    [Header("Debugging")]
    public bool DebugGame = false;                  // Debug game 
    public bool DebugModel = false;                 // Debug model (graph) display
    public bool DebugFire = false;                  // Debug fire
    public bool DebugDetailed = false;              // Detailed debugging

    ///* Litter */
    //public float DeadTreeShrinkFactor = 0.033f;         // Percent to shrink dead tree litter by each frame

    /// <summary>
    /// Start this instance. 
    /// </summary>
    void Start()
    {
        if(BuildForWeb)
            OptimizeForWeb();
    }

    public void OptimizeForWeb()
    {
        //Debug.Log("OptimizeForWeb()");
        MaxTrees = (int)(MaxTrees * WebBuildMaxVegMultiplier);   
        MaxShrubs = (int)(MaxShrubs * WebBuildMaxVegMultiplier);

        TreeMinSpacing = 0.65f;            

        TreeCarbonFactor *= WebBuildCarbonMultiplier;          
        RootsCarbonFactor *= WebBuildCarbonMultiplier;       
        ShrubCarbonFactor *= WebBuildCarbonMultiplier;       
        CubeATreeCarbonFactor *= WebBuildCarbonMultiplier;   
        CubeARootsCarbonFactor *= WebBuildCarbonMultiplier;  
        CubeAShrubCarbonFactor *= WebBuildCarbonMultiplier;  
    }
}
