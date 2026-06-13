# RHESSys Data Importer Scenario Config

Last updated: 2026-06-13

## Purpose

The current importer uses a JSON scenario config to describe the active scenario, database connection, input folders, file patterns, column mappings, transform placeholders, flags, and output tables.

Default config:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer/ScenarioConfig_BigCreek.json
```

## Current Scope

The config is used by the importer only. The Unity runtime does not currently load this file.

The current config is Big Creek-oriented and should be treated as part of the data import pipeline, not as a complete runtime scenario definition.

## Top-Level Shape

Current top-level fields:

| Field | Purpose |
| --- | --- |
| `scenarioName` | Human-readable scenario name |
| `description` | Scenario description |
| `version` | Config/scenario version label |
| `database` | MySQL connection settings |
| `inputFolders` | Named source data folders |
| `filePatterns` | Glob patterns by importer category |
| `columnMapping` | Source-column to importer-model mappings |
| `transforms` | Placeholder transform lists by category |
| `flags` | Scenario behavior hints |
| `outputTables` | Table names expected as import targets |

## Database Section

Current fields:

| Field | Purpose |
| --- | --- |
| `name` | Database name |
| `host` | MySQL host |
| `port` | MySQL port |
| `user` | MySQL user |
| `password` | MySQL password |
| `charset` | MySQL charset |
| `collation` | MySQL collation |

`DatabaseConfig.GetConnectionString()` builds:

```text
server={Host};port={Port};database={Name};user={User};password={Password};charset={Charset};
```

`DatabaseConfig.GetAdminConnectionString()` omits the database name.

## Input Folders

The current Big Creek config defines:

| Key | Configured meaning |
| --- | --- |
| `cubeData` | Cube source files |
| `patchOutput` | Patch-level output |
| `basinOutput` | Basin-level output |
| `spatialData` | Spatial data |
| `climateData` | Climate data |

`FileDiscovery` currently searches all configured folders for every category pattern. It does not bind a category to only one folder key.

Paths are normalized with `Path.GetFullPath`, so relative paths are resolved from the importer working directory.

## File Patterns

The current config recognizes:

| Category | Current pattern |
| --- | --- |
| `cube` | `p*_2veg_*_*.txt` |
| `patch` | `extent100m_*.txt` |
| `terrain` | `patches100m*.txt` |
| `fire` | `firemask*.txt` |
| `water` | `ext100m_*.txt` |
| `climate` | `clim*.txt` |

The importer uses `Directory.GetFiles(dir, pattern, SearchOption.TopDirectoryOnly)`.

## Column Mapping

Column mapping is currently meaningful for config-driven cube imports.

The mapping shape is:

```json
{
  "columnMapping": {
    "cube": {
      "source_column_name": "targetFieldName"
    }
  }
}
```

`ColumnMapper` reads the first non-empty line as a header, splits it on spaces or tabs, and matches source column names case-insensitively. It then allows `TextFileInput` to read target fields by name.

If no mapped columns are matched, cube import logs an error and falls back to legacy positional parsing.

## Flags

Current flags:

| Field | Purpose |
| --- | --- |
| `hasFire` | Indicates that scenario includes fire data |
| `vegetationLayers` | Indicates expected vegetation layer count |

These flags are currently light metadata. They do not yet drive a comprehensive runtime or importer strategy.

## Output Tables

Current output tables:

- `cubedata`
- `patchdata`
- `terraindata`
- `firedata`
- `waterdata`
- `dates`

The list documents expected targets but does not automatically create or validate all tables.

## Current Config Issues To Know

- The checked-in description contains mojibake for the temperature range text.
- Configured input folder paths point to `../Data/...`, while sample files are currently embedded under `RHESSYs_Data_Importer/RHESSYs_Data_Importer/data/`.
- Some config categories exist before full importer support exists.
- The config includes climate mappings, but climate import is not implemented.
- Database passwords should not be committed for real shared environments.
