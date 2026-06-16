# Data Mappings

Last updated: 2026-06-12

## Purpose

This spec explains how Future Mountain data fields become 3D visual behavior over time. It complements [DataModel.md](DataModel.md), which describes the shape of the data. This document focuses on runtime interpretation: which values drive which objects, materials, particles, terrain textures, UI displays, and time-based behaviors.

## Mapping Overview

| Data source | Field(s) | Primary visual target | Update style |
| --- | --- | --- | --- |
| `waterdata` | `qBase`, `qWarm1`, `qWarm2`, `qWarm4`, `qWarm6` | Large landscape river height/face | Direct mapped value by warming index |
| `cubedata` | `qout` | Cube stream height/face | Direct mapped value, log-scaled |
| `cubedata` | `snow` | Cube snow surface and precipitation-to-groundwater particle effect | Accumulating/melting value over time |
| `patchdata` / `terraindata` | `snow`, terrain splatmap data | Large landscape snow texture/surface | Splatmap blending/interpolation |
| `cubedata` | `depthToGW` | Cube groundwater color/wetness | Range-mapped material color/metallic |
| `cubedata` | `vegAccessWater` | Cube surface soil wetness | Range-mapped material glossiness |
| `cubedata` | `transOver`, `transUnder` | Tree/shrub evapotranspiration particles | Particle emission rate |
| `cubedata` | `leafC*`, `stemC*`, `rootC*` | Tree count, tree size, shrub count/size, roots | Feedback system over time; full regeneration on jumps |
| `cubedata` | `litter` | Litter/dead vegetation state | Partial/unfinished; litter objects shrink over time |
| `cubedata` | `netpsn` | Model/statistics data | Stored/ranged, limited visible mapping |
| `firedata` | fire frames, fire points, spread/iter | Landscape fire grid/cells and burned terrain | Data-driven fire spread after scheduled ignition |
| `dates` | `year`, `month`, `day`, `id` | Time progression, timeline, sun position, event matching | Global clock/date index |

## Time Model

`GameController` owns the global simulation index, `timeIdx`. During playback, `RunGame()` increments `timeIdx` by `timeStep` when the simulation is not paused and not auto-paused during fire. `UpdateSimulation()` then applies the current date to the landscape, cubes, messages, timeline, fire, and lighting.

Timeline jumps use a different path. When the user clicks a timeline year, `TimelineControl.clickedID` is read by `GameController`, which calls `SetTimePosition(selectedYearIdx)`. That sets `timeIdx` to January 1 of the selected year, then forces relevant systems to re-read data for the new time.

This distinction matters most for vegetation:

- Playback: compare current visual vegetation against current model data and grow/kill incrementally.
- Timeline jump: reset the cube and regenerate vegetation from data for the destination time.

## Landscape Water Mapping

Large landscape river flow comes from `waterdata`.

The current model stores one streamflow value per warming level:

- `QBase`
- `QWarm1`
- `QWarm2`
- `QWarm4`
- `QWarm6`

`WaterDataFrame.GetStreamflowForWarmingIdx(warmIdx)` maps warming index to the correct streamflow field. `LandscapeController.UpdateData()` stores the current value in `StreamflowLevel`.

`LandscapeController.UpdateRiver()` maps `StreamflowLevel` into:

- `riverObject.transform.localPosition.y`
- `riverFaceObject.transform.localPosition.y`
- `riverFaceObject.transform.localScale.y`

The mapping uses `MapValue(StreamflowLevel, RiverLevelMin, RiverLevelMax, ...)` and clamps to scene-configured min/max heights/scales.

## Cube Stream Mapping

Cube stream flow comes from `cubedata.qout`, stored as `CubeController.StreamHeight`.

`CubeController.UpdateStream()` maps it through a logarithmic scaling step:

```text
streamPos = MapValue(Log(StreamHeight) * 20, StreamHeightMin, StreamHeightMax, 0, 1)
```

Then it maps `streamPos` to:

- `streamObject.transform.localPosition.y`
- `streamFaceObject.transform.localScale.y`

This means cube streams are not a purely linear visualization. The log scaling makes smaller changes more visible across a broad streamflow range.

## Cube Soil And Groundwater Mapping

Cube soil uses:

- `vegAccessWater` -> `WaterAccess`
- `depthToGW` -> `DepthToGW`

`CubeController.UpdateVegetationBehavior()` calls:

```text
soilController.UpdateSimulation(timeIdx, timeStep, WaterAccess, DepthToGW)
```

`SoilController` maps `WaterAccess` to shallow soil material glossiness. Higher water access makes surface soil appear wetter/shinier.

`DepthToGW` is mapped against groundwater object vertical positions. Groundwater objects fade between wet and dry colors based on whether the mapped groundwater level is above or below each object. This is a visual depth cue rather than literal geometry movement.

## Cube Snow Mapping

Cube snow uses `cubedata.snow`, stored as `SnowAmount`.

On simulation start, the current snow amount is mapped into `snowManager.snowValue`. During playback, snow behaves like an accumulated visual state:

1. Existing `snowValue` melts by `snowMeltRate * sqrt(timeStep)`.
2. Current or recent `SnowAmount` data is mapped from data min/max into the visual snow range.
3. At small time steps, mapped snow is added gradually.
4. At larger time steps, combined snow over the skipped interval is averaged and amplified/replaced so fast playback remains readable.
5. `snowManager.snowValue` is updated.
6. If snow is present, `UpdatePrecipToGW(snowValue)` activates the precipitation-to-groundwater particle effect.

The precipitation-to-groundwater effect is controlled by `WaterToGWController`, which maps snow value and time step into particle emission rate, speed, lifetime, and trail lifetime.

## Landscape Snow Mapping

Landscape snow is more complex and likely Big Creek-specific.

In local/non-web paths, `LandscapeController.BuildTerrainSplatmapForDay()` uses monthly patch snow values. For each patch:

1. Current and next month snow values are normalized against `SnowAmountMax`.
2. Snow is interpolated by day-of-month.
3. Snow weight is converted to terrain texture weights.
4. Patch extents map patch IDs to alphamap locations.
5. Splatmap weights are written into the terrain alphamap.

The terrain texture layers are used as:

- Unburned/no snow.
- Unburned/snow.
- Burned/snow.
- Burned/no snow.

In web/background-snow paths, terrain data can come from `terraindata/{warmingIdx}` as precomputed splatmap frames. `UpdateTerrain()` interpolates between monthly splatmaps and applies them to the terrain.

Fire and snow share the same splatmap blending. If a patch is burned, the snow/no-snow weight is blended with burned/recovered texture state.

## Cube Vegetation Mapping

Vegetation is the most sophisticated mapping system. It does not simply set object scales from data every frame. Instead, it maintains a living 3D population that approximates model carbon values over time.

### Data Roles

For one-layer vegetation cubes (`Veg1`):

- `leafCOver + stemCOver` represents shrub/grass biomass.
- `transOver` drives shrub evapotranspiration particle emission.
- `rootCOver` is available but tree roots are mainly relevant for tree-capable cubes.

For two-layer vegetation cubes (`Veg2`):

- `leafCOver + stemCOver` represents overstory tree biomass.
- `rootCOver` represents overstory roots.
- `transOver` drives tree evapotranspiration.
- `leafCUnder + stemCUnder` represents understory shrub/grass biomass.
- `transUnder` drives shrub evapotranspiration.

For aggregate cubes (`Agg`):

- Overstory/understory carbon fields are used similarly.
- `NetTranspiration` is mapped from aggregate transpiration.
- Aggregate-specific carbon/emission factors are used.

### Carbon-to-Object Conversion

`CubeController.Initialize()` calculates average carbon represented by a visual object:

- `treeAverageCarbonAmount`
- `treeAverageRootCarbonAmount`
- `shrubAverageCarbonAmount`
- `grassAverageCarbonAmount`

These depend on `SimulationSettings` factors, tree/shrub full-size ranges, full tree height, and root depth. Web builds modify some values to reduce vegetation density.

The scene can then compare:

```text
model carbon at current time
vs.
carbon currently represented by visible objects
```

Current visualized tree carbon comes from `TreeController.GetCarbonAmount()`, which uses tree height scale, full tree height, and tree carbon factor. Current visualized shrub carbon comes from shrub renderer height times shrub carbon factor. Root carbon is summed from living fir root state.

### Initial Generation

`GrowInitialVegetation()` converts the current data row into initial object counts.

For `Veg1`:

```text
shrubsToGrow = round((stemCOver + leafCOver) / shrubAverageCarbonAmount)
```

For `Veg2`:

```text
treesToGrow = round((stemCOver + leafCOver) / treeAverageCarbonAmount)
shrubsToGrow = round((stemCUnder + leafCUnder) / shrubAverageCarbonAmount)
```

It then grows firs, shrubs, and initial grass patches. This path is used when starting a non-web simulation and when a cube is reset/regenerated for a timeline jump.

### Playback Update

During playback, `UpdateVegetationBehavior(timeIdx, timeStep)` updates the current data values, then calls `UpdateVegetation()` unless the terrain is currently burning.

`UpdateVegetation()` is a feedback controller:

1. If pending kill counts exist, kill a fir, shrub, or grass patch.
2. Compute target model carbon for the current data row.
3. Compute current visualized carbon in the scene.
4. If visual carbon is too low, grow new objects.
5. If visual carbon is too high, mark objects to die.
6. Continue growth animations for existing roots, shrubs, and grass.

The tolerance is generally half an average object:

```text
if visual < target - averageObjectCarbon / 2: grow
if visual > target + averageObjectCarbon / 2: kill
```

Growth is throttled by wait times such as `firGrowthWaitTime` and `shrubGrowthWaitTime` so vegetation does not spawn all at once during normal playback.

### Timeline Jump / Regeneration

When a user clicks the timeline, `GameController.SetTimePosition()` changes `timeIdx` and calls `UpdateVegetationFromData()` on active cubes.

`UpdateVegetationFromData()`:

1. Calls `ResetCube()`.
2. Reads the data row for the new `timeIdx`.
3. Calls `GrowInitialVegetation()`.

This is intentionally different from playback. A large time jump should not animate decades of growth/death one event at a time; it reconstructs a plausible vegetation state directly from the destination data.

## Tree And Shrub Size Mapping

Tree count is driven primarily by carbon, but individual tree size is also animated. Trees have randomized full height/width scales within `SimulationSettings` ranges. Tree prefabs and root prefabs are selected based on current height/depth, and LOD groups are scaled as growth changes.

Tree evapotranspiration maps to particle emission. `FirController.UpdateSimulation()` receives transpiration and sets emission rate. It also updates growth or death state.

Shrubs are simpler. Their count is driven by understory or one-layer carbon. Their evapotranspiration particle emission is driven directly from `TransUnder`, `TransOver`, or aggregate net transpiration depending on cube type.

## Litter Mapping

`cubedata.litter` is stored as `Litter`, but the current visible mapping appears incomplete. `UpdateLitter()` collects objects tagged as litter and shrinks existing litter over time using `SimulationSettings.DeadTreeShrinkFactor`. `GetLitterAmountVisualized()` currently returns `0f`, so this mapping should be treated as partially implemented.

## Net Photosynthesis Mapping

`cubedata.netpsn` is stored as `NetPhotosynthesis` and included in data range calculations. The current visible mapping is limited; several UI/statistics lines for net photosynthesis are commented out. Treat `netpsn` as available model data with incomplete or disabled visualization in the current version.

## Unvisualized Or Partially Visualized Fields

This section is provisional because the original raw Big Creek source data is not present in this repo or in the configured sibling `../Data` folder on this workstation. It is based on the Unity code, runtime DTOs, and `ScenarioConfig_BigCreek.json`.

### Clearly Visualized

These fields currently have direct or substantial visual mappings:

- `cubedata.snow`: cube snow and precipitation-to-groundwater particles.
- `cubedata.depthToGW`: cube groundwater/soil visualization.
- `cubedata.vegAccessWater`: cube surface-soil wetness.
- `cubedata.qout`: cube stream height/face scale.
- `cubedata.transOver`, `cubedata.transUnder`: evapotranspiration particles.
- `cubedata.leafCOver`, `stemCOver`, `rootCOver`, `leafCUnder`, `stemCUnder`, `rootCUnder`: tree/shrub/root population, growth, size, and fire biomass loss.
- `waterdata.qBase`, `qWarm1`, `qWarm2`, `qWarm4`, `qWarm6`: landscape river height/face by warming scenario.
- `waterdata.precipitation`: timeline bar height and message/story context.
- `patchdata.snow`: landscape snow splatmap generation in local/non-web paths.
- `patchdata.spread`, `patchdata.iter`: fire frame generation in legacy/local paths.
- `firedata._dataList`: data-controlled fire grid cells/spread.
- `terraindata._dataList`: precomputed terrain/snow splatmaps when background snow terrain data is enabled.

### Partially Or Weakly Visualized

These fields are loaded or ranged but appear to have limited current visual effect:

- `cubedata.netpsn`: stored as `NetPhotosynthesis` and ranged, but UI/statistics visualization is mostly commented out.
- `cubedata.litter`: stored and `UpdateLitter()` shrinks existing litter objects, but `GetLitterAmountVisualized()` returns `0f`, so model litter does not appear to fully drive litter object creation.
- `cubedata.evap`: present in the DTO/column mapping, but this audit did not find an active visual mapping. Evaporation appears folded into labels such as evapotranspiration rather than separately visualized.
- `cubedata.soil`: present in DTO/column mapping, but this audit did not find an active visual mapping. `SoilController` has a `soilCarbon` field, but current update calls use water access and groundwater depth.
- `cubedata.heightOver`, `heightUnder`: present in DTO/column mapping. Current vegetation size is primarily derived from carbon factors and generated object geometry rather than directly setting tree/shrub height from these fields.
- `waterdata.index`: used as a record/index value, not a visualization.
- `dates.id`, `dates.date`, `dates.year`, `dates.month`, `dates.day`: drive time, timeline, messages, events, and lighting, but are metadata/control data rather than ecological visual variables.

### Configured But Not Runtime-Visualized In Unity

`ScenarioConfig_BigCreek.json` includes source mappings that are useful to the importer/database but not directly visualized by the Unity runtime as standalone variables:

- `basin.wy` / `waterYear`: importer/database metadata. Unity consumes calendar date and streamflow/precipitation instead.
- `climate.date`, `day`, `month`, `year`: source climate metadata.
- `climate.precip`, `tmax`, `tmin`, `tavg`, `vpd`: configured for import, but this audit did not find direct Unity visualization of climate fields as separate variables. Their effects may be implicit in RHESSys outputs such as snow, streamflow, transpiration, vegetation carbon, and fire spread.

### Unknown Until Schema/Data Samples

The following need confirmation from MySQL schema export and old/new source snippets:

- Whether imported tables include additional columns not represented in current Unity DTOs.
- Whether Central Coast v2 adds variables that should be visualized or stored only for provenance/model completeness.
- Whether climate source fields should remain import-only or become user-visible explanatory layers.
- Whether `height_*`, `evap`, `soil`, `netpsn`, and `litter` should be promoted into stronger visual roles or removed from runtime payloads if unused.

## Fire Mapping

Fire is covered in detail in [Fire.md](Fire.md), but from a data-mapping perspective:

- Fire dates are scheduled scenario events.
- Fire spread/severity after ignition is driven by `firedata` frames.
- Landscape fire data maps to `SERI_FireGrid` cells and burned terrain splatmap state.
- Cube fire uses fire-time vegetation carbon differences to decide how many shrubs/trees to burn.

Fire also modifies later mappings by setting burned terrain state, killed vegetation, and litter/dead tree behavior.

## Model/Statistics Overlay Mapping

See [ShowModelDataLayer.md](ShowModelDataLayer.md) for the feature-level behavior and future improvement notes.

The model display compares data values against visualized values. `CubeController.UpdateStatistics()` maps:

- Data net transpiration into `netTransSlider`.
- Data stem + leaf carbon into `plantCarbonSlider`.
- Visualized transpiration into `netTransSliderDebug`.
- Visualized tree + shrub carbon into `plantCarbonSliderDebug`.

Several additional sliders for snow, net photosynthesis, water access, and groundwater depth are present or referenced but commented out.

## Backward Compatibility Notes

For Central Coast or future scenarios, each new field should declare a visual role:

- Direct geometry mapping.
- Material/color mapping.
- Particle mapping.
- Terrain/splatmap mapping.
- Population feedback mapping.
- UI/statistics only.
- Metadata/no direct visualization.

Adding a new data field should not automatically require a new visual behavior. If a field is not used visually yet, it should be documented as available but unmapped. Big Creek should continue to provide the existing mapped fields, or a scenario adapter should provide default values.
