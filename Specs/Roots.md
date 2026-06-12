# Roots Spec

Last updated: 2026-06-12

## Purpose

Roots are the below-ground companion visualization for tree growth. They make vegetation carbon visible as more than trunks and leaves, and help communicate that climate, water access, and biomass changes affect the hidden root system as well as the visible canopy.

Roots are currently tied to fir/tree-capable cubes. They are not a separate user interface control in the current version.

## Visual Behavior

Root objects appear under fir trees in terrain cubes. As trees become established and grow, the active root prefab and its scale change to represent increasing root depth and spread.

Visually, roots should read as below-ground root structures, not as dead trees, branch clusters, or above-ground vegetation. Runtime root transforms should preserve this orientation even when tree objects are randomly rotated.

## Data Inputs

Root behavior is driven by cube vegetation data:

- `rootCOver`: overstory root carbon.
- `rootCUnder`: understory root carbon, loaded where available but less directly represented by current tree root visuals.

For tree-capable two-layer vegetation cubes, overstory root carbon is the main root signal. Aggregate cubes use the same overstory/understory-style fields with aggregate-specific scaling factors.

## Technical Flow

`CubeController` reads root data into:

- `RootsCarbonOver`
- `RootsCarbonUnder`
- `RootsCarbonOverMin`
- `RootsCarbonOverMax`
- `RootsCarbonUnderMin`
- `RootsCarbonUnderMax`

When firs are created, `CubeController.InstantiateTreeFromPrefab()` creates the tree object, tree LOD groups, dead-tree LOD group, and one root object per root prefab. The root objects are named `Roots_0`, `Roots_1`, and so on so `TreeController` can find and switch between them.

`FirController.UpdateSimulation(...)` receives root carbon with transpiration, leaf carbon, and stem carbon. It compares the model value to the currently visualized root carbon and calls `GrowRoots()` when the visual root system needs to catch up.

`TreeController` owns root state:

- `rootsHeightScale`
- `rootsWidthScale`
- `rootsFullHeightScale`
- `rootsFullWidthScale`
- `rootsPrefabIdx`
- `curRootsObject`

`TreeController.UpdateRootsPrefab()` chooses the closest root prefab for the current depth. `SetCurrentRootsPrefab()` deactivates the previous root object and activates the new one. `UpdateRootsLODsScale()` scales the active root LOD children.

## Prefabs And Scaling

Root meshes come from:

`Assets/Prefabs/Vegetation/Components/Roots/Roots_Incremental/`

The current implementation uses incremental root prefabs named `Roots_001` through `Roots_010`. Their default renderer bounds are measured during `TreeController.InitializePrefabs()` and stored as root prefab depths and widths.

Root scale settings live in `SimulationSettings`:

- `MinRootsFullHeightScale`
- `MaxRootsFullHeightScale`
- `MinRootsFullWidth`
- `MaxRootsFullWidth`
- `RootsSpreadSpeedFactor`
- `RootsSizeRatio`
- `RootsYOffsetFactor`
- `RootsWidthVariability`
- `RootsCarbonFactor`
- `CubeARootsCarbonFactor`

Web optimization can multiply root carbon factors through `SimulationSettings.OptimizeForWeb()`.

## Known Constraints

- Roots are implemented as discrete prefab swaps plus scale changes, not procedural geometry.
- The mapping is an approximate visual representation of root carbon, not a literal root architecture model.
- Current root carbon visualization is strongest for overstory/tree roots.
- Root orientation is sensitive to prefab rotations and parent transforms. Runtime code should instantiate roots as local children of their tree and set local transform intentionally.

