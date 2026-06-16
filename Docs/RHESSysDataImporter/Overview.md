# RHESSys Data Importer Overview

Last updated: 2026-06-16

## Purpose

The RHESSys Data Importer is a standalone .NET console utility embedded in the Future Mountain repository under:

```text
RHESSYs_Data_Importer/
```

Its current purpose is to import RHESSys-derived Big Creek v1 and Central Coast
v2 data into MySQL databases used by the Future Mountain API and Unity runtime.

This documentation describes the current checked-in importer behavior only. It does not define a future generalized importer model.

## Project Location

Solution:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer.sln
```

Opening the solution in Visual Studio requires Visual Studio 2022 or newer. The importer targets .NET 8, and older Visual Studio versions may not load the solution correctly.

Project:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer/RHESSYs_Data_Importer.csproj
```

Main entry point:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer/Program.cs
```

## Runtime Type

The importer is a .NET 8 console application.

The project file currently targets:

```xml
<TargetFramework>net8.0</TargetFramework>
```

The project uses Entity Framework Core with Pomelo/MySQL for database writes. Older SQL Server references remain in comments and package references, but the active DbContext configuration uses MySQL.

## High-Level Flow

1. `Program.cs` starts the importer.
2. The importer looks for `ScenarioConfig_BigCreek.json` in the current working directory.
3. If the scenario config exists, it is loaded through `ScenarioConfigLoader`.
4. The database connection string is built from the scenario config and passed to `ConnectionHelper`.
5. `FileDiscovery` searches configured input folders for known data categories.
6. In interactive mode, `WizardRunner` prompts the user for config, database, data type, and confirmation choices.
7. In auto mode, command-line flags select the data categories to import.
8. Big Creek v1 paths primarily use `TextFileInput` and `RHESSYsDAL`.
9. Central Coast v2 paths use `CentralCoastImporter` and `CentralCoastDAL`.

## Main Code Areas

| Area | Purpose |
| --- | --- |
| `Program.cs` | Startup, config loading, flag parsing, interactive/auto mode dispatch |
| `Configuration/` | Scenario config DTOs and JSON loading |
| `IO/FileDiscovery.cs` | File discovery from configured folders and patterns |
| `Wizard/WizardRunner.cs` | Interactive console wizard |
| `Parsing/ColumnMapper.cs` | Header-to-model column mapping for config-aware cube imports |
| `TextFileInput.cs` | Parsing and import orchestration for cube, dates, water, fire, patch, and terrain data |
| `DAL/` | Connection helper, EF Core DbContexts, and write methods |
| `Models/` | Database/import model classes |
| `Migrations/` | EF migration artifacts for some contexts |
| `data/` | Embedded sample/source data currently present in the importer tree |

## Current Import Categories

The current config/discovery model recognizes these categories:

- `dates`
- `cube`
- `patch`
- `terrain`
- `fire`
- `burn`
- `water`
- `climate`
- `stratum`

Big Creek v1 still has cube as the most complete config-driven wizard path.
Central Coast v2 has implemented paths for dates, cube patch/stratum updates,
water, burn, patch-map, stratum carbon, and terrain generation. Climate remains
a recognized placeholder.

## Current Database Targets

The Big Creek v1 scenario config lists these output tables:

- `cubedata`
- `patchdata`
- `terraindata`
- `firedata`
- `waterdata`
- `dates`

Each major table currently has a dedicated EF Core DbContext.

Central Coast v2 uses a dedicated schema/database and additional tables such as
`BurnData`, `StratumData`, and `ImportRun`.

## Current Operation Modes

### Interactive Mode

Interactive mode is the default when `--auto` is not provided.

If `ScenarioConfig_BigCreek.json` is found, the importer opens the wizard. The wizard can load another config, simulate database creation, discover files, preview cube mappings, and run selected imports.

For Big Creek v1, only cube import is currently implemented in wizard mode.
Other categories are shown in the wizard but report that their import is not yet
implemented there.

For Central Coast v2, wizard mode supports dates, cube, water, burn, patch,
stratum, and terrain. Fire-frame import is exposed only as a placeholder until a
source file is configured.

### Auto Mode

Auto mode is selected with:

```text
--auto
```

Supported flags include:

- `--dryrun`
- `--force`
- `--config <path>`
- `--dates`
- `--cubes`
- `--patch`
- `--terrain`
- `--fire`
- `--burn`
- `--water`
- `--climate`
- `--stratum`

If no category flag is provided in auto mode, the importer enables cube, patch,
terrain, fire, water, dates, and stratum. Burn is also enabled for
Central Coast v2. Climate remains a placeholder.

### Legacy Fallback Mode

If the default scenario config is not found, or if config-driven cube discovery finds no cube files, the importer can fall back to older hard-coded folder paths and positional parsing behavior.

Those paths are currently local workstation paths in `Program.cs`.

## Current Known Boundaries

- The Unity runtime does not load this importer configuration directly.
- The importer is not a Unity project.
- The importer does not currently provide a stable API.
- The importer is not currently a universal RHESSys importer.
- The current docs and specs describe the embedded current state, not a future scenario migration.

## Related Documentation

- [Building And Running](BuildingAndRunning.md)
- [Scenario Config](ScenarioConfig.md)
- [Data Sources](DataSources.md)
- [Scenario Upgrade Guide](ScenarioUpgradeGuide.md)
- [Import Pipeline Spec](../../Specs/RHESSysDataImporter/ImportPipeline.md)
- [Scenario Config Schema Spec](../../Specs/RHESSysDataImporter/ScenarioConfigSchema.md)
- [File Naming And Discovery Spec](../../Specs/RHESSysDataImporter/FileNamingAndDiscovery.md)
- [Database Write Contract Spec](../../Specs/RHESSysDataImporter/DatabaseWriteContract.md)
- [Roadmap](../../Specs/RHESSysDataImporter/Roadmap.md)
