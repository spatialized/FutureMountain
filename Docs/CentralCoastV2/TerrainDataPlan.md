# CCV2-18 Precomputed Central Coast TerrainData Plan

Last updated: 2026-06-13

## Purpose

This document is the planning deliverable for CCV2-18. It resolves the open
questions from CCV2-15 and defines the complete design for generating precomputed
`TerrainData` frames for Central Coast v2.

Inputs available after CCV2-16:

- `PatchData` -- one row per `zoneID`, `data` JSON with `pixels`, `pixelCount`,
  `centroid`, `boundingBox`, `gridWidth` (396), `gridHeight` (301)
- `StratumData` -- monthly per-stratum carbon rows (~6.9M rows)
- `BurnData` (level="patch") -- monthly per-patch burn rows
- `Dates`, `scenarioRunId`, `warmingIdx`

No implementation is done in this task. That is CCV2-19.

---

## Decision 1: Rectangular Grid Shape

The patch map raster is **396 x 301**, which is rectangular, not square.
The DEM raster (`dem30mSBFRbound.tiff`) uses the same 396 x 301 grid, so the
static Unity terrain heightmap and the dynamic Central Coast terrain/splatmap
frames start from aligned source rasters.

Big Creek's `TerrainData` uses a single `gridSize` field that implies a square
grid. The Big Creek Unity runtime reads `gridSize` and treats `_dataList` as a
`gridSize x gridSize` flat array.

**Decision: extend the payload with explicit `gridWidth` and `gridHeight` fields
alongside `gridSize` for backward compatibility.**

Rules:

- Central Coast `TerrainData` rows set `gridWidth = 396`, `gridHeight = 301`,
  and `gridSize = 0` (or omit it) to signal a non-square frame.
- Big Creek `TerrainData` rows are untouched and continue to use `gridSize`.
- The Unity runtime must be updated in CCV2-20 to check: if `gridWidth > 0` and
  `gridHeight > 0`, use those; otherwise fall back to `gridSize x gridSize`.
- The API endpoint `terraindata/{warmingIdx}` can be reused if it includes
  `gridWidth`/`gridHeight` in the response; or a profile-aware endpoint
  `terraindata/centralcoast/{warmingIdx}` can be added. That decision is deferred
  to CCV2-20.

Do NOT resample Central Coast data into a square grid. That would silently
distort the spatial footprints.

Note: this decision applies to API/database `TerrainData` frames, not to the
Unity terrain heightmap asset itself. Unity's imported terrain heightmap is
square, so the DEM can be resampled to a Unity-friendly square RAW while the
runtime data grid remains rectangular.

---

## Decision 1A: Unity DEM Heightmap Import

For the Central Coast pre-prototype, use `dem30mSBFRbound.tiff` to shape the
duplicated Unity terrain. This is a static scene asset workflow and is separate
from the monthly `TerrainData` frames generated from `PatchData`, `StratumData`,
and `BurnData`.

Observed DEM properties:

| Property | Value |
| --- | --- |
| Source file | `RHESSYs_Data_Importer/Data/CentralCoast/RHESSysOutput-SingleWarmIdx-6-4-2026/dem30mSBFRbound.tiff` |
| Grid size | 396 x 301 |
| Pixel scale | ~30 m |
| Sample type | unsigned 16-bit, single band |
| Compression | none |
| Observed value range | 0..255 |
| Nodata pixels observed | 0 using `65535` as nodata |

The DEM aligns with the patch-family raster (`Pch30rip90upRN.tiff`), so no
reprojection, cropping, or raster alignment is needed before making the Unity
heightmap.

Prototype generated RAW:

```text
Assets/Terrains/CentralCoastV2/Heightmaps/CentralCoast_DEM_513_uint16_little_endian.raw
```

Generation method:

- Read source TIFF as 396 x 301 unsigned 16-bit values.
- Bilinearly resample to 513 x 513 for Unity terrain import.
- Scale source min..max to 0..65535.
- Write headerless little-endian 16-bit RAW.

Equivalent GDAL-style command, if GDAL is available:

```text
gdal_translate dem30mSBFRbound.tiff CentralCoast_DEM_513_uint16_little_endian.raw -of ENVI -ot UInt16 -scale 0 255 0 65535 -outsize 513 513 -r bilinear
```

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

The DEM values appear normalized rather than raw meter elevations, so terrain
height is a visual tuning parameter for this prototype. If the terrain is
north/south reversed relative to the patch raster or map, regenerate or import a
vertically flipped RAW.

---

## Decision 2: Output Frame JSON Shape

Each `TerrainData` row represents one monthly frame for one
`(scenarioRunId, warmingIdx, year, month)` tuple.

### Database table: `TerrainData`

Reuse the existing Big Creek `TerrainData` table concept, extended for Central
Coast:

| Column | Type | Notes |
| --- | --- | --- |
| `id` | int identity PK | |
| `scenarioRunId` | varchar | Central Coast scenario member id |
| `warmingIdx` | int | Warming case index |
| `year` | int | Calendar year |
| `month` | int | 1-12 |
| `gridSize` | int | 0 for Central Coast (non-square) |
| `gridWidth` | int | 396 for Central Coast |
| `gridHeight` | int | 301 for Central Coast |
| `pixelGrainSize` | int | ~30 (meters per pixel) |
| `decimalPrecision` | int | 4 (stored float precision in `_dataList`) |
| `_dataList` | longtext | JSON flat array, length = gridWidth * gridHeight |

### `_dataList` encoding

`_dataList` is a flat JSON array of length `gridWidth * gridHeight`
(396 x 301 = 119,196 values), stored in row-major order matching the patch map:

```
index = row * gridWidth + col
```

Each element is a float with the following encoding:

```
value = vegIntensity + burnSignal * 100
```

Where:

- `vegIntensity` is in `[0.0, 1.0]`: normalized mean `total_plantc` for the
  `zoneID` at this pixel for this month/year. Pixels with no `zoneID` (nodata)
  store `0.0`.
- `burnSignal` is `0` or `1`: `1` if max `burn` for the `zoneID` at this pixel
  for this month/year is above the burn threshold (see Decision 4).

This matches the Big Creek convention where `_dataList` encodes blended
splatmap weights as floats. The `vegIntensity + burnSignal * 100` encoding
allows Unity to separate veg and burn in one value without adding a second
array:

```
vegIntensity = fmod(value, 100.0)
burnSignal   = floor(value / 100.0)
```

This encoding is analogous to how Big Creek encodes snow/burned state into
the same splatmap array.

---

## Decision 3: Aggregation

These defaults were set in CCV2-15. Confirmed here:

| Source | Aggregation | Reason |
| --- | --- | --- |
| `StratumData.total_plantc` | Mean across all patchID and stratumID members per zoneID/month | Avoids double-counting 2 patches x 2 strata |
| `BurnData.burn` (level="patch") | Max across patchID members per zoneID/month | Burn is a signal; max is conservative and intuitive |

Normalization for `vegIntensity`:

- Compute global max `total_plantc` across all months and all `zoneID`s for the
  given `(scenarioRunId, warmingIdx)`.
- Store this as a metadata value (log it during generation; later expose via API
  or `ImportRun.notes`).
- `vegIntensity = meanPlantC / globalMaxPlantC`, clamped to `[0.0, 1.0]`.

This ensures all monthly frames are normalized on the same scale.

---

## Decision 4: Burn Threshold

A `burnSignal = 1` is set when `maxBurn > 0.0` for a `zoneID`/month.

Rationale: RHESSys `burn` values are small positive floats when fire occurs;
zero when no fire. Any non-zero value should be treated as a burn signal for
visualization purposes. Scientists can revise the threshold later if needed.

---

## Decision 5: Coordinate Transformation

The patch map stores pixels as zero-based `(col, row)` with upper-left origin
(CCV2-15 coordinate system).

For `_dataList` encoding, pixel `(col, row)` maps to:

```
index = row * gridWidth + col
```

**No coordinate transformation is required for the generator.** The flat array
index is simply `row * 396 + col`. Unity reads the array by the same index.

The Unity terrain renderer will need to map these indices to its own UV/alphamap
space. That mapping is a Unity-side concern deferred to CCV2-20. The generator
does not need to know the Unity terrain world dimensions.

---

## Decision 6: Temporal Grain

Monthly. Central Coast source data (`StratumData`, `BurnData`) is monthly.
One `TerrainData` row per `(scenarioRunId, warmingIdx, year, month)`.

384 months x 1 warming case = **384 rows** in `TerrainData` for the initial
sample bundle.

Do not precompute daily frames. Unity can interpolate between monthly frames
the same way it does for Big Creek landscape snow.

---

## Generator Algorithm

```
Given (scenarioRunId, warmingIdx):

1. Load all PatchData rows for scenarioRunId into a dict:
   zoneID -> pixels list

2. Compute globalMaxPlantC:
   SELECT MAX(avg_plantc) FROM (
     SELECT zoneID, year, month,
            AVG(total_plantc) AS avg_plantc
     FROM StratumData
     WHERE scenarioRunId = ? AND warmingIdx = ?
     GROUP BY zoneID, year, month
   ) sub

3. For each unique (year, month) in StratumData:

   a. Initialize output float array of length 396 * 301 = 119,196
      with all zeros.

   b. For each zoneID in PatchData:
      - Query StratumData: mean total_plantc for (scenarioRunId,
        warmingIdx, year, month, zoneID) across all patchID/stratumID.
      - Query BurnData: max burn for (scenarioRunId, warmingIdx,
        year, month, zoneID, level="patch") across all patchID.
      - vegIntensity = clamp(meanPlantC / globalMaxPlantC, 0, 1)
      - burnSignal = (maxBurn > 0.0) ? 1 : 0
      - value = vegIntensity + burnSignal * 100
      - For each [col, row] in PatchData.pixels[zoneID]:
          output[row * 396 + col] = value

   c. Serialize output to JSON array (_dataList).

   d. Write one TerrainData row:
      (scenarioRunId, warmingIdx, year, month,
       gridSize=0, gridWidth=396, gridHeight=301,
       pixelGrainSize=30, decimalPrecision=4, _dataList)

4. Print summary: N frames generated.
```

---

## TerrainData Model Class

The existing Big Creek `TerrainData` model is in the Big Creek codebase and
must not be modified. For Central Coast v2, add a new EF model class:

```csharp
[Table("TerrainData")]
[Index(nameof(scenarioRunId), nameof(warmingIdx), nameof(year), nameof(month))]
public class TerrainDataRow
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int id { get; set; }

    public string scenarioRunId { get; set; }
    public int warmingIdx { get; set; }
    public int year { get; set; }
    public int month { get; set; }
    public int gridSize { get; set; }
    public int gridWidth { get; set; }
    public int gridHeight { get; set; }
    public int pixelGrainSize { get; set; }
    public int decimalPrecision { get; set; }

    [Column(TypeName = "longtext")]
    public string _dataList { get; set; }
}
```

Add `DbSet<TerrainDataRow> TerrainData` to `CentralCoastDbContext`.

---

## Wiring

- Add `GenerateTerrainData(ScenarioConfig config, bool dryrun)` to
  `CentralCoastImporter` (or a new `CentralCoastTerrainGenerator` class if
  the method grows large).
- Add `AddTerrainDataRow(TerrainDataRow row)` to `CentralCoastDAL`.
- Add `--terrain` flag CCV2 branch in `Program.cs` auto mode.
- Add `[3] Terrain` CCV2 branch in wizard `RunSelectedImports`.

Note: `--terrain` already exists as a flag for the legacy Big Creek path. Wire
the CCV2 branch the same way `--burn` and `--water` are already split.

---

## Open Questions for CCV2-20 (API/Unity)

- Does the Unity `TerrainData` endpoint need a new route
  (`/terraindata/centralcoast/{warmingIdx}`) or can the existing
  `terraindata/{warmingIdx}` route serve Central Coast frames when the active
  scenario is `CentralCoastV2`?
- How does Unity interpolate between monthly `TerrainData` frames for Central
  Coast? The existing snow interpolation loop uses `gridSize`; it must be
  updated to use `gridWidth`/`gridHeight`.
- Should burn persist across months (cumulative) or reset each month? Big Creek
  fire state persists. First pass: persist in Unity (not in the precomputed
  frame), or set burn to `1` for the month of the event and zero thereafter.

---

## Acceptance

- [x] Rectangular grid decision: use `gridWidth`/`gridHeight`, set `gridSize=0`.
      Big Creek `TerrainData` rows are untouched.
- [x] `_dataList` encoding defined: `vegIntensity + burnSignal * 100`, row-major.
- [x] Aggregation confirmed: mean `total_plantc`, max `burn`.
- [x] Normalization defined: `vegIntensity = meanPlantC / globalMaxPlantC`.
- [x] Burn threshold defined: `maxBurn > 0.0`.
- [x] Coordinate transform: none required in generator; flat index `row * 396 + col`.
- [x] Temporal grain: monthly, 384 frames for initial sample.
- [x] Generator algorithm stated.
- [x] `TerrainDataRow` model class defined.
- [x] Wiring path specified.
- [x] Static Unity DEM import workflow documented.
- [x] Open questions for CCV2-20 documented.
- [x] Big Creek `TerrainData` behavior untouched.
