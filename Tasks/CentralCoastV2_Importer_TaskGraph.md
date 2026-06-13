# Central Coast v2 Importer Task Graph

Last updated: 2026-06-13

## Objective

Add a Central Coast v2 data ingestion path beside the existing Big Creek v1 path.

The first implementation phase is database ingestion only. Do not change Big Creek v1 behavior, Unity visualization, API behavior, or existing Big Creek database/schema assumptions.

## Guiding Constraints

- Preserve Big Creek v1 as-is.
- Add Central Coast v2 as an explicit scenario profile.
- Use separate Central Coast database/schema settings.
- Treat the current Central Coast bundle as a single scenario member.
- Use `warmingIdx = 0` for the current sample until real warming/climate-case metadata is provided.
- Preserve raw Central Coast identifiers: `zoneID`, `patchID`, and `stratumID`.
- Import raw/staging data before designing API or Unity projections.
- Do not work on DEM/large-landscape generation in this task graph's first phase.

## Source References

- Central Coast format reference: `Docs/CentralCoastV2/DataFormats.md`
- Big Creek comparison: `Docs/CentralCoastV2/BigCreekV1Differences.md`
- Current importer docs: `Docs/RHESSysDataImporter/`
- Current importer specs: `Specs/RHESSysDataImporter/`
- Current sample bundle: `RHESSYs_Data_Importer/Data/RHESSysOutput-SingleWarmIdx-6-4-2026/`

## Current Status

| ID | Task | Status |
| --- | --- | --- |
| CCV2-00 | Discovery and documentation | Complete |
| CCV2-01 | Repository/importer cleanup decision | Completed |
| CCV2-02 | Scenario profile design | Completed |
| CCV2-03 | Central Coast config design | Completed |
| CCV2-04 | Central Coast database schema design | Completed |
| CCV2-05 | Importer model classes | Completed |
| CCV2-06 | Import validation/reporting framework | Completed |
| CCV2-07 | Daily aggregate importer | Completed |
| CCV2-08 | Daily cube patch importer | Completed |
| CCV2-09 | Daily cube stratum importer | Completed |
| CCV2-10 | Monthly basin burn importer | Pending |
| CCV2-11 | Monthly patch burn importer | Pending |
| CCV2-12 | Monthly stratum carbon importer | Pending |
| CCV2-13 | Import dry-run and row-count verification | Pending |
| CCV2-14 | Real database import smoke test | Pending |
| CCV2-15 | Spatial/raster metadata planning | Pending |
| CCV2-16 | API/Unity follow-on planning | Pending |

## Task Graph

```mermaid
flowchart TD
  CCV2_00["CCV2-00 Discovery and docs"]
  CCV2_01["CCV2-01 Repo/importer cleanup decision"]
  CCV2_02["CCV2-02 Scenario profile design"]
  CCV2_03["CCV2-03 Central Coast config design"]
  CCV2_04["CCV2-04 DB schema design"]
  CCV2_05["CCV2-05 Importer model classes"]
  CCV2_06["CCV2-06 Validation/reporting"]
  CCV2_07["CCV2-07 Daily aggregate importer"]
  CCV2_08["CCV2-08 Daily cube patch importer"]
  CCV2_09["CCV2-09 Daily cube stratum importer"]
  CCV2_10["CCV2-10 Monthly basin burn importer"]
  CCV2_11["CCV2-11 Monthly patch burn importer"]
  CCV2_12["CCV2-12 Monthly stratum carbon importer"]
  CCV2_13["CCV2-13 Dry-run verification"]
  CCV2_14["CCV2-14 Database import smoke test"]
  CCV2_15["CCV2-15 Spatial/raster metadata planning"]
  CCV2_16["CCV2-16 API/Unity follow-on planning"]

  CCV2_00 --> CCV2_01
  CCV2_00 --> CCV2_02
  CCV2_02 --> CCV2_03
  CCV2_03 --> CCV2_04
  CCV2_04 --> CCV2_05
  CCV2_04 --> CCV2_06
  CCV2_05 --> CCV2_07
  CCV2_05 --> CCV2_08
  CCV2_05 --> CCV2_09
  CCV2_05 --> CCV2_10
  CCV2_05 --> CCV2_11
  CCV2_05 --> CCV2_12
  CCV2_06 --> CCV2_13
  CCV2_07 --> CCV2_13
  CCV2_08 --> CCV2_13
  CCV2_09 --> CCV2_13
  CCV2_10 --> CCV2_13
  CCV2_11 --> CCV2_13
  CCV2_12 --> CCV2_13
  CCV2_13 --> CCV2_14
  CCV2_14 --> CCV2_15
  CCV2_14 --> CCV2_16
```

## Task Details

### CCV2-00 Discovery And Documentation

Status: Complete

Completed outputs:

- Current importer docs and specs.
- Central Coast v2 data format reference.
- Big Creek v1 vs Central Coast v2 differences.
- Source file inventory, row counts, date ranges, cube IDs, and patch/stratum identity model.

Acceptance:

- Team can identify every current Central Coast source file and its grain.
- Team understands that current sample is a single scenario member with assumed `warmingIdx = 0`.

### CCV2-01 Repository/Importer Cleanup Decision

Status: Completed

Decide how the embedded importer should live in the Future Mountain repo.

Questions:

- Fully absorb the importer as source?
- Keep it as a submodule?

Decision: Fully absorb the importer as source (no submodule, no nested `.git`).
See `Docs/RHESSysDataImporter/RepositoryStrategy.md`.

Implementation:

- Root `.gitignore` now keeps Unity-generated `*.csproj`/`*.sln` ignored but
  narrowly un-ignores the importer's real `RHESSYs_Data_Importer.sln` and
  `RHESSYs_Data_Importer.csproj` so the absorbed tool can be cloned and built.
- Importer `bin/`, `obj/`, and `.vs/` are explicitly ignored.
- Large source data remains tracked via Git LFS (`Data/.gitattributes`).

Acceptance:

- Future Mountain can commit the importer without nested Git confusion.
- Large source data handling is explicit.
- Generated local files are not committed.

### CCV2-02 Scenario Profile Design

Status: Completed

Add an explicit scenario-profile concept to the importer design.

Required profiles:

- `BigCreekV1`
- `CentralCoastV2`

Implementation:

- `ScenarioProfileKind` enum and `ScenarioProfiles` helpers in
  `Configuration/ScenarioProfile.cs` (`BigCreekV1`, `CentralCoastV2`).
- `ScenarioConfig.ScenarioProfile` string field + `GetProfileKind()`; missing or
  unknown values default to `BigCreekV1`.
- `Program.cs` resolves/logs the active profile and warns on unknown values;
  `WizardRunner` displays it.
- `ScenarioConfig_BigCreek.json` declares `"scenarioProfile": "BigCreekV1"`.
- Design documented in `Docs/RHESSysDataImporter/ScenarioProfiles.md`.

Acceptance:

- Big Creek v1 default behavior remains unchanged.
- Central Coast v2 can be selected explicitly.
- Importer does not infer data model from table names or file presence alone.

### CCV2-03 Central Coast Config Design

Status: Completed

Design config fields for Central Coast v2 imports.

Minimum fields:

- `scenarioProfile`
- `scenarioRunId`
- `warmingIdx`
- `sourceRoot`
- Central Coast database connection
- file names/patterns for current CSVs

Implementation:

- Added optional `ScenarioConfig` fields: `ScenarioRunId`, `WarmingIdx` (int?),
  `SourceRoot`, `Delimiter`, and `Files` (role -> file name), plus
  `GetSourceFilePath(role)`. All unused by Big Creek v1.
- Added `ScenarioConfig_CentralCoastV2.json` with `scenarioProfile`,
  `scenarioRunId`, `warmingIdx=0`, `sourceRoot` (relative, not hardcoded),
  `delimiter`, named file roles, and original EF-style output tables (`Dates`,
  `CubeData`, `PatchData`, `FireData`, `WaterData`, `TerrainData`).
- Captured config design + the cube/water/burn/terrain/patch/climate/grain/raster
  decisions in `Docs/RHESSysDataImporter/CentralCoastConfig.md`.
- Verified the config loads via the wizard's "load another config" path.

Acceptance:

- Current sample can be configured without hardcoding its folder.
- Future scenario members can reuse the same config shape with different `scenarioRunId` and `warmingIdx`.

### CCV2-04 Central Coast Database Schema Design

Status: Completed

Design Central Coast raw/staging import tables.

Tables live in their own Central Coast database (`centralcoast_rhessys`, parallel
to `bigcreek_rhessys`), so they are NOT prefixed with `centralcoast_`. They reuse
the original Big Creek EF/PascalCase table-naming style; the database provides
the namespace.

Designed tables (see `Docs/RHESSysDataImporter/CentralCoastSchema.md`):

- `Dates` — daily date dimension
- `CubeData` — daily per-cube (patch + overstory + understory merged)
- `WaterData` — daily basin/aggregate (`cube_agg_p`); streamflow + basin summaries
- `FireData` — monthly burn (basin + patch) with a `level` discriminator
- `StratumData` — monthly whole-landscape stratum carbon
- `PatchData` — static patch-family spatial extents (raster-derived)
- `TerrainData` — deferred (DEM); defined for parity
- `ImportRun` — provenance / batch marker
- `RasterMetadata` — raster provenance

File/grain -> table mapping, the daily-aggregate-to-`WaterData` decision, full
column lists, keys, and indexes are documented in the schema design doc.

Common columns include:

- `scenarioRunId`
- `warmingIdx`
- `importRunId` (batch marker) and `sourceFile` where a single file feeds a table

Acceptance:

- Schema preserves raw Central Coast structure.
- Schema does not overload Big Creek v1 `CubeData`.
- Schema can store multiple future scenario members.

### CCV2-05 Importer Model Classes

Status: Completed

Add C# model classes for Central Coast v2 rows and target tables.

Implementation:

- New `Models/CentralCoast/` classes in namespace `RHESSYs_Data_Importer.Models.CentralCoast`,
  each mapped to its table via `[Table(...)]`: `CubeDataRow` (CubeData),
  `WaterDataRow` (WaterData, daily aggregate), `FireDataRow` (FireData, monthly
  burn), `StratumDataRow` (StratumData), `PatchDataRow` (PatchData),
  `TerrainDataRow` (TerrainData, deferred), `ImportRun`, `RasterMetadata`.
- Columns match `Docs/CentralCoastV2/DataFormats.md`; source dots mapped to
  underscores. `CubeData` keeps patch 01/02 as separate rows and merges
  overstory/understory into columns.
- Provenance columns (`scenarioRunId`, `warmingIdx`, `importRunId`, `sourceFile`).
- New `DAL/CentralCoastDbContext.cs` exposes all Central Coast tables (reuses the
  existing `Date` model for `Dates`). Big Creek models/contexts untouched.

Acceptance:

- Model classes match documented CSV columns.
- Models include `scenarioRunId` and `warmingIdx`.
- Models do not modify existing Big Creek classes.

### CCV2-06 Import Validation/Reporting Framework

Status: Completed

Add dry-run/reporting output for Central Coast imports.

Validation checks:

- Daily range is `1987-07-01` through `2019-06-30`.
- Daily date count is 11,688.
- Monthly range is `1987-07` through `2019-06`.
- Monthly count is 384.
- Cube files have five rows per day.
- Expected cube `zoneID` values are present.
- Patch and stratum counts match expectations where applicable.

Acceptance:

- Dry run reports counts before DB writes.
- Mismatched counts produce warnings or errors.

Implementation:

- `IO/CentralCoastValidator.cs`: streaming validation (no full-file load)
  for large CSVs (~7M rows). Validates per-role file existence, header
  presence, row counts, date ranges, rows-per-day (cube), zoneIDs,
  patch counts, and stratum counts.
- `IO/ValidationReport.cs`: structured report with `Errors`, `Warnings`,
  `Info`, per-file `FileValidationResult`, and `Print()` console output.
- Wizard: runs validation after file discovery for CentralCoastV2 profiles;
  aborts on failure unless user confirms continuation.
- Auto mode: runs validation before imports; aborts on failure unless
  `--force` is passed.

### CCV2-07 Daily Aggregate Importer

Status: Completed

Import:

```text
cube_agg_p.csv
```

Acceptance:

- 11,688 rows imported or dry-run counted.
- Date range validates.
- `scenarioRunId` and `warmingIdx` are attached to each row.

Implementation:

- `DAL/CentralCoastDAL.cs`: `AddWaterDataRow` writes through
  `CentralCoastDbContext.WaterData`.
- `IO/CentralCoastImporter.cs`: `ImportWaterData` streams the CSV,
  normalizes dots to underscores for column mapping, computes `dateIdx`
  from day/month/year, attaches `scenarioRunId`/`warmingIdx`, and writes
  each row.
- Wired into wizard (water category) and auto mode (`--water`) for
  `CentralCoastV2` profile; legacy Big Creek path preserved.

### CCV2-08 Daily Cube Patch Importer

Status: Completed

Import:

```text
cube_p_patch1.csv
cube_p_patch2.csv
```

Acceptance:

- 116,880 combined rows imported or dry-run counted.
- Five cube rows per date per file.
- `zoneID`, `patchID`, and patch member suffix are preserved.
- Riparian patch 01/02 difference is not flattened away.

Implementation:

- `CentralCoastImporter.ImportCubePatchData` streams both
  `cubePatchDaily01` and `cubePatchDaily02` roles, maps patch hydrology
  columns to `CubeDataRow` via reflection, computes `dateIdx`, and
  attaches `scenarioRunId`/`warmingIdx`. Stratum columns remain at
  default (0) awaiting CCV2-09.
- Wired into wizard (cube category) and auto mode (`--cube`) for
  `CentralCoastV2` profile; legacy Big Creek path preserved.

### CCV2-09 Daily Cube Stratum Importer

Status: Completed

Import:

```text
cubes_sc_over_patch1.csv
cubes_sc_over_patch2.csv
cube_sc_under_patch1.csv
cube_sc_under_patch2.csv
```

Acceptance:

- 233,760 combined rows imported or dry-run counted.
- Overstory and understory are distinguishable.
- `stratumID` is preserved.
- `veg_parm_ID` is preserved.

Implementation:

- `CentralCoastDAL.UpdateCubeDataStratum`: queries existing `CubeData` row by
  composite key (dateIdx, zoneID, patchID, scenarioRunId, warmingIdx),
  applies an `Action<CubeDataRow>` updater, and saves changes.
- `CentralCoastImporter.ImportCubeStratumData`: streams all four stratum
  files, resolves column indices per file type (overstory vs understory),
  handles `veg_parm_ID` -> `vegParmIDOver`/`vegParmIDUnder` and
  `stratumID` -> `stratumIDOver`/`stratumIDUnder` mapping, computes
  `dateIdx`, and updates matching rows.
- Wired into wizard and auto mode (`--cube`) for `CentralCoastV2` profile,
  running immediately after patch import.

### CCV2-10 Monthly Basin Burn Importer

Status: Pending

Import:

```text
bm.csv
```

Acceptance:

- 384 rows imported or dry-run counted.
- Month range validates.

### CCV2-11 Monthly Patch Burn Importer

Status: Pending

Import:

```text
spatial_data_point_patchvar.csv
```

Acceptance:

- 3,438,336 rows imported or dry-run counted.
- 4,477 `zoneID` values and 8,954 `patchID` values are preserved.
- Month range validates.

### CCV2-12 Monthly Stratum Carbon Importer

Status: Pending

Import:

```text
spatial_data_point_stratvar.csv
```

Acceptance:

- 6,876,672 rows imported or dry-run counted.
- 17,908 `stratumID` values are preserved.
- Month range validates.

### CCV2-13 Dry-Run Verification

Status: Pending

Run a full Central Coast v2 dry run.

Acceptance:

- All expected row counts match.
- All date/month ranges match.
- All expected cube IDs are present.
- No DB writes occur.

### CCV2-14 Database Import Smoke Test

Status: Pending

Run import against a local or staging Central Coast database.

Acceptance:

- Import completes.
- Row counts in database match dry-run counts.
- Spot checks match CSV source rows.
- Big Creek database/tables remain untouched.

### CCV2-15 Spatial/Raster Metadata Planning

Status: Pending

Plan, but do not implement yet, spatial/raster handling.

Inputs:

- `Pch30rip90upRN.tiff`
- `dem30mSBFRbound.tiff`

Acceptance:

- Patch map handling plan explains `zoneID` to patch-family footprint conversion.
- DEM is documented as future landscape generation source.
- No DEM/Unity terrain work is included in first ingestion implementation.

### CCV2-16 API/Unity Follow-On Planning

Status: Pending

Plan the post-ingestion work only after database import is proven.

Topics:

- Central Coast API endpoints or provider.
- Big Creek adapter vs Central Coast adapter.
- Runtime DTO normalization.
- Single-scenario fallback behavior if only `warmingIdx = 0` is available.
- Future multi-warming comparison behavior.

Acceptance:

- Follow-on plan preserves Big Creek v1 behavior.
- API/Unity work is not started until ingestion is validated.

## First Implementation Milestone

The first milestone is complete when:

- Central Coast v2 can be selected by config.
- Current sample bundle can be dry-run validated.
- Current sample bundle can be imported into separate Central Coast tables.
- Imported row counts match source row counts.
- Big Creek v1 is untouched.
