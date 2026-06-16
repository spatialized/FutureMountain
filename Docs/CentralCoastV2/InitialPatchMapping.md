# Initial Patch Mapping

Last updated: 2026-06-16

## Purpose

This document explains the patch-mapping implementation used by the current
pre-prototype Central Coast v2 scenario. It replaces the earlier planning note
for the now-completed patch-map workflow.

The implementation uses the partial Central Coast dataset at:

```text
RHESSYs_Data_Importer/Data/CentralCoast/RHESSysOutput-SingleWarmIdx-6-4-2026/
```

That sample bundle has one explicit Future Mountain warming index assumption:

- `scenarioRunId = single-warming-sample`
- `warmingIdx = 0`

The mapping described here converts the Central Coast patch-family raster into
`PatchData` rows. Those rows are then used by the terrain generator to project
monthly `StratumData` and `BurnData` values onto the Central Coast landscape
grid.

## Source Raster

Patch mapping starts with:

```text
Pch30rip90upRN.tiff
```

The file is configured through `ScenarioConfig_CentralCoastV2.json`:

```json
"patchFamilyRaster": "Pch30rip90upRN.tiff"
```

Observed properties:

| Property | Value |
| --- | --- |
| Grid size | 396 columns x 301 rows |
| Pixel scale | approximately 30 m |
| Nodata | `65535` |
| Valid patch-family IDs | 4,477 |
| Source metadata | GRASS GIS 7.8.3 / GDAL 3.0.4 |

Each non-nodata pixel stores a `zoneID`. In Central Coast v2, `zoneID` is the
mapped spatial footprint. The child `patchID` values, usually ending in `01` or
`02`, are aspatial members within that footprint.

This is different from Big Creek v1, where patch identifiers were treated more
directly as mapped spatial patches.

## Import Command

From the importer project folder:

```powershell
cd RHESSYs_Data_Importer\RHESSYs_Data_Importer
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --patch
```

Dry run:

```powershell
dotnet run -- --auto --config ScenarioConfig_CentralCoastV2.json --dryrun --patch
```

The `--patch` Central Coast path calls:

```text
CentralCoastImporter.ImportPatchMapData(config, dryrun)
```

That method decodes the raster and writes rows through:

```text
CentralCoastDAL.AddPatchDataRows(...)
```

For non-Central Coast profiles, `--patch` continues to use the legacy Big Creek
patch import path.

## Implementation

`ImportPatchMapData` reads the TIFF with `BitMiracle.LibTiff.Classic`. The raster
is a single-band unsigned 16-bit grid, so the importer reads each scanline,
decodes each two-byte value, skips `65535`, and groups all remaining pixel
coordinates by `zoneID`.

Algorithm:

```text
1. Resolve patchFamilyRaster from ScenarioConfig_CentralCoastV2.json.
2. Open Pch30rip90upRN.tiff.
3. Read raster width and height.
4. For each row:
   For each column:
     Read the 16-bit pixel value.
     If value == 65535, skip it.
     Otherwise append [col, row] to that zoneID's pixel list.
5. For each zoneID:
   Compute pixelCount, centroid, and bounding box.
   Serialize the footprint as JSON.
   Add one PatchDataRow to the insert batch.
6. Batch insert all rows into PatchData.
```

Expected console summary:

```text
[PatchData] Decoded 4,477 unique zoneIDs from 396x301 grid (... total non-nodata pixels).
[PatchData] Imported 4,477 of 4,477 source rows.
```

## PatchData Rows

The Central Coast `PatchData` table stores one row per mapped `zoneID`.

| Column | Meaning |
| --- | --- |
| `scenarioRunId` | Scenario member, currently `single-warming-sample` |
| `importRunId` | Import provenance placeholder, currently `0` |
| `zoneID` | Patch-family id from the raster value |
| `data` | JSON footprint payload |

The footprint JSON has this shape:

```json
{
  "zoneID": 3497,
  "gridWidth": 396,
  "gridHeight": 301,
  "pixelCount": 12,
  "centroidCol": 198.3,
  "centroidRow": 142.7,
  "boundingBox": {
    "colMin": 195,
    "colMax": 202,
    "rowMin": 139,
    "rowMax": 147
  },
  "pixels": [[195, 139], [196, 140]]
}
```

The `pixels` field is the important bridge. It maps a `zoneID` from RHESSys data
back to concrete output grid cells.

## Coordinate System

Pixel coordinates are stored as zero-based `(col, row)` pairs with the origin at
the upper-left corner of the TIFF:

- column increases left-to-right: `0..395`
- row increases top-to-bottom: `0..300`

For generated Central Coast `TerrainData`, a pixel maps to a flat row-major
index:

```text
index = row * 396 + col
```

No DEM is read during patch mapping. The DEM file in the same sample folder is
used separately for static terrain-height workflow experiments.

## Terrain Projection

Patch mapping is static and climate-independent. It does not store vegetation,
carbon, snow, burn, or warming values. Instead, it lets the terrain generator
project monthly RHESSys values onto the same 396 x 301 grid.

For each `(scenarioRunId, warmingIdx, year, month)`:

```text
For each zoneID in PatchData:
  1. Read StratumData rows for that zoneID.
     Aggregate mean total_plantc across patchID and stratumID members.

  2. Read BurnData rows for that zoneID where level = "patch".
     Aggregate max burn across patchID members.

  3. For each [col, row] in PatchData.pixels:
     Write the aggregated values into the output TerrainData frame.
```

The current terrain generator is documented in
`Docs/CentralCoastV2/InitialTerrainData.md`. It writes one monthly `TerrainData`
row per `(scenarioRunId, warmingIdx, year, month)`. The flat `_dataList` array
uses the same row-major grid indexing described above.

## Validation

The current implementation reports the decoded zone count and saved row count.
For this sample bundle, both should be `4,477`.

Useful validation checks:

- Decoded unique `zoneID` count equals `4,477`.
- `PatchData` row count for `single-warming-sample` equals `4,477`.
- Total stored pixel count across all rows equals the TIFF non-nodata pixel
  count.
- No row is written for nodata value `65535`.
- All `zoneID` values used by `StratumData` exist in `PatchData`.
- All patch-level `BurnData.zoneID` values exist in `PatchData`.

If a `zoneID` appears in `StratumData` or patch-level `BurnData` but not in
`PatchData`, that value cannot be spatially projected into `TerrainData`.

## Current Constraints

- This mapping documents the initial partial dataset only. It should be
  revalidated if a later Central Coast bundle changes the raster, grid size,
  scenario member, or warming-case metadata.
- The raster grid is rectangular (`396 x 301`). Central Coast `TerrainData`
  uses explicit `gridWidth` and `gridHeight`; it should not be forced into a
  square Big Creek-style `gridSize`.
- `importRunId` is still a placeholder value (`0`) until structured import-run
  tracking is wired.
- `PatchData` stores raster pixel coordinates, not UTM coordinates. UTM/world
  coordinate conversion can be derived later from raster georeferencing if
  needed.
