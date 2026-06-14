# RHESSys Data Importer Import Pipeline Spec

Last updated: 2026-06-13

## Scope

This spec documents the current import pipeline implemented by the embedded RHESSys Data Importer.

It does not specify future scenario support or new data formats.

## Entry Point

The importer starts in:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer/Program.cs
```

Startup responsibilities:

- Initialize import-category booleans.
- Define legacy folder paths.
- Load `ScenarioConfig_BigCreek.json` if present.
- Set the active DB connection override.
- Discover files through `FileDiscovery`.
- Parse command-line flags.
- Dispatch to wizard, auto, or legacy import paths.

## Config Load

Default path:

```text
ScenarioConfig_BigCreek.json
```

`ScenarioConfigLoader.Load(path)` uses Newtonsoft.Json to deserialize the file into `ScenarioConfig`.

If the config loads:

1. The importer logs scenario and database information.
2. `ConnectionHelper.SetOverride(config.Database.GetConnectionString())` sets the connection string for subsequent DbContexts.
3. `FileDiscovery.FindFiles(config)` builds a category-to-files result.

If the config does not exist, the importer logs that it is running the legacy Big Creek importer.

## Flag Parsing

Flags are read from:

```csharp
Environment.GetCommandLineArgs().Skip(1)
```

Recognized flags:

- `--auto`
- `--dryrun`
- `--force`
- `--cubes`
- `--patch`
- `--terrain`
- `--fire`
- `--water`
- `--climate`

If `--auto` is absent and a config is active, `WizardRunner.Run(activeConfig, dryrun)` is called and `Program.cs` returns afterward.

## Interactive Pipeline

`WizardRunner.Run` performs:

1. Scenario confirmation.
2. Optional alternate config load.
3. Existing database vs simulated new database choice.
4. File discovery.
5. Data category selection.
6. Optional cube column-mapping preview.
7. Final confirmation.
8. Selected import execution.

Current `RunSelectedImports` implementation:

- `cube`: imports discovered cube files through `TextFileInput.ReadCubeDataFiles`.
- `patch`, `terrain`, `fire`, `water`, `climate`: logs that import is not implemented in wizard mode.

## Auto Pipeline

When `--auto` is present:

1. The importer logs auto mode.
2. `--dryrun` and `--force` are logged if present.
3. Category flags are checked.
4. If any category flag exists, only those categories are enabled.
5. If no category flag exists, cube, patch, terrain, fire, and water are enabled.
6. Climate is recognized as a placeholder but not imported.

Auto cube behavior:

- If config and discovered cube files exist, import those files unless dry-run is enabled.
- If config exists but no cube files are discovered, warn and fall back to legacy cube import unless dry-run is enabled.
- If no config exists, run legacy cube import unless dry-run is enabled.

Auto patch, terrain, fire, and water behavior:

- These call legacy methods in `TextFileInput` unless dry-run is enabled.

## Cube Import Pipeline

Config-aware cube import is implemented in:

```text
TextFileInput.ReadCubeDataFiles(IEnumerable<string> files, ScenarioConfig config)
```

For each file:

1. Infer warming index from filename.
2. Infer patch index from leading `p...` filename segment if present.
3. Read all lines.
4. Treat the first non-empty line as a header.
5. Build a `ColumnMapper` from the header and `config.ColumnMapping["cube"]`.
6. If no columns map, fall back to legacy positional parsing.
7. Warn for expected mapped fields not found in the header.
8. Convert each non-header data line into `CubeDataPoint`.
9. Write each row through `RHESSYsDAL.AddDataPoint`.

## Legacy Cube Pipeline

Legacy cube import is implemented in:

```text
TextFileInput.ReadCubeData(string folderAggregate, string folderCubes)
```

It imports:

- Aggregate files from `folderAggregate` with `patchIdx = -1`.
- Patch/cube files from `folderCubes` with patch id inferred from filename.

Rows are parsed by fixed numeric positions.

Aggregate rows omit the `transUnder` source position used by patch cube rows.

## Legacy Non-Cube Pipelines

Current legacy methods:

| Method | Source expectation | Target write method |
| --- | --- | --- |
| `ReadDates` | Historical aggregate text file | `AddDate` |
| `ReadWaterData` | `WaterData.json` | `AddWaterDataFrame` |
| `ReadFireData` | JSON files in fire folder | `AddFireDataFrame` |
| `ReadPatchData` | `PatchData.json` | `AddPatchData` |
| `ReadTerrainData` | Terrain JSON files with metadata in filename | `AddTerrainDataFrame` |

These paths are older and less config-driven than the cube path.

## Database Write Pipeline

`RHESSYsDAL` creates a new DbContext for each record write and calls `SaveChanges`.

Current write methods:

- `AddDataPoint`
- `AddDate`
- `AddWaterDataFrame`
- `AddPatchData`
- `AddTerrainDataFrame`
- `AddFireDataFrame`

This is simple but may be slow for large imports.

## Error Handling

Current behavior is mostly console logging and catch-and-continue.

Examples:

- File-level cube processing catches exceptions and logs warnings.
- Some legacy methods catch exceptions but ignore exception details.
- `AddTerrainDataFrame` and `AddFireDataFrame` catch DB exceptions and return false.

The importer does not currently produce a structured import report.

## Current Acceptance Criteria

For the current importer baseline:

- The solution builds.
- The default config can be loaded from the correct working directory.
- File discovery prints counts and warnings.
- Cube import can run in wizard or auto mode.
- Legacy non-cube paths remain callable from auto mode.
- MySQL connection strings flow through `ConnectionHelper`.
