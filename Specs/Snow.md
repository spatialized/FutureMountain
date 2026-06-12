# Snow Spec

Last updated: 2026-06-12

## User Interface Behavior

Snow appears on the landscape and cubes as a visible indicator of changing water/climate conditions. In Big Creek, snow is central to the experience because the Sierra Nevada watershed depends heavily on snowpack dynamics.

This system is likely Big Creek-specific, but it is important to preserve because future mountain or high-elevation scenarios may reuse it.

## Technical Behavior

Snow is implemented in two related ways:

- Cube snow uses each cube's `snow` data value and a per-cube `SnowManager`.
- Landscape snow uses terrain splatmaps and, in some modes, background `SnowManager` objects.

The project uses `SnowManager` components from the included Dynamic Snow/NatureManufacture-related assets.

## Cube Snow

`CubeController` reads snow from cube data:

- Web/API path: `CubeData.snow`.
- TextAsset path: `DataColumnIdx.Snow` or `AggregateDataColumnIdx.Snow`.

It tracks `SnowAmountMin` and `SnowAmountMax` from data ranges. Runtime snow value is mapped into a `SnowManager.snowValue`, clamped to a visual range.

Cube snow also interacts with precipitation-to-groundwater visual effects:

- `UpdatePrecipToGW(float snowValue)` activates the rain/snow-to-groundwater prefab when snow value is greater than zero.

## Landscape Snow

`LandscapeController` owns:

- `snowManager` for `SnowManager_Landscape`.
- `snowManagerBkgd` for `SnowManager_Background`.
- `snowWeightFactor`.
- `backgroundSnowFactor`.
- `averageSnowAmount`.
- `SnowAmountMax`.
- `AvgSnowAmountMin` and `AvgSnowAmountMax`.

Scripting symbols affect background snow:

- `LOCAL_VERSION`: `backgroundSnowOn = true`.
- `WEB_VERSION`: `backgroundSnowOn = false`.
- Default: `backgroundSnowOn = false`.

When background snow is on, landscape simulation can load terrain data through `terraindata/{warmingIdx}` and build monthly/current splatmaps. `FinishUpdateTerrainDataFromWeb()` converts API terrain data into `TerrainDataFrame` objects and then into splatmaps.

## Splatmap Behavior

Landscape terrain uses splatmap texture weights to represent:

- Unburned/no snow.
- Unburned/snow.
- Burned/snow.
- Burned/no snow.

In non-web/local paths, `BuildTerrainSplatmapForDay()` interpolates between monthly patch data, maps snow to a normalized weight, and blends snow with burned/regrowth state.

In web/background-snow paths, `UpdateTerrain()` looks up precomputed monthly splatmaps, interpolates them by day/month/year, and applies the result to `terrain.terrainData.SetAlphamaps(...)`.

## Fire Interaction

Snow and fire share terrain texture blending. Burned terrain can still show snow through burned-snow texture weights. During post-fire recovery, `regrowthAmount` gradually shifts weights back toward unburned terrain.

## Current Constraints

- Landscape web snow behavior is split by `backgroundSnowOn`, and WebGL currently sets it false.
- Some background snow update code is commented out.
- A hard-coded landscape start year of `1942` appears in the web/background snow month-index calculation.
- Snow texture layer meaning is implicit in code comments and terrain setup.
- Future scenarios should explicitly decide whether they use cube snow only, full landscape snow, no snow, or a replacement seasonal surface system.

