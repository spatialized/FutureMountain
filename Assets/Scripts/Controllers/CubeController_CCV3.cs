using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Central Coast V3 cube controller.
///
/// Inherits <see cref="CubeController"/> (BigCreek) in full. Every method and
/// field of the base class is retained as-is; this subclass only adds and
/// overrides the Central Coast V3 per-patch behaviour (patch1 / patch2 as equal
/// members that split the cube by area, riparian clustering, grass as a carbon
/// layer, drought / fire death, stream response curve, per-patch dead prefabs).
///
/// Because it derives from CubeController, it slots into GameController's
/// CubeController[] arrays and is driven exactly like any other cube, so nothing
/// in the base game loop needs to change.
///
/// Extraction plan: V3-specific code is moved down from the base class into this
/// subclass one seam at a time. Until a feature is moved, it still runs from the
/// inherited base implementation, so behaviour is identical to the pre-refactor
/// build at every step. BigCreek cubes keep using CubeController directly and are
/// never affected by anything in this file.
/// </summary>
public class CubeController_CCV3 : CubeController
{
    // Stage 1: empty subclass. Swapping a Central Coast cube's component from
    // CubeController to CubeController_CCV3 changes nothing yet, because all V3
    // logic still lives in the base class and is inherited unchanged. This lets
    // us do the Unity component swap first, verify identical behaviour, and only
    // then move code down -- so no further scene rewiring is needed later.
    //
    // Later stages will move the V3 fields and methods here as overrides:
    //   - PatchDisplayInfo gains memberID + deadPrefab (patch1/patch2 fully equal)
    //   - two per-patch data buffers; hydrology area-weighted into the base buffer
    //   - per-patch overstory balance, grass-as-carbon, drought/fire death
    //   - stream response curve, per-patch dead prefabs, riparian clustering

    // ----- Stage 2: vegetation balance seam -----
    // The base class calls UpdateVegetationCore() once per step inside its
    // UpdateVegetation() scaffold (which still handles simulationOn plus roots /
    // shrubs / grass). Central Coast cubes run the per-patch balance instead of
    // the BigCreek single-patch path. The per-patch logic itself still lives in
    // the base class for now (UpdateVegetationCentralCoast, inherited as
    // protected); a later stage relocates it into this file.
    protected override void UpdateVegetationCore()
    {
        UpdateVegetationCentralCoast();         // Trees balanced per patch; grass stands in for the understory
    }

    // Streamflow (mapped into StreamHeight) at which the channel is exactly bankfull. Common to all
    // Central Coast cubes. At/below this the water fills the channel; above it the water floods.
    private const float StreamBankfullFlow = 3.0e-4f;

    // ----- Stage 3 / flood: stream response seam -----
    // Central Coast data has no snow and drives the stream from raw streamflow. Map the cube's own
    // minimum streamflow -> 0 (empty channel) and the fixed bankfull threshold -> 1 (full channel).
    // Streamflow above the threshold (up to the cube's data max) returns > 1, so the water rises past
    // the bank and floods -- UpdateStream no longer clamps the upper end, so the spline lifts above
    // streamFullHeight. The cube's data max maps to its flood peak.
    protected override float ComputeStreamPos()
    {
        // 0 streamflow -> empty channel (streamZeroHeight); the fixed bankfull threshold -> full channel
        // (streamFullHeight). Above the threshold the value exceeds 1, so the water rises past the bank
        // and floods (UpdateStream no longer clamps the upper end).
        return Mathf.Max(0f, StreamHeight / StreamBankfullFlow);   // 0 empty, 1 = bankfull (3E-4), >1 = flood
    }

    // ----- Stage 3b: fire-death seam -----
    // When a fire hits, queue tree/grass deaths per patch (percent-scaled, maturity-based) instead of
    // the BigCreek single-patch shrub/tree accounting. The per-patch logic still lives in the base
    // class for now (SetCentralCoastVegetationToDieFromFire, inherited as protected); a later stage
    // relocates it into this file.
    protected override void SetVegetationToDieFromFire(int fireTimeIdx)
    {
        SetCentralCoastVegetationToDieFromFire(fireTimeIdx);
    }

    // ----- Stage 4: per-cube tree-carbon-factor override -----
    // A cube whose carbon needs more than MaxTrees to represent it (saturated riparian cubes) can
    // raise the per-tree carbon factor so fewer, "heavier" trees represent the same carbon. Only set
    // cubeTreeCarbonFactorOverride on such cubes; it stays 0 elsewhere and falls through to BigCreek.
    public override float GetTreeCarbonFactor()
    {
        if (cubeTreeCarbonFactorOverride > 0f)
            return cubeTreeCarbonFactorOverride;
        return base.GetTreeCarbonFactor();
    }

    // ----- Stage 5: fire burns the whole cube -----
    // BigCreek keeps one tree standing even in a total burn; Central Coast lets a full burn clear the
    // cube so a fire that removes all overstory carbon actually leaves no trees.
    protected override int LastBurnableTreeIndex()
    {
        return 0;
    }

    // ----- Stage 5: no trailing burn after the fire stops -----
    // When the cube's fire goes out, kill any tree still burning right away, so the fire leaving the
    // cube and the trees dying happen together instead of the tree burning on for its own duration.
    protected override void OnFireExtinguished()
    {
        // Iterate a copy of the full fir list (not just alive trees): a tree ignited by fire may
        // already be mid-death (dying) or have had its chain disabled by a later SetTreesToBurn, so
        // checking only alive + enabled left one or two still burning. Kill anything still dying or
        // burning outright so nothing keeps burning after the fire is out.
        foreach (FirController fir in new List<FirController>(firs))
        {
            if (fir == null)
                continue;

            bool burning = fir.fireNodeChain != null &&
                           (fir.fireNodeChain.enabled || fir.fireNodeChain.ToBeDestroyed());
            if (fir.IsDying() || burning)
                fir.Kill(true);
        }
    }

    // ----- Stage 5: deterministic initial grass fill -----
    // Central Coast grass is a real carbon layer, so seed it with a deterministic background fill
    // instead of BigCreek's random scatter.
    protected override void GrowInitialGrassLayer()
    {
        GrowGrassPatches(ccBackgroundGrassPatches);
    }

    // ----- Stage 5: load the second patch member -----
    // Each Central Coast cube (zone) is driven by two patch members. patch1 uses this cube's own
    // rows; patch2's overstory carbon comes from the next member (patchID + 1). Load it as well, and
    // hold off growing until both members have arrived so patch2 uses its own carbon from the start.
    protected override void RequestExtraPatchData(int warmingIdx)
    {
        WebManager.Instance.RequestCubeData(patchID + 1, warmingIdx, this.FinishUpdateDataFromWebP2);
    }

    protected override bool ReadyToGrowFromData()
    {
        return p2Loaded;
    }

    // ----- Stage 5: patch2 fills tree slots from the far end -----
    // Locations are sorted nearest-stream-first. patch1 (sp0) fills from the near end so oak clusters
    // along the riparian strip; patch2 (sp1+) fills from the far end so the understory species stays
    // on the outer banks.
    protected override bool FillTreeSlotsFromFarEnd(int speciesIdx)
    {
        // patch2 species fill from the far (outer) end; patch1 from the near (stream) end.
          // Keyed off patchSlot so a patch can hold multiple species without breaking placement.
          if (patchSlotBySpecies != null && speciesIdx >= 0 && speciesIdx < patchSlotBySpecies.Length)
              return patchSlotBySpecies[speciesIdx] == 2;
          return speciesIdx > 0;   // Fallback for pre-migration cubes.
    }

    // ----- Stage 5: riparian clustering of tree locations -----
    // Sort the tree locations into groves. If the cube has a stream, grove centers hug the stream line
    // and the sort (anisotropic in NearestClumpDist) runs near-stream -> far-stream, so patch1 (grown
    // first, from the near end) clusters along the banks and patch2 fills outward.
    protected override void ClusterTreeLocations(float offsetX, float offsetZ, float cubeZMin, float cubeZMax)
    {
        const int numClumps = 4;   // number of patch1 groves; tune to taste
        Vector3[] clumpCenters = new Vector3[numClumps];
        for (int c = 0; c < numClumps; c++)
        {
            if (hasStream)
            {
                // Clump centers hug the stream line.
                float sx = Random.Range(streamCenter - streamWidth, streamCenter + streamWidth) + offsetX;
                float sz = Random.Range(cubeZMin, cubeZMax) + offsetZ;
                clumpCenters[c] = new Vector3(sx, 0f, sz);
            }
            else
            {
                clumpCenters[c] = firLocations[Random.Range(0, firLocations.Length)];
            }
        }

        // Sort so locations nearest a clump come first: patch1 (grown first) fills the clumps, patch2 fills the rest.
        System.Array.Sort(firLocations, (a, b) =>
            NearestClumpDist(a, clumpCenters).CompareTo(NearestClumpDist(b, clumpCenters)));
    }

    // ----- Stage 5: initial overstory grown per patch -----
    // patch1 = this cube's member (member 01); patch2 = the second member (member 02). Each grows from
    // its own carbon and area percentage (GrowPatchOverstory), so neither species starves the other.
    protected override void GrowInitialOverstory(float combinedCarbonOver)
    {
        GrowPatchOverstory(patch1, combinedCarbonOver);
        GrowPatchOverstory(patch2, GetOverstoryCarbonP2(timeIdx));
    }

    // ----- Stage 3: per-patch overstory flattened into the cube's flat species list -----
    // Built by PrepareVegetationList() and index-aligned with the base treeList / speciesIdx:
    //   patchSlotBySpecies[idx]   -> which patch (1 or 2) this species belongs to
    //   targetStemsBySpecies[idx] -> initial individuals for this species (N_stems * percentInPatch)
    protected int[] patchSlotBySpecies;
    protected int[] targetStemsBySpecies;

    // Rebuild vegetation.species from the two patches' overstory lists so the base tree-list build
    // (and all speciesIdx-keyed runtime state) is driven by the per-patch community definition.
    protected override void PrepareVegetationList()
    {
        // Not migrated yet: leave the Inspector-assigned list alone (legacy overstorySpecies still works).
        bool hasP1 = patch1 != null && patch1.overstory != null && patch1.overstory.Count > 0;
        bool hasP2 = patch2 != null && patch2.overstory != null && patch2.overstory.Count > 0;
        if (!hasP1 && !hasP2) return;

        var flat  = new List<Species>();
        var slots = new List<int>();
        var stems = new List<int>();

        AppendPatchOverstory(patch1, 1, flat, slots, stems);
        AppendPatchOverstory(patch2, 2, flat, slots, stems);

        vegetation.species   = flat;
        patchSlotBySpecies   = slots.ToArray();
        targetStemsBySpecies = stems.ToArray();
    }

    // ----- Stage 4: per-cube tree budget follows the patch stem counts -----
    // Central Coast follows cube_info N_stems literally, so the pool must hold the sum of both patches'
    // stems (can exceed the global MaxTrees). base.MaxTreesForCube() returns the global cap.
    protected override int MaxTreesForCube()
    {
        int p1 = (patch1 != null) ? patch1.nStems : 0;
        int p2 = (patch2 != null) ? patch2.nStems : 0;
        return Mathf.Max(base.MaxTreesForCube(), p1 + p2);
    }

    // Append one patch's overstory species to the flat list, recording each species' patch slot and
    // its share of the patch's N_stems. Overstory species must be trees (isShrub = false) so their
    // flat index lines up with the base treeList index.
    private void AppendPatchOverstory(PatchDisplayInfo patch, int slot,
                                    List<Species> flat, List<int> slots, List<int> stems)
    {
        if (patch == null || patch.overstory == null) return;
        foreach (Species sp in patch.overstory)
        {
            if (sp == null) continue;
            sp.runtimeSpeciesIdx = flat.Count;
            flat.Add(sp);
            slots.Add(slot);
            stems.Add(Mathf.RoundToInt(patch.nStems * sp.percentInPatch / 100f));
        }
    }

    // ----- Tree height driven by data heightOver (replaces the random 0.66–0.8) -----
    // Each step, set every alive tree's full-grown height to its patch's heightOver (m): patch1 from this
    // cube's row (HeightOverP1), patch2 from the second member (GetHeightOverP2). Height then tracks the data —
    // shrinking after fire and regrowing as heightOver recovers.
    protected override void UpdateOverstoryHeights()
    {
        if (firs == null || patchSlotBySpecies == null) return;
        foreach (FirController fir in firs)
        {
            if (fir == null || !fir.IsAlive()) continue;
            int idx = fir.speciesIdx;
            if (idx < 0 || idx >= patchSlotBySpecies.Length) continue;
            float h = GetHeightOver(timeIdx, patchSlotBySpecies[idx] == 2);
            if (h > 0f) fir.SetFullHeightMeters(h);
        }
    }
}
