# RHESSys Data Importer File Naming And Discovery Spec

Last updated: 2026-06-13

## Scope

This spec documents the current filename assumptions and discovery behavior in the embedded importer.

## File Discovery

Implemented in:

```text
IO/FileDiscovery.cs
```

Inputs:

- `ScenarioConfig.InputFolders`
- `ScenarioConfig.FilePatterns`

Output:

- `FileDiscoveryResult.FilesByCategory`
- `FileDiscoveryResult.Warnings`

## Discovery Algorithm

For each configured input folder:

1. Normalize the folder path with `Path.GetFullPath`.
2. Trim trailing directory separators.
3. Warn if the folder does not exist.

For each fixed category:

1. Read the category pattern from `FilePatterns`.
2. Search every configured folder using `Directory.GetFiles`.
3. Use `SearchOption.TopDirectoryOnly`.
4. Add matching files to the category list.
5. Normalize files with `Path.GetFullPath`.
6. De-duplicate case-insensitively.

## Fixed Categories

Current fixed categories:

| Category | Purpose |
| --- | --- |
| `cube` | Cube-level RHESSys output |
| `patch` | Patch-level output |
| `terrain` | Terrain/spatial terrain data |
| `fire` | Fire mask/fire output |
| `water` | Water or basin output |
| `climate` | Climate output placeholder |

## Current Config Patterns

| Category | Pattern |
| --- | --- |
| `cube` | `p*_2veg_*_*.txt` |
| `patch` | `extent100m_*.txt` |
| `terrain` | `patches100m*.txt` |
| `fire` | `firemask*.txt` |
| `water` | `ext100m_*.txt` |
| `climate` | `clim*.txt` |

## Cube Filename Parsing

Config-aware cube import infers metadata from filenames.

### Patch Id

If a filename starts with `p`, the importer:

1. Splits the filename on `_`.
2. Reads the first segment.
3. Skips the leading `p`.
4. Takes subsequent digits.
5. Parses those digits as `patchIdx`.

Example:

```text
p1239496_2veg_hist_fire.txt -> patchIdx 1239496
```

### Warming Index

If the filename contains `hist`, warming index is:

```text
0
```

Otherwise, if the filename contains `_fire`, the importer:

1. Splits the filename at `_fire`.
2. Reads the last character before `_fire`.
3. If it is a digit, maps it through `WarmingDegreesToIndex`.

Current mapping:

| Filename warming degree | Warming index |
| ---: | ---: |
| 0 | 0 |
| 1 | 1 |
| 2 | 2 |
| 4 | 3 |
| 6 | 4 |
| Other | -1 |

## Legacy Aggregate Filename Parsing

Aggregate files are read from the aggregate folder.

If filename contains:

```text
hist
```

then warming index is `0`.

Otherwise the legacy parser expects the warming digit before `_fire`.

Aggregate rows are imported with:

```text
patchIdx = -1
```

## Legacy Fire Filename Parsing

Legacy fire import enumerates files in the configured fire folder and extracts warming from the last character before `_fire`.

The parsed value is used directly as `warmingIdx` in current code, rather than through `WarmingDegreesToIndex`.

## Legacy Terrain Filename Parsing

Legacy terrain import expects filename segments like:

```text
terrain_warm1_1942_10_4_4.json
```

The parser extracts:

| Segment | Meaning |
| --- | --- |
| `warm1` | Warming index digit |
| `1942` | Year |
| `10` | Month |
| `4` | Grain size |
| `4` | Decimal precision |

## Discovery Limitations

- Discovery does not recurse.
- Discovery searches every folder for every category, not a specific folder per category.
- Discovery does not validate filename metadata before import.
- Discovery does not check that all warming levels are present.
- Discovery does not check that all expected patch/cube ids are present.
- Discovery does not check row counts or date coverage.

## Current Practical Implications

- Wrong working directory can make relative input folders resolve incorrectly.
- A broad pattern can pick up unintended files from any configured folder.
- Missing files produce warnings but do not necessarily stop the import.
- Existing file naming conventions are part of the current importer contract.
