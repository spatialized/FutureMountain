# Central Coast v2 vs Big Creek v1 Data Differences

Last updated: 2026-06-13

## Purpose

This document distinguishes the Central Coast v2 source data from the current Big Creek v1 data contract.

The goal is to preserve Big Creek v1 while adding Central Coast v2 beside it as an explicit scenario profile.

## Summary

Big Creek v1 and Central Coast v2 should be treated as two known scenario/data-model profiles:

```text
BigCreekV1
CentralCoastV2
```

Do not mutate Big Creek v1 tables, importer assumptions, Unity assets, or API behavior to fit Central Coast v2.

Central Coast v2 should get its own importer path and database/schema path. Compatibility should happen through explicit profile selection and later API/runtime adapters.

## Major Differences

| Area | Big Creek v1 | Central Coast v2 |
| --- | --- | --- |
| Scenario members | Five warming levels are part of the current runtime assumption. | Current sample has no warming identifier and appears to be one scenario member. |
| Date range | Current Big Creek runtime uses its existing historical/model date range. | Current sample covers 1987-07-01 through 2019-06-30. |
| Cube file layout | Existing importer expects aggregate and per-cube text files using Big Creek naming conventions. | Current cube files contain all five cube/zone IDs in each CSV. |
| Cube identity | Big Creek cube identity is mostly `patchIdx`. | Central Coast cube identity is `zoneID`, with `patchID` members beneath it. |
| Patch model | Big Creek treats mapped patch IDs as direct spatial patches. | Central Coast uses patch families: `zoneID` maps spatially, while `patchID` is `zoneID` plus `01` or `02`. |
| Strata | Big Creek runtime fields flatten overstory and understory values into one cube data row. | Central Coast provides separate overstory and understory stratum files. |
| Burn data | Big Creek has fire/burn data integrated into existing fire/terrain flows by warming index. | Current Central Coast burn data is monthly at basin and patch levels; daily cube burn is zero in the sample. |
| Spatial map | Big Creek patch extents are consumed as derived patch data / text-derived collections. | Central Coast provides a GeoTIFF patch-family raster that must be converted into equivalent patch collections. |
| Landscape scale | Big Creek current runtime uses existing terrain/assets and precomputed terrain data paths. | Central Coast includes DEM and patch map rasters; DEM use is a later landscape task, not the first import step. |
| Import style | Big Creek importer includes legacy positional parsing and Big Creek file conventions. | Central Coast should use named CSV columns and profile-specific parsing. |

## Warming Scenario Difference

Big Creek v1 has a hard-coded mental model of five warming levels:

| Index | Big Creek label |
| ---: | --- |
| 0 | 0 C / baseline |
| 1 | +1 C |
| 2 | +2 C |
| 3 | +4 C |
| 4 | +6 C |

The current Central Coast v2 sample has no warming or climate-case field.

For initial import only, assign:

```text
warmingIdx = 0
```

This preserves compatibility with Future Mountain's comparison-oriented architecture while making the assumption explicit.

Future Central Coast data should identify scenario members through config or filename metadata, not through inference from table shape.

## Patch Identity Difference

Big Creek v1:

```text
patchID -> mapped patch footprint
```

Central Coast v2:

```text
zoneID -> mapped patch-family footprint
patchID -> aspatial member inside patch family
stratumID -> canopy stratum inside patch member
```

Example:

```text
zoneID 10071
  patchID 1007101
    stratumID 10071011 overstory
    stratumID 10071012 understory
  patchID 1007102
    stratumID 10071021 overstory
    stratumID 10071022 understory
```

The Central Coast patch map stores `zoneID` values. It does not distinguish patch `01` and patch `02` spatially.

For compatibility with existing patch-location runtime code, Central Coast can either:

- Store patch extents by `zoneID` and teach Central Coast-specific consumers to use patch families.
- Duplicate the same spatial footprint to patch `01` and patch `02` when an old-style `patchID -> footprint` lookup is needed.

The first option is cleaner long-term. The second option may be useful as a compatibility bridge.

## Riparian Difference

In the current Central Coast sample, only `zoneID = 10071` differs materially between patch 01 and patch 02.

The data-provider description says:

- Patch 01 is oak for the riparian cube and chaparral elsewhere.
- Patch 02 is chaparral.
- Both have grass understory.

The sample confirms that patch 01 and patch 02 values are identical for the other four cube locations, but differ for the riparian cube.

This means the importer must preserve patch 01 and patch 02 rows even though most locations currently duplicate values.

## Stratum Difference

Big Creek v1 cube rows already contain fields like:

- `heightOver`
- `transOver`
- `leafCOver`
- `stemCOver`
- `rootCOver`
- `heightUnder`
- `transUnder`
- `leafCUnder`
- `stemCUnder`
- `rootCUnder`

Central Coast v2 provides these as separate stratum files:

- `cubes_sc_over_patch*.csv`
- `cube_sc_under_patch*.csv`

The importer can later derive Big Creek-like cube payloads from Central Coast records if needed, but the raw import should preserve the separated stratum structure.

## Burn Difference

The current Central Coast daily cube files include a `burn` column, but the sample values are zero.

Burn is provided at monthly grain through:

- `bm.csv` for basin-level burn.
- `spatial_data_point_patchvar.csv` for patch-level burn.

That differs from Big Creek runtime expectations around fire frames and warming-indexed fire data.

Initial import should preserve monthly burn as source data. API/runtime fire behavior should be designed later.

## Spatial Data Difference

Big Creek runtime consumes patch extents as `PatchPointCollection` records containing:

- data grid location
- fire-grid location
- terrain alphamap location
- UTM location

Central Coast provides the source raster needed to generate equivalent collections:

```text
Pch30rip90upRN.tiff
```

The reusable part is the downstream `PatchPointCollection` contract. The decoder should be new because the input is GeoTIFF, not the old Big Creek text grid format.

## Import Strategy Difference

Big Creek v1 should remain on its existing importer and database path.

Central Coast v2 should add:

- explicit scenario profile config
- separate connection/database settings
- new CSV readers
- raw/staging tables that preserve Central Coast identifiers
- optional derived compatibility tables or API projections later

Recommended first-phase Central Coast tables:

- `centralcoast_dates`
- `centralcoast_cube_aggregate_daily`
- `centralcoast_cube_patch_daily`
- `centralcoast_cube_stratum_daily`
- `centralcoast_basin_monthly_burn`
- `centralcoast_patch_monthly_burn`
- `centralcoast_stratum_monthly_carbon`
- `centralcoast_patch_family_spatial`
- `centralcoast_raster_metadata`

Names can change, but the separation of daily patch, daily stratum, monthly burn, and monthly full-landscape carbon should remain.

## Compatibility Rule

The guiding rule:

```text
Big Creek v1 remains a preserved legacy scenario.
Central Coast v2 becomes the first explicit new scenario profile.
Shared abstractions should emerge only where the two scenarios truly overlap.
```

That keeps the first phase focused on importing Central Coast v2 data safely without breaking current Future Mountain behavior.
