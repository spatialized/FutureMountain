# Central Coast Version

Last updated: 2026-06-16

## Scope

This document describes the current Central Coast v2 pre-prototype version of
Future Mountain. It is a work-in-progress scenario beside Big Creek, not a full
replacement for the deployed Big Creek experience.

## Current Scenario

- Scenario: Central Coast v2.
- Unity scene: `Assets/Scenes/CentralCoastV2/CentralCoastV2.unity`.
- Source data: partial RHESSys-derived sample bundle at
  `RHESSYs_Data_Importer/Data/CentralCoast/RHESSysOutput-SingleWarmIdx-6-4-2026/`.
- Import profile: `CentralCoastV2`.
- Scenario run id: `single-warming-sample`.
- Current warming index assumption: `warmingIdx = 0`.
- API profile: `CentralCoast`, using `/api/centralcoast/...` routes.

## Implemented So Far

- Dedicated Central Coast Unity scene.
- Dedicated Central Coast importer profile and database/schema path.
- Dates derived from `cube_agg_p.csv`.
- Cube, water, burn, patch mapping, stratum carbon, and monthly terrain
  generation import paths.
- Initial patch mapping from `Pch30rip90upRN.tiff` into `PatchData`.
- Initial monthly `TerrainData` generation from `PatchData`, `StratumData`, and
  `BurnData`.
- Prototype API routes under `/api/centralcoast/...`.
- Central Coast-specific message resource paths in `SimulationSettings`.

## Important Missing Data

The current Central Coast sample bundle does not yet include real Future
Mountain warming scenarios. It is imported as one assumed baseline/member with
`warmingIdx = 0`.

Fire spread playback data also does not exist yet for Central Coast. Monthly
RHESSys burn data is imported into `BurnData`, but that is not the same as
Unity fire spread-frame data. `FireData` remains reserved for event/frame data
with spread and iteration/order values once a suitable source is provided.

## Current Constraints

- Warming comparison UI and Side-by-Side Mode still inherit Big Creek
  assumptions and need careful validation for a single-warming Central Coast
  sample.
- Fire simulation should not be treated as complete until Central Coast
  fire-frame source data exists.
- Carbon factors, vegetation density, snow, fire, and web multipliers need
  scenario-specific tuning in `SimulationSettings`.
- Central Coast uses rectangular terrain data (`gridWidth = 396`,
  `gridHeight = 301`) rather than Big Creek's square `gridSize` convention.
- Shared assets must be checked carefully so Central Coast visual tuning does
  not bleed into Big Creek.

## Related Docs

- [Adding Future Scenarios](../AddingFutureScenarios.md)
- [Initial Patch Mapping](../CentralCoastV2/InitialPatchMapping.md)
- [Initial Terrain Data](../CentralCoastV2/InitialTerrainData.md)
- [Central Coast Data Formats](../CentralCoastV2/DataFormats.md)
- [Central Coast vs Big Creek](../CentralCoastV2/BigCreekV1Differences.md)
- [Importer Scenario Upgrade Guide](../RHESSysDataImporter/ScenarioUpgradeGuide.md)
