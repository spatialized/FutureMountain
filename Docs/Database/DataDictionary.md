# Future Mountain Database Data Dictionary

Last updated: 2026-06-12

## Overview

The Future Mountain database stores RHESSys-derived simulation outputs, terrain data, fire progression, hydrology, and metadata required to drive the Unity visualization.

This dictionary describes the current Big Creek database/API contract as understood from the Unity repository. It should be reconciled with a MySQL Workbench schema export before it is treated as authoritative.

See also:

- [Data Model Spec](../Specs/DataModel.md)
- [Data Mappings Spec](../Specs/DataMappings.md)
- [Data Formats](DataFormats.md)

## Naming Notes

Database column casing and Unity/API JSON property casing are not always identical in code comments and DTOs. The Unity runtime currently expects lower camel case JSON for several fields, including `qout`, `qBase`, `qWarm1`, `qWarm2`, `qWarm4`, and `qWarm6`.

When updating the importer, API, or schema, keep the database column name, API property name, Unity DTO property name, units, and visual mapping aligned.

## Table: `cubedata`

Stores ecological simulation outputs for individual patches/cubes at a particular date and warming scenario.

| Column | Type | Description |
| --- | --- | --- |
| `id` | `int` | Primary key. |
| `dateIdx` | `int` | Foreign key/reference to `dates.id`. |
| `warmingIdx` | `int` | Warming scenario index. Current Big Creek indices map to `0 C`, `+1 C`, `+2 C`, `+4 C`, and `+6 C`. |
| `patchIdx` | `int` | Patch/cube identifier. |
| `snow` | `float` | Snow amount. Drives cube snow and precipitation-to-groundwater effects. |
| `evap` | `float` | Evaporation/evapotranspiration-related output. Current direct visualization appears limited. |
| `netpsn` | `float` | Net photosynthesis. Loaded and ranged; current visible mapping is limited. |
| `depthToGW` | `float` | Depth to groundwater. Drives cube groundwater/soil visual state. |
| `vegAccessWater` | `float` | Vegetation-accessible water. Drives surface-soil wetness. |
| `qout` | `float` | Cube water outflow/stream height input. |
| `litter` | `float` | Litter carbon/biomass. Partially visualized through litter/dead vegetation behavior. |
| `soil` | `float` | Soil carbon/biomass. Loaded, but current direct visualization appears limited. |
| `heightOver` | `float` | Overstory vegetation height. Loaded, but current tree sizing is primarily carbon-derived. |
| `transOver` | `float` | Overstory transpiration. Drives tree evapotranspiration particles and Show Model bars. |
| `heightUnder` | `float` | Understory vegetation height. Loaded, but current shrub sizing is primarily carbon-derived. |
| `transUnder` | `float` | Understory transpiration. Drives shrub evapotranspiration particles and Show Model bars. |
| `leafCOver` | `float` | Overstory leaf carbon. Drives tree/vegetation carbon mapping. |
| `stemCOver` | `float` | Overstory stem carbon. Drives tree/vegetation carbon mapping. |
| `rootCOver` | `float` | Overstory root carbon. Drives root visual behavior where applicable. |
| `leafCUnder` | `float` | Understory leaf carbon. Drives shrub/understory carbon mapping. |
| `stemCUnder` | `float` | Understory stem carbon. Drives shrub/understory carbon mapping. |
| `rootCUnder` | `float` | Understory root carbon. Loaded for data completeness; current direct visualization should be confirmed. |

## Table: `dates`

Lookup table used to map simulation date indices to calendar dates.

| Column | Type | Description |
| --- | --- | --- |
| `id` | `int` | Primary key/date index used by runtime lookups. |
| `date` | `datetime(6)` | Full simulation date/time. |
| `year` | `int` | Calendar year. |
| `month` | `int` | Calendar month. |
| `day` | `int` | Calendar day. |

## Table: `firedata`

Stores fire simulation results for a specific date and warming scenario.

| Column | Type | Description |
| --- | --- | --- |
| `id` | `int` | Primary key. |
| `warmingIdx` | `int` | Warming scenario index. |
| `year` | `int` | Calendar year. |
| `month` | `int` | Calendar month. |
| `day` | `int` | Calendar day. |
| `gridHeight` | `int` | Fire grid height. |
| `gridWidth` | `int` | Fire grid width. |
| `_dataList` | `mediumtext` | Serialized fire grid data. Unity deserializes this into fire data points. |

### Notes

Fire has two distinct data concepts:

- Fire event dates are scheduled scenario events.
- Fire spread/growth after those dates is data-driven through the fire grid frames.

For Big Creek, the Unity code currently schedules fire starts in 1969 and 1988. The exact event dates should be reconciled between code, messages, and source data before the Central Coast scenario is added.

## Table: `patchdata`

Stores patch metadata and spatial configuration.

| Column | Type | Description |
| --- | --- | --- |
| `id` | `int` | Primary key. |
| `patchId` | `int` | RHESSys patch identifier. |
| `_data` | `mediumtext` | Serialized patch metadata, including spatial points/locations used by Unity. |

### Notes

Patch information is stored as serialized data rather than normalized relational fields. Unity uses it to connect RHESSys patch IDs to landscape coordinates, fire locations, terrain alphamap locations, and UTM/spatial metadata.

## Table: `terraindata`

Stores monthly terrain overlays and landscape raster data.

| Column | Type | Description |
| --- | --- | --- |
| `id` | `int` | Primary key. |
| `warmingIdx` | `int` | Warming scenario index. |
| `year` | `int` | Calendar year. |
| `month` | `int` | Calendar month. |
| `gridSize` | `int` | Terrain grid dimension. |
| `pixelGrainSize` | `int` | Spatial resolution of each cell. |
| `decimalPrecision` | `int` | Precision used in stored values. |
| `_dataList` | `mediumtext` | Serialized terrain raster/splatmap data. |

### Notes

Unity uses terrain data for landscape-scale overlays such as snow and burned/unburned texture state. The exact layer semantics are scenario-specific and should be versioned with future terrain payloads.

## Table: `waterdata`

Stores watershed-scale hydrologic outputs.

| Column | Type | Description |
| --- | --- | --- |
| `index` | `int` | Primary key/index value. |
| `year` | `int` | Calendar year. |
| `month` | `int` | Calendar month. |
| `day` | `int` | Calendar day. |
| `qBase` | `float` | Streamflow under baseline/no-warming conditions. |
| `qWarm1` | `float` | Streamflow under `+1 C` warming scenario. |
| `qWarm2` | `float` | Streamflow under `+2 C` warming scenario. |
| `qWarm4` | `float` | Streamflow under `+4 C` warming scenario. |
| `qWarm6` | `float` | Streamflow under `+6 C` warming scenario. |
| `precipitation` | `float` | Precipitation amount. Used for the Timeline precipitation bars. |

### Notes

Current water data encodes warming levels as separate columns. Future scenarios should consider a normalized structure keyed by scenario/climate case and date so additional warming or climate cases do not require new columns.

## Entity Relationships

### `cubedata`

```text
dateIdx -> dates.id
patchIdx -> patchdata.patchId
```

Each `cubedata` record represents:

```text
Date
  + Warming Scenario
  + Patch
  = Ecological State
```

### `firedata`

Each `firedata` record represents:

```text
Date
  + Warming Scenario
  = Fire Grid Snapshot
```

### `terraindata`

Each `terraindata` record represents:

```text
Year
  + Month
  + Warming Scenario
  = Terrain Raster Snapshot
```

### `waterdata`

Each `waterdata` record represents:

```text
Date
  = Hydrologic Output
```

## Historical Notes

This schema was developed for the original Future Mountain RHESSys visualization pipeline.

Key design characteristics:

- Patch-level ecological data is stored in `cubedata`.
- Fire grids are stored as serialized raster data.
- Terrain layers are stored as serialized raster data.
- Watershed hydrology is stored separately in `waterdata`.
- Temporal indexing is managed through the `dates` table.

Future versions of the system may migrate to newer RHESSys output formats and expanded patch-family structures introduced in later Central Coast simulations.
