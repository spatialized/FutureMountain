# Big Creek Version

Last updated: 2026-06-16

## Scope

This document describes the current Big Creek version of Future Mountain as
implemented in this Unity repository. It is a baseline for comparison as newer
scenario scenes are added.

## Current Scenario

- Scenario: Big Creek watershed, Sierra Nevada.
- Scientific source: RHESSys-derived model output.
- Warming levels: baseline, `+1 C`, `+2 C`, `+4 C`, `+6 C`.
- Runtime data source: Future Mountain API for web builds, with legacy
  TextAsset/Resources loading paths still present.
- Unity scene: `Assets/Scenes/BigCreekV1/BigCreekV1.unity`.

## Primary User Features

Feature-level specs:

- [Normal Mode](../../Specs/NormalMode.md)
- [Side-by-Side Mode](../../Specs/SideBySideMode.md)
- [Timeline](../../Specs/Timeline.md)
- [Show Model / Data Layer](../../Specs/ModelDataLayer.md)
- [Data Model](../../Specs/DataModel.md)
- [Data Mappings](../../Specs/DataMappings.md)
- [Fire](../../Specs/Fire.md)
- [Messages](../../Specs/Messages.md)
- [Lighting](../../Specs/Lighting.md)
- [Snow](../../Specs/Snow.md)
- [Roots](../../Specs/Roots.md)
- [Soil](../../Specs/Soil.md)
- [Ground Water](../../Specs/GroundWater.md)

## Runtime Behavior

- The user can start the simulation, select warming level, pause/resume, use the
  timeline, inspect cubes, and enter Side-by-Side Mode.
- The scene contains one aggregate cube, five detailed terrain cubes, matching
  side-by-side cube instances, and one large watershed terrain.
- Fire, snow, river/streamflow, vegetation, roots, groundwater, and cube
  statistics appear consistently with the deployed Big Creek behavior.
- Web builds use `https://data.futuremtn.org/api/`.
- Local standalone builds use `http://localhost:5550/api/`.
- Web optimization reduces vegetation density and increases carbon factors in
  `SimulationSettings.OptimizeForWeb`.

## Known Constraints

- Big Creek assumptions are still embedded in code, data, scene setup, and UI.
- Warming levels are hard-coded in multiple places.
- Several data formats are positional rather than schema-driven.
- Some non-web data loading paths remain but may not be current.
- API/database schema is external to this Unity repo.

## Baseline Check

- Project opens in Unity `2022.3.62f3`.
- `Assets/Scenes/BigCreekV1/BigCreekV1.unity` loads without missing scripts.
- WebGL build can load Big Creek data from the API.
- Timeline, messages, terrain, cubes, Side-by-Side Mode, fire, snow, roots,
  groundwater, and model data layer remain functional.
