# Central Coast v2 Data Formats

Last updated: 2026-06-13

## Overview

Central Coast v2 is a newer RHESSys-derived data model than the current Big Creek v1 data used by Future Mountain.

The current sample bundle is located at:

```text
RHESSYs_Data_Importer/Data/CentralCoast/RHESSysOutput-SingleWarmIdx-6-4-2026/
```

This bundle appears to represent one scenario member only. The files do not contain a warming index, warming label, climate-case label, or filename token such as `hist`, `warm1`, `warm2`, `warm4`, or `warm6`.

For initial ingestion, treat this sample as:

```text
scenarioProfile = CentralCoastV2
scenarioRun = single-warming-sample
warmingIdx = 0
```

This is an import assumption, not a confirmed scientific label. Future complete output is expected to include multiple warming or climate scenario members.

## Date Coverage

Daily files cover:

```text
1987-07-01 through 2019-06-30
```

That is 11,688 daily records per single-row daily series.

Monthly files cover:

```text
1987-07 through 2019-06
```

That is 384 monthly records per single-row monthly series.

The date range reflects the WRF climate data window described by the data provider.

## File Inventory

| File | Rows | Grain | Notes |
| --- | ---: | --- | --- |
| `cube_agg_p.csv` | 11,688 | Daily basin/aggregate | One row per day |
| `cube_p_patch1.csv` | 58,440 | Daily cube patch 01 | Five cube/zone rows per day |
| `cube_p_patch2.csv` | 58,440 | Daily cube patch 02 | Five cube/zone rows per day |
| `cubes_sc_over_patch1.csv` | 58,440 | Daily overstory stratum, patch 01 | Five cube/zone rows per day |
| `cubes_sc_over_patch2.csv` | 58,440 | Daily overstory stratum, patch 02 | Five cube/zone rows per day |
| `cube_sc_under_patch1.csv` | 58,440 | Daily understory stratum, patch 01 | Five cube/zone rows per day |
| `cube_sc_under_patch2.csv` | 58,440 | Daily understory stratum, patch 02 | Five cube/zone rows per day |
| `bm.csv` | 384 | Monthly basin burn | One row per month |
| `spatial_data_point_patchvar.csv` | 3,438,336 | Monthly all-patch burn | 8,954 patch rows per month |
| `spatial_data_point_stratvar.csv` | 6,876,672 | Monthly all-stratum carbon | 17,908 stratum rows per month |
| `Pch30rip90upRN.tiff` | n/a | Raster | Patch-family map, used to derive spatial patch extents |
| `dem30mSBFRbound.tiff` | n/a | Raster | DEM/height raster for shaping the Unity Central Coast terrain |

## Spatial Identity Model

Central Coast v2 uses a multi-scale routing structure.

Key identifiers:

| Field | Meaning |
| --- | --- |
| `basinID` | Basin identifier. Current sample uses basin `1`. |
| `hillID` | Hillslope identifier. |
| `zoneID` | Patch family identifier. For the five cube files, this is the cube identifier. |
| `patchID` | Aspatial patch identifier. Encoded as `zoneID` plus `01` or `02`. |
| `stratumID` | Canopy stratum identifier. Encoded as `patchID` plus `1` or `2`. |
| `veg_parm_ID` | Vegetation parameter identifier. Current sample uses `11`, `6`, and `2`. |

Patch family examples:

```text
zoneID 10071 -> patchID 1007101 and 1007102
patchID 1007101 -> stratumID 10071011 and 10071012
patchID 1007102 -> stratumID 10071021 and 10071022
```

The patch map raster stores `zoneID` / patch-family IDs. It does not separately map `01` and `02` aspatial patch members.

## DEM / Unity Heightmap Notes

`dem30mSBFRbound.tiff` is the Central Coast DEM used to shape the Unity terrain.
It aligns with `Pch30rip90upRN.tiff`:

| Property | Value |
| --- | --- |
| Grid size | 396 columns x 301 rows |
| Pixel scale | ~30 m |
| Bands | 1 |
| TIFF sample type | unsigned 16-bit |
| Compression | none |
| Source value range observed | 0..255 |
| Nodata value observed | none; `65535` count was 0 |

Because the DEM and patch-family raster share the same 396 x 301 grid, no GIS
reprojection, cropping, or alignment step is needed for the Central Coast
pre-prototype. Unity terrain heightmaps are square, so the DEM must be resampled
and scaled before import.

Generated prototype heightmap:

```text
Assets/Terrains/CentralCoastV2/Heightmaps/CentralCoast_DEM_513_uint16_little_endian.raw
```

Generation notes:

- Source: `RHESSYs_Data_Importer/Data/CentralCoast/RHESSysOutput-SingleWarmIdx-6-4-2026/dem30mSBFRbound.tiff`
- Output grid: 513 x 513
- Format: headerless RAW, unsigned 16-bit, little-endian / Windows byte order
- Resampling: bilinear
- Scaling: source min..max scaled to 0..65535

Unity `Import Raw...` settings:

| Setting | Value |
| --- | --- |
| Depth | Bit16 |
| Width | 513 |
| Height | 513 |
| Byte order | Windows / Little Endian |
| Terrain Size X | 11880 |
| Terrain Size Z | 9030 |
| Terrain Size Y | Start with 1000 or 1500 and tune visually |

The source DEM values appear normalized rather than true elevation meters, so
`Terrain Size Y` is a visual scale choice for the prototype. If the terrain
appears north/south reversed relative to the patch raster or map, regenerate or
import a vertically flipped heightmap.

## Cube Locations

The current sample includes five cube/zone IDs.

| zoneID | Label | hillID |
| ---: | --- | ---: |
| 12166 | North facing | 320 |
| 12771 | South facing | 330 |
| 6492 | High elevation | 332 |
| 18891 | Low elevation | 336 |
| 10071 | Riparian | 334 |

Only the riparian cube (`zoneID = 10071`) differs materially between patch 01 and patch 02 in the current daily cube and stratum files. The other four cube locations have identical patch 01 and patch 02 values in the sample.

## Daily Aggregate File

File:

```text
cube_agg_p.csv
```

Rows:

```text
11,688
```

Columns:

| Column | Notes |
| --- | --- |
| `day` | Calendar day |
| `month` | Calendar month |
| `year` | Calendar year |
| `basinID` | Basin identifier |
| `litter_cs.totalc` | Litter carbon total |
| `burn` | Daily aggregate burn output. Current sample is all zero. |
| `soil_cs.totalc` | Soil carbon total |
| `sat_deficit_z` | Saturation deficit depth |
| `evaporation_surf` | Surface evaporation |
| `exfiltration_unsat_zone` | Unsaturated-zone exfiltration |
| `exfiltration_sat_zone` | Saturated-zone exfiltration |
| `evaporation` | Evaporation |
| `family_pct_cover` | Family percent cover |
| `streamflow` | Basin streamflow |
| `rz_storage` | Root-zone storage |
| `rain` | Rain |
| `transpiration_sat_zone` | Saturated-zone transpiration |
| `transpiration_unsat_zone` | Unsaturated-zone transpiration |
| `cs.net_psn` | Canopy stratum net photosynthesis |
| `epv.height` | Effective plant height |
| `cs.leafc` | Leaf carbon |
| `cs.leafc_store` | Leaf carbon store |
| `cs.live_stemc` | Live stem carbon |
| `cs.dead_stemc` | Dead stem carbon |
| `cs.frootc` | Fine root carbon |
| `cs.live_crootc` | Live coarse root carbon |
| `cs.dead_crootc` | Dead coarse root carbon |
| `fe.canopy_target_prop_c_consumed` | Fire effects canopy carbon consumed |
| `fe.canopy_target_prop_c_remain_adjusted` | Fire effects adjusted remaining canopy carbon |
| `fe.canopy_target_prop_c_remain_adjusted_leafc` | Fire effects adjusted remaining leaf carbon |
| `rootzone.depth` | Root-zone depth |

## Daily Cube Patch Files

Files:

```text
cube_p_patch1.csv
cube_p_patch2.csv
```

Rows per file:

```text
58,440
```

Each file has five rows per day, one for each cube/zone ID.

Columns:

| Column | Notes |
| --- | --- |
| `day` | Calendar day |
| `month` | Calendar month |
| `year` | Calendar year |
| `basinID` | Basin identifier |
| `hillID` | Hillslope identifier |
| `zoneID` | Patch family / cube identifier |
| `patchID` | Aspatial patch member ID ending in `01` or `02` |
| `coverfract` | Cover fraction |
| `litterc` | Litter carbon |
| `burn` | Daily patch burn. Current sample is all zero in cube patch files. |
| `soilc` | Soil carbon |
| `depthToGW` | Depth to groundwater |
| `canopyevap` | Canopy evaporation |
| `streamflow` | Streamflow |
| `rootdepth` | Root depth |
| `groundevap` | Ground evaporation |
| `vegAccessWater` | Vegetation-accessible water |
| `Qin` | Input flow |
| `Qout` | Output flow |
| `rain` | Rain |

## Daily Overstory Stratum Files

Files:

```text
cubes_sc_over_patch1.csv
cubes_sc_over_patch2.csv
```

Rows per file:

```text
58,440
```

Each file has five rows per day, one for each cube/zone ID.

Columns:

| Column | Notes |
| --- | --- |
| `day` | Calendar day |
| `month` | Calendar month |
| `year` | Calendar year |
| `basinID` | Basin identifier |
| `hillID` | Hillslope identifier |
| `zoneID` | Patch family / cube identifier |
| `patchID` | Aspatial patch member ID |
| `stratumID` | Overstory stratum ID ending in `1` |
| `consumedCOver` | Consumed overstory carbon |
| `mortCOver` | Overstory mortality carbon |
| `netpsnOver` | Overstory net photosynthesis |
| `heightOver` | Overstory height |
| `transOver` | Overstory transpiration |
| `leafCOver` | Overstory leaf carbon |
| `stemCOver` | Overstory stem carbon |
| `rootCOver` | Overstory root carbon |
| `rootdepthCOver` | Overstory root depth |
| `veg_parm_ID` | Vegetation parameter ID |
| `laiOver` | Overstory leaf area index |

In the current sample, overstory `veg_parm_ID = 6` appears for riparian patch 01, while overstory `veg_parm_ID = 11` appears for other overstory rows.

## Daily Understory Stratum Files

Files:

```text
cube_sc_under_patch1.csv
cube_sc_under_patch2.csv
```

Rows per file:

```text
58,440
```

Each file has five rows per day, one for each cube/zone ID.

Columns:

| Column | Notes |
| --- | --- |
| `day` | Calendar day |
| `month` | Calendar month |
| `year` | Calendar year |
| `basinID` | Basin identifier |
| `hillID` | Hillslope identifier |
| `zoneID` | Patch family / cube identifier |
| `patchID` | Aspatial patch member ID |
| `stratumID` | Understory stratum ID ending in `2` |
| `consumedCUnder` | Consumed understory carbon |
| `mortCUnder` | Understory mortality carbon |
| `transUnder` | Understory transpiration |
| `netpsnUnder` | Understory net photosynthesis |
| `heightUnder` | Understory height |
| `leafCUnder` | Understory leaf carbon |
| `stemCUnder` | Understory stem carbon |
| `rootCUnder` | Understory root carbon |
| `rootdepthUnder` | Understory root depth |
| `veg_parm_ID` | Vegetation parameter ID |
| `laiUnder` | Understory leaf area index |

In the current sample, understory rows use `veg_parm_ID = 2`.

## Monthly Basin Burn File

File:

```text
bm.csv
```

Rows:

```text
384
```

Columns:

| Column | Notes |
| --- | --- |
| `month` | Calendar month |
| `year` | Calendar year |
| `basinID` | Basin identifier |
| `burn` | Monthly basin burn value |

Current sample burn range:

```text
0.000000 through 5.654753
```

## Monthly Patch Burn File

File:

```text
spatial_data_point_patchvar.csv
```

Rows:

```text
3,438,336
```

This equals:

```text
384 months * 8,954 patch IDs
```

Columns:

| Column | Notes |
| --- | --- |
| `month` | Calendar month |
| `year` | Calendar year |
| `basinID` | Basin identifier |
| `hillID` | Hillslope identifier |
| `zoneID` | Patch family ID |
| `patchID` | Aspatial patch member ID |
| `burn` | Monthly patch burn value |

Current sample includes:

- 4,477 `zoneID` values.
- 8,954 `patchID` values.
- Burn range `0.000000` through `29.174637`.

## Monthly Stratum Carbon File

File:

```text
spatial_data_point_stratvar.csv
```

Rows:

```text
6,876,672
```

This equals:

```text
384 months * 17,908 stratum IDs
```

Columns:

| Column | Notes |
| --- | --- |
| `month` | Calendar month |
| `year` | Calendar year |
| `basinID` | Basin identifier |
| `hillID` | Hillslope identifier |
| `zoneID` | Patch family ID |
| `patchID` | Aspatial patch member ID |
| `stratumID` | Canopy stratum ID |
| `totalc` | Total carbon |
| `total_plantc` | Total plant carbon |

Current sample includes:

- 4,477 `zoneID` values.
- 8,954 `patchID` values.
- 17,908 `stratumID` values.

### Stratum Carbon Shape

This file is a rectangular CSV, but it is in **long table** form rather than map
or raster form. Each line is one monthly observation for one vegetation layer:

```text
month,year,basinID,hillID,zoneID,patchID,stratumID,totalc,total_plantc
7,1987,1,324,3497,349701,3497011,256.597308,247.802126
7,1987,1,324,3497,3497012,0.188243,0.188243
```

Plain-English grain:

```text
for this month
for this zoneID / patch-family
for this patchID / aspatial patch member
for this stratumID / vegetation layer
the carbon values are totalc and total_plantc
```

The shape is:

```text
4,477 zoneIDs
* 2 patchIDs per zoneID
= 8,954 patchIDs

8,954 patchIDs
* 2 strata per patchID
= 17,908 stratumIDs

17,908 stratumIDs
* 384 months
= 6,876,672 rows
```

The spatial footprint is indirect. `zoneID` links these monthly values back to
the patch-family raster (`Pch30rip90upRN.tiff`), whose pixels store the same
`zoneID` values. The CSV itself is not shaped like `x,y,value` and is not a
Unity terrain/splatmap frame.

## Patch Map Raster Source

```text
Pch30rip90upRN.tiff
```

The patch map is the spatial bridge between RHESSys `zoneID` values and Future
Mountain landscape footprints. It is required for Central Coast `PatchData` and
for later precomputed `TerrainData` generation.

Raster properties:

| Property | Value |
| --- | --- |
| Grid size | 396 columns x 301 rows |
| Pixel scale | Approximately 30 m |
| Nodata | `65535` |
| Source metadata | GRASS GIS 7.8.3 with GDAL 3.0.4 |

- Stores patch-family IDs matching `zoneID`.
- Contains 4,477 valid patch-family IDs.
- Aligns with the monthly patch and stratum CSVs.
- Should be used to derive patch spatial extents for Central Coast v2.

## Initial Import Assumptions

For the initial Central Coast v2 importer path:

- Preserve Big Creek v1 tables and behavior.
- Use a separate Central Coast v2 database or schema.
- Add explicit scenario profile metadata.
- Assign this sample `warmingIdx = 0` until true warming/climate-case metadata is provided.
- Preserve source identifiers: `zoneID`, `patchID`, and `stratumID`.
- Do not flatten patch 01 and patch 02 into one record.
- Treat `zoneID` as the mapped spatial footprint and `patchID` as an aspatial member within that footprint.
- Load raw/staging tables first before designing API or Unity visualization transformations.

## Open Questions

- What scientific label should this sample have: baseline, historical, control, or another climate case?
- What filename or config convention will identify future warming/climate scenario members?
- Will future bundles repeat this exact file set per warming case?
- Are units stable across all files and future scenario members?
- Which burn fields should drive user-visible fire behavior versus provenance/statistics?
- Should monthly patch/stratum landscape data be imported fully for the first phase, or staged separately because of its size?
