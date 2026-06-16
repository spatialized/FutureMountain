# Central Coast v2 Database Schema Design

Last updated: 2026-06-13

## Purpose

This document designs the Central Coast v2 import (staging) schema, delivered as
task `CCV2-04`. It defines the tables that the Central Coast importer writes to,
their columns, keys, and which source file/grain feeds each one.

It builds on the config design in `CentralCoastConfig.md` and the source-file
inventory in `Docs/CentralCoastV2/DataFormats.md`.

## Ground Rules

- **Separate database.** Central Coast tables live in their own database
  (`centralcoast_rhessys`, parallel to `bigcreek_rhessys`). Nothing here touches
  the Big Creek v1 database or its `CubeData`.
- **Original EF naming style.** Tables are unprefixed and use the existing
  Big Creek EF/PascalCase convention (`CubeData`, `WaterData`,
  `PatchData`, `Dates`). New tables that have no Big Creek
  equivalent reuse the same style (`BurnData`, `StratumData`, `ImportRun`).
  This applies to the new Central Coast database only; Big Creek v1 remains
  untouched, including any lowercase table names shown by the current MySQL
  server.
- **Provider/conventions match the importer.** MySQL via Pomelo, `utf8mb4`,
  integer identity `id` primary keys, `float` numeric columns, `dateIdx`/
  `warmingIdx` integer keys, exactly like the existing Big Creek models.
- **Multi-member ready.** Every data table carries `scenarioRunId` and
  `warmingIdx` so multiple scenario members can coexist in one database.
- **Provenance.** Every data table carries `importRunId` (FK to `ImportRun`) and,
  where a single file feeds the table, `sourceFile`.

## Scale Split

Central Coast data separates cleanly into two scales, mirroring Big Creek's cube
vs. large-landscape split:

- **Cube scale** (5 detailed cube locations, daily): `CubeData` + `WaterData`.
- **Landscape scale** (all ~8,954 patches / ~17,908 strata, monthly):
  `BurnData` (monthly burn) + `StratumData` (carbon) + `PatchData` (spatial extents).

This is why `CubeData` stays small/clean and is not overloaded with
whole-landscape monthly data.

## Raw Import vs Precomputed TerrainData

The tables in this document are raw imported RHESSys/source tables. They are not
yet the Unity-facing large-landscape payload.

For Big Creek v1, `TerrainData` is a precomputed monthly large-landscape
splatmap/texture frame that Unity can load through the API and interpolate over
time. Central Coast v2 should keep that same concept and name, but its
`TerrainData` should be generated after import from Central Coast source tables
and spatial assets:

```text
PatchData geometry
+ StratumData monthly vegetation/carbon
+ BurnData monthly burn
+ scenario/warming metadata
= precomputed Central Coast TerrainData
```

That `TerrainData` generation is a separate post-import/API-data task. It is not
the same thing as importing `spatial_data_point_stratvar.csv`.

## Table Overview

| Table | Grain | Source file(s) | Notes |
| --- | --- | --- | --- |
| `Dates` | Daily | derived from daily files | Date dimension; `dateIdx` = `id`. |
| `CubeData` | Daily, per cube | `cube_p_patch1/2`, `cubes_sc_over_patch1/2`, `cube_sc_under_patch1/2` | Patch + overstory + understory merged into one row. |
| `WaterData` | Daily, basin | `cube_agg_p` | Aggregate/whole-watershed daily (streamflow, precip, basin summaries). |
| `BurnData` | Monthly, basin + patch | `bm`, `spatial_data_point_patchvar` | RHESSys burn state; `level` discriminates basin vs patch. This is not Unity fire-spread frame data. |
| `StratumData` | Monthly, per stratum | `spatial_data_point_stratvar` | Whole-landscape stratum carbon over time. |
| `PatchData` | Static, per patch family | `Pch30rip90upRN.tiff` | Spatial extents (PatchPointCollection contract). |
| `ImportRun` | per run | n/a | Provenance / batch marker. |

## Decision: where the daily aggregate goes

The daily aggregate file `cube_agg_p.csv` is whole-watershed, not per-cube. Per
config decision 2, its `streamflow` is the basin streamflow that drives the large
landscape river — the role Big Creek's `WaterData` filled. So it maps to
`WaterData`, not to `CubeData`. This keeps `CubeData` purely per-cube (and
honors "does not overload CubeData") while preserving the aggregate's richer
basin columns in `WaterData`.

This means Central Coast `WaterData` differs from Big Creek `WaterData`: Big Creek
encoded warming as columns (`qBase…qWarm6`); Central Coast uses one row per
`(dateIdx, warmingIdx, scenarioRunId)` with a single `streamflow`, plus basin
summary columns. This is the normalized form recommended in `Specs/DataModel.md`.

## Common Columns

Unless noted, every data table includes:

| Column | Type | Meaning |
| --- | --- | --- |
| `id` | int identity PK | Surrogate key. |
| `importRunId` | int (FK `ImportRun.id`) | Which import run wrote the row. |
| `scenarioRunId` | varchar | Scenario member id (e.g. `single-warming-sample`). |
| `warmingIdx` | int | Warming/climate-case index (`0` for current sample). |
| `sourceFile` | varchar (nullable) | Source file name, where a single file feeds the table. |

## Dates

Date dimension built from the daily files. Same shape as Big Creek `Dates`;
`dateIdx` used by daily tables equals `Dates.id`.

| Column | Type | Source |
| --- | --- | --- |
| `id` | int identity PK | — |
| `date` | datetime | from `year`/`month`/`day` |
| `year` | int | `year` |
| `month` | int | `month` |
| `day` | int | `day` |

Unique index on `(year, month, day)`.

## CubeData

Daily per-cube rows for the 5 cube locations × 2 patch members (`01`/`02`). Built
by joining the patch hydrology file with the overstory and understory stratum
files on `(year, month, day, zoneID, patchID)`. Overstory `stratumID` ends in `1`,
understory in `2`.

Keys / identity:

| Column | Type | Source |
| --- | --- | --- |
| common columns | | |
| `dateIdx` | int (FK `Dates.id`) | from date |
| `basinID` | int | `basinID` |
| `hillID` | int | `hillID` |
| `zoneID` | int | `zoneID` (cube identity) |
| `patchID` | bigint | `patchID` (`…01`/`…02`) |

Patch hydrology (from `cube_p_patch*`):

`coverfract`, `litterc`, `burn`, `soilc`, `depthToGW`, `canopyevap`,
`streamflow`, `rootdepth`, `groundevap`, `vegAccessWater`, `Qin`, `Qout`, `rain`
— all `float`.

Overstory stratum (from `cubes_sc_over_patch*`):

`stratumIDOver` (bigint), `consumedCOver`, `mortCOver`, `netpsnOver`,
`heightOver`, `transOver`, `leafCOver`, `stemCOver`, `rootCOver`,
`rootdepthCOver`, `laiOver` (`float`), `vegParmIDOver` (int).

Understory stratum (from `cube_sc_under_patch*`):

`stratumIDUnder` (bigint), `consumedCUnder`, `mortCUnder`, `transUnder`,
`netpsnUnder`, `heightUnder`, `leafCUnder`, `stemCUnder`, `rootCUnder`,
`rootdepthUnder`, `laiUnder` (`float`), `vegParmIDUnder` (int).

Index on `(scenarioRunId, warmingIdx, dateIdx, zoneID, patchID)`.

This is a superset of the Big Creek `CubeData` columns (`heightOver`, `transOver`,
`leafCOver`, …, `transUnder`, … are all present), so a later adapter can project
Central Coast `CubeData` onto the Big Creek cube contract.

## WaterData

Daily basin/aggregate rows from `cube_agg_p.csv`.

| Group | Columns (all `float` unless noted) |
| --- | --- |
| keys | common columns, `dateIdx` (FK `Dates.id`), `basinID` (int) |
| hydrology | `streamflow`, `rain`, `evaporation`, `evaporation_surf`, `exfiltration_unsat_zone`, `exfiltration_sat_zone`, `transpiration_sat_zone`, `transpiration_unsat_zone`, `sat_deficit_z`, `rz_storage`, `rootzone_depth`, `family_pct_cover` |
| burn | `burn` |
| carbon | `litter_cs_totalc`, `soil_cs_totalc`, `cs_net_psn`, `epv_height`, `cs_leafc`, `cs_leafc_store`, `cs_live_stemc`, `cs_dead_stemc`, `cs_frootc`, `cs_live_crootc`, `cs_dead_crootc` |
| fire effects | `fe_canopy_target_prop_c_consumed`, `fe_canopy_target_prop_c_remain_adjusted`, `fe_canopy_target_prop_c_remain_adjusted_leafc` |

Index on `(scenarioRunId, warmingIdx, dateIdx)`.

Column names map the source headers' dots to underscores (e.g. `cs.net_psn` ->
`cs_net_psn`).

## BurnData

Monthly burn at basin and patch level, combining `bm.csv` and
`spatial_data_point_patchvar.csv`.

| Column | Type | Source |
| --- | --- | --- |
| common columns | | |
| `year` | int | `year` |
| `month` | int | `month` |
| `level` | varchar(`basin`/`patch`) | which file produced the row |
| `basinID` | int | `basinID` |
| `hillID` | int (nullable) | `hillID` (patch only) |
| `zoneID` | int (nullable) | `zoneID` (patch only) |
| `patchID` | bigint (nullable) | `patchID` (patch only) |
| `burn` | float | `burn` |

Index on `(scenarioRunId, warmingIdx, year, month, zoneID, patchID)`.

`level = 'basin'` rows leave `hillID`/`zoneID`/`patchID` null. This is monthly
data; runtime interpolates to daily using the existing snow/terrain interpolation
(config decision 7). No new runtime mechanism.

`FireData` is reserved for Big Creek-style Unity fire playback frames:
instantaneous fire events with `gridLocation`, `patchId`, `spread`, and `iter`
inside `_dataList`. The current Central Coast v2 sample does not include that
fire-frame source data, so monthly RHESSys burn must not be imported into
`FireData`.

## StratumData

Monthly whole-landscape stratum carbon from `spatial_data_point_stratvar.csv`
(~6.9M rows per member). Kept separate from `CubeData` because it spans every
stratum in the watershed, not just the 5 cubes.

This table is long-format RHESSys source data, not a map grid. One row means:

```text
for this month + zoneID + patchID + stratumID,
the carbon values are totalc and total_plantc
```

The current sample has 6,876,672 rows:

```text
17,908 stratumIDs * 384 months
```

The `zoneID` column links these rows back to the patch-family raster; the CSV
itself does not contain pixel coordinates or Unity texture weights.

| Column | Type | Source |
| --- | --- | --- |
| common columns | | |
| `year` | int | `year` |
| `month` | int | `month` |
| `basinID` | int | `basinID` |
| `hillID` | int | `hillID` |
| `zoneID` | int | `zoneID` |
| `patchID` | bigint | `patchID` |
| `stratumID` | bigint | `stratumID` |
| `totalc` | float | `totalc` |
| `total_plantc` | float | `total_plantc` |

Index on `(scenarioRunId, warmingIdx, year, month, stratumID)`.

## PatchData

Static per-patch-family spatial extents, decoded from `Pch30rip90upRN.tiff`. This
reuses Big Creek's `PatchData` role: the `PatchPointCollection` contract used for
the opening "where each cube comes from" animation and large-landscape terrain
color/texture (config decision 8). Only the decoder is new (GeoTIFF vs text grid).

| Column | Type | Meaning |
| --- | --- | --- |
| common columns (no `warmingIdx`; spatial is climate-independent) | | |
| `zoneID` | int | Patch-family id (raster value). |
| `data` | longtext (JSON) | Serialized `PatchPointCollection`: data-grid location, fire-grid location, alphamap location, UTM, pixel members. |

Index on `(scenarioRunId, zoneID)`.

Decoding the raster into this contract is a later task; the table shape is fixed
here.

## ImportRun

One row per import execution; the batch marker referenced by `importRunId`.

| Column | Type | Meaning |
| --- | --- | --- |
| `id` | int identity PK | — |
| `scenarioName` | varchar | From config. |
| `scenarioProfile` | varchar | `CentralCoastV2`. |
| `scenarioRunId` | varchar | Member id. |
| `warmingIdx` | int | Member warming index. |
| `databaseName` | varchar | Target database. |
| `sourceRoot` | varchar | Resolved source bundle path. |
| `startedUtc` | datetime | Run start. |
| `finishedUtc` | datetime (nullable) | Run end. |
| `status` | varchar | e.g. `running`, `succeeded`, `failed`, `dryrun`. |
| `filesImported` | int | Count of files processed. |
| `rowsImported` | bigint | Total rows written. |
| `notes` | longtext (nullable) | Warnings/summary. |

## Acceptance Mapping

- **Preserves raw Central Coast structure:** each source file's columns are
  preserved (cube files merged only along their shared key; aggregate, burn,
  stratum carbon, and rasters each retain their native columns).
- **Does not overload Big Creek v1 `CubeData`:** Central Coast uses its own
  database and its own `CubeData`; whole-landscape monthly data lives in separate
  tables (`BurnData`, `StratumData`).
- **Stores multiple future members:** `scenarioRunId` + `warmingIdx` on every data
  table, plus `ImportRun` provenance, allow many members in one database.

## Follow-ups

- Model classes for these tables: `CCV2-05`.
- EF migrations generated from those models (authoritative DDL): after `CCV2-05`.
- Raster decoder for `PatchData`: later spatial task.
