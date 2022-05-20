using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

/* Derived classes control specific trees during simulation */
public abstract class TreeController : MonoBehaviour
{
    /* Debugging */
    protected bool debugTree = false;
    protected bool debugRoots = false;
    protected bool debugDetailed = false;

    /* Game Objects */
    protected GameObject treeObject;                        // Tree object 
    private List<GameObject> treePrefabs;                   // Tree prefab list
    private List<GameObject> rootsPrefabs;                  // Tree prefab list
    protected float[] treePrefabHeights;                    // Tree prefab heights (m.) at default scale (1)
    protected float[] treePrefabWidths;                     // Tree prefab heights (m.) at default scale (1)
    protected float[] rootsPrefabDepths;                    // Roots prefab heights (m.) at default scale (1)
    protected float[] rootsPrefabWidths;                    // Roots prefab heights (m.) at default scale (1)
    protected float deadTreePrefabHeight;                   // Dead tree prefab height (m.) at default scale (1)
    protected float deadTreePrefabWidth;                    // Dead tree prefab height (m.) at default scale (1)
    protected Vector2[] treePrefabScaleRanges;              // Scale ranges for each prefab to lead smoothly from 
    protected Vector2[] rootsPrefabScaleRanges;             // Scale ranges for each prefab to lead smoothly from 
    protected int treePrefabIdx;                            // Current tree prefab
    protected int rootsPrefabIdx;                           // Current tree prefab
    protected GameObject[] lodGroupObjects;                 // LOD Group objects
    protected GameObject[] rootsObjects;                    // Roots objects

    protected GameObject curLODGroup;                       // Current LOD group
    protected GameObject curRootsObject;                    // Current roots object
    protected GameObject deadTreePrefab;                    // Dead tree prefab
    public SERI_FireNodeChain fireNodeChain;             // Fire node chain associated with tree

    /* Settings */
    protected SimulationSettings settings;
    protected bool isFrontTree = false;             // Flag for tree in front of cube

    /* Geometry */
    protected Vector3 cubeNECorner, cubeSWCorner;   // Corners of cube
    protected float treefallPadding = 6f;           // Padding to avoid trees falling out of cube
    /* Graphics */
    protected Renderer treeLOD_0_Renderer;          // LOD 0 Renderer
    protected Renderer rootsLOD_0_Renderer;         // LOD 0 Renderer

    /* Timing */
    protected float deathStartTime;                 // Death start time

    /* Growth Settings */
    //protected float rootsYAnchorPosition;          // Roots Y anchor position
    private float[] prefabSizes;                     // Array to find size of next prefab while growing

    /* Simulation States */
    public bool alive = false;
    //public bool alive = false;
    public bool dying = false;

    /* Simulation Parameters */
    public int timeStep;
    protected float timeStepGrowthSpeedFactor = 1f / 7f;
    public float leafCarbon;                                // Leaf carbon amount
    public float stemCarbon;                                // Stem carbon amount -- Affect tree height
    public float rootCarbon;                                // Root carbon amount
    public float transpiration;                             // Moisture evaporated from leaves

    /* Visualization Settings */
    protected float particleEmissionFactor = 1f;	// Scaling from ET value to particle emission rate

    protected float treeCarbonFactor;               // Scaling of tree height to vegetation amount (to compare with stem+leaf carbon in data)
    protected float rootsCarbonFactor;              // Scaling of root height to roots amount to compare with root carbon in data   -- SHOULD ACCOUNT FOR WIDTH!

    /* Parameter Ranges */
    protected float maxStemCarbon;                  // Max stem carbon amount in cube data 
    protected float minStemCarbon;                  // Max stem carbon amount in cube data
    protected float maxLeafCarbon;                  // Max leaf carbon amount in cube data
    protected float minLeafCarbon;                  // Max leaf carbon amount in cube data
    protected float maxRootCarbon;                  // Max root carbon amount in cube data
    protected float minRootCarbon;                  // Max root carbon amount in cube data
    protected float maxTranspiration;               // Max transpiration amount in cube data
    protected float minTranspiration;               // Min transpiration amount in cube data

    /* Tree Settings */
    protected float treeHeightScale;                  // Current tree height scale
    protected float treeFullHeightScale;              // Tree height scale at fully grown state

    protected float treeWidthScale;                  // Current tree width scale
    protected float treeFullWidthScale;              // Tree width scale at fully grown state
    public float alphaCutoff;                        // Leaf shader alpha cutoff (Used for visualizing leaf carbon)   -- Unused

    /* Roots Settings */
    protected float rootsHeightScale;                  // Current tree height scale
    protected float rootsFullHeightScale;              // Roots height scale at fully grown state
    protected float rootsWidthScale;                  // Current roots width scale
    protected float rootsFullWidthScale;              // Roots width scale at fully grown state

    /* Particle System */
    protected ParticleSystem etParticles;
    public bool showParticles;
    public bool particlesEnabled;

    /* Map value to new range */
    public static float MapValue(float value, float from1, float to1, float from2, float to2)
    {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
    }

    /// <summary>
    /// Sets the vegetation minimum max ranges.
    /// </summary>
    /// <param name="newTranspirationMin">New transpiration minimum.</param>
    /// <param name="newTranspirationMax">New transpiration max.</param>
    /// <param name="newLeafCarbonMin">New leaf carbon minimum.</param>
    /// <param name="newLeafCarbonMax">New leaf carbon max.</param>
    /// <param name="newStemCarbonMin">New stem carbon minimum.</param>
    /// <param name="newStemCarbonMax">New stem carbon max.</param>
    /// <param name="newRootCarbonMin">New root carbon minimum.</param>
    /// <param name="newRootCarbonMax">New root carbon max.</param>
    public void SetMinMaxRanges(float newTranspirationMin, float newTranspirationMax, float newLeafCarbonMin, float newLeafCarbonMax,
                                 float newStemCarbonMin, float newStemCarbonMax, float newRootCarbonMin, float newRootCarbonMax)
    {
        minTranspiration = newTranspirationMin;
        maxTranspiration = newTranspirationMax;
        minRootCarbon = newRootCarbonMin;
        maxRootCarbon = newRootCarbonMax;
        minLeafCarbon = newLeafCarbonMin;
        maxLeafCarbon = newLeafCarbonMax;
        minStemCarbon = newStemCarbonMin;
        maxStemCarbon = newStemCarbonMax;
    }

    /// <summary>
    /// Grows the tree immediately or over time.
    /// </summary>
    /// <param name="immediate">If set to <c>true</c>, grows immediately to full height.</param>
    public bool Grow(bool immediate)
    {
        if (alive)
            return false;

        alive = true;
        dying = false;

        if (immediate)
        {
            InitializeScale(false);
        }
        else
        {
            InitializeScale(true);
        }

        ShowParticles();

        if (debugTree && debugDetailed)
            Debug.Log(transform.parent.transform.name + "   " + transform.name + ".Grow(" + immediate + ")" + " heightScale:" + GetHeightScale() + " carbon amount:" + GetCarbonAmount());

        return true;
    }

    /// <summary>
    /// Gets the carbon amount represented by this tree in simulation.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    public float GetCarbonAmount()
    {
        if (!alive)
            return 0f;
        else if (dying)
            return 0f;
        else if (transform.localScale.magnitude <= 0f)
            return 0f;
        else
        {
            return treeHeightScale * GetFullTreeHeight() * treeCarbonFactor;
        }
    }

    /// <summary>
    /// Sets whether to destroy fir after fire.
    /// </summary>
    /// <param name="destroyAfter">If set to <c>true</c> destroy after.</param>
    private void SetDestroyAfterFire(bool destroyAfter)
    {
        //SERI_FireNodeChain chain = GetComponent<SERI_FireNodeChain>() as SERI_FireNodeChain;
        fireNodeChain.SetDestroyAfterFire(destroyAfter);
    }

    /// <summary>
    /// Sets up the fire node chain.
    /// </summary>
    /// <param name="newNodeChain">New node chain.</param>
    public void InitFireNodeChain(SERI_FireNodeChain newNodeChain)
    {
        fireNodeChain = newNodeChain;
        SetDestroyAfterFire(true);
    }

    /// <summary>
    /// Ignite the specified immediate.
    /// </summary>
    /// <param name="immediate">If set to <c>true</c> immediate.</param>
    public void Ignite(bool immediate, int fireLengthInFrames)
    {
        fireNodeChain.enabled = true;                   // Make sure node chain is enabled
        if (debugTree)
            Debug.Log(transform.parent.transform.parent.transform.name + "... " + name + ".Ignite()... immediate:" + immediate);
        fireNodeChain.Ignite(transform.position, fireLengthInFrames);
    }

    /// <summary>
    /// Grows the tree incrementally.
    /// </summary>
    protected void GrowTree()
    {
        float newHeightScale, newWidthScale;
        float hDiff = treeFullHeightScale - GetHeightScale();
        float wDiff = treeFullWidthScale - GetWidthScale();

        /* Normal Growth */
        float heightGrowthAmount = settings.TreeGrowthSpeedFactor * timeStep;      // Slow height growth over time
        float widthGrowthAmount = settings.TreeGrowthSpeedFactor * timeStep;       // Increase width growth over time

        /* Near-Full-Height Growth */
        if (hDiff < 0.2f)
        {
            float gFactor = MapValue(hDiff, 0f, 0.2f, 0f, 1f);
            heightGrowthAmount = gFactor * settings.TreeGrowthSpeedFactor * timeStep;      // Slow height growth over time
        }

        newHeightScale = GetHeightScale() + heightGrowthAmount;
        newHeightScale = Mathf.Clamp(newHeightScale, 0f, treeFullHeightScale);

        /* Near-Full-Width Growth */
        if (wDiff < 0.2f)
        {
            float wFactor = MapValue(wDiff, 0f, 0.2f, 0f, 1f);
            widthGrowthAmount = wFactor * settings.TreeGrowthSpeedFactor * timeStep;     // Increase width growth over time
        }

        newWidthScale = GetWidthScale() + widthGrowthAmount;
        newWidthScale = Mathf.Clamp(newWidthScale, 0f, treeFullWidthScale);

        SetTreeScale(newHeightScale, newWidthScale, false);                    // Set scale and update LODs
    }

    /// <summary>
    /// Grows the roots.
    /// </summary>
    public void GrowRoots()
    {
        float newHeightScale, newWidthScale;
        float hDiff = treeFullHeightScale - GetRootsHeightScale();
        float wDiff = treeFullWidthScale - GetRootsWidthScale();

        /* Normal Growth */
        float heightGrowthAmount = settings.RootsGrowthSpeedFactor * timeStep;      // Slow height growth over time
        float widthGrowthAmount = settings.RootsGrowthSpeedFactor * timeStep;       // Increase width growth over time

        /* Near-Full-Height Growth */
        if (hDiff < 0.2f)
        {
            float gFactor = MapValue(hDiff, 0f, 0.2f, 0f, 1f);
            heightGrowthAmount = gFactor * settings.RootsGrowthSpeedFactor * timeStep;      // Slow height growth over time
        }

        newHeightScale = GetRootsHeightScale() + heightGrowthAmount;
        newHeightScale = Mathf.Clamp(newHeightScale, 0f, treeFullHeightScale);

        /* Near-Full-Width Growth */
        if (wDiff < 0.2f)
        {
            float wFactor = MapValue(wDiff, 0f, 0.2f, 0f, 1f);
            widthGrowthAmount = wFactor * settings.RootsGrowthSpeedFactor * timeStep;     // Increase width growth over time
        }

        newWidthScale = GetRootsWidthScale() + widthGrowthAmount;
        newWidthScale = Mathf.Clamp(newWidthScale, 0f, treeFullWidthScale);

        //if (debugRoots)
        //Debug.Log(transform.name + "      GrowRoots()...   oldHeight:" + GetRootsHeightScale() + "    GrowRoots()... oldWidth:"+ GetRootsWidthScale() + " newHeightScale:" + newHeightScale+ "  newWidthScale:" + newWidthScale);

        SetRootsScale(newHeightScale, newWidthScale, false);
    }

    /// <summary>
    /// Sets the current tree scale.
    /// </summary>
    /// <param name="newTreeHeightScale">New tree scale.</param>
    public void SetTreeScale(float newTreeHeightScale, float newTreeWidthScale, bool init)
    {
        treeHeightScale = newTreeHeightScale;
        treeWidthScale = newTreeWidthScale;

        //if(alive)
        //{
        if (treePrefabIdx >= 0 && treePrefabIdx < treePrefabs.Count - 1)        // Update tree prefab if not fully grown
            UpdateTreePrefab(init);
        //UpdateTreeLODsScale();                                  // Update LODs size
        //}
        //else
        //{
        //    SetCurrentTreePrefab(0);
        //}
        UpdateTreeLODsScale();                                  // Update LODs size
    }

    /// <summary>
    /// Updates the tree prefab.
    /// </summary>
    private void UpdateTreePrefab(bool init)
    {
        float currentHeight = treeHeightScale * GetFullTreeHeight();

        int newTreePrefabIdx = GetClosestFloatIdxLowerThan(treePrefabHeights, currentHeight);
        if (newTreePrefabIdx == -1) newTreePrefabIdx = 0;

        if (init || (treePrefabIdx != newTreePrefabIdx))
        {
            if (debugTree && debugDetailed)
                Debug.Log(transform.name + " UpdateTreePrefab()... GetTreeActualHeight():" + GetTreeActualHeight() + " Will set new prefab to:" + newTreePrefabIdx + " at size:" + treePrefabHeights[newTreePrefabIdx]);

            SetCurrentTreePrefab(newTreePrefabIdx, init);
        }

        //if (GetTreeActualHeight() >= treePrefabHeights[currentTreePrefabIdx + 1])
        //{
        //    if (debugTree)
        //        Debug.Log(transform.name + "UpdateTreePrefab()...  GetTreeHeight():" + GetTreeActualHeight() + "  nextPrefabSize:" + treePrefabHeights[currentTreePrefabIdx + 1] + " Will set new prefab to:" + (currentTreePrefabIdx + 1));

        //    SetCurrentTreePrefab(currentTreePrefabIdx + 1);
        //}
    }

    /// <summary>
    /// Sets the roots scale.
    /// </summary>
    /// <param name="newRootsHeightScale">New roots height scale.</param>
    /// <param name="newRootsWidthScale">New roots width scale.</param>
    public void SetRootsScale(float newRootsHeightScale, float newRootsWidthScale, bool init)
    {
        rootsHeightScale = newRootsHeightScale;
        rootsWidthScale = newRootsWidthScale;

        //if (alive)
        //{
        if (rootsPrefabIdx >= 0 && rootsPrefabIdx < rootsPrefabs.Count - 1)        // Update roots prefab if not fully grown
            UpdateRootsPrefab(init);
        UpdateRootsLODsScale();                                                   // Update LODs size
        //}

        //UpdateRootsLODsScale();                                                   // Update LODs size
    }

    /// <summary>
    /// Hides the LOD Groups.
    /// </summary>
    public void HideLODGroups()
    {
        int count = 0;
        while (count < treePrefabs.Count)
        {
            GameObject lodGroup = GetLODGroupObject(count);
            lodGroup.SetActive(false);
            count++;
        }
    }

    /// <summary>
    /// Hides the roots objects.
    /// </summary>
    public void HideRootsObjects()
    {
        int count = 0;
        while (count < rootsPrefabs.Count)
        {
            GameObject rootsObj = GetRootsObject(count);
            rootsObj.SetActive(false);
            count++;
        }
    }

    /// <summary>
    /// Updates the tree prefab.
    /// </summary>
    private void UpdateRootsPrefab(bool init)
    {
        float currentDepth = rootsHeightScale * GetFullRootsDepth();       // -- TESTING

        //float currentDepth = GetRootsActualDepth();
        //if (Mathf.Abs(-1f + currentDepth) < 0.0001f)
        //{
        //    Debug.Log(transform.name + " UpdateTreePrefab()... ERROR: Tree actual height returned -1... Setting currentDepth to:" + currentDepth + " from rootsHeightScale:" + rootsHeightScale + " for GetFullRootsDepth():" + GetFullRootsDepth());
        //    currentDepth = rootsHeightScale * GetFullRootsDepth();
        //}

        int newRootsPrefabIdx = GetClosestFloatIdxLowerThan(rootsPrefabDepths, currentDepth);
        if (newRootsPrefabIdx == -1) newRootsPrefabIdx = 0;

        if (init || (rootsPrefabIdx != newRootsPrefabIdx))
        {
            if (debugRoots && debugDetailed)
                Debug.Log(transform.name + " UpdateRootsPrefab()... GetRootsActualDepth():" + GetRootsActualDepth() + " Will set new prefab to:" + newRootsPrefabIdx + " at size:" + rootsPrefabDepths[newRootsPrefabIdx]);

            SetCurrentRootsPrefab(newRootsPrefabIdx, init);
        }
    }

    /// <summary>
    /// Initializes the tree scaling variables.
    /// </summary>
    /// <param name="startAtZero">If set to <c>true</c> start at zero.</param>
    private void InitializeScale(bool startAtZero)
    {
        float newTreeHeightScale;
        if (startAtZero)
            newTreeHeightScale = 0f;
        else
            newTreeHeightScale = UnityEngine.Random.Range(0f, treeFullHeightScale);

        float newTreeWidthScale = GetWidthScaleFromHeightScale(newTreeHeightScale, settings.TreeWidthVariability);
        float curHeight = newTreeHeightScale * GetFullTreeHeight();
        SetTreePrefabForHeight(curHeight, true);
        SetTreeScale(newTreeHeightScale, newTreeWidthScale, true);

        float factor = newTreeHeightScale / treeFullHeightScale;

        float newRootsHeightScale;
        if (startAtZero)
            newRootsHeightScale = 0f;
        else
            newRootsHeightScale = UnityEngine.Random.Range(0f, rootsFullHeightScale * factor);

        float newRootsWidthScale = GetWidthScaleFromHeightScale(newRootsHeightScale, settings.RootsWidthVariability);
        float curRootsDepth = newRootsHeightScale * GetFullRootsDepth();
        SetRootsPrefabForDepth(curRootsDepth, true);
        SetRootsScale(newRootsHeightScale, newRootsWidthScale, true);

        //Debug.Log(name + ".InitializeScale()... newTreeHeightScale:" + newTreeHeightScale + " factor:" + factor + " startAtZero:"+ startAtZero);
        //Debug.Log(name + ".InitializeScale()... newRootsHeightScale:" + newRootsHeightScale + " newRootsWidthScale:" + newRootsWidthScale + " curRootsDepth:" + curRootsDepth);
    }

    /// <summary>
    /// Sets the current prefab based on current size.
    /// </summary>
    /// <returns>The prefab for current size.</returns>
    protected void SetTreePrefabForHeight(float height, bool init)
    {
        int minIdx = GetClosestFloatIdxLowerThan(treePrefabHeights, height);
        if (minIdx == -1) minIdx = 0;

        if (debugTree && debugDetailed)
            Debug.Log(transform.name + " SetTreePrefabForHeight()... idx: " + minIdx);

        treePrefabIdx = minIdx;

        if (init)
            InitializeTreePrefab(treePrefabIdx);
    }

    /// <summary>
    /// Sets the current prefab based on given depth.
    /// </summary>
    /// <returns>The prefab for current size.</returns>
    protected void SetRootsPrefabForDepth(float depth, bool init)
    {
        int minIdx = GetClosestFloatIdxLowerThan(rootsPrefabDepths, depth);
        if (minIdx == -1) minIdx = 0;

        if (debugRoots && debugDetailed)
            Debug.Log(transform.name + " SetRootsPrefabForDepth()... roots idx: " + minIdx);

        rootsPrefabIdx = minIdx;

        if (init)
            InitializeRootsPrefab(rootsPrefabIdx);
    }

    /// <summary>
    /// Gets the index of value in list closest to and lower than given value.
    /// </summary>
    /// <returns>The closest float index lower than.</returns>
    /// <param name="floatList">Float list.</param>
    /// <param name="value">Value.</param>
    private int GetClosestFloatIdxLowerThan(float[] floatList, float value)
    {
        int count = 0;
        float diff = 100000f;
        float minDiff = 100000f;
        int minIdx = -1;

        foreach (float cValue in floatList)           // Find prefab height below tree height 
        {
            diff = value - cValue;
            //Debug.Log(transform.name + " count:" + count + " diff:" + diff + "  minIdx :" + minIdx + " cValue:" + cValue + " value:" + value + " floatList.Length:" + floatList.Length);

            if (diff > 0)
            {
                if (diff < minDiff)
                {
                    minDiff = diff;
                    minIdx = count;
                    //Debug.Log(transform.name + " Found new minDiff: " + minDiff + " at index:" + count);
                }
            }

            count++;
        }

        return minIdx;
    }

    /// <summary>
    /// Gets the full height of the tree (m.)
    /// </summary>
    /// <returns>The full tree height.</returns>
    protected float GetFullTreeHeight()
    {
        float height = treePrefabHeights[treePrefabHeights.Length - 1] * treeFullHeightScale;
        return height;
    }

    /// <summary>
    /// Gets the full roots depth (m.)
    /// </summary>
    /// <returns>The full roots depth.</returns>
    protected float GetFullRootsDepth()
    {
        float depth = rootsPrefabDepths[rootsPrefabDepths.Length - 1] * rootsFullWidthScale;
        return depth;
    }

    /// <summary>
    /// Gets the height of the tree (m.).
    /// </summary>
    /// <returns>The tree size (m.).</returns>
    public float GetTreeActualHeight()
    {
        if (treeLOD_0_Renderer != null)
            return treeLOD_0_Renderer.bounds.size.y;
        else
            return -1f;
    }

    /// <summary>
    /// Gets the width of the tree (m.).
    /// </summary>
    /// <returns>The tree size (m.).</returns>
    public float GetTreeActualWidth()
    {
        if (treeLOD_0_Renderer != null)
            return treeLOD_0_Renderer.bounds.size.x;
        else
            return -1f;
    }

    /// <summary>
    /// Gets the depth of the roots (m.).
    /// </summary>
    /// <returns>The roots depth (m.).</returns>
    public float GetRootsActualDepth()
    {
        if (rootsLOD_0_Renderer != null)
            return rootsLOD_0_Renderer.bounds.size.y;
        else
            return -1f;
    }

    /// <summary>
    /// Gets the current scale.
    /// </summary>
    /// <returns>The current scale.</returns>
    public float GetHeightScale()
    {
        return treeHeightScale;
    }

    /// <summary>
    /// Gets the current scale.
    /// </summary>
    /// <returns>The current scale.</returns>
    public float GetWidthScale()
    {
        return treeWidthScale;
    }

    /// <summary>
    /// Gets the current scale.
    /// </summary>
    /// <returns>The current scale.</returns>
    public float GetRootsHeightScale()
    {
        return rootsHeightScale;
    }

    /// <summary>
    /// Gets the current scale.
    /// </summary>
    /// <returns>The current scale.</returns>
    public float GetRootsWidthScale()
    {
        return rootsWidthScale;
    }

    /// <summary>
    /// Updates LODs scaling while growing.
    /// </summary>
    private void UpdateTreeLODsScale()
    {
        float hFactor = treePrefabHeights[treePrefabIdx] / treePrefabHeights[treePrefabHeights.Length - 1];   // Calculate diff. between prefab heights
        float newHeightScale = treeHeightScale / hFactor;                                                        // Adjust LODs scale to match full-grown height scale range
        float wFactor = treePrefabWidths[treePrefabIdx] / treePrefabWidths[treePrefabHeights.Length - 1];     // Calculate diff. between prefab widths
        float newWidthScale = treeWidthScale / wFactor;                                                          // Adjust LODs scale to match full-grown width scale range

        SetTreeLODsScale(newHeightScale, newWidthScale);                                                         // Set scale of LODs

        //GameObject lod0 = curLODGroup.transform.GetChild(0).gameObject as GameObject;
        //float value = lod0.transform.GetComponent<Renderer>().bounds.size.y;            // Get height of prefab (m.)

        //Debug.Log(transform.name + " UpdateLODsScale()...  TEST lod0.transform.GetComponent<Renderer>().bounds.size.y:" + value + " at scale:"+ newLODsScale);
    }

    /// <summary>
    /// Updates LODs scaling while growing.
    /// </summary>
    private void UpdateRootsLODsScale()
    {
        float hFactor = rootsPrefabDepths[rootsPrefabIdx] / rootsPrefabDepths[rootsPrefabDepths.Length - 1];     // Calculate diff. between prefab heights
        float newHeightScale = rootsHeightScale / hFactor;                                                       // Adjust LODs scale to match full-grown height scale range
        float wFactor = rootsPrefabDepths[rootsPrefabIdx] / rootsPrefabDepths[rootsPrefabDepths.Length - 1];     // Calculate diff. between prefab widths
        float newWidthScale = rootsWidthScale / wFactor;                                                         // Adjust LODs scale to match full-grown width scale range

        SetRootsLODsScale(newHeightScale, newWidthScale);                                                        // Set scale of LODs
        //SetRootsLODsScale(rootsHeightScale, rootsWidthScale);                                                  // Set scale of LODs

        //GameObject lod0 = curRootsObject.transform.GetChild(0).gameObject as GameObject;
        //float value = lod0.transform.GetComponent<Renderer>().bounds.size.y;                                   // Get height of prefab (m.)

        //Debug.Log(transform.name + " UpdateRootsLODsScale()...  newHeightScale:" + newHeightScale + " newWidthScale:" + newWidthScale+ " hFactor:"+ hFactor+" wFactor:"+wFactor+" rDepth:"+ rootsPrefabDepths[rootsPrefabDepths.Length - 1]);
    }

    /// <summary>
    /// Sets the tree LODs scale.
    /// </summary>
    /// <param name="newHeightScale">New height scale.</param>
    /// <param name="newWidthScale">New width scale.</param>
    private void SetTreeLODsScale(float newHeightScale, float newWidthScale)
    {
        if (curLODGroup != null)
        {
            for (int i = 0; i < curLODGroup.transform.childCount; i++)
            {
                GetLODInGroup(i, curLODGroup).transform.localScale = new Vector3(newWidthScale, newHeightScale, newWidthScale);
            }
        }
        else
        {
            Debug.Log(transform.name + " SetTreeLODsScale()... no curLODGroup!  alive:" + alive + " dying:" + dying);
            //SetCurrentTreePrefab(0);
        }
    }

    /// <summary>
    /// Sets the roots LODs scale.
    /// </summary>
    /// <param name="newHeightScale">New height scale.</param>
    /// <param name="newWidthScale">New width scale.</param>
    private void SetRootsLODsScale(float newHeightScale, float newWidthScale)
    {
        if (curRootsObject != null)
        {
            for (int i = 0; i < curRootsObject.transform.childCount; i++)
            {
                GetLODInGroup(i, curRootsObject).transform.localScale = new Vector3(newWidthScale, newHeightScale, newWidthScale);
            }
        }
        else
        {
            Debug.Log(transform.name + " SetRootsLODsScale()... no curRootsObject!  alive:" + alive + " dying:" + dying);
            //SetCurrentRootsPrefab(1);
        }
    }

    /// <summary>
    /// Shows the particles.
    /// </summary>
    protected void ShowParticles()
    {
        SetEmissionRate(transpiration * settings.TreeParticleEmissionFactor * GetHeightScale());
        etParticles.Play();
        showParticles = true;
    }

    /// <summary>
    /// Hides the particles.
    /// </summary>
    protected void StopParticles()
    {
        etParticles.Stop();
        SetEmissionRate(0);
        showParticles = false;
    }

    /// <summary>
    /// Sets the emission rate.
    /// </summary>
    /// <param name="newEmissionRate">New emission rate.</param>
    protected void SetEmissionRate(float newEmissionRate)
    {
        var emission = etParticles.emission;
        emission.rateOverTime = newEmissionRate;
        //emission.rateOverTime = (int)newEmissionRate;
    }

    /// <summary>
    /// Returns whether fir is alive
    /// </summary>
    /// <returns><c>true</c>, if alive and not dying, <c>false</c> otherwise.</returns>
    public bool IsAvailable()
    {
        //return !alive;
        return !alive && !dying;
    }

    /// <summary>
    /// Returns whether fir is alive
    /// </summary>
    /// <returns><c>true</c>, if alive and not dying, <c>false</c> otherwise.</returns>
    public bool IsAlive()
    {
        return alive;
    }

    /// <summary>
    /// Returns whether fir is dying
    /// </summary>
    /// <returns><c>true</c>, if dying, <c>false</c> otherwise.</returns>
    public bool IsDying()
    {
        return dying;
    }

    /// <summary>
    /// Hide and set tree to inactive.
    /// </summary>
    public void ClearTree()
    {
        alive = false;
        dying = false;
        //transform.localScale = Vector3.zero;
        StopParticles();
    }

    /// <summary>
    /// Gets scale of tree at full size.
    /// </summary>
    /// <returns>The scale at full size.</returns>
    public float GetFullScale()
    {
        return treeFullHeightScale;
    }

    /// <summary>
    /// Sets the current tree prefab.
    /// </summary>
    /// <param name="index">Index.</param>
    public void SetCurrentTreePrefab(int index, bool init)
    {
        if (debugTree && debugDetailed)
            Debug.Log(transform.name + " SetCurrentTreePrefab()... New index:" + index + "  treePrefabIdx:" + treePrefabIdx);

        if (init || (treePrefabIdx != index))
        {
            treePrefabIdx = index;

            if (curLODGroup != null)
            {
                if (!dying)
                {
                    //Debug.Log(transform.parent.transform.parent.transform.name + "   " + transform.name + " SetCurrentTreePrefab()... RESET LODS");
                    SetTreeLODsScale(1f, 1f);                                       // Reset LODs 
                    curLODGroup.SetActive(false);
                }
            }

            GameObject newLODGroup = transform.Find("LODGroup_" + index).gameObject;
            newLODGroup.SetActive(true);
            curLODGroup = newLODGroup;

            //SetTreeLODsScale(treeHeightScale, treeWidthScale);                                                         // Set scale of LODs
            UpdateTreeLODsScale();
            UpdateLODGroup();
            UpdateRenderer();
        }

        //UpdateLODGroup();
        //UpdateRenderer();
    }

    /// <summary>
    /// Sets the current tree prefab.
    /// </summary>
    /// <param name="index">Index.</param>
    public void SetCurrentRootsPrefab(int index, bool init)
    {
        if (debugRoots)
            Debug.Log(transform.name + " SetCurrentRootsPrefab()... index:" + index);

        if (init || (rootsPrefabIdx != index))
        {
            rootsPrefabIdx = index;

            if (curRootsObject != null)
            {
                //Debug.Log(transform.parent.transform.parent.transform.name + "   " + transform.name + " SetCurrentRootsPrefab()... RESET LODS");

                SetRootsLODsScale(1f, 1f);                  // Reset LODs
                curRootsObject.SetActive(false);
            }

            GameObject newRootsObject = transform.Find("Roots_" + index).gameObject;
            newRootsObject.SetActive(true);
            curRootsObject = newRootsObject;

            UpdateRootsLODsScale();
            UpdateRootsObject();
            UpdateRootsRenderer();
        }
    }


    /// <summary>
    /// Initializes the roots prefab.
    /// </summary>
    /// <param name="index">Index.</param>
    public void InitializeTreePrefab(int index)
    {
        if (debugTree && debugDetailed)
            Debug.Log(transform.name + " InitializeTreePrefab()... index:" + index);

        treePrefabIdx = index;

        GameObject newLODGroup = transform.Find("LODGroup_" + index).gameObject;
        newLODGroup.SetActive(true);
        curLODGroup = newLODGroup;

        UpdateTreeLODsScale();
        UpdateLODGroup();
        UpdateRenderer();
    }

    /// <summary>
    /// Initializes the roots prefab.
    /// </summary>
    /// <param name="index">Index.</param>
    public void InitializeRootsPrefab(int index)
    {
        if (debugRoots && debugDetailed)
            Debug.Log(transform.name + " InitializeRootsPrefab()... index:" + index);

        rootsPrefabIdx = index;

        GameObject newRootsObject = transform.Find("Roots_" + index).gameObject;
        newRootsObject.SetActive(true);
        curRootsObject = newRootsObject;

        UpdateRootsLODsScale();
        UpdateRootsObject();
        UpdateRootsRenderer();
    }

    /// <summary>
    /// Sets current prefab to dead tree model.
    /// </summary>
    public void SetDeadPrefab()
    {
        float currentHeight = GetTreeActualHeight();
        if (Mathf.Abs(-1f + currentHeight) < 0.0001f)
        {
            Debug.Log(transform.name + " SetDeadPrefab()... ERROR: Tree actual height returned -1");
        }

        //Debug.Log(transform.name + " SetDeadPrefab()... currentPrefabIdx:" + currentPrefabIdx + " deadTreePrefabSize:"+ deadTreePrefabSize);
        treePrefabIdx = 0;                   // Reset prefab index

        curLODGroup.SetActive(false);
        GameObject newLODGroup = transform.Find("LODGroup_DeadTree").gameObject;
        float newLODsScale = currentHeight / deadTreePrefabHeight * 0.75f;             // -- Why 0.75?

        /* Set dead tree object LOD scale */
        for (int i = 0; i < newLODGroup.transform.childCount; i++)
        {
            GetLODInGroup(i, newLODGroup).transform.localScale = Vector3.one * newLODsScale;
        }

        //if (debugTree)
        //Debug.Log(transform.name + "   SetDeadPrefab()... prefabHeight:" + prefabHeight + " deadTreePrefabSize:" + deadTreePrefabSize + " newScale:" + newLODsScale);

        newLODGroup.SetActive(true);
        curLODGroup = newLODGroup;

        UpdateRenderer();
    }

    /// <summary>
    /// Hides the dead prefab.
    /// </summary>
    protected void HideDeadTreeObjects()
    {
        GameObject oldLODGroup = transform.Find("LODGroup_DeadTree").gameObject;      // Reset dead tree object LOD scale
        for (int i = 0; i < oldLODGroup.transform.childCount; i++)
        {
            GetLODInGroup(i, oldLODGroup).transform.localScale = Vector3.one;
        }
        oldLODGroup.SetActive(false);
        for (int i = 0; i < curRootsObject.transform.childCount; i++)
        {
            GetLODInGroup(i, curRootsObject).transform.localScale = Vector3.one;
        }
        curRootsObject.SetActive(false);
    }

    /// <summary>
    /// Initializes the simulation settings.
    /// </summary>
    /// <param name="newSettings">New settings.</param>
    public void InitializeSettings(SimulationSettings newSettings)
    {
        settings = newSettings;
    }

    /// <summary>
    /// Initializes the geometry.
    /// </summary>
    public void InitializeGeometry()
    {
        treeFullHeightScale = UnityEngine.Random.Range(settings.MinTreeFullHeightScale, settings.MaxTreeFullHeightScale);
        treeFullWidthScale = GetWidthScaleFromHeightScale(treeFullHeightScale, settings.TreeWidthVariability);

        rootsFullHeightScale = UnityEngine.Random.Range(settings.MinRootsFullHeightScale, settings.MaxRootsFullHeightScale);
        rootsFullWidthScale = GetWidthScaleFromHeightScale(rootsFullHeightScale, settings.RootsWidthVariability);

        /* Set Height and Width Scale */
        //float newTreeHeightScale = UnityEngine.Random.Range(settings.MinTreeStartHeight, settings.MaxTreeStartHeight);
        //float newTreeWidthScale = GetWidthScaleFromHeightScale(newTreeHeightScale, settings.TreeWidthVariability);
        ////float newTreeWidthScale = UnityEngine.Random.Range(minStartWidthScale, maxStartWidthScale);
        //SetTreeScale(newTreeHeightScale, newTreeWidthScale);

        //float newRootsHeightScale = UnityEngine.Random.Range(settings.MinRootsStartHeight, settings.MaxRootsStartHeight);
        //float newRootsWidthScale = GetWidthScaleFromHeightScale(newRootsHeightScale, settings.RootsWidthVariability);
        ////float newRootsWidthScale = UnityEngine.Random.Range(minStartRootsWidthScale, maxStartRootsWidthScale);
        //SetRootsScale(newRootsHeightScale, newRootsWidthScale);
    }

    /// <summary>
    /// Initializes game object prefabs for tree.
    /// </summary>
    /// <param name="newTreePrefabs">New tree prefabs.</param>
    /// <param name="newRootsPrefabs">New roots prefabs.</param>
    /// <param name="newDeadTreePrefab">New dead tree prefab.</param>
    public void InitializePrefabs(List<GameObject> newTreePrefabs, List<GameObject> newRootsPrefabs, GameObject newDeadTreePrefab)
    {
        treePrefabs = newTreePrefabs;
        rootsPrefabs = newRootsPrefabs;

        rootsObjects = new GameObject[rootsPrefabs.Count];
        for (int i = 0; i < rootsPrefabs.Count; i++)
        {
            try
            {
                rootsObjects[i] = transform.Find("Roots_" + i).gameObject;
            }
            catch (System.NullReferenceException)
            {
                Debug.Log(" No Roots Object found: Roots_" + i);
            }
        }

        lodGroupObjects = new GameObject[treePrefabs.Count];
        for (int i = 0; i < treePrefabs.Count; i++)
        {
            try
            {
                lodGroupObjects[i] = transform.Find("LODGroup_" + i).gameObject;
            }
            catch (System.NullReferenceException)
            {
                Debug.Log(" No Roots Object found: Roots_" + i);
            }
        }
        deadTreePrefab = newDeadTreePrefab;
        treePrefabHeights = new float[treePrefabs.Count];
        treePrefabWidths = new float[treePrefabs.Count];

        int count = 0;
        while (count < treePrefabs.Count)
        {
            GameObject lodGroup = GetLODGroupObject(count);
            treePrefabHeights[count] = GetChildHeightInLODGroup(lodGroup, 0);
            treePrefabWidths[count] = GetChildWidthInLODGroup(lodGroup, 0);
            //Debug.Log(" TREE HEIGHT count:" + count + ":" + treePrefabHeights[count]);
            //Debug.Log(" TREE HEIGHT count:" + count + ":" + treePrefabWidths[count]);
            count++;
        }

        rootsPrefabDepths = new float[rootsPrefabs.Count];
        rootsPrefabWidths = new float[rootsPrefabs.Count];

        count = 0;
        while (count < rootsPrefabs.Count)
        {
            GameObject rObject = GetRootsObject(count);
            //Debug.Log(" ROOTS HEIGHT #" + count + ":" + GetChildHeightInLODGroup(rObject, 1));
            rootsPrefabDepths[count] = GetChildHeightInLODGroup(rObject, 1);
            rootsPrefabWidths[count] = GetChildWidthInLODGroup(rObject, 1);
            //Debug.Log(" ROOTS HEIGHT count:" + count + ":" + rootsPrefabDepths[count]);
            //Debug.Log(" ROOTS WIDTH count:" + count + ":" + rootsPrefabWidths[count]);
            count++;
        }

        deadTreePrefabHeight = GetDeadPrefabHeight();
        deadTreePrefabWidth = GetDeadPrefabWidth();
    }

    /// <summary>
    /// Gets current size of given roots prefab.
    /// </summary>
    /// <returns>The prefab size.</returns>
    /// <param name="idx">Index.</param>
    private float GetRootsPrefabHeight(int idx)
    {
        GameObject lodObject = GetRootsObject(idx).gameObject as GameObject;
        return GetChildHeightInLODGroup(lodObject, 1);
        //if (rObject != null)
        //{
        //    float value = rObject.transform.GetComponent<Renderer>().bounds.size.y;        // Get current height of given prefab (m.) 
        //    return value;
        //}
        //else
        //{
        //    return 1000000f;
        //}
    }

    /// <summary>
    /// Gets the height of the child of given LOD group by index.
    /// </summary>
    /// <returns>The prefab size.</returns>
    /// <param name="lodGroup">LOD group list</param>
    /// <param name="childIdx">Child index.</param>
    private float GetChildHeightInLODGroup(GameObject lodGroup, int childIdx)
    {
        //GameObject lodGroup = GetLODGroupObject(groupIdx);
        GameObject lod0 = lodGroup.transform.GetChild(childIdx).gameObject as GameObject;
        float value = lod0.transform.GetComponent<Renderer>().bounds.size.y;            // Get height of prefab (m.)
        return value;
    }

    /// <summary>
    /// Gets the width of the prefab.
    /// </summary>
    /// <returns>The prefab size.</returns>
    /// <param name="lodGroup">LOD group list</param>
    /// <param name="childIdx">Prefab index.</param>
    private float GetChildWidthInLODGroup(GameObject lodGroup, int childIdx)
    {
        //GameObject lodGroup = GetLODGroupObject(groupIdx);
        GameObject lod0 = lodGroup.transform.GetChild(childIdx).gameObject as GameObject;
        float value = lod0.transform.GetComponent<Renderer>().bounds.size.x;            // Get height of prefab (m.)
        return value;
    }

    /// <summary>
    /// Gets the size of the dead prefab.
    /// </summary>
    /// <returns>The dead prefab size.</returns>
    private float GetDeadPrefabHeight()
    {
        GameObject lod0 = deadTreePrefab.transform.GetChild(0).gameObject as GameObject;
        float value = lod0.transform.GetComponent<Renderer>().bounds.size.y;            // Get height of dead prefab (m.)
        return value;
    }

    /// <summary>
    /// Gets the size of the dead prefab.
    /// </summary>
    /// <returns>The dead prefab size.</returns>
    private float GetDeadPrefabWidth()
    {
        GameObject lod0 = deadTreePrefab.transform.GetChild(0).gameObject as GameObject;
        float value = lod0.transform.GetComponent<Renderer>().bounds.size.x;            // Get height of dead prefab (m.)
        return value;
    }

    /// <summary>
    /// Updates the current LOD Group.
    /// </summary>
    protected void UpdateLODGroup()
    {
        curLODGroup = GetLODGroupObject(treePrefabIdx);
    }

    /// <summary>
    /// Updates the current LOD Group.
    /// </summary>
    protected void UpdateRootsObject()
    {
        curRootsObject = GetRootsObject(rootsPrefabIdx);
    }

    /// <summary>
    /// Gets random width scale given height scale within given variability.
    /// </summary>
    /// <returns>The width scale from given height scale.</returns>
    /// <param name="heightScale">Height scale.</param>
    /// <param name="variability">Variability.</param>
    public float GetWidthScaleFromHeightScale(float heightScale, float variability)
    {
        float widthScale = heightScale + heightScale * (Random.Range(0f, variability * 2f) - heightScale * variability);
        return widthScale;
    }

    /// <summary>
    /// Sets the LOD Renderers from transform.
    /// </summary>
    protected void UpdateRenderer()
    {
        GameObject lod0 = GetLODInGroup(0, curLODGroup);
        Assert.IsNotNull(lod0);

        treeLOD_0_Renderer = lod0.GetComponent<Renderer>();
        Assert.IsNotNull(treeLOD_0_Renderer);
    }

    /// <summary>
    /// Sets the LOD Renderers from transform.
    /// </summary>
    protected void UpdateRootsRenderer()
    {
        GameObject rootsLOD0 = GetLODInGroup(0, curRootsObject);
        Assert.IsNotNull(rootsLOD0);

        rootsLOD_0_Renderer = rootsLOD0.GetComponent<Renderer>();
        Assert.IsNotNull(rootsLOD_0_Renderer);
    }

    /// <summary>
    /// Gets LOD from given LOD Group by index.
    /// </summary>
    /// <returns>The LOD game object.</returns>
    /// <param name="index">Index.</param>
    /// <param name="theLODGroup">LOD Group</param>
    protected GameObject GetLODInGroup(int index, GameObject theLODGroup)
    {
        if (theLODGroup.transform.childCount > index)
        {
            return theLODGroup.transform.GetChild(index).gameObject as GameObject;
        }
        else
            return null;
    }

    /// <summary>
    /// Gets LOD Group by index
    /// </summary>
    /// <param name="index">Index.</param>
    protected GameObject GetLODGroupObject(int index)
    {
        return lodGroupObjects[index];
        //GameObject lodGroup = transform.Find("LODGroup_" + index).gameObject;
        //return lodGroup;
    }

    /// <summary>
    /// Gets LOD Group by index
    /// </summary>
    /// <param name="index">Index.</param>
    protected GameObject GetRootsObject(int index)
    {
        return rootsObjects[index];
        //try
        //{
        //    GameObject result = transform.Find("Roots_" + index).gameObject;
        //    return result;
        //}
        //catch(System.NullReferenceException)
        //{
        //    Debug.Log(" No Roots Object found: Roots_" + index);
        //    return null;
        //}
    }
}
