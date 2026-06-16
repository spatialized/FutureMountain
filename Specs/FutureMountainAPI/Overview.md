# Future Mountain API Overview

Last updated: 2026-06-16

## Purpose

This spec documents the current Future Mountain ASP.NET Core API. The API serves
Unity runtime data for the deployed Big Creek experience and the Central Coast
v2 prototype.

Project path:

```text
Services/FutureMountainApi/FutureMountainAPI/FutureMountainAPI/
```

The API targets `.NET 8` and uses ASP.NET Core controllers with EF Core and
Pomelo/MySQL.

## Runtime Configuration

The API reads named connection strings from configuration:

| Key | Purpose |
| --- | --- |
| `BigCreekDbContext` | Legacy Big Creek tables and required startup connection |
| `CentralCoastDbContext` | Central Coast v2 prototype schema/database |

Legacy Big Creek DbContext class names remain unchanged:

- `CubeDataDbContext`
- `WaterDataDbContext`
- `FireDataDbContext`
- `TerrainDataDbContext`
- `PatchDataDbContext`
- `DateDbContext`

Central Coast routes use `CentralCoastDbContext`.

## Route Families

Big Creek routes keep the legacy `/api/<Controller>` pattern:

```text
/api/CubeData/...
/api/WaterData/...
/api/FireData/...
/api/PatchData/...
/api/TerrainData/...
/api/Dates/...
```

Central Coast routes are scenario-explicit:

```text
/api/centralcoast/CubeData/...
/api/centralcoast/WaterData/...
/api/centralcoast/PatchData/...
/api/centralcoast/TerrainData/...
/api/centralcoast/Dates/...
```

Unity applies this route selection through `SimulationSettings.apiProfile` and
`WebManager`.

## Current Constraints

- There is no explicit `/api/bigcreek/...` route family yet.
- Central Coast responses are prototype Unity-compatible DTOs, not native full
  Central Coast scientific records.
- `FireData` routes exist for Big Creek only. Central Coast fire spread playback
  data has not been provided yet.
- Swagger is enabled only in development environment.
- CORS currently allows any origin.

## Related Docs

- `Docs/Services/FutureMountainApi.md`
- `Specs/FutureMountainAPI/Routes.md`
- `Specs/FutureMountainAPI/Deployment.md`
- `Docs/AddingFutureScenarios.md`
- `Docs/RHESSysDataImporter/ScenarioUpgradeGuide.md`
