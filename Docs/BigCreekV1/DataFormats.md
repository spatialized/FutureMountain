# Data Formats

Last updated: 2026-06-12

## Overview

Future Mountain Big Creek (v1) visualizes RHESSys-derived data through Unity runtime models, API JSON responses, and legacy TextAsset parsing paths.
The runtime code still contains hard-coded column order assumptions, so this document should be treated as both documentation and a migration checklist.

## Scenario Config

`ScenarioConfig_BigCreek.json` currently defines:

- Scenario name: `BigCreek`
- Database: `bigcreek_rhessys` on local MySQL defaults.
- Input folders for cube, patch, basin, spatial, and climate data.
- File patterns for cube, aggregate cube, patch, basin, and climate inputs.
- Column mappings for cube, patch, basin, and climate inputs.
- Output tables: `cubedata`, `patchdata`, `terraindata`, `firedata`, `waterdata`, `dates`.
- Flags: `hasFire: true`, `vegetationLayers: 2`.

This file is currently documentation/config for the data pipeline. The Unity runtime does not load this scenario config directly. This format may be used/expanded in the future for a generalized scenario loader.

## Warming Levels

Current warming indices:

| Index | Degrees |
| --- | ---: |
| 0 | 0 C |
| 1 | 1 C |
| 2 | 2 C |
| 3 | 4 C |
| 4 | 6 C |

The same mapping appears in UI and controller code. Future scenarios should define this once.

## Cube Data

Runtime DTO: `Assets/Scripts/Models/CubeData.cs`

Web/API fields consumed by Unity:

- `id`
- `dateIdx`
- `warmingIdx`
- `patchIdx`
- `snow`
- `evap`
- `netpsn`
- `depthToGW`
- `vegAccessWater`
- `qout`
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

Legacy/TextAsset cube columns are indexed in `CubeController.DataColumnIdx`:

| Column | Meaning |
| --- | --- |
| `date` | Date index/string value in source file |
| `snow` | Snow |
| `evap` | Evaporation |
| `netpsn` | Net photosynthesis |
| `depthtogw` | Depth to groundwater |
| `vegaccesswater` | Vegetation-accessible water |
| `qout` | Streamflow/outflow |
| `litter` | Litter |
| `soil` | Soil carbon/storage |
| `height_over` | Overstory height |
| `trans_over` | Overstory transpiration |
| `height_under` | Understory height |
| `trans_under` | Understory transpiration |
| `leafc_over` | Overstory leaf carbon |
| `stemc_over` | Overstory stem carbon |
| `rootc_over` | Overstory root carbon |
| `leafc_under` | Understory leaf carbon |
| `stemc_under` | Understory stem carbon |
| `rootc_under` | Understory root carbon |
| `year` | Year |
| `month` | Month |
| `day` | Day |

Aggregate cube data has a related but slightly different enum that uses a single transpiration column.

## Water Data

Runtime DTO: `Assets/Scripts/Models/WaterData.cs`

Fields:

- `index`
- `year`
- `month`
- `day`
- `qBase`
- `qWarm1`
- `qWarm2`
- `qWarm4`
- `qWarm6`
- `precipitation`

Legacy/TextAsset water columns are indexed in `LandscapeController.WaterDataColumnIdx`:

- `day`
- `month`
- `year`
- `date`
- `wy`
- `precip`
- `QBase`
- `QWarm1`
- `QWarm2`
- `QWarm4`
- `QWarm6`

## Patch Data

Patch columns are indexed in `LandscapeController.PatchDataColumnIdx`:

- `month`
- `year`
- `patchID`
- `snow`
- `plantc`
- `spread`
- `iter`

`ScenarioConfig_BigCreek.json` currently maps patch input columns for `month`, `year`, `patchID`, `snow`, and `plantc`; the runtime also expects fire-related `spread` and `iter` columns in legacy formatting paths.

## Fire Data

Runtime DTO: `Assets/Scripts/Models/FireData.cs`

The API fire frame record includes:

- `id`
- `warmingIdx`
- `year`
- `month`
- `day`
- `gridHeight`
- `gridWidth`
- `_dataList`

`_dataList` is serialized JSON containing fire points. Runtime fire point classes are currently nested in `LandscapeController.cs`.

## Terrain Data

Runtime DTO: `Assets/Scripts/Models/TerrainDataFrame.cs`

Terrain frame fields include:

- `id`
- `warmingIdx`
- `year`
- `month`
- `gridSize`
- `pixelGrainSize`
- `decimalPrecision`
- `_dataList`

`_dataList` is serialized JSON containing an integer array used to rebuild terrain/snow/texture data.

## Dates

Runtime DTO: `Assets/Scripts/Models/DateModel.cs`

The API provides a date list used by `GameController` to map simulation indices to calendar dates.

## Central Coast Migration Checklist

- Add any new source columns to the importer config, MySQL schema, API DTOs, and Unity DTOs together.
- Decide whether new fields are visualization-driving fields or metadata.
- Avoid relying on column position for new data where a named schema can be used.
- Define scenario-specific warming levels, dates, patch/cube counts, and labels in configuration.
- Version the data contract so Unity can detect incompatible API/importer data.

