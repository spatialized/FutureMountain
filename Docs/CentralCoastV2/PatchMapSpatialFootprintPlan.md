# CCV2-15 Patch Map Spatial Footprint Plan

Last updated: 2026-06-13

## Purpose

This document is the planning deliverable for CCV2-15. It defines:

1. What the patch-family raster (`Pch30rip90upRN.tiff`) is and how its pixels
   become `PatchData` rows.
2. What `PatchData` must store per `zoneID` footprint.
3. How `PatchData` footprints enable downstream projection of `StratumData` and
   `FireData` values into precomputed `TerrainData`.

No precomputed `TerrainData` generation is implemented here. That is CCV2-16.
No DEM (`dem30mSBFRbound.tiff`) work is included in this task.

---

## Source: `Pch30rip90upRN.tiff`

| Property | Value |
| --- | --- |
| Grid size | 396 columns x 301 rows (rectangular) |
| Pixel scale | ~30 m |
| Nodata | `65535` |
| Valid patch-family IDs | 4,477 |
| Source metadata | GRASS GIS 7.8.3 / GDAL 3.0.4 |

Each non-nodata pixel stores a `zoneID` value that matches the `zoneID` column
in `StratumData` and `FireData`. The raster defines the spatial footprint
(which landscape pixels) for each patch family.

---

## What the Raster Decoder Must Produce

### Input

`Pch30rip90upRN.tiff` loaded as a 2D integer grid (396 x 301).

### Output: one `PatchData` row per unique `zoneID`

For each of the 4,477 unique `zoneID` values in the raster:

| Field | Type | How produced |
| --- | --- | --- |
| `zoneID` | int | Pixel value (non-nodata) |
| `pixelCount` | int | Number of raster pixels with this `zoneID` |
| `pixels` | JSON array of `[col, row]` pairs | All pixel coordinates (zero-based, upper-left origin) |
| `boundingBoxColMin` | int | Min column index |
| `boundingBoxColMax` | int | Max column index |
| `boundingBoxRowMin` | int | Min row index |
| `boundingBoxRowMax` | int | Max row index |
| `centroidCol` | float | Mean column of member pixels |
| `centroidRow` | float | Mean row of member pixels |
| `gridWidth` | int | Source raster width (396) |
| `gridHeight` | int | Source raster height (301) |

All fields are serialized as JSON in the `data` column of `PatchDataRow`.

### Coordinate system

Pixel coordinates are stored as **zero-based (col, row)** with the origin at
the **upper-left corner** of the TIFF, matching standard raster row-major
order. Column increases left-to-right (0..395); row increases top-to-bottom
(0..300).

CCV2-16 is responsible for converting these raster coordinates to Unity terrain
coordinates, alphamap UV, or data-grid positions. That mapping is not defined
here.

### JSON shape for `data` column

```json
{
  "zoneID": 3497,
  "gridWidth": 396,
  "gridHeight": 301,
  "pixelCount": 12,
  "centroidCol": 198.3,
  "centroidRow": 142.7,
  "boundingBox": { "colMin": 195, "colMax": 202, "rowMin": 139, "rowMax": 147 },
  "pixels": [[195,139],[196,140]]
}
```

The `pixels` array is the primary input for the TerrainData generator (CCV2-16).
It is the only field that maps a `zoneID` to output grid cells.

---

## Decoder Implementation Requirements

### Library

**BitMiracle.LibTiff.Classic** (NuGet, no native dependency, reads TIFF pixel
data as a flat int array). Acceptable alternative: any .NET library that reads
the raw 16-bit pixel values of a single-band TIFF without coordinate
transformation.

### Algorithm

```
1. Open Pch30rip90upRN.tiff.
2. Read raster width (396) and height (301).
3. For each row r in 0..300:
   For each col c in 0..395:
     Read pixel value v.
     If v == 65535: skip (nodata).
     Else: append [c, r] to pixel list for zoneID = v.
4. For each collected zoneID:
   - Compute pixelCount, centroidCol/Row, bounding box.
   - Serialize to JSON (schema above).
   - Write one PatchDataRow (zoneID, data, scenarioRunId, importRunId).
```

Expected output: **4,477 rows** in `PatchData`.

### Dry run

Before writing rows, print a summary:

```
[PatchData] Decoded N unique zoneIDs from 396x301 grid (M total non-nodata pixels).
```

where N should equal 4,477 and M should equal the total non-nodata pixel count.

### Wiring

- `patchFamilyRaster` file role is already present in
  `ScenarioConfig_CentralCoastV2.json`.
- Add `ImportPatchMapData(ScenarioConfig config, bool dryrun)` to
  `CentralCoastImporter`.
- Add `AddPatchDataRow(PatchDataRow row)` to `CentralCoastDAL`.
- Wire into auto mode under `--patch` flag (CCV2 branch; existing `--patch` maps
  to legacy for non-CCV2 profiles).
- Wire into wizard category `[2] Patch` for CCV2 profile.

---

## How PatchData Enables TerrainData Projection

This section states the contract CCV2-16 must consume.

```
For a given (scenarioRunId, warmingIdx, year, month):

  For each zoneID in PatchData:
    1. Look up StratumData rows matching
       (scenarioRunId, warmingIdx, year, month, zoneID).
       Aggregate: mean total_plantc across all patchID and stratumID members
       within that zoneID (avoids double-counting 2 patches x 2 strata).

    2. Look up FireData rows matching
       (scenarioRunId, warmingIdx, year, month, zoneID, level="patch").
       Aggregate: max burn value across patchID members within zoneID
       (burn is a signal, not an additive quantity).

    3. For each [col, row] in PatchData.pixels for this zoneID:
       Write (col, row, meanPlantC, maxBurn) to the output frame.

  Output: one TerrainData frame per (scenarioRunId, warmingIdx, year, month),
  covering the full 396 x 301 grid (or stored as a sparse pixel list).
```

`PatchData.pixels` is the spatial bridge. Without it, `zoneID` values in
`StratumData` and `FireData` cannot be mapped to output grid coordinates.

---

## What PatchData Must Store (Summary)

| Must store | Reason |
| --- | --- |
| `zoneID` | Links to StratumData and FireData |
| `pixels` | Required by TerrainData generator to write output cells |
| `pixelCount` | Area metric; validation check |
| `centroidCol`, `centroidRow` | Point-based fallback and label placement |
| `boundingBox` | Efficient region queries |
| `gridWidth`, `gridHeight` | Source grid dimensions; CCV2-16 needs these |

Fields NOT stored in `PatchData`:

| Not stored | Reason |
| --- | --- |
| `warmingIdx` | Spatial footprints are climate-independent |
| `totalc`, `burn` | Live in StratumData / FireData |
| UTM coordinates | Can be derived later from pixel (col, row) + raster affine transform |

---

## Decisions for CCV2-16

The following defaults are set here so CCV2-16 can implement them directly:

| Question | Decision |
| --- | --- |
| StratumData aggregation | Mean `total_plantc` per zoneID / month across all patchID and stratumID members |
| FireData aggregation | Max `burn` per zoneID / month across patchID members (level="patch") |
| Temporal grain | Monthly (do not precompute daily landscape frames in this phase) |
| Table/concept name | `TerrainData` (keep existing Big Creek name) |
| Grid shape issue | Raster is 396 x 301 (rectangular). CCV2-16 must decide: extend the TerrainData payload to support `gridWidth`/`gridHeight`, or resample/project into a square Unity terrain grid. This is the first issue CCV2-16 must resolve. |
| Unity coordinate mapping | Deferred to CCV2-16. Raster (col, row) must be converted to alphamap UV and/or data-grid position. |

---

## Validation Acceptance

When the decoder runs (including dry run), it must verify and report:

- [ ] Decoded unique `zoneID` count equals **4,477**.
- [ ] `PatchData` row count after import equals **4,477**.
- [ ] Total stored pixel count across all rows equals total non-nodata pixels
      in the TIFF (all pixels where value != 65535).
- [ ] Nodata value `65535` is skipped; no `PatchData` row is written for it.
- [ ] All `zoneID` values in `StratumData` are present in the patch-map
      `zoneID` set; missing IDs are reported by count and sample.
- [ ] All `zoneID` values in `FireData` (level="patch") are present in the
      patch-map `zoneID` set; missing IDs are reported by count and sample.
- [ ] Extra `zoneID` values in `StratumData` or `FireData` that have no
      patch-map footprint are reported (they cannot be spatially projected).
- [ ] No DEM file is read or referenced.

---

## Acceptance

- [x] Source is `Pch30rip90upRN.tiff` only. No DEM.
- [x] `PatchData` shape confirmed: one row per `zoneID`, `data` JSON with
      `pixels`, `pixelCount`, `centroid`, `boundingBox`, `gridWidth`,
      `gridHeight`.
- [x] Single JSON field name `pixels` used consistently (no `pixelIndices`).
- [x] Coordinate system documented: zero-based (col, row), upper-left origin.
- [x] Decoder algorithm defined (BitMiracle or equivalent).
- [x] Wiring path specified: `ImportPatchMapData` -> `AddPatchDataRow` ->
      `PatchData` table.
- [x] CCV2-16 contract stated: `PatchData.pixels` maps `zoneID` to output cells.
- [x] CCV2-16 aggregation defaults set (mean `total_plantc`, max `burn`,
      monthly grain, rectangular grid issue flagged).
- [x] Validation acceptance criteria defined.
- [x] No precomputed `TerrainData` generation implemented here.
