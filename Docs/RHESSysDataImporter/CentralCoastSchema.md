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
  the Big Creek v1 database or its `cubedata`.
- **Original naming style.** Tables are unprefixed and use the original
  lowercase `*data` style (`cubedata`, `waterdata`, `firedata`, `patchdata`,
  `terraindata`, `dates`). New tables that have no Big Creek equivalent reuse the
  same style (`stratumdata`, `importrun`, `rastermetadata`).
- **Provider/conventions match the importer.** MySQL via Pomelo, `utf8mb4`,
  integer identity `id` primary keys, `float` numeric columns, `dateIdx`/
  `warmingIdx` integer keys, exactly like the existing Big Creek models.
- **Multi-member ready.** Every data table carries `scenarioRunId` and
  `warmingIdx` so multiple scenario members can coexist in one database.
- **Provenance.** Every data table carries `importRunId` (FK to `importrun`) and,
  where a single file feeds the table, `sourceFile`.

## Scale Split

Central Coast data separates cleanly into two scales, mirroring Big Creek's cube
vs. large-landscape split:

- **Cube scale** (5 detailed cube locations, daily): `cubedata` + `waterdata`.
- **Landscape scale** (all ~8,954 patches / ~17,908 strata, monthly):
  `firedata` (burn) + `stratumdata` (carbon) + `patchdata` (spatial extents).

This is why `cubedata` stays small/clean and is not overloaded with
whole-landscape monthly data.

## Table Overview

| Table | Grain | Source file(s) | Notes |
| --- | --- | --- | --- |
| `dates` | Daily | derived from daily files | Date dimension; `dateIdx` = `id`. |
| `cubedata` | Daily, per cube | `cube_p_patch1/2`, `cubes_sc_over_patch1/2`, `cube_sc_under_patch1/2` | Patch + overstory + understory merged into one row. |
| `waterdata` | Daily, basin | `cube_agg_p` | Aggregate/whole-watershed daily (streamflow, precip, basin summaries). |
| `firedata` | Monthly, basin + patch | `bm`, `spatial_data_point_patchvar` | Burn; `level` discriminates basin vs patch. |
| `stratumdata` | Monthly, per stratum | `spatial_data_point_stratvar` | Whole-landscape stratum carbon over time. |
| `patchdata` | Static, per patch family | `Pch30rip90upRN.tiff` | Spatial extents (PatchPointCollection contract). |
| `terraindata` | (deferred) | `dem30mSBFRbound.tiff` | Defined for parity; not populated in phase 1. |
| `importrun` | per run | n/a | Provenance / batch marker. |
| `rastermetadata` | per raster | both `.tiff` | Raster provenance. |

## Decision: where the daily aggregate goes

The daily aggregate file `cube_agg_p.csv` is whole-watershed, not per-cube. Per
config decision 2, its `streamflow` is the basin streamflow that drives the large
landscape river — the role Big Creek's `waterdata` filled. So it maps to
`waterdata`, not to `cubedata`. This keeps `cubedata` purely per-cube (and
honors "does not overload cubedata") while preserving the aggregate's richer
basin columns in `waterdata`.

This means Central Coast `waterdata` differs from Big Creek `waterdata`: Big Creek
encoded warming as columns (`qBase…qWarm6`); Central Coast uses one row per
`(dateIdx, warmingIdx, scenarioRunId)` with a single `streamflow`, plus basin
summary columns. This is the normalized form recommended in `Specs/DataModel.md`.

## Common Columns

Unless noted, every data table includes:

| Column | Type | Meaning |
| --- | --- | --- |
| `id` | int identity PK | Surrogate key. |
| `importRunId` | int (FK `importrun.id`) | Which import run wrote the row. |
| `scenarioRunId` | varchar | Scenario member id (e.g. `single-warming-sample`). |
| `warmingIdx` | int | Warming/climate-case index (`0` for current sample). |
| `sourceFile` | varchar (nullable) | Source file name, where a single file feeds the table. |

## dates

Date dimension built from the daily files. Same shape as Big Creek `dates`;
`dateIdx` used by daily tables equals `dates.id`.

| Column | Type | Source |
| --- | --- | --- |
| `id` | int identity PK | — |
| `date` | datetime | from `year`/`month`/`day` |
| `year` | int | `year` |
| `month` | int | `month` |
| `day` | int | `day` |

Unique index on `(year, month, day)`.

## cubedata

Daily per-cube rows for the 5 cube locations × 2 patch members (`01`/`02`). Built
by joining the patch hydrology file with the overstory and understory stratum
files on `(year, month, day, zoneID, patchID)`. Overstory `stratumID` ends in `1`,
understory in `2`.

Keys / identity:

| Column | Type | Source |
| --- | --- | --- |
| common columns | | |
| `dateIdx` | int (FK `dates.id`) | from date |
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

This is a superset of the Big Creek `cubedata` columns (`heightOver`, `transOver`,
`leafCOver`, …, `transUnder`, … are all present), so a later adapter can project
Central Coast `cubedata` onto the Big Creek cube contract.

## waterdata

Daily basin/aggregate rows from `cube_agg_p.csv`.

| Group | Columns (all `float` unless noted) |
| --- | --- |
| keys | common columns, `dateIdx` (FK `dates.id`), `basinID` (int) |
| hydrology | `streamflow`, `rain`, `evaporation`, `evaporation_surf`, `exfiltration_unsat_zone`, `exfiltration_sat_zone`, `transpiration_sat_zone`, `transpiration_unsat_zone`, `sat_deficit_z`, `rz_storage`, `rootzone_depth`, `family_pct_cover` |
| burn | `burn` |
| carbon | `litter_cs_totalc`, `soil_cs_totalc`, `cs_net_psn`, `epv_height`, `cs_leafc`, `cs_leafc_store`, `cs_live_stemc`, `cs_dead_stemc`, `cs_frootc`, `cs_live_crootc`, `cs_dead_crootc` |
| fire effects | `fe_canopy_target_prop_c_consumed`, `fe_canopy_target_prop_c_remain_adjusted`, `fe_canopy_target_prop_c_remain_adjusted_leafc` |

Index on `(scenarioRunId, warmingIdx, dateIdx)`.

Column names map the source headers' dots to underscores (e.g. `cs.net_psn` ->
`cs_net_psn`).

## firedata

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

## stratumdata

Monthly whole-landscape stratum carbon from `spatial_data_point_stratvar.csv`
(~6.9M rows per member). Kept separate from `cubedata` because it spans every
stratum in the watershed, not just the 5 cubes.

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

## patchdata

Static per-patch-family spatial extents, decoded from `Pch30rip90upRN.tiff`. This
reuses Big Creek's `patchdata` role: the `PatchPointCollection` contract used for
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

## terraindata (deferred)

Defined for parity with Big Creek but not populated in phase 1. Source would be
`dem30mSBFRbound.tiff` plus derived splatmaps. Shape mirrors Big Creek
`terraindata`: common columns, `year`, `month`, `gridSize`, `pixelGrainSize`,
`decimalPrecision`, `data` (serialized frame). Listed so the schema is complete
and future terrain work has a defined home.

## importrun

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

## rastermetadata

Raster provenance for the two `.tiff` inputs.

| Column | Type | Meaning |
| --- | --- | --- |
| common columns (no `warmingIdx`) | | |
| `role` | varchar | `patchFamily` or `dem`. |
| `fileName` | varchar | Raster file name. |
| `gridColumns` | int | e.g. 396. |
| `gridRows` | int | e.g. 301. |
| `pixelScaleMeters` | float | ~30. |
| `nodataValue` | bigint | e.g. 65535. |
| `minValue` | float | Sample min. |
| `maxValue` | float | Sample max. |
| `validIdCount` | int | e.g. 4,477 patch-family ids. |
| `sourceMetadata` | varchar | e.g. GRASS/GDAL provenance. |

## Acceptance Mapping

- **Preserves raw Central Coast structure:** each source file's columns are
  preserved (cube files merged only along their shared key; aggregate, burn,
  stratum carbon, and rasters each retain their native columns).
- **Does not overload Big Creek v1 `cubedata`:** Central Coast uses its own
  database and its own `cubedata`; whole-landscape monthly data lives in separate
  tables (`firedata`, `stratumdata`).
- **Stores multiple future members:** `scenarioRunId` + `warmingIdx` on every data
  table, plus `importrun` provenance, allow many members in one database.

## Follow-ups

- Model classes for these tables: `CCV2-05`.
- EF migrations generated from those models (authoritative DDL): after `CCV2-05`.
- Raster decoder for `patchdata`: later spatial task.
- `terraindata` population: deferred landscape task.
