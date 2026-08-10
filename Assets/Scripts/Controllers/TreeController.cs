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
    public bool IsFrontTree() { return isFrontTree; }

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
    protected float rootsDepthTargetOverride = -1f;     // CC: data-driven root scale (>=0 when set); <0 keeps BigCreek's tree-linked roots
    protected float rootsWidthScale;                  // Current roots width scale
    protected float rootsFullWidthScale;              // Roots width scale at fully grown state

    /* Particle System */
    protected ParticleSystem etParticles;
    public bool showParticles;
    public bool particlesEnabled;
    protected float heightJitter = 1f;   // per-tree random multiplier so a patch's trees vary around heightOver


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
    /// Carbon this tree will represent once fully grown. The Central Coast balance counts saplings at
    /// this value so they already fill their share of the target: comparing current carbon instead makes
    /// the loop plant again every frame while everything is still growing, so the stand is permanently
    /// overplanted with trees that never reach full size. Deliberately omits the zero-scale check used by
    /// GetCarbonAmount, because a freshly planted tree starts at scale zero.
    /// </summary>
    /// <returns>The carbon amount at full size.</returns>
    public float GetPotentialCarbonAmount()
    {
        if (!alive)
            return 0f;
        else if (dying)
            return 0f;
        else
            return treeFullHeightScale * GetFullTreeHeight() * treeCarbonFactor;
    }

    /// <summary>
    /// Sets whether to destroy fir after fire.
    /// </summary>
    /// <param name="destroyAfter">If set to <c>true</c> destroy after.</param>
    private void SetDestroyAfterFire(bool destroyAfter)
    {
        if(fireNodeChain)
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
        if (fireNodeChain)
        {
            fireNodeChain.enabled = true;                   // Make sure node chain is enabled
            if (debugTree)
                Debug.Log(transform.parent.transform.parent.transform.name + "... " + name + ".Ignite()... immediate:" + immediate);
            fireNodeChain.Ignite(transform.position, fireLengthInFrames);
        }
    }

    /// <summary>
    /// Grows the tree incrementally.
    /// </summary>
     protected void GrowTree()
      {
        float newHeightScale, newWidthScale;
        float step = settings.TreeGrowthSpeedFactor * timeStep;

        // Move gradually toward treeFullHeightScale in BOTH directions. BigCreek's target is fixed and the
        // tree never overshoots it, so only the grow branch runs there (unchanged). Central Coast drives
        // treeFullHeightScale from data heightOver, which can drop — the shrink branch eases it down instead
        // of snapping (which caused the sudden shrink).
        float hDiff = treeFullHeightScale - GetHeightScale();
        float hStep = step;
        if (Mathf.Abs(hDiff) < 0.2f)                                  // ease near the target
            hStep *= MathUtil.MapValue(Mathf.Abs(hDiff), 0f, 0.2f, 0f, 1f);
        if (hDiff >= 0f)
            newHeightScale = Mathf.Min(GetHeightScale() + hStep, treeFullHeightScale);   // grow up
        else
            newHeightScale = Mathf.Max(GetHeightScale() - hStep, treeFullHeightScale);   // shrink down gradually

        float wDiff = treeFullWidthScale - GetWidthScale();
        float wStep = step;
        if (Mathf.Abs(wDiff) < 0.2f)
            wStep *= MathUtil.MapValue(Mathf.Abs(wDiff), 0f, 0.2f, 0f, 1f);
        if (wDiff >= 0f)
            newWidthScale = Mathf.Min(GetWidthScale() + wStep, treeFullWidthScale);
        else
            newWidthScale = Mathf.Max(GetWidthScale() - wStep, treeFullWidthScale);

        SetTreeScale(newHeightScale, newWidthScale, false);          // Set scale and update LODs
    }

    /// <summary>
    /// Central Coast: set the tree's full-grown height to an absolute value in metres (from data heightOver),
    /// overriding the random treeFullHeightScale. GrowTree then grows/shrinks toward it; width scales uniformly.
    /// </summary>
    public void SetFullHeightMeters(float meters)
    {
        if (treePrefabHeights == null || treePrefabHeights.Length == 0) return;
        float prefabH = treePrefabHeights[treePrefabHeights.Length - 1];
        if (prefabH <= 0f || meters <= 0f) return;
        treeFullHeightScale = (meters * heightJitter)  / prefabH;
        treeFullWidthScale  = treeFullHeightScale;   // uniform scaling (keep prefab proportions)
        //Debug.Log($"[HGT] {name} heightOver={meters:F2}m  prefabH={prefabH:F2}m  scale={treeFullHeightScale:F2}");
    }

    // Central Coast: root SIZE from data root depth (metres). Display depth ≈ rootsHeightScale × deepest
    // prefab depth, so target rootsHeightScale = metres / deepest. Prefab STAGE handled separately by
    // RootsPrefabDepthBoost. Negative disables (BigCreek keeps its own roots).
    public void SetRootDepthMeters(float meters)
    {
        if (rootsPrefabDepths == null || rootsPrefabDepths.Length == 0) { rootsDepthTargetOverride = -1f; return; }
        float deepest = rootsPrefabDepths[rootsPrefabDepths.Length - 1];
        rootsDepthTargetOverride = (deepest > 0f) ? Mathf.Max(0f, meters / deepest) : -1f;
    }

    /// <summary>
    /// Grows the roots.
    /// </summary>
    public void GrowRoots()
    {
        // BigCreek's full-root target, multiplied by a per-patch data factor (1 = BigCreek). CC sets the
        // factor from rootdepthCOver, so roots still climb through the prefab stages but track the data
        // depth (and shrink after a fire when the data root depth drops).
        float rootFullH = (rootsDepthTargetOverride >= 0f) ? rootsDepthTargetOverride : rootsFullHeightScale;
        float rootFullW = (rootsDepthTargetOverride >= 0f) ? rootsDepthTargetOverride : rootsFullWidthScale;;

        float newHeightScale, newWidthScale;
        float hDiff = rootFullH - GetRootsHeightScale();
        float wDiff = rootFullW - GetRootsWidthScale();

        /* Normal Growth */
        float heightGrowthAmount = settings.RootsSpreadSpeedFactor * timeStep;      // Slow height growth over time
        float widthGrowthAmount = settings.RootsSpreadSpeedFactor * timeStep;       // Increase width growth over time

        /* Near-Full-Height Growth */
        if (hDiff < 0.2f)
        {
            float gFactor = MathUtil.MapValue(hDiff, 0f, 0.2f, 0f, 1f);
            heightGrowthAmount = gFactor * settings.RootsSpreadSpeedFactor * timeStep;      // Slow height growth over time
        }

        newHeightScale = GetRootsHeightScale() + heightGrowthAmount;
        newHeightScale = Mathf.Clamp(newHeightScale, 0f, rootFullH);

        /* Near-Full-Width Growth */
        if (wDiff < 0.2f)
        {
            float wFactor = MathUtil.MapValue(wDiff, 0f, 0.2f, 0f, 1f);
            widthGrowthAmount = wFactor * settings.RootsSpreadSpeedFactor * timeStep;     // Increase width growth over time
        }

        newWidthScale = GetRootsWidthScale() + widthGrowthAmount;
        newWidthScale = Mathf.Clamp(newWidthScale, 0f, rootFullW);

        if (debugRoots)
            Debug.Log(transform.name + "      GrowRoots()...   oldHeight:" + GetRootsHeightScale() + "    GrowRoots()... oldWidth:" + GetRootsWidthScale() + " newHeightScale:" + newHeightScale + "  newWidthScale:" + newWidthScale);

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

        if (treePrefabIdx >= 0 && treePrefabIdx < treePrefabs.Count - 1)        // Update tree prefab if not fully grown
            UpdateTreePrefab(init);

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

        if (rootsPrefabIdx >= 0 && rootsPrefabIdx < rootsPrefabs.Count - 1)        // Update roots prefab if not fully grown
            UpdateRootsPrefab(init);
        UpdateRootsLODsScale();                                                   // Update LODs size
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

        int newRootsPrefabIdx = GetClosestFloatIdxLowerThan(rootsPrefabDepths, currentDepth * settings.RootsPrefabDepthBoost);
        if (newRootsPrefabIdx == -1) newRootsPrefabIdx = 0;
        Debug.Log(name + " [ROOTDBG] rHS=" + rootsHeightScale
              + " curDepth=" + (rootsHeightScale * GetFullRootsDepth())
              + " boost=" + settings.RootsPrefabDepthBoost
              + " boosted=" + (rootsHeightScale * GetFullRootsDepth() * settings.RootsPrefabDepthBoost)
              + " idx=" + newRootsPrefabIdx + " depths0=" + rootsPrefabDepths[0]
              + " override=" + rootsDepthTargetOverride);

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

          // Only front (cut-face) trees show roots; interior roots are occluded, so leave them inactive
          // (from instantiation) instead of activating/scaling here. Matches the isFrontTree gate in GrowRoots.
          if (isFrontTree)
          {
              float newRootsHeightScale = startAtZero ? 0f
                  : UnityEngine.Random.Range(0f, rootsFullHeightScale * factor);
              float newRootsWidthScale = GetWidthScaleFromHeightScale(newRootsHeightScale, settings.RootsWidthVariability);
              float curRootsDepth = newRootsHeightScale * GetFullRootsDepth();
              SetRootsPrefabForDepth(curRootsDepth, true);
              SetRootsScale(newRootsHeightScale, newRootsWidthScale, true);
          }

          if (debugTree)
              Debug.Log(name + ".InitializeScale()... newTreeHeightScale:" + newTreeHeightScale + " factor:" + factor + " startAtZero:" + startAtZero);
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
        float fullHeight = treePrefabHeights[treePrefabHeights.Length - 1];
        float fullWidth = treePrefabWidths[treePrefabHeights.Length - 1];
        float hFactor = treePrefabHeights[treePrefabIdx] / fullHeight;   // Calculate diff. between prefab heights
        float wFactor = treePrefabWidths[treePrefabIdx] / fullWidth;     // Calculate diff. between prefab widths

        // A prefab whose LOD0 mesh measures ~0 height/width (bad bounds) drives hFactor/wFactor
        // toward zero; dividing treeHeightScale by it scales the model to a screen-filling size.
        // Guard so one broken prefab can't spawn a giant tree, and log which prefab so it can be
        // fixed at the source. Healthy prefabs keep their original scaling (guard never triggers).
        if (hFactor < 0.0001f || wFactor < 0.0001f)
        {
            Debug.LogWarning(transform.name + " UpdateTreeLODsScale()... degenerate prefab size, clamping to avoid a giant tree. " +
                             "treePrefabIdx:" + treePrefabIdx + " measuredHeight:" + treePrefabHeights[treePrefabIdx] +
                             " measuredWidth:" + treePrefabWidths[treePrefabIdx] + " fullHeight:" + fullHeight + " fullWidth:" + fullWidth);
            if (hFactor < 0.0001f) hFactor = 1f;
            if (wFactor < 0.0001f) wFactor = 1f;
        }

        float newHeightScale = treeHeightScale / hFactor;               // Adjust LODs scale to match full-grown height scale range
        float newWidthScale = treeWidthScale / wFactor;                 // Adjust LODs scale to match full-grown width scale range

        SetTreeLODsScale(newHeightScale, newWidthScale);               // Set scale of LODs

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
        if(debugRoots)
            Debug.Log(transform.name + " UpdateRootsLODsScale()...  newHeightScale:" + newHeightScale + " newWidthScale:" + newWidthScale + " hFactor:" + hFactor + " wFactor:" + wFactor + " rDepth:" + rootsPrefabDepths[rootsPrefabDepths.Length - 1]);
    }

    /// <summary>
    /// Sets the tree LODs scale.
    /// </summary>
    /// <param name="newHeightScale">New height scale.</param>
    /// <param name="newWidthScale">New width scale.</param>
    private void SetTreeLODsScale(float newHeightScale, float newWidthScale)
    {
        // Safety net against the screen-filling "giant tree" flash: no healthy tree renders more than
        // a modest multiple of its LOD's natural size. If the requested scale is absurd (bad prefab
        // height data feeding the division upstream), log the inputs so we can find the offending
        // prefab, then clamp. Normal trees stay well under the cap, so this never affects them.
        const float maxLodScale = 12f;
        if (newHeightScale > maxLodScale || newWidthScale > maxLodScale)
        {
            Debug.LogWarning(transform.name + " SetTreeLODsScale()... oversized scale clamped (giant-tree guard). " +
                "treePrefabIdx:" + treePrefabIdx + " newHeightScale:" + newHeightScale + " newWidthScale:" + newWidthScale +
                " treeHeightScale:" + treeHeightScale + " alive:" + alive + " dying:" + dying);
            newHeightScale = Mathf.Min(newHeightScale, maxLodScale);
            newWidthScale = Mathf.Min(newWidthScale, maxLodScale);
        }

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
                GameObject rootLOD = GetLODInGroup(i, curRootsObject);
                if (rootLOD == null)
                    continue;

                rootLOD.transform.localScale = new Vector3(newWidthScale, Mathf.Abs(newHeightScale), newWidthScale);
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

        Transform newLODGroupTransform = transform.Find("LODGroup_DeadTree");
        if (newLODGroupTransform == null)
        {
            Debug.LogWarning(transform.name + ".SetDeadPrefab()... no LODGroup_DeadTree child; keeping the live model. Is a dead tree prefab assigned for this species?");
            return;
        }

        // A dead prefab whose LOD0 mesh measures ~0 height makes currentHeight / deadTreePrefabHeight
        // explode, so the dead model flashes up screen-filling during the fall animation. Keep the
        // live model in that case (the tree just falls and shrinks) and log which prefab is broken.
        if (deadTreePrefabHeight < 0.0001f || currentHeight < 0f)
        {
            Debug.LogWarning(transform.name + ".SetDeadPrefab()... degenerate dead prefab size (currentHeight:" + currentHeight +
                             " deadTreePrefabHeight:" + deadTreePrefabHeight + "); keeping live model to avoid a giant dead tree.");
            return;
        }

        curLODGroup.SetActive(false);
        GameObject newLODGroup = newLODGroupTransform.gameObject;

        // Scale the dead model to render at 0.75x the live tree's height. Rather than dividing two
        // separately-measured prefab heights and overwriting each LOD child's scale (which discarded
        // any scale baked into the dead prefab and could render the dead tree far larger than the live
        // one), activate the model at unit scale, measure how tall it actually renders, then scale the
        // whole group to the target. This is robust to any non-1 scales inside the dead prefab.
        newLODGroup.transform.localScale = Vector3.one;
        newLODGroup.SetActive(true);

        float deadNaturalHeight = 0f;
        Renderer[] deadRenderers = newLODGroup.GetComponentsInChildren<Renderer>();
        if (deadRenderers.Length > 0)
        {
            Bounds deadBounds = deadRenderers[0].bounds;
            for (int i = 1; i < deadRenderers.Length; i++)
                deadBounds.Encapsulate(deadRenderers[i].bounds);
            deadNaturalHeight = deadBounds.size.y;
        }

        if (deadNaturalHeight > 0.0001f)
            newLODGroup.transform.localScale = Vector3.one * (currentHeight * 0.75f / deadNaturalHeight);

        curLODGroup = newLODGroup;
        UpdateRenderer();
    }

    /// <summary>
    /// Hides the dead prefab.
    /// </summary>
    protected void HideDeadTreeObjects()
    {
        // The dead model is created in CubeController.InstantiateTreeFromPrefab; it is missing when
        // neither the species' deadPrefab nor the cube's shared deadTreePrefab is assigned.
        Transform oldLODGroupTransform = transform.Find("LODGroup_DeadTree");
        if (oldLODGroupTransform != null)
        {
            GameObject oldLODGroup = oldLODGroupTransform.gameObject;                 // Reset dead tree object LOD scale
            for (int i = 0; i < oldLODGroup.transform.childCount; i++)
            {
                GetLODInGroup(i, oldLODGroup).transform.localScale = Vector3.one;
            }
            oldLODGroup.SetActive(false);
        }
        else
        {
            Debug.LogWarning(transform.name + ".HideDeadTreeObjects()... no LODGroup_DeadTree child; is a dead tree prefab assigned for this species?");
        }

        if (curRootsObject != null)
        {
            for (int i = 0; i < curRootsObject.transform.childCount; i++)
            {
                GetLODInGroup(i, curRootsObject).transform.localScale = Vector3.one;
            }
            curRootsObject.SetActive(false);
        }
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

        heightJitter = UnityEngine.Random.Range(0.85f, 1.1f);

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
