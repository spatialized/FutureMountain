# Soil Spec

Last updated: 2026-06-12

## Purpose

Soil is the cube-level visual layer that shows near-surface wetness and deeper soil moisture state. It helps connect abstract RHESSys water variables to visible ground conditions around vegetation.

In the current version, soil is primarily a material/shader-driven visual system rather than a geometry-changing system.

## Visual Behavior

Soil wetness is communicated through shininess/reflectivity:

- Surface soil objects become glossier as vegetation-accessible water increases.
- The front deep-soil plane changes its material metallic value based on groundwater depth.

This makes wetter soil read as darker, shinier, or more reflective depending on the material and lighting setup.

## Data Inputs

Soil visualization uses cube data fields:

- `vegAccessWater`: vegetation-accessible water in surface soil.
- `depthToGW`: depth to groundwater.

The `soil` data field is loaded and tracked in data models, but this audit did not find it driving a current direct visual effect. Current soil visuals are water-focused.

## Technical Flow

`CubeController` reads water values into:

- `WaterAccess`
- `DepthToGW`

During startup and playback, `CubeController` calls:

```text
soilController.UpdateParams(timeStep, WaterAccess, DepthToGW)
soilController.UpdateSimulation(timeIdx, timeStep, WaterAccess, DepthToGW)
```

`SoilController` finds its child renderers at startup:

- `FrontPlane` for deep/front soil.
- `SurfaceSoil1`, `SurfaceSoil2`, etc. for shallow surface soil patches.
- `GroundWater1`, `GroundWater2`, etc. for groundwater pockets.

It stores each renderer's material so it can update shader parameters during the simulation.

## Surface Soil Mapping

`SoilController.UpdateSimulation()` maps `waterAccess` from `[WaterAccessMin, WaterAccessMax]` into:

- `minShallowSoilShininess`
- `maxShallowSoilShininess`

It writes the mapped value to each surface soil material:

```text
_Glossiness
```

Higher `vegAccessWater` therefore makes shallow soil appear wetter or shinier.

## Deep Soil Mapping

`SoilController.UpdateSimulation()` also maps groundwater-related state into a deep-soil shininess value and writes it to the front soil material:

```text
_Metallic
```

This is a visual cue for deeper wetness rather than a literal soil-carbon display.

## Current Constraints

- The current code maps deep-soil shininess using `waterAccess` while checking `depthToGW` bounds. This may be intentional visual tuning or a historical bug; future refactors should confirm the desired mapping.
- Soil carbon is loaded but not strongly visualized in the current implementation.
- Soil materials depend on Unity shader parameters such as `_Glossiness` and `_Metallic`; changing material/shader types can break the wetness cue.
- The behavior is cube-local and does not directly change the large landscape terrain.

