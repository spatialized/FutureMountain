# Central Coast v2 Importer Config Design

Last updated: 2026-06-13

## Purpose

This document defines the scenario-config design for Central Coast v2 imports,
delivered as task `CCV2-03`. It also records the design decisions agreed while
reviewing how Central Coast v2 source files relate to the existing Big Creek v1
data model.

The config file is `RHESSYs_Data_Importer/RHESSYs_Data_Importer/ScenarioConfig_CentralCoastV2.json`.

## Config Shape

Central Coast v2 reuses the existing `ScenarioConfig` object plus a small set of
optional fields (all unused by Big Creek v1, which leaves them null):

| Field | Type | Purpose |
| --- | --- | --- |
| `scenarioProfile` | string | Must be `CentralCoastV2`. Selects the data model explicitly. |
| `scenarioRunId` | string | Identifies one scenario member/run (e.g. `single-warming-sample`). |
| `warmingIdx` | int | Warming/climate-case index. `0` for the current sample (assumed). |
| `sourceRoot` | string | Base folder the `files` entries resolve against. Keeps the bundle path out of code. |
| `delimiter` | string | Field delimiter for source files (`,` for Central Coast CSVs). |
| `files` | object | Logical file role -> file name, resolved relative to `sourceRoot`. |
| `database` | object | Central Coast database connection (separate DB: `centralcoast_rhessys`). |
| `outputTables` | array | The `centralcoast_*` staging tables (see `CCV2-04`). |

`ScenarioConfig.GetSourceFilePath(role)` joins `sourceRoot` + the file name for a
role and returns a full path, or null if the role is not configured.

### Reusing The Shape For Future Members

A future warming/climate member is configured by changing only:

- `sourceRoot` (new bundle folder),
- `scenarioRunId` (new member id),
- `warmingIdx` (real index once metadata exists).

The `files` role names and file names stay the same, because each member is
expected to repeat the same file set. This satisfies the requirement that the
sample is configured without hardcoding its folder and that future members reuse
the same config shape.

## File Roles

Roles are explicit and named, instead of the six fixed Big Creek discovery
categories, because the Central Coast file set is split by grain (daily/monthly)
and spatial level (aggregate/patch/stratum):

| Role | File | Grain |
| --- | --- | --- |
| `cubeAggregateDaily` | `cube_agg_p.csv` | Daily basin/aggregate |
| `cubePatchDaily01` / `cubePatchDaily02` | `cube_p_patch1.csv` / `cube_p_patch2.csv` | Daily cube patch member |
| `cubeStratumOver01` / `cubeStratumOver02` | `cubes_sc_over_patch1.csv` / `cubes_sc_over_patch2.csv` | Daily overstory stratum |
| `cubeStratumUnder01` / `cubeStratumUnder02` | `cube_sc_under_patch1.csv` / `cube_sc_under_patch2.csv` | Daily understory stratum |
| `basinMonthlyBurn` | `bm.csv` | Monthly basin burn |
| `patchMonthlyBurn` | `spatial_data_point_patchvar.csv` | Monthly all-patch burn |
| `stratumMonthlyCarbon` | `spatial_data_point_stratvar.csv` | Monthly all-stratum carbon |
| `patchFamilyRaster` | `Pch30rip90upRN.tiff` | Patch-family raster |
| `demRaster` | `dem30mSBFRbound.tiff` | DEM raster (deferred) |

## Design Decisions

These decisions explain why the config looks the way it does. They resolve the
question of how Central Coast files relate to Big Creek's six fixed categories
(`cube`, `patch`, `terrain`, `fire`, `water`, `climate`).

### 1. Cube stays one logical table; strata are columns, not separate tables

Big Creek's cube row already flattens overstory and understory fields into one
record. The Central Coast over/understory files are the same data delivered as
separate source files. The importer joins them back into one cube row on
`(day, month, year, patchID)` (overstory `stratumID` ends in `1`, understory in
`2`). A wider cube table is fine and keeps the cube contract stable; Central
Coast's extra stratum fields (`consumedC*`, `mortC*`, `netpsn*`, `lai*`,
`veg_parm_ID`, root depths) are additive optional columns. Splitting into
`cube_over` / `cube_under` tables is explicitly rejected.

### 2. No separate water file; basin streamflow comes from the aggregate cube

The aggregate cube represents the whole watershed, so `streamflow` in
`cube_agg_p.csv` is the basin streamflow that drives the large-landscape river
(the role Big Creek's `waterdata` filled). There is therefore no `water`
category. Per-warming streamflow columns become per-member rows as more members
arrive.

### 3. Burn is imported as monthly source columns; runtime fire is deferred

Burn is present spatially and monthly (`bm.csv`, `spatial_data_point_patchvar.csv`
are non-zero; daily cube `burn` is zero in the sample). It is not Big Creek's
fire-frame/`spread`/`iter` format. Monthly per-patch burn is conceptually the
burned-terrain field and will be interpolated to daily at runtime using the same
mechanism as snow (see decision 7). Import preserves `burn` columns now; the
config is built so it works once fuller data arrives. There is no `fire`
category.

### 4. No terrain category

Big Creek terrain splatmaps were precomputed/derived artifacts and the DEM is a
landscape-generation concern. The DEM raster role is recorded for provenance but
deferred. There is no active `terrain` import for this profile.

### 5. Patch identity: `zoneID` is the spatial cube identity

This is the largest model change. Big Creek used a flat `patchID -> footprint`.
Central Coast uses a patch family:

```text
zoneID -> patchID (01/02 aspatial members) -> stratumID (over/under)
```

Handling:

- `zoneID` takes over Big Creek's old `patchIdx` role for spatial identity (the
  patch-family raster maps `zoneID` to pixels; the five cube locations are
  `zoneID`s).
- `patchID` (`01`/`02`) is preserved as a member dimension in staging, never
  flattened. Only the riparian `zoneID 10071` differs between `01`/`02` (oak vs
  chaparral); the others duplicate, but both rows are kept.
- Cube rows are keyed by `(zoneID, patchID)`. A later adapter can bridge to the
  legacy "one cube per location" shape.

### 6. No climate category

Climate was imported just-in-case in Big Creek and never consumed. The Central
Coast sample has no climate files. No `climate` category.

### 7. Temporal grain is a storage concern only; runtime reuses existing interpolation

Future Mountain stays on a 1-day `timeIdx`. The importer simply loads daily files
into day-keyed tables and monthly files into month-keyed tables. At runtime,
monthly Central Coast data (snow/landscape, burn, stratum carbon) is interpolated
to daily using the **existing** Big Creek monthly-to-daily interpolation
(`BuildTerrainSplatmapForDay` and the terrain-frame interpolation). No new time
model or interpolation mechanism is introduced.

### 8. Patch-family raster decoded into the existing `PatchPointCollection` contract

The `.tiff` patch map is used the same way Big Creek's text patch map was: to
place where each cube "comes from" (opening animation) and to drive large-
landscape terrain color/texture. Only the decoder is new (GeoTIFF vs text grid);
the downstream `PatchPointCollection` contract (data-grid location, fire-grid
location, alphamap location, UTM) is unchanged.

## Selecting The Config

The Central Coast config is selected explicitly:

- Via the wizard's "Load another config" option, entering the path to
  `ScenarioConfig_CentralCoastV2.json`.
- The resolved profile (`CentralCoastV2`) is printed at startup and in the wizard.

Big Creek remains the default config loaded by `Program.cs`, so default behavior
is unchanged. Wiring the Central Coast profile into actual import paths and
staging tables is handled by `CCV2-04` onward.

## Known Follow-ups

- The current `ColumnMapper` splits on whitespace; Central Coast CSVs are
  comma-delimited. The `delimiter` config field is provided for this, and the
  CSV-aware parsing path is implemented with the model classes in `CCV2-05`.
- Detailed source-column to model-field mappings are defined alongside the model
  classes in `CCV2-05`, using the column lists in
  `Docs/CentralCoastV2/DataFormats.md`.
