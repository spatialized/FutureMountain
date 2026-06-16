# RHESSys Data Importer Backlog And Known Gaps

Last updated: 2026-06-15

## Scope

This document records current known gaps in the embedded RHESSys Data Importer.
It is a short operational risk register, not a migration plan.

Keep this file while Central Coast v2 production import and API integration are
still active. Retire it once the remaining items are either fixed or moved into
tracked tasks.

## Current Status Snapshot

- Big Creek v1 and Central Coast v2 data now share the top-level
  `RHESSYs_Data_Importer/Data/` folder.
- Central Coast v2 uses a dedicated schema, `futuremtn_central_coast`, not
  `defaultdb`.
- A checked-in Central Coast schema export exists at
  `Database/Schema/CentralCoastV2_schema.sql`.
- Central Coast v2 dates are derived from the configured daily aggregate CSV
  (`cubeAggregateDaily`) rather than manually configured start/end dates.
- `--dates` exists, and full Central Coast auto import includes dates.
- Central Coast v2 production import exposed transient MySQL/VPN failure and
  command-timeout issues.
- `CentralCoastDbContext` now enables MySQL retry resiliency and uses a longer
  command timeout for large Central Coast reads/writes.
- `StratumData` batch insert now reports actual saved rows and recursively
  isolates bad rows so a single failed row does not drop an entire 10k-row batch.

## Still-Open High Priority Gaps

### Import Resume / Idempotency

Central Coast category imports are not generally idempotent.

If a production import fails midway, rerunning the same category may append
duplicate rows unless the target table is cleared first. The current safest
manual recovery path for failed `StratumData` is:

```sql
USE futuremtn_central_coast;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE terraindata;
TRUNCATE TABLE stratumdata;
SET FOREIGN_KEY_CHECKS = 1;
```

Then rerun `--stratum`, verify row counts, and run `--terrain`.

Needed:

- explicit replace/resume modes
- duplicate detection or uniqueness constraints for scenario keys
- clear guidance in the importer output when a table must be truncated before
  retrying

### Failed Writes Must Abort When Data Completeness Matters

Some DAL methods still catch exceptions and return `0`. The improved
`StratumData` path reports saved-vs-source counts, but import orchestration
should fail the process when required rows are missing, especially before
terrain generation.

Needed:

- throw or return a hard failure when `saved != expected`
- prevent full import from continuing to dependent categories after incomplete
  upstream data
- apply the same standard to `FireData`, `WaterData`, `PatchData`,
  `TerrainData`, and date population where appropriate

### Production Preflight Validation

The importer validates source files, but target database validation is still
limited.

Needed before future production runs:

- confirm target schema exists
- confirm expected tables and columns exist
- confirm expected table row counts are zero or intentionally replaceable
- print target database/schema in the final confirmation
- optionally require an explicit production acknowledgement flag

### Structured Import Report

Console output is still the main run record.

Needed:

- per-category source rows read
- rows saved
- rows skipped/dropped
- failure details
- elapsed time
- target database/schema
- scenario metadata
- ideally a persisted `ImportRun` record

## Medium Priority Gaps

### Scenario Config Validation

No formal JSON schema exists for scenario config validation.

Needed:

- validate required fields by `scenarioProfile`
- reject unknown file roles when profile-specific importers require fixed roles
- prevent credentials from being committed in shared configs
- validate database name/host before import begins

### Wizard Mode

Wizard mode has Central Coast v2 coverage, but auto mode remains the primary
tested path for production imports. The wizard now includes derived `dates`,
runs date validation/population before cube and water imports, uses the tested
Central Coast v2 category order, and hides unsupported legacy-only categories
from the Central Coast v2 selection menu.

Needed:

- run one end-to-end interactive Central Coast v2 wizard smoke test
- keep wizard prompts aligned with any future auto-mode import order changes

### Bulk Insert Performance

Central Coast imports use chunked EF inserts, which worked locally but remain
slow and sensitive to network/database interruptions at production scale.

Needed:

- evaluate MySQL bulk load or batched insert strategies for large tables
- reduce per-row EF overhead for `StratumData` and `FireData`
- keep enough logging to diagnose bad rows without flooding the console

### Terrain Generation Query Performance

The command timeout was increased, but terrain generation still performs large
aggregate scans over `StratumData`.

Needed:

- confirm indexes support `(scenarioRunId, warmingIdx, year, month, zoneID)`
- consider pre-aggregating monthly zone plant carbon
- make terrain generation fail cleanly if required upstream row counts are
  incomplete

## Lower Priority / Cleanup Gaps

- The project builds with many nullable warnings.
- Some comments and package references still reflect older SQL Server history.
- `TextFileInput.cs` remains large and mixes parsing, conversion, and import
  orchestration.
- Several legacy Big Creek paths still rely on positional parsing and filename
  conventions.
- Climate import is recognized but not implemented.
- `--force` is recognized but does not have a well-defined safety contract.
- The create-database wizard option is simulated.
- Automated tests are still missing for parser behavior, config loading,
  calendar/date derivation, and database write failure behavior.

## Recently Resolved Or Improved

- README no longer describes the importer as MSSQL-only.
- Central Coast and Big Creek data folders were unified under
  `RHESSYs_Data_Importer/Data/`.
- Central Coast v2 schema setup now documents the MySQL Workbench + checked-in
  SQL export workflow.
- Visual Studio 2022+ requirement is documented for loading the importer
  solution.
- `ScenarioConfig_CentralCoastV2.json` points at the unified Central Coast data
  folder.
- Central Coast v2 date table population no longer depends on Big Creek's legacy
  `hist` aggregate text-file path.
- Transient MySQL retry resiliency and longer command timeout were added to
  `CentralCoastDbContext`.

## Should This File Continue To Exist?

Yes, for now.

This file is still useful because the importer is in an active transition:
Central Coast v2 has passed local import testing, production import has started,
and several remaining risks are operational rather than purely code-level.

Retire this file when:

- production Central Coast import is repeatable
- row-count validation is automated or documented in the runbook
- import failure behavior is hard-fail instead of best-effort logging
- remaining cleanup work has been moved into issue/task tracking
