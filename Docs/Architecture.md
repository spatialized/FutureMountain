# Future Mountain Architecture

Last updated: 2026-06-15

## Project Type

Future Mountain is a Unity project using Unity 2022.3.62f3. The active build scene is:

- `Assets/Scenes/FutureMountain/FutureMountain.unity`

The project targets WebGL and standalone/editor workflows. Build symbols in `ProjectSettings/ProjectSettings.asset` include:

- `WEB_VERSION` for WebGL.
- `LOCAL_VERSION` for Standalone.

## High-Level Runtime Flow

1. `GameController` coordinates scene startup, UI state, time, cube setup, timeline setup, messages, and simulation updates.
2. `SimulationSettings` stores tunable runtime and performance settings, including WebGL optimization multipliers.
3. `WebManager` fetches JSON data from the API in web/local builds.
4. `LandscapeController` loads and formats watershed-level water, terrain, patch, snow, and fire data.
5. `CubeController` loads and visualizes per-cube RHESSys data for snow, groundwater, water access, streamflow, litter, photosynthesis, transpiration, and vegetation carbon.
6. UI scripts control the warming knob, time knob, pause button, timeline interactions, and message display.
7. Fire scripts under `Assets/Scripts/Fire` manage grid/cell fire behavior and visual fire propagation.

## Main Project-Owned Code Areas

- `Assets/Scripts/Controllers`
  - `GameController`: application coordinator and simulation loop.
  - `LandscapeController`: large terrain state, water/patch/fire/terrain data formatting, snow/river/fire visualization.
  - `CubeController`: detailed cube state, data parsing, vegetation/water/soil/fire visual updates.
  - `WebManager`: UnityWebRequest wrapper around the Future Mountain API.
  - Tree, shrub, stream, soil, camera, and water-to-groundwater controllers.
- `Assets/Scripts/Models`
  - JSON/data transfer classes for cube, date, fire, terrain, water, and patch data.
  - `FireModels.cs` — `FireDataPoint`, `FireDataPointCollection`, `FireDataFrame`, `FireDataFrameRecord`
  - `SnowData.cs` — `SnowDataFrame`
  - `WaterDataFrames.cs` — `WaterDataFrame`, `WaterDataMonth`, `WaterDataYear`
  - `TerrainSimulationData.cs` — `TerrainSimulationData`
  - `PatchDataModels.cs` — `PatchDataFrame`, `PatchDataMonth`, `PatchDataYear`
  - (Pre-existing) `FireData.cs`, `PatchData.cs`, `WaterData.cs`, `CubeData.cs`, `DateModel.cs`, `TerrainDataFrame.cs`, and timeline transfer classes.
- `Assets/Scripts/UI`
  - Timeline, warming/time knobs, pause/continue buttons, and message management.
- `Assets/Scripts/Utilities`
  - `MathUtils.cs` — shared `MapValue(value, from1, to1, from2, to2)` used across controllers and UI. Previously duplicated in ~10 files.
  - `GameUtilities.cs`, `GameObjectPool.cs`, `GameObjectExtensions.cs` — pre-existing general helpers.
- `Assets/Scripts/Settings`
  - `SimulationSettings` MonoBehaviour with inspector-tuned parameters. See [SimulationSettings.md](SimulationSettings.md) for full field reference.
- `Assets/Scripts/Fire`
  - SERI fire grid, cells, nodes, terrain texture integration, visual manager, and ignition helpers.

## Data Sources

The current web API base URL is selected by scripting symbol:

- `LOCAL_VERSION`: `http://localhost:5550/api/`
- `WEB_VERSION` or default: `https://data.futuremtn.org/api/`

Known API paths:

- `cubedata/{patchIdx}/{warmingIdx}`
- `waterdata/{index}`
- `waterdata/total`
- `firedata/{warmingIdx}`
- `patchdata`
- `patchdata/{patchId}`
- `dates`
- `dates/{year}/{month}/{day}`
- `terraindata/{warmingIdx}`

Standalone/non-web paths still support TextAsset/Resources workflows in several places, but the current settings default toward web/API loading.

## Scene and UI Structure

The scene contains:

- One large terrain/landscape.
- One aggregate cube and five individual cubes.
- Matching side-by-side cube instances.
- Loading, setup, simulation, side-by-side, and timeline UI canvases.
- Instruction/loading text stored directly in the Unity scene.
- Message data referenced as TextAssets by `GameController`.

## Scenario Assumptions Currently Embedded

The current runtime assumes:

- Five warming levels mapped by index: `0 -> 0 C`, `1 -> 1 C`, `2 -> 2 C`, `3 -> 4 C`, `4 -> 6 C`.
- Five individual cubes plus one aggregate cube.
- Big Creek-oriented API/database data.
- Fixed cube data column order through enum indices in `CubeController` and `WebManager`.
- Fixed patch and water column order through enum indices in `LandscapeController`.
- Terrain/fire data shapes that match the existing Big Creek data pipeline.

These assumptions should be reviewed before adding the Central Coast scenario.

## External and Third-Party Assets

The project includes several Unity asset/plugin areas, including Standard Assets, Dynamic Fog, PostProcessing, Dynamic Snow System, River Auto Material, Terrain Stitch, NatCorder, Horizon[ON], NatureManufacture/Dynamic Nature assets, and utility/editor packages. These are not all necessarily active in the final scene, but they are part of the repository and should be handled carefully during refactors.

## Refactor Priorities For Handoff

### Completed (June 2026)

- Extracted all data model classes previously embedded in `LandscapeController.cs` into dedicated files under `Assets/Scripts/Models/`. `LandscapeController.cs` no longer defines any model types.
- Consolidated the `MapValue` range-mapping utility (previously copy-pasted into ~10 files) into `Assets/Scripts/Utilities/MathUtils.cs`. All call sites updated.
- Removed obsolete commented-out code from `LandscapeController.cs` (terrain texture helpers, debug log statements, dead method variants).
- Cleaned up commented-out code and bogus nested-namespace `using` statements in the RHESSys Data Importer project.
- Converted `SimulationSettings.BuildForWeb` from an Inspector toggle to a compile-time property (`true` for `WEB_VERSION`/`LOCAL_VERSION`, `false` for Editor). Removes the risk of a mis-set Inspector value breaking web builds.
- Wired `LandscapeController` debug logging (`DebugGame`, `DebugFire`, `DebugDetailed`) to `SimulationSettings` instead of hardcoded local fields. Debug output is now controlled from the Inspector.

### Remaining

- Introduce a scenario configuration layer used by runtime code, not only by importer/config files.
- Replace duplicated warming-level switch statements with a shared data structure.
- Consolidate data contracts so importer, database/API, and Unity DTOs cannot drift silently.
- Separate Big Creek content and labels from reusable visualization code.
- Decide whether the data importer should live in this repo as a utility project or remain a separate repo with clear versioning and setup docs.

