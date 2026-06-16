# Initial Terrain Data

Last updated: 2026-06-16

## Purpose

This document explains the implemented Central Coast v2 `TerrainData`
generation workflow for the current pre-prototype scenario. It replaces the
earlier planning note for the now-completed terrain-frame generator.

The implementation uses the partial Central Coast dataset at:

```text
RHESSYs_Data_Importer/Data/CentralCoast/RHESSysOutput-SingleWarmIdx-6-4-2026/
```

That sample bundle is imported with:

- `scenarioRunId = single-warming-sample`
- `warmingIdx = 0`

The terrain generator converts imported `PatchData`, `StratumData`, and
`BurnData` into monthly `TerrainData` frames that can be served through the
Future Mountain API and consumed by Unity as Central Coast landscape state.

## Inputs

`GenerateTerrainData` expects the upstream Central Coast import tables to
already be populated:

| Input | Role |
| --- | --- |
| `PatchData` | Static `zoneID` footprints from `Pch30rip90upRN.tiff` |
| `StratumData` | Monthly per-stratum carbon values |
| `BurnData` | Monthly basin/patch burn values; terrain uses `level = "patch"` |

`PatchData` is produced by the initial patch mapping workflow documented in:

```text
Docs/CentralCoastV2/InitialPatchMapping.md
```

For the current sample bundle, the generated time series is monthly and spans
384 frames for one warming case.

## Import Command

From the importer project folder:

```powershell
cd RHESSYs_Data_Importer\RHESSYs_Data_Importer
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --terrain
```

The terrain import should run after patch, burn, and stratum imports:

```powershell
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --patch
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --burn
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --stratum
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --terrain
```

The `--terrain` Central Coast path calls:

```text
CentralCoastImporter.GenerateTerrainData(config, dryrun)
```

Rows are written through:

```text
CentralCoastDAL.AddTerrainDataRows(...)
```

Dry-run behavior is intentionally limited. The generator logs that terrain
generation is skipped because it depends on database-resident `PatchData` and
`StratumData`.

## Rectangular Grid

The Central Coast patch map raster is rectangular:

| Property | Value |
| --- | --- |
| Grid width | 396 |
| Grid height | 301 |
| Total cells | 119,196 |
| Pixel grain size | approximately 30 m |

Big Creek `TerrainData` uses a single `gridSize` field and assumes a square
grid. Central Coast rows keep backward compatibility by setting:

| Field | Value |
| --- | --- |
| `gridSize` | `0` |
| `gridWidth` | `396` |
| `gridHeight` | `301` |

Central Coast data should not be resampled into a square `gridSize` payload.
Doing so would distort the patch-map footprints.

## TerrainData Rows

Each Central Coast `TerrainData` row represents one monthly frame:

```text
(scenarioRunId, warmingIdx, year, month)
```

Database shape:

| Column | Meaning |
| --- | --- |
| `scenarioRunId` | Scenario member, currently `single-warming-sample` |
| `warmingIdx` | Warming case, currently `0` |
| `year` | Frame year |
| `month` | Frame month |
| `gridSize` | `0` for Central Coast rectangular frames |
| `gridWidth` | `396` |
| `gridHeight` | `301` |
| `pixelGrainSize` | `30` |
| `decimalPrecision` | `4` |
| `_dataList` | JSON flat float array |

The model class is:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer/Models/CentralCoast/TerrainDataRow.cs
```

## Data Encoding

`_dataList` is a row-major JSON float array with length:

```text
gridWidth * gridHeight = 396 * 301 = 119,196
```

Pixel coordinates from `PatchData.pixels` map into `_dataList` with:

```text
index = row * gridWidth + col
```

Each value encodes vegetation intensity and burn signal in one float:

```text
value = vegIntensity + burnSignal * 100
```

Where:

- `vegIntensity` is normalized into `[0.0, 1.0]`.
- `burnSignal` is `1` when patch-level burn is positive for the zone/month,
  otherwise `0`.

Unity or API consumers can separate the two pieces as:

```text
vegIntensity = value % 100
burnSignal = floor(value / 100)
```

This follows the broad Big Creek convention of encoding terrain visual state in
one terrain-frame value while still allowing Central Coast to use explicit
rectangular dimensions.

## Aggregation

For each monthly frame and each mapped `zoneID`:

| Source | Aggregation |
| --- | --- |
| `StratumData.total_plantc` | Mean across all patchID and stratumID members for the zone/month |
| `BurnData.burn` | Max across patch-level rows for the zone/month |

Mean `total_plantc` avoids double-counting the two patch members and over/under
strata inside a `zoneID`. Max burn treats burn as a signal rather than an
additive quantity.

The implementation computes `globalMaxPlantC` across all imported `StratumData`
rows for the active `(scenarioRunId, warmingIdx)` and normalizes each zone/month:

```text
vegIntensity = clamp(meanPlantC / globalMaxPlantC, 0, 1)
```

The current code uses the maximum individual `total_plantc` value as
`globalMaxPlantC`.

## Generator Flow

`GenerateTerrainData` performs these steps:

```text
1. Load PatchData rows for scenarioRunId.
   Convert each [col, row] pixel to a flat index.

2. Compute globalMaxPlantC for scenarioRunId and warmingIdx.

3. Read distinct (year, month) pairs from StratumData.

4. For each month:
   a. Aggregate mean total_plantc by zoneID.
   b. Aggregate max patch-level burn by zoneID.
   c. Allocate a 396 x 301 float array.
   d. For each zoneID footprint:
      - compute vegIntensity
      - compute burnSignal
      - write value into every pixel index for that zoneID
   e. Serialize the array as JSON.
   f. Add one TerrainDataRow to the batch.

5. Batch insert all generated TerrainData rows.
```

Expected console output includes:

```text
[TerrainData] Loaded 4,477 zoneID footprints.
[TerrainData] globalMaxPlantC = ...
[TerrainData] 384 monthly frames to generate.
[TerrainData] Generated 384 TerrainData rows.
```

## Static DEM Heightmap

The sample folder also includes:

```text
dem30mSBFRbound.tiff
```

That DEM is aligned with the patch-family raster and is used separately for the
static Unity terrain-height prototype. It is not read by `GenerateTerrainData`.

Observed DEM properties:

| Property | Value |
| --- | --- |
| Grid size | 396 x 301 |
| Pixel scale | approximately 30 m |
| Sample type | unsigned 16-bit, single band |
| Observed value range | 0..255 |
| Nodata pixels observed | 0 using `65535` as nodata |

Prototype RAW output:

```text
Assets/Terrains/CentralCoastV2/Heightmaps/CentralCoast_DEM_513_uint16_little_endian.raw
```

Generation method:

- Read source TIFF as 396 x 301 unsigned 16-bit values.
- Bilinearly resample to 513 x 513 for Unity terrain import.
- Scale source min..max to 0..65535.
- Write headerless little-endian 16-bit RAW.

Unity `Import Raw...` settings used for the prototype:

| Setting | Value |
| --- | --- |
| Depth | Bit16 |
| Width | 513 |
| Height | 513 |
| Byte order | Windows / Little Endian |
| Terrain Size X | 11880 |
| Terrain Size Z | 9030 |
| Terrain Size Y | Start with 1000 or 1500 and tune visually |

The DEM values appear normalized rather than raw meter elevations, so terrain
height remains a visual tuning parameter for this prototype.

## Current Constraints

- This terrain-generation workflow documents the initial partial dataset only.
  Revalidate it if a later Central Coast bundle changes the raster, date range,
  scenario member, or warming-case metadata.
- Terrain generation depends on completed `PatchData`, `BurnData`, and
  `StratumData` imports. It is not idempotent; clear or replace existing rows
  before rerunning against the same target if duplicate rows matter.
- The burn signal is monthly. Any persistence of burn state across later months
  is a Unity/runtime visualization decision, not currently encoded here.
- Central Coast API/Unity consumers must use `gridWidth` and `gridHeight` when
  present, falling back to Big Creek `gridSize` only for legacy square frames.
