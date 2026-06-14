# Central Coast v2 Importer Config Design

Last updated: 2026-06-13

## Purpose

This document defines the scenario-config design for Central Coast v2 imports,
delivered as task `CCV2-03`. It also records the design decisions agreed while
reviewing how Central Coast v2 source files relate to the existing Big Creek v1
data model.

The config file is `RHESSYs_Data_Importer/RHESSYs_Data_Importer/ScenarioConfig_CentralCoastV2.json`.

## Config Shape

Central Coast v2 reuses the existing `ScenarioConfig` object plus a small set of
optional fields (all unused by Big Creek v1, which leaves them null):

| Field | Type | Purpose |
| --- | --- | --- |
| `scenarioProfile` | string | Must be `CentralCoastV2`. Selects the data model explicitly. |
| `scenarioRunId` | string | Identifies one scenario member/run (e.g. `single-warming-sample`). |
| `warmingIdx` | int | Warming/climate-case index. `0` for the current sample (assumed). |
| `sourceRoot` | string | Base folder the `files` entries resolve against. Keeps the bundle path out of code. |
| `delimiter` | string | Field delimiter for source files (`,` for Central Coast CSVs). |
| `files` | object | Logical file role -> file name, resolved relative to `sourceRoot`. |
| `database` | object | Central Coast database connection (separate DB: `centralcoast_rhessys`). |
| `outputTables` | array | Target tables, named to match the existing EF/Big Creek table convention (`Dates`, `CubeData`, `PatchData`, `FireData`, `WaterData`). See `CCV2-04`. |

### Table Naming

Tables reuse the original Big Creek EF naming convention so the schema and any
later API/adapter stay familiar: `Dates`, `CubeData`, `PatchData`, `FireData`,
`WaterData`. Central Coast-only tables use the same PascalCase style:
`StratumData` and `ImportRun`.

This is a Central Coast v2 decision only. Big Creek v1 remains untouched, even if
an existing MySQL instance displays its tables in lowercase.

`ScenarioConfig.GetSourceFilePath(role)` joins `sourceRoot` + the file name for a
role and returns a full path, or null if the role is not configured.

### Reusing The Shape For Future Members

A future warming/climate member is configured by changing only:

- `sourceRoot` (new bundle folder),
- `scenarioRunId` (new member id),
- `warmingIdx` (real index once metadata exists).

The `files` role names and file names stay the same, because each member is
expected to repeat the same file set. This satisfies the requirement that the
sample is configured without hardcoding its folder and that future members reuse
the same config shape.

## File Roles

Roles are explicit and named, instead of the six fixed Big Creek discovery
categories, because the Central Coast file set is split by grain (daily/monthly)
and spatial level (aggregate/patch/stratum):

| Role | File | Grain |
| --- | --- | --- |
| `cubeAggregateDaily` | `cube_agg_p.csv` | Daily basin/aggregate |
| `cubePatchDaily01` / `cubePatchDaily02` | `cube_p_patch1.csv` / `cube_p_patch2.csv` | Daily cube patch member |
| `cubeStratumOver01` / `cubeStratumOver02` | `cubes_sc_over_patch1.csv` / `cubes_sc_over_patch2.csv` | Daily overstory stratum |
| `cubeStratumUnder01` / `cubeStratumUnder02` | `cube_sc_under_patch1.csv` / `cube_sc_under_patch2.csv` | Daily understory stratum |
| `basinMonthlyBurn` | `bm.csv` | Monthly basin burn |
| `patchMonthlyBurn` | `spatial_data_point_patchvar.csv` | Monthly all-patch burn |
| `stratumMonthlyCarbon` | `spatial_data_point_stratvar.csv` | Monthly all-stratum carbon |
| `patchFamilyRaster` | `Pch30rip90upRN.tiff` | Patch-family raster |

## Design Decisions

These decisions explain why the config looks the way it does. They resolve the
question of how Central Coast files relate to Big Creek's six fixed categories
(`cube`, `patch`, `terrain`, `fire`, `water`, `climate`).

### 1. Cube stays one logical table; strata are columns, not separate tables

Big Creek's cube row already flattens overstory and understory fields into one
record. The Central Coast over/understory files are the same data delivered as
separate source files. The importer joins them back into one cube row on
`(day, month, year, patchID)` (overstory `stratumID` ends in `1`, understory in
`2`). A wider cube table is fine and keeps the cube contract stable; Central
Coast's extra stratum fields (`consumedC*`, `mortC*`, `netpsn*`, `lai*`,
`veg_parm_ID`, root depths) are additive optional columns. Splitting into
`cube_over` / `cube_under` tables is explicitly rejected.

### 2. No separate water file; basin streamflow comes from the aggregate cube

The aggregate cube represents the whole watershed, so `streamflow` in
`cube_agg_p.csv` is the basin streamflow that drives the large-landscape river
(the role Big Creek's `WaterData` filled). There is therefore no `water`
category. Per-warming streamflow columns become per-member rows as more members
arrive.

### 3. Burn is imported as monthly source columns; runtime fire is deferred

Burn is present spatially and monthly (`bm.csv`, `spatial_data_point_patchvar.csv`
are non-zero; daily cube `burn` is zero in the sample). It is not Big Creek's
fire-frame/`spread`/`iter` format. Monthly per-patch burn is conceptually the
burned-terrain field and will be interpolated to daily at runtime using the same
mechanism as snow (see decision 7). Import preserves `burn` columns now; the
config is built so it works once fuller data arrives. There is no `fire`
category.

### 4. Patch identity: `zoneID` is the spatial cube identity

This is the largest model change. Big Creek used a flat `patchID -> footprint`.
Central Coast uses a patch family:

```text
zoneID -> patchID (01/02 aspatial members) -> stratumID (over/under)
```

Handling:

- `zoneID` takes over Big Creek's old `patchIdx` role for spatial identity (the
  patch-family raster maps `zoneID` to pixels; the five cube locations are
  `zoneID`s).
- `patchID` (`01`/`02`) is preserved as a member dimension in staging, never
  flattened. Only the riparian `zoneID 10071` differs between `01`/`02` (oak vs
  chaparral); the others duplicate, but both rows are kept.
- Cube rows are keyed by `(zoneID, patchID)`. A later adapter can bridge to the
  legacy "one cube per location" shape.

### 5. No climate category

Climate was imported just-in-case in Big Creek and never consumed. The Central
Coast sample has no climate files. No `climate` category.

### 6. Patch-family raster decoded into the existing `PatchPointCollection` contract

The `.tiff` patch map is used the same way Big Creek's text patch map was: to
place where each cube "comes from" (opening animation) and to drive large-
landscape terrain color/texture. Only the decoder is new (GeoTIFF vs text grid);
the downstream `PatchPointCollection` contract (data-grid location, fire-grid
location, alphamap location, UTM) is unchanged.

## Selecting The Config

The Central Coast config is selected explicitly:

- Via the wizard's "Load another config" option, entering the path to
  `ScenarioConfig_CentralCoastV2.json`.
- The resolved profile (`CentralCoastV2`) is printed at startup and in the wizard.

Big Creek remains the default config loaded by `Program.cs`, so default behavior
is unchanged. Wiring the Central Coast profile into actual import paths and
staging tables is handled by `CCV2-04` onward.

## How To Run

The canonical run instructions live in
`Docs/RHESSysDataImporter/Runbook.md`, including the Central Coast v2 wizard flow
and dry-run command. See the `Central Coast v2 Config` section there.

## Schema Setup and Migration Workflow

The Central Coast v2 tables live in a dedicated schema: **`futuremtn_central_coast`**.
Do not create or touch these tables in `defaultdb` (Big Creek).

### One-time schema creation (recommended MySQL Workbench path)

The checked-in schema export is:

```text
Database/Schema/CentralCoastV2_schema.sql
```

Use MySQL Workbench unless there is a specific reason to use the CLI:

1. Connect to the target MySQL server.
2. In the Schemas panel, choose **Create Schema**.
3. Name the schema exactly `futuremtn_central_coast`.
4. Click **Apply**.
5. Open `Database/Schema/CentralCoastV2_schema.sql`.
6. Make `futuremtn_central_coast` the active/default schema, or add this line near the top of the SQL editor:

```sql
USE futuremtn_central_coast;
```

7. Run the script.
8. Verify tables were created:

```sql
SHOW TABLES;
```

Expected tables include `cubedata`, `dates`, `firedata`, `importrun`,
`patchdata`, `stratumdata`, `terraindata`, `waterdata`, and
`__efmigrationshistory`.

The schema export does not create the database and does not contain a `USE`
statement, so the schema must exist and must be selected before running it.

### EF Core migration alternative

The EF migration artifacts also exist under:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer/Migrations/CentralCoast/
```

However, `dotnet ef database update --context CentralCoastDbContext` uses the
design-time connection in `DAL/CentralCoastDbContextFactory.cs`, which is local
development oriented. For production/staging servers, prefer the exported SQL
file above unless the design-time connection has been intentionally updated for
the target server.

### Import sequence (after schema exists)

```powershell
# 1. Dry run -- validate config, file paths, column headers
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --dryrun

# 2. Patch map (spatial footprints -- fast, ~4,477 rows)
dotnet run -- --patch --config ScenarioConfig_CentralCoastV2.json

# 3. Fire (basin + patch monthly burn)
dotnet run -- --fire --config ScenarioConfig_CentralCoastV2.json

# 4. Stratum (6.9M rows -- chunked 10k, takes minutes)
dotnet run -- --stratum --config ScenarioConfig_CentralCoastV2.json

# 5. Terrain (reads PatchData + StratumData + FireData -- must be last)
dotnet run -- --terrain --config ScenarioConfig_CentralCoastV2.json

# 6. Full import (all of the above in dependency order)
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json
```

All commands run from the `RHESSYs_Data_Importer/RHESSYs_Data_Importer` directory.

### Adding future migrations

After any model change to a CCV2 entity:

```powershell
dotnet ef migrations add <MigrationName> --context CentralCoastDbContext --output-dir Migrations/CentralCoast
dotnet ef database update --context CentralCoastDbContext
```

Big Creek migrations live in `Migrations/` (root) and use `CubeDataDbContext`.
Central Coast migrations live in `Migrations/CentralCoast/` and use `CentralCoastDbContext`.
Never mix them.

## Known Follow-ups

- The current `ColumnMapper` splits on whitespace; Central Coast CSVs are
  comma-delimited. The `delimiter` config field is provided for this, and the
  CSV-aware parsing path is implemented with the model classes in `CCV2-05`.
- Detailed source-column to model-field mappings are defined alongside the model
  classes in `CCV2-05`, using the column lists in
  `Docs/CentralCoastV2/DataFormats.md`.
