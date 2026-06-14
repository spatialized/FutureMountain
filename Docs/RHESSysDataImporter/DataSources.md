# RHESSys Data Importer Data Sources

Last updated: 2026-06-13

## Purpose

This document describes the current data files and source-data assumptions used by the embedded RHESSys Data Importer.

It covers current state only.

## Current Embedded Data

The importer tree currently includes source/sample files under one shared data
root:

```text
RHESSYs_Data_Importer/Data/
```

Current subfolders:

```text
Data/BigCreek/aggregate/
Data/BigCreek/fire_cubes/
Data/CentralCoast/RHESSysOutput-SingleWarmIdx-6-4-2026/
```

The embedded files total roughly 120 MB.

## Aggregate Files

Current aggregate examples:

```text
agg_hist_fire.txt
agg_warm1_fire.txt
agg_warm2_fire.txt
agg_warm4_fire.txt
agg_warm6_fire.txt
```

Legacy aggregate cube parsing treats these as patch index `-1`.

## Cube Files

Current cube examples:

```text
p1239496_2veg_hist_fire.txt
p1239496_2veg_warm1_fire.txt
p1239496_2veg_warm2_fire.txt
p1239496_2veg_warm4_fire.txt
p1239496_2veg_warm6_fire.txt
```

The legacy parser infers:

- Patch id from the leading `p...` filename segment.
- Baseline warming index from filenames containing `hist`.
- Non-baseline warming index from the final warming digit before `_fire`.

Current warming index mapping:

| Warming degrees | Warming index |
| ---: | ---: |
| 0 | 0 |
| 1 | 1 |
| 2 | 2 |
| 4 | 3 |
| 6 | 4 |

## Configured Source Folders

The current `ScenarioConfig_BigCreek.json` points to these relative folders:

```text
../Data/BigCreek/fire_cubes/
../Data/BigCreek/aggregate/
```

Those folders are not the same as the embedded `data/` folder. When running the config-driven path, make sure the configured folders exist relative to the importer working directory.

## Source Formats Currently Parsed

### Cube Text Files

Cube text files are parsed either by:

- Header-based config mapping through `ColumnMapper`.
- Legacy positional parsing if mapping fails or the legacy path is used.

The parser splits lines on spaces or tabs.

### Dates

Dates are imported from the first aggregate file whose filename contains `hist`. The legacy dates path reads year/month/day from fixed positions in each data line.

### Water JSON

The legacy water importer expects:

```text
WaterData.json
```

inside the configured water folder.

### Fire JSON

The legacy fire importer enumerates files in the configured fire folder, infers warming from each filename, deserializes JSON fire frame records, and writes serialized JSON records to the database model.

### Patch JSON

The legacy patch importer expects:

```text
PatchData.json
```

inside the configured patch folder.

### Terrain JSON

The legacy terrain importer enumerates files in the configured terrain folder and expects filenames shaped like:

```text
terrain_warm1_1942_10_4_4.json
```

It extracts warming, year, month, grain size, and decimal precision from filename segments.

## Current Source-Data Assumptions

- Warming levels are fixed to baseline, +1 C, +2 C, +4 C, and +6 C.
- Aggregate cube data has a slightly different positional layout than patch cube data.
- Config-driven cube import expects source file headers that can be mapped to model field names.
- Legacy cube import relies on column positions.
- File discovery searches only the top level of configured input folders.
- The importer does not currently validate a full source-data manifest before writing.

## Current Data Management Concerns

- The embedded data is large enough that Git/LFS policy should be decided before committing it.
- The importer includes generated build output folders in the embedded tree; those are not source data.
- The importer includes a nested Git repository; that should be resolved before the importer is fully absorbed into the parent repository.
- Source data and test fixture data are not yet clearly separated.
