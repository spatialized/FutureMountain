# Ground Water

Last updated: 2026-06-12

## Purpose

Ground water is a cube-level visual cue for depth to groundwater. It shows hidden water availability below the terrain surface and helps explain why vegetation may grow, decline, or experience water stress.

The current implementation represents groundwater as colored water-pocket objects embedded in the soil portion of each cube.

## Visual Behavior

Groundwater objects are named `GroundWater1`, `GroundWater2`, and so on under a cube's `Soil` object. They do not physically fill upward or move during playback. Instead, each object changes color and material wetness according to the current mapped groundwater level.

The intended visual effect is:

- Wet/filled pockets when groundwater is high enough for that pocket.
- Dry or less saturated pockets when groundwater is too deep.
- Smooth color blending near the transition.

## Data Inputs

Groundwater visualization uses:

- `depthToGW`: depth to groundwater from cube model data.

`CubeController` loads this into `DepthToGW` and passes it to `SoilController`.

## Technical Flow

`SoilController.Start()` discovers groundwater pocket objects by repeatedly looking for child names:

```text
GroundWater1
GroundWater2
GroundWater3
...
```

For each pocket it stores:

- Renderer.
- Material.
- Local Y position.

It initializes each groundwater material with:

```text
_Metallic = 0
_Smoothness = 0.5
```

During playback, `CubeController.UpdateVegetationBehavior()` calls:

```text
soilController.UpdateSimulation(timeIdx, timeStep, WaterAccess, DepthToGW)
```

`SoilController.UpdateSimulation()` then calls `UpdateGroundwater()`.

## Depth Mapping

`UpdateGroundwater()` normalizes the current `depthToGW` against:

- `DepthToGWMin`
- `DepthToGWMax`

It maps that value into a normalized groundwater position from `0` to `0.75`. Each groundwater object maps its own local Y position between:

- `deepSoilBottomYPos`
- `deepSoilTopYPos`

The difference between mapped groundwater level and object position determines whether the object is displayed as wet, dry, or in transition.

## Material Mapping

Groundwater uses two HSV-defined colors:

- `gwWet`
- `gwDry`

The code converts those to Unity colors at startup. During updates:

- Objects clearly above/beyond the mapped level are assigned the dry color and higher metallic value.
- Objects clearly below/within the mapped level are assigned the wet color and lower metallic value.
- Objects near the threshold blend between wet and dry colors.

This gives the appearance of pockets filling or draining without moving geometry.

## Related Systems

Groundwater is visually related to the precipitation-to-groundwater effect described in `Snow.md`. Cube snow can activate `RainToGW_Prefab`, while groundwater pockets show the current mapped groundwater-depth state.

These are separate systems:

- Snow/rain-to-groundwater is a particle/pathway effect.
- Groundwater pockets are persistent soil objects whose material state changes.

## Current Constraints

- Groundwater pockets do not physically fill, deform, or move.
- The visual mapping is relative to min/max values calculated from loaded cube data.
- The color comments in `SoilController` are partly inconsistent with the wet/dry variable names; behavior should be verified visually before changing colors.
- The current system is cube-local and does not render watershed-scale groundwater on the large landscape.

