# RHESSys Data Importer Database Write Contract Spec

Last updated: 2026-06-13

## Scope

This spec documents the current database write behavior in the RHESSys Data Importer.

It does not define a future database schema.

## Database Provider

All current DbContexts configure MySQL through Pomelo:

```csharp
optionsBuilder.UseMySql(cs, ServerVersion.AutoDetect(cs));
```

SQL Server packages and comments remain in the project, but the active write paths use MySQL connection strings.

## Connection String Resolution

Implemented in:

```text
DAL/ConnectionHelper.cs
```

Resolution order:

1. If `ConnectionHelper.SetOverride` has been called with a non-empty connection string, return that.
2. If `appsettings.Development.json` exists, try to read `Database.ConnectionString`.
3. Fall back to a local MySQL placeholder:

```text
server=localhost;port=3306;database=bigcreek_rhessys;user=root;password=;charset=utf8mb4;
```

When the default scenario config loads, `Program.cs` sets the override using the config database section.

## DAL Class

Implemented in:

```text
DAL/RHESSYsDAL.cs
```

Current write methods:

| Method | DbContext | DbSet |
| --- | --- | --- |
| `AddDataPoint` | `CubeDataDbContext` | `CubeData` |
| `AddDate` | `DatesDbContext` | `Dates` |
| `AddWaterDataFrame` | `WaterDataDbContext` | `WaterData` |
| `AddPatchData` | `PatchDataDbContext` | `PatchData` |
| `AddTerrainDataFrame` | `TerrainDataDbContext` | `TerrainData` |
| `AddFireDataFrame` | `FireDataDbContext` | `FireData` |

## Write Pattern

The current DAL pattern is:

1. Construct a DbContext.
2. Add one record.
3. Call `SaveChanges`.
4. Return true if `SaveChanges()` reports more than zero changes.

This means large file imports call `SaveChanges` once per imported row.

## Current DbContexts

| DbContext | Model |
| --- | --- |
| `CubeDataDbContext` | `CubeDataPoint` |
| `DatesDbContext` | `Date` |
| `WaterDataDbContext` | `WaterDataFrame` |
| `PatchDataDbContext` | `PatchDataRecord` |
| `TerrainDataDbContext` | `TerrainDataFrameJSONRecord` |
| `FireDataDbContext` | `FireDataFrameJSONRecord` |

Each DbContext stores a connection string and configures itself if options have not already been configured.

## Cube Data Contract

`CubeDataPoint` is written by config-aware and legacy cube imports.

Current importer-populated fields include:

- `dateIdx`
- `warmingIdx`
- `patchIdx`
- `snow`
- `evap`
- `netpsn`
- `depthToGW`
- `vegAccessWater`
- `Qout`
- `litter`
- `soil`
- `heightOver`
- `transOver`
- `heightUnder`
- `transUnder`
- `leafCOver`
- `stemCOver`
- `rootCOver`
- `leafCUnder`
- `stemCUnder`
- `rootCUnder`

Aggregate cube imports use `patchIdx = -1`.

## Dates Contract

Dates are written through `AddDate`.

Legacy date import reads from historical aggregate text data and writes:

- `year`
- `month`
- `day`
- `date`

## Patch Data Contract

Patch import reads `PatchData.json` into a dictionary of `PatchPointCollection` values.

The DAL converts each collection to `PatchDataRecord` and writes:

- `patchID`
- serialized patch data through `SetData`

## Fire Data Contract

Fire import reads JSON fire frame records, converts them to `FireDataFrameJSONRecord`, assigns `warmingIdx`, and writes serialized frame data.

## Terrain Data Contract

Terrain import reads flattened integer arrays from JSON files, extracts metadata from filenames, converts to `TerrainDataFrameJSONRecord`, and writes serialized terrain data.

## Water Data Contract

Water import reads `WaterData.json`, traverses years/months/frames, increments frame index, and writes `WaterDataFrame` records.

## Current Schema Management

The project includes EF migration files for cube data and dates. It does not currently provide a clear complete migration workflow for every table listed in the scenario config.

The wizard's create-database option is simulated and does not create schema.

## Current Write Limitations

- No bulk insert path.
- No transaction across a whole file or import run.
- No duplicate detection.
- No truncate/replace safety mechanism.
- No import manifest table.
- No structured row-level error report.
- No complete schema validation before import.
- No production/staging guardrail.

## Current Operational Contract

Before running an import, the operator is responsible for confirming:

- The database exists.
- The expected tables exist.
- The schema matches the model classes.
- The database target is staging or otherwise safe.
- Existing data has been backed up if needed.
