# Fire

Last updated: 2026-06-16

## Conceptual Model

RHESSys fire dates are intentionally set by the scenario. In the current Big Creek version, the fires are scheduled on:

- July 15, 1969
- November 20, 1988

Those dates are not emergent from climate or vegetation data inside the Unity simulation. They are scenario events.

However, once a scheduled fire begins, its extent/severity/spread is data-driven. Big Creek fire spread differs by warming scenario because the loaded fire data for each warming index defines which patches/cells burn and in what order/intensity.

## User Interface Behavior

When time reaches a scheduled fire:

- The large landscape can ignite a data-driven fire pattern.
- Relevant cubes can ignite if they correspond to affected patches or are explicitly configured to burn.
- The fire may auto-pause the simulation if `AutoPauseOnFire` is enabled.
- Fire icons appear on the timeline at fire years.
- Fire messages can appear through the message system.
- Burned terrain changes appearance, then may visually regrow/recover over time.
- Vegetation in cubes can burn, die, shrink, or be removed based on the fire effect on visualized biomass.

## Scheduled Fire Dates

`GameController.SetupFires()` currently hard-codes two `Vector3(month, day, year)` dates:

- `(7, 15, 1969)`
- `(11, 20, 1988)`

It converts those dates into `timeIdx` values using `GetTimeIdxForDay()`, stores them in `fireFrames`, and sends the dates to `LandscapeController.SetupFires()`.

The code comments mark this as a future refactor target: fire dates should come from scenario data/configuration.

## Fire Ignition Flow

`GameController.UpdateFireIgnition()` checks the current `timeIdx` against `fireFrameSet`. If the time step skips over a fire frame, it also scans the interval between the last and current time index so fires are not missed at higher simulation speeds.

When a fire should start:

1. `pausedAuto` is set if `SimulationSettings.AutoPauseOnFire` is true.
2. `LandscapeController.IgniteTerrain(date, timeStep, autoPause, maxFireLength, fireFrameIdx)` ignites the large landscape fire.
3. Cube controllers decide whether to ignite through `CubeController.ShouldBurnFireOnDate(date)`.
4. `CubeController.IgniteTerrain(fireTimeIdx, useThresholds)` ignites cube terrain and vegetation.
5. Aggregate cube ignition is checked separately.

## Data-Driven Landscape Spread

Landscape fire data is loaded by warming index:

- Web path: `WebManager.RequestFireData(warmingIdx)` calls `firedata/{warmingIdx}`.
- Local/file path: Resources fire data can be loaded from `FireData/fireDataList_{warmingIdx}`.

`LandscapeController.FinishUpdateFireDataFromWeb()` deserializes API records into `FireDataFrame` objects. Each frame contains date/grid metadata and a list/grid of `FireDataPoint` values.

`SERI_FireManager.Initialize(...)` receives fire frames and creates one `SERI_FireGrid` per fire frame. In data-controlled mode, `SERI_FireGrid` uses `FireDataPoint` and `FireDataPointCollection` data to decide active cells, patch IDs, spread values, and burn order.

## Importer Contract

`FireData` means Unity-compatible fire playback frames. It should contain event dates, landscape fire grid dimensions, and serialized `FireDataPoint` values with patch/zone id, spread, and iter/order. This is the data used for instantaneous fire animation after a scheduled ignition.

`BurnData` is separate. In Central Coast v2, monthly RHESSys burn values from `bm.csv` and `spatial_data_point_patchvar.csv` are imported with `--burn` into `BurnData`. These rows can inform terrain state, but they are not fire spread/iter playback frames.

The Central Coast v2 importer now has a `--fire` scaffold. The scenario config reserves two file roles for future fire-frame sources:

- `fireFrameSpreadIter`: event rows with date, patch/zone id, spread, and iter/order.

That role is empty in the current Central Coast sample bundle because no Central Coast fire-frame source has been provided yet. Central Coast fire-frame generation should reuse existing `PatchData` as the landscape patch/zone grid map; `PatchData` is currently derived from `patchFamilyRaster`.

## Cube Fire Behavior

Cube fires are less spatially data-driven than landscape fires. The cube fire grid is ignited immediately because cube-level spread data is not currently used. The data-driven part is the amount of vegetation to remove:

- `SetVegetationToDieFromFire()` compares current visualized carbon against data values at the fire time index.
- It calculates `shrubsToKill` and, for two-layer vegetation cubes, `firsToKill`.
- `SetShrubsToBurn()` ignites shrub `SERI_FireNodeChain` objects.
- `SetTreesToBurn()` ignites selected `FirController` fire node chains.
- Once burning ends, cube terrain is set to a burned splatmap.

## Fire Animation Architecture

Main fire scripts:

- `SERI_FireManager`: parent coordinator attached under terrain/cube fire manager objects. Stores terrain references, terrain texture rules, fire prefab, grid size, cell size, fire grids, and terrain restoration data.
- `SERI_FireGrid`: creates a grid of fire cells over a terrain, tracks burning cells, starts cells, updates combustion, and handles data-controlled spread.
- `SERI_FireCell`: one cell in the grid. Instantiates pooled fire prefabs, holds fuel/combustion state, sets visual state, and extinguishes/returns pooled objects.
- `SERI_FireVisualManager`: controls particle systems on each fire prefab. It switches heat-up, ignition, and extinguish visual states, randomizes fire, and scales particle parameters.
- `SERI_FireNodeChain`: attached to burnable vegetation objects. It links one or more `SERI_FireNode` objects and can destroy/replace vegetation after fire.
- `SERI_FireNode`: fire node on vegetation; consumes fuel and controls local fire visuals.
- `SERI_FireTerrainTexture`: terrain texture/fire fuel settings.
- `SERI_FireGrassRemover`: removes/replaces grass details after burning.
- `SERI_FireIgniter` and `SERI_FireBox`: legacy/adapted helpers from the Fire Propagation System asset.

Scene fire manager objects are named by cube/terrain, such as `FireManager_A` through `FireManager_F` and `FireManager_T`.

## Burned Terrain And Regrowth

Landscape fire state is tracked with:

- `terrainBurning`
- `terrainBurnt`
- `recentFire`
- `fireRegrowthStartTimeIdx`
- `fireRegrowthLength`

After fire stops, `SetToBurnt()` marks the terrain burned and stops grid fires. `UpdateTerrain()` then blends burned/unburned state through a `regrowthAmount`. Snow and burned texture weights interact in the landscape splatmap.

## Current Constraints

- Fire dates are hard-coded in Unity.
- Big Creek has exactly two scheduled fire dates.
- Landscape fire spread is data-driven by warming index; cube spread is visually immediate and biomass-driven.
- The fire system is adapted from a third-party Fire Propagation System and has project-specific SERI modifications.
- Future scenarios need explicit fire-date configuration and a concrete fire-frame source format that can populate `FireData`.

