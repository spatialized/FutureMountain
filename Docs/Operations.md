# Future Mountain Operations

Last updated: 2026-06-12

## Purpose

This document is a first-pass operations runbook for opening, testing, building, and handing off the current Future Mountain Unity project. It focuses on the current Big Creek version and should be expanded as deployment credentials, server details, and the Central Coast data pipeline are confirmed.

## Contacts

To be filled in manually.

Suggested contact areas:

- Project owner / producer.
- Unity developer.
- Designer / visual lead.
- Data/modeling contact.
- API/database administrator.
- Web hosting/deployment contact.
- Exhibit/install support contact.

## Repository

- Repository root: `D:\Git\FutureMountain` on this workstation.
- Unity solution: `FutureMountain.sln`.
- Active scene: `Assets/Scenes/FutureMountain/FutureMountain.unity`.
- Unity version: `2022.3.62f3`.
- Scenario config reference: `ScenarioConfig_BigCreek.json`.

The repository contains Unity source/assets plus documentation in `Docs/` and feature specs in `Specs/`.

## Required Local Software

- Unity Editor `2022.3.62f3`.
- Unity WebGL build support if building the online version.
- Git.
- A browser for WebGL smoke testing.
- Optional: MySQL Workbench 8 for schema inspection/export.
- Optional: local Future Mountain API/database stack if testing `LOCAL_VERSION`.

## Build Targets And Symbols

The project currently uses scripting define symbols in `ProjectSettings/ProjectSettings.asset`.

Known symbols:

- `WEB_VERSION` for WebGL.
- `LOCAL_VERSION` for Standalone/editor-local API testing.

Current API base URLs in `Assets/Scripts/Controllers/WebManager.cs`:

- `LOCAL_VERSION`: `http://localhost:5550/api/`
- `WEB_VERSION` or default: `https://data.futuremtn.org/api/`

`SimulationSettings.BuildForWeb` is currently true by default. In web builds, `SimulationSettings.OptimizeForWeb()` reduces vegetation density and increases carbon factors to improve performance.

## Opening The Project

1. Open the repository folder in Unity Hub.
2. Use Unity `2022.3.62f3`.
3. Open `Assets/Scenes/FutureMountain/FutureMountain.unity`.
4. Wait for Unity to finish importing assets and compiling scripts.
5. Confirm that the scene loads without missing-script errors in the Console.

## Running In The Editor

The project can run in the Unity Editor, but current runtime settings are oriented toward API-backed data loading.

Before pressing Play, confirm:

- The active scene is `Assets/Scenes/FutureMountain/FutureMountain.unity`.
- The intended scripting symbol is active for the target being tested.
- The API target is reachable if using web/API data.
- The Console is visible for data-loading errors.

Basic run check:

1. Press Play.
2. Confirm the intro/loading flow appears.
3. Start the simulation.
4. Confirm terrain, aggregate cube, and individual cubes load.
5. Confirm the Timeline appears and the simulation advances through dates.

## Web/API Data Check

For the deployed Big Creek API, these endpoints are expected by Unity:

- `https://data.futuremtn.org/api/cubedata/{patchIdx}/{warmingIdx}`
- `https://data.futuremtn.org/api/waterdata/{index}`
- `https://data.futuremtn.org/api/waterdata/total`
- `https://data.futuremtn.org/api/firedata/{warmingIdx}`
- `https://data.futuremtn.org/api/patchdata`
- `https://data.futuremtn.org/api/patchdata/{patchId}`
- `https://data.futuremtn.org/api/dates`
- `https://data.futuremtn.org/api/dates/{year}/{month}/{day}`
- `https://data.futuremtn.org/api/terraindata/{warmingIdx}`

If the app stalls during loading, first check browser/Unity Console logs for failed API requests, JSON parse failures, or missing fields.

## Local API Testing

`LOCAL_VERSION` points Unity to:

```text
http://localhost:5550/api/
```

Use this path when testing a local API/database copy. The local API should match the same endpoint and JSON field contract as the deployed API unless Unity code is being intentionally updated.

Before testing locally:

- Start the local API.
- Confirm the local database is loaded with the expected scenario data.
- Visit one or two API endpoints directly in a browser to confirm JSON responses.
- Confirm CORS/browser access if testing a WebGL build against the local API.

## WebGL Build Checklist

Before building:

- Confirm active build target is WebGL.
- Confirm `WEB_VERSION` is present for WebGL scripting define symbols.
- Confirm `Assets/Scenes/FutureMountain/FutureMountain.unity` is included in Build Settings.
- Confirm `SimulationSettings.BuildForWeb` is true.
- Confirm the deployed API is reachable.
- Confirm no local-only API URL is selected.

Build smoke test:

1. Launch the built WebGL output through a local web server or deployment staging URL.
2. Confirm loading completes.
3. Confirm the landscape river, cubes, vegetation, snow behavior, timeline, and messages are visible.
4. Change warming level.
5. Pause/resume time.
6. Click the Timeline to jump to another year.
7. Enter Side-by-Side Mode on a cube and compare two warming levels.
8. Toggle Show Model/Data Layer.
9. Verify fire behavior around Big Creek fire years.

## Standalone/Local Build Checklist

Before building:

- Confirm active build target is Standalone.
- Confirm `LOCAL_VERSION` is present for Standalone scripting define symbols if testing a local API.
- Confirm a local API is running at `http://localhost:5550/api/`, or adjust the code/config intentionally.
- Confirm `Assets/Scenes/FutureMountain/FutureMountain.unity` is included in Build Settings.

Smoke test the same primary features as WebGL, with extra attention to any local/non-web paths such as background snow and legacy data-loading behavior.

## Data Update Procedure

Current Big Creek runtime data is API/database-backed. The raw Big Creek source data files are not currently present in this Unity repository.

For any scenario data update:

1. Confirm source files and units with the data/modeling contact.
2. Update importer configuration and importer code as needed.
3. Import into a staging database.
4. Export or document the resulting schema changes.
5. Verify API responses for every endpoint Unity consumes.
6. Update Unity DTOs only if the API contract changes.
7. Update [DataDictionary.md](DataDictionary.md), [Data Model Spec](../Specs/DataModel.md), and [Data Mappings Spec](../Specs/DataMappings.md).
8. Run the WebGL/editor smoke tests before replacing production data.

For Central Coast, new fields should be added with an explicit compatibility plan so Big Creek can continue to run unchanged or through a clear adapter.

## Documentation Update Procedure

When behavior changes, update the nearest feature spec in `Specs/`.

When data contracts change, update:

- [DataDictionary.md](DataDictionary.md)
- [DataFormats.md](DataFormats.md)
- [Data Model Spec](../Specs/DataModel.md)
- [Data Mappings Spec](../Specs/DataMappings.md)

When build, deployment, access, or runbook details change, update this operations document.

## Troubleshooting

### Loading Does Not Complete

Likely causes:

- API unavailable.
- Endpoint URL mismatch.
- JSON field name mismatch.
- Missing scenario data for a cube, warming index, date, fire frame, terrain frame, or patch.
- Browser/CORS issue in WebGL.

First checks:

- Unity Console or browser developer console.
- `WebManager` base URL and active scripting symbol.
- Direct browser request to the failing API endpoint.

### Cubes Load But Vegetation Looks Wrong

Likely causes:

- Carbon fields changed units or ranges.
- Scenario data missing overstory/understory fields.
- `SimulationSettings` carbon factors or web optimization values changed.
- Warming/cube/patch index mismatch.

Relevant specs:

- [Data Mappings Spec](../Specs/DataMappings.md)
- [Normal Mode Spec](../Specs/NormalMode.md)
- [Side-by-Side Mode Spec](../Specs/SideBySideMode.md)

### Timeline Looks Wrong

Likely causes:

- Missing or incorrect annual precipitation totals.
- `waterdata/total` contract changed.
- Web path still using hard-coded maximum precipitation scaling.
- Date index/year mismatch.

Relevant specs:

- [Timeline Spec](../Specs/Timeline.md)
- [Show Model / Data Layer Spec](../Specs/ShowModelDataLayer.md)

### Fire Timing Or Spread Looks Wrong

Likely causes:

- Scheduled fire dates differ between code, messages, and model data.
- Fire grid dimensions or serialized `_dataList` format changed.
- Missing fire data for selected warming index.

Relevant spec:

- [Fire Spec](../Specs/Fire.md)

### Snow Looks Wrong

Likely causes:

- `BuildForWeb` or `backgroundSnowOn` path changed.
- Terrain snow data missing or scenario-specific.
- Cube `snow` units/ranges changed.

Relevant spec:

- [Snow Spec](../Specs/Snow.md)

## Release Notes Template

Use this lightweight template for future handoff/release notes:

```text
Version / date:
Build target:
Unity version:
Scenario data version:
API/database version:
Major changes:
Known issues:
Smoke tests completed:
Deployment location:
Rollback notes:
```

## Open Operations Items

- Add real project contacts.
- Document production hosting/deployment steps for `futuremtn.org`.
- Document API/backend repository location and deployment process.
- Decide whether the importer remains separate or becomes a utility project inside this repository.
- Add MySQL schema export procedure once the database workflow is confirmed.
- Add Central Coast scenario data import and validation procedure.
