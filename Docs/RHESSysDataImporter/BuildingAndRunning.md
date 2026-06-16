# RHESSys Data Importer Building and Running

Last updated: 2026-06-13

## Purpose

This document describes how to build and run the current RHESSys Data Importer embedded in Future Mountain.

It is intended for developers or technical staff importing current Big Creek-style RHESSys data into a local or staging MySQL database.

## Prerequisites

Required:

- .NET SDK compatible with `net8.0`.
- Visual Studio 2022 or newer if opening the `.sln` in Visual Studio. Older Visual Studio versions may not load the .NET 8 importer solution correctly.
- MySQL server reachable from the workstation.
- Source RHESSys data files in folders matching the active scenario config.
- A database user with permission to write the configured database.

Useful:

- MySQL Workbench or another MySQL inspection tool.
- A staging database for testing imports before production updates.

## Build

From the importer solution folder:

```powershell
cd RHESSYs_Data_Importer
dotnet build RHESSYs_Data_Importer.sln
```

The project currently builds successfully, but with nullable and cleanup warnings.

## Configuration Files

Default scenario config:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer/ScenarioConfig_BigCreek.json
```

Optional local connection fallback:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer/appsettings.Development.json
```

When the scenario config exists, it takes precedence because `Program.cs` calls `ConnectionHelper.SetOverride(config.Database.GetConnectionString())`.

## Working Directory

Run commands from the project folder that contains `ScenarioConfig_BigCreek.json`:

```powershell
cd RHESSYs_Data_Importer\RHESSYs_Data_Importer
dotnet run
```

The current code checks for the default config using a relative path:

```text
ScenarioConfig_BigCreek.json
```

Running from another working directory may cause config discovery to fail and trigger legacy fallback behavior.

## Interactive Import

Default interactive run:

```powershell
dotnet run
```

Expected flow:

1. The app prints the importer title.
2. It loads `ScenarioConfig_BigCreek.json` if present.
3. It prints the configured scenario and database.
4. It discovers matching files and prints category counts.
5. It opens the wizard.
6. The user confirms the scenario or loads another config.
7. The user chooses whether to use an existing database or simulate creation of a new database.
8. The user selects data categories.
9. The user can preview cube column mappings.
10. The user confirms import.

Current wizard limitations (Big Creek v1):

Only cube import is implemented in wizard mode for the Big Creek v1 profile.
Patch, terrain, fire, water, and climate are selectable but report that the
import is not yet implemented.

For the Central Coast v2 profile, the following categories are fully
implemented in wizard mode:

| Category | Wizard | Auto |
| --- | --- | --- |
| Cube (patch + stratum) | Implemented | `--cubes` |
| Water | Implemented | `--water` |
| Burn (basin + patch monthly burn) | Implemented | `--burn` |
| Fire (Unity spread frames) | Placeholder until a fire-frame source is configured | `--fire` |
| Stratum carbon | Implemented | `--stratum` |

### Central Coast v2 Config

Central Coast v2 is selected through the interactive wizard. Run from the importer
project folder:

```powershell
cd RHESSYs_Data_Importer\RHESSYs_Data_Importer
dotnet run
```

The app loads `ScenarioConfig_BigCreek.json` first because Big Creek remains the
default profile. To use Central Coast v2, choose:

```text
[2] Load another config (enter path)
```

Then enter:

```text
ScenarioConfig_CentralCoastV2.json
```

For a validation-only run through the same wizard path:

```powershell
cd RHESSYs_Data_Importer\RHESSYs_Data_Importer
dotnet run -- --dryrun
```

Then choose option `2` and load `ScenarioConfig_CentralCoastV2.json`. The wizard
prints the resolved profile (`CentralCoastV2`), database target
(`centralcoast_rhessys`), discovery summary, and Central Coast validation report
before any import writes.

Headless (auto mode) with an explicit config:

```powershell
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json
```

Dry run:

```powershell
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --dryrun
```

## Auto Import

Run all currently enabled auto categories:

```powershell
dotnet run -- --auto
```

Dry run:

```powershell
dotnet run -- --auto --dryrun
```

Cube-only dry run:

```powershell
dotnet run -- --auto --dryrun --cubes
```

Cube-only import:

```powershell
dotnet run -- --auto --cubes
```

### Central Coast v2 Auto Dry Run

From the importer project folder:

Full dry run (all CCV2 categories, no DB writes):

```powershell
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --dryrun
```

Expected console output (approximate row counts):

| Category | File(s) | Expected rows |
| --- | --- | --- |
| Water | `cube_agg_p.csv` | 11,688 |
| Cube patch | `cube_p_patch1.csv` + `patch2.csv` | 116,880 |
| Cube stratum | over/under patch1/2 | 233,760 updates |
| Burn basin | `bm.csv` | 384 |
| Burn patch | `spatial_data_point_patchvar.csv` | 3,438,336 |
| Stratum carbon | `spatial_data_point_stratvar.csv` | 6,876,672 |

Category-scoped dry runs:

```powershell
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --dryrun --water
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --dryrun --cubes
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --dryrun --burn
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --dryrun --stratum
```

Auto mode flags:

| Flag | Current behavior |
| --- | --- |
| `--auto` | Enables non-interactive mode |
| `--dryrun` | Prints intended actions without DB writes in supported paths |
| `--force` | Skips validation failure abort; prints that force is enabled |
| `--cubes` | Enables cube import (CCV2: patch + stratum rows) |
| `--patch` | Enables legacy patch import |
| `--terrain` | Enables legacy terrain import |
| `--burn` | Enables Central Coast v2 monthly burn import (`BurnData`: basin + patch burn) |
| `--fire` | Enables configured fire-frame import. The current CCV2 sample has no fire-frame source file, so this is a clean no-op for that scenario. |
| `--water` | Enables water import (CCV2: daily aggregate) |
| `--stratum` | Enables stratum carbon import (CCV2 only) |
| `--config <path>` | Loads the specified scenario config instead of the default `ScenarioConfig_BigCreek.json` |
| `--climate` | Recognized as a flag, but climate import is not implemented |

## Database Behavior

The importer writes through EF Core DbContexts. Central Coast v2 burn, stratum, patch, and terrain data use batch inserts (chunk-based `AddRange` + single `SaveChanges` per chunk) to handle the large row counts efficiently.

Before importing:

1. Confirm the target database name.
2. Confirm that credentials in the scenario config point to staging or the intended target.
3. Confirm that existing data can be replaced or appended safely.
4. Back up any database that matters.

The current database creation helper is simulated. Choosing "Create new database" in the wizard logs what it would create but does not actually create a MySQL database.

## File Discovery Check

On startup, the importer prints a discovery summary:

```text
cube: N files
patch: N files
terrain: N files
fire: N files
water: N files
climate: N files
```

Warnings are printed when:

- An input folder does not exist.
- A category has no configured file pattern.
- No files match a category pattern.
- A directory search fails.

Treat these warnings as important. A successful process run can still import little or no data if discovery paths are wrong.

## Recommended Current Workflow

1. Build the importer.
2. Verify the scenario config database points to staging.
3. Run a dry run with the intended category flags.
4. Review discovery counts and warnings.
5. Confirm source files and target tables.
6. Back up the target database if it already contains useful data.
7. Run the import.
8. Inspect row counts in MySQL.
9. Smoke test the API endpoints that Unity consumes.
10. Smoke test the Unity runtime against the imported database/API.

## Troubleshooting

### The importer says no config was found

Run from:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer/
```

or pass through the wizard and load a config manually.

### File counts are zero

Check:

- `inputFolders` in the scenario config.
- Whether paths are relative to the current working directory.
- File patterns under `filePatterns`.
- Whether source files are in the top level of each folder.

`FileDiscovery` currently searches only the top level of each input folder.

### Cube import uses legacy parsing

If the source header does not match configured `columnMapping.cube` keys, `ColumnMapper` has no matches. The importer logs an error and falls back to positional legacy parsing.

### Wizard create-database option does not create a database

This is current behavior. `DatabaseHelper.CreateNewDatabase` is a placeholder that logs a simulated action.

### Build succeeds with warnings

The current code has nullable warnings, unused variables, and legacy comments. These do not currently prevent build output.

## Current Safety Notes

- Do not assume the importer is idempotent.
- Do not point the importer at production before validating on staging.
- Do not rely on `--force` as a real safety or overwrite mechanism.
- Do not assume all wizard categories are implemented.
- Do not commit local credentials.
