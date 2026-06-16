# Future Mountain API

Last updated: 2026-06-16

The API project is stored at `Services/FutureMountainApi/`. It was moved from
the former standalone `FutureMountainAPI` repository with `git subtree` to
preserve project history.

The imported history was sanitized before import:

- `appsettings.json` and `appsettings.Development.json` entries containing
  database credentials were removed from historical commits.
- Hardcoded connection-string credentials in historical source files were
  redacted.
- The current API startup code reads named connection strings from
  configuration instead of using checked-in connection strings.

Use a local configuration source for the connection string, such as .NET user
secrets, environment variables, or an ignored `appsettings.Development.json`.

## Connection Strings

The API serves legacy Big Creek data and Central Coast prototype data from
separate databases.

```json
{
  "ConnectionStrings": {
    "BigCreekDbContext": "<legacy Big Creek database>",
    "CentralCoastDbContext": "<Central Coast database>"
  }
}
```

`BigCreekDbContext` is the connection-string key used by the existing legacy
contexts (`CubeDataDbContext`, `WaterDataDbContext`, `FireDataDbContext`,
`TerrainDataDbContext`, `PatchDataDbContext`, and `DateDbContext`). The C#
context class names are intentionally unchanged.

`CentralCoastDbContext` is used by the new Central Coast API context and points
at the separate Central Coast schema/database produced by the importer.

## Routes

Legacy Big Creek routes remain unchanged:

```text
/api/CubeData/...
/api/WaterData/...
/api/PatchData/...
/api/TerrainData/...
/api/Dates/...
```

Central Coast prototype routes are scenario-explicit under the same `/api`
prefix:

```text
/api/centralcoast/CubeData/...
/api/centralcoast/WaterData/...
/api/centralcoast/PatchData/...
/api/centralcoast/TerrainData/...
/api/centralcoast/Dates/...
```

A future cleanup may add `/api/bigcreek/...` aliases while keeping the original
Big Creek routes for backwards compatibility.

## Central Coast Prototype DTOs

Central Coast database rows preserve the Central Coast source structure, which
does not exactly match the Unity runtime JSON contract used by Big Creek. The
prototype API therefore shapes Central Coast rows into Unity-friendly responses
at the route boundary.

Explicit prototype DTO classes live in:

```text
Services/FutureMountainApi/FutureMountainAPI/FutureMountainAPI/Models/CentralCoast/CentralCoastPrototypeDtos.cs
```

Current explicit DTOs:

- `CentralCoastCubeDataPrototypeDto`
- `CentralCoastPatchDataPrototypeDto`

Examples of prototype mappings:

- Central Coast `zoneID` is exposed as legacy-style `patchIdx`/`patchID`.
- Central Coast `litterc` and `soilc` are exposed as `litter` and `soil`.
- Central Coast `Qout` is exposed as `qout`.
- Central Coast overstory and understory `netpsn` values are summed into
  legacy-style `netpsn`.
- Central Coast canopy and ground evaporation are summed into legacy-style
  `evap`.

`WaterData` and `TerrainData` currently reuse existing API response models
(`WaterDataFrame` and `TerrainDataFrameJSONRecord`) with Central Coast query
projections. Richer Central Coast v2 production endpoints can later expose
native fields such as `scenarioRunId`, `zoneID`, `patchID`, `basinID`,
`hillID`, and stratum identifiers without changing these prototype contracts.

## Local Build And Publish

Project folder:

```text
Services/FutureMountainApi/FutureMountainAPI/FutureMountainAPI/
```

Build:

```powershell
dotnet build
```

Publish to a local folder:

```powershell
dotnet publish -c Release -o C:\tmp\FutureMountainApiPublish
```

Before copying the publish output to the server, confirm the published
configuration contains valid production connection strings:

```json
{
  "ConnectionStrings": {
    "BigCreekDbContext": "<production Big Creek database>",
    "CentralCoastDbContext": "<production Central Coast database>"
  }
}
```

The required keys are `BigCreekDbContext` and `CentralCoastDbContext`.
`BigCreekDbContext` is required at startup. `CentralCoastDbContext` is optional
in code, but Central Coast routes require it to be configured.

Do not commit production credentials. For deployment, use the server-side
configuration mechanism already approved for the host, or update the
`appsettings.json` in the local publish folder before copying it to IIS.

## IIS Deployment Runbook

The deployed API is served by IIS for:

```text
https://data.futuremtn.org/api/
```

Manual publish workflow:

1. Publish the API locally with `dotnet publish -c Release`.
2. Confirm the publish folder contains the expected build output and deployment
   `appsettings.json`.
3. Log in to `fm01.grit.ucsb.edu` over Remote Desktop.
4. Open IIS Manager.
5. Stop the IIS website or application that serves `data.futuremtn.org`.
6. Back up the current deployed API folder.
7. Copy all files from the local publish folder into the server folder for
   `data.futuremtn.org`, replacing the old application files.
8. Confirm `appsettings.json` in the deployed folder has the production
   connection strings.
9. Start the IIS website or application.
10. Smoke test the API endpoints below.

If deployment fails, restore the backed-up server folder and restart the IIS
site/application.

Smoke-test URLs:

```text
https://data.futuremtn.org/api/dates
https://data.futuremtn.org/api/waterdata/total
https://data.futuremtn.org/api/cubedata/-1/0
https://data.futuremtn.org/api/centralcoast/dates
https://data.futuremtn.org/api/centralcoast/waterdata/total
```

Use the Unity WebGL build only after the API smoke tests succeed.

## Documentation

Additional API specs live in:

```text
Specs/FutureMountainAPI/
```
