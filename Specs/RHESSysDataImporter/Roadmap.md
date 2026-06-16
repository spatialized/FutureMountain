# RHESSys Data Importer Roadmap

Last updated: 2026-06-16

## Purpose

This roadmap records the remaining work and operational risks for the embedded
RHESSys Data Importer. It is intentionally practical: it tracks what should be
improved next now that the Central Coast v2 pre-prototype import path is in
place.

The current importer supports Big Creek v1 legacy import paths and Central
Coast v2 profile-specific paths. Central Coast v2 is far enough along to import
the partial single-warming sample bundle, generate patch mapping, generate
monthly terrain frames, and serve prototype API data. The remaining work is
mostly about repeatability, production safety, reporting, and cleanup.

## Current Baseline

- Big Creek v1 and Central Coast v2 data share the top-level
  `RHESSYs_Data_Importer/Data/` folder.
- Central Coast v2 uses a dedicated schema, `futuremtn_central_coast`, not
  `defaultdb`.
- A checked-in Central Coast schema export exists at
  `Database/Schema/CentralCoastV2_schema.sql`.
- `ScenarioConfig_CentralCoastV2.json` points at the partial sample bundle:
  `RHESSysOutput-SingleWarmIdx-6-4-2026`.
- Central Coast v2 dates are derived from the configured daily aggregate CSV
  (`cubeAggregateDaily`) rather than manually configured start/end dates.
- `--dates` exists, and full Central Coast auto import includes dates.
- Central Coast v2 patch mapping is implemented from `patchFamilyRaster`
  (`Pch30rip90upRN.tiff`) into `PatchData`.
- Central Coast v2 monthly `TerrainData` generation is implemented from
  `PatchData`, `StratumData`, and `BurnData`.
- `CentralCoastDbContext` enables MySQL retry resiliency and uses a longer
  command timeout for large Central Coast reads/writes.
- `StratumData` batch insert reports actual saved rows and recursively isolates
  bad rows so a single failed row does not drop an entire large batch.
- Wizard mode has Central Coast v2 coverage for dates, cube, water, burn, patch,
  stratum, and terrain, though auto mode remains the better-tested production
  path.

## Near-Term Priorities

### Import Resume And Idempotency

Central Coast category imports are not generally idempotent. If a production
import fails midway, rerunning the same category may append duplicate rows
unless the target table is cleared first.

Current manual recovery example for failed `StratumData` plus dependent
terrain:

```sql
USE futuremtn_central_coast;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE terraindata;
TRUNCATE TABLE stratumdata;
SET FOREIGN_KEY_CHECKS = 1;
```

Then rerun:

```powershell
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --stratum
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --terrain
```

Planned improvements:

- Add explicit replace/resume modes.
- Add duplicate detection or uniqueness constraints for scenario keys.
- Print clear recovery guidance when a table must be truncated before retrying.
- Prefer import-run based cleanup once `ImportRun` records are actively used.

### Hard-Fail On Incomplete Writes

Several DAL methods still catch exceptions and return `0`. Some import paths
report saved-vs-source row counts, but orchestration should fail the process
when required rows are missing, especially before dependent categories such as
terrain generation.

Planned improvements:

- Throw or return a hard failure when `saved != expected`.
- Prevent full import from continuing to dependent categories after incomplete
  upstream data.
- Apply the same standard to dates, cube, water, burn, patch, stratum, terrain,
  and fire-frame imports where appropriate.
- Keep the helpful bad-row isolation behavior for `StratumData`, but make final
  completeness status unambiguous.

### Structured Import Reporting

The `ImportRun` model and table exist, but current Central Coast writers still
set `importRunId = 0`; the table is not yet acting as the real batch/provenance
record.

Planned improvements:

- Create an `ImportRun` row at the start of each import execution.
- Set status to `running`, `succeeded`, `failed`, or `dryrun`.
- Store per-category source rows read, rows saved, rows skipped/dropped, and
  elapsed time.
- Store target database/schema, scenario metadata, source root, and useful
  failure details.
- Write generated row counts into the final console summary.

### Production Preflight Validation

The importer validates Central Coast source files, but target database
validation is still limited.

Planned improvements:

- Confirm target schema exists.
- Confirm expected tables and columns exist.
- Confirm expected table row counts are zero or intentionally replaceable.
- Print target database/schema in the final confirmation.
- Optionally require an explicit production acknowledgement flag.

## Medium-Term Improvements

### Scenario Config Validation

No formal JSON schema exists for scenario config validation.

Planned improvements:

- Validate required fields by `scenarioProfile`.
- Reject unknown file roles when profile-specific importers require fixed roles.
- Prevent credentials from being committed in shared configs.
- Validate database name/host before import begins.
- Keep the human-readable validation report, but make profile-specific
  requirements machine-checkable.

### Wizard Mode Smoke Testing

Wizard mode has Central Coast v2 coverage, but auto mode remains the primary
tested path for production-scale imports.

Planned improvements:

- Run one end-to-end interactive Central Coast v2 wizard smoke test.
- Keep wizard prompts aligned with auto-mode import order.
- Make wizard recovery guidance match the future replace/resume behavior.

### Bulk Insert Performance

Central Coast imports use chunked EF inserts. This worked locally but remains
slow and sensitive to network/database interruptions at production scale.

Planned improvements:

- Evaluate MySQL bulk load or more efficient batched insert strategies for large
  tables.
- Reduce per-row EF overhead for `StratumData`, `BurnData`, and other large
  categories.
- Keep enough logging to diagnose bad rows without flooding the console.

### Terrain Generation Performance

The command timeout was increased, but terrain generation still performs large
aggregate scans over `StratumData` and `BurnData`.

Planned improvements:

- Confirm indexes support `(scenarioRunId, warmingIdx, year, month, zoneID)`.
- Consider pre-aggregating monthly zone plant carbon.
- Fail cleanly if required upstream row counts are incomplete.
- Consider replacing per-month EF aggregate queries with a streaming or
  precomputed intermediate table if later datasets grow.

## Cleanup And Lower-Priority Work

- The project builds with many nullable warnings.
- Some comments and package references still reflect older SQL Server history.
- `TextFileInput.cs` remains large and mixes parsing, conversion, and import
  orchestration.
- Several legacy Big Creek paths still rely on positional parsing and filename
  conventions.
- Climate import is recognized but not implemented.
- `--force` is recognized but does not have a well-defined safety contract
  beyond bypassing Central Coast validation failure.
- The create-database wizard option is simulated; it shows setup guidance rather
  than creating a MySQL schema.
- Automated tests are still missing for parser behavior, config loading,
  calendar/date derivation, database write failure behavior, and generated
  terrain-frame contracts.

## Completed Or Improved

- README no longer describes the importer as MSSQL-only.
- Central Coast and Big Creek data folders were unified under
  `RHESSYs_Data_Importer/Data/`.
- Central Coast v2 schema setup now documents the MySQL Workbench plus
  checked-in SQL export workflow.
- Visual Studio 2022+ requirement is documented for loading the importer
  solution.
- Central Coast v2 date table population no longer depends on Big Creek's
  legacy `hist` aggregate text-file path.
- Transient MySQL retry resiliency and longer command timeout were added to
  `CentralCoastDbContext`.
- Patch mapping and terrain generation docs were converted from completed
  planning notes into current implementation notes.

## When To Revisit This Roadmap

Revisit after each production-style Central Coast import run, after any new
scenario profile is added, or when importer failures require manual database
recovery. Retire or split this roadmap once the remaining operational items are
tracked in the project issue/task system.
