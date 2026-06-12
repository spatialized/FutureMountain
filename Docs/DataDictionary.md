# Future Mountain Database Data Dictionary

## Overview

The Future Mountain database stores simulation outputs, terrain data, fire progression, hydrology, and metadata required to drive the Unity visualization.

---

# Table: cubedata

Stores ecological simulation outputs for individual patches/cubes at a particular date and warming scenario.

| Column | Type | Description |
|----------|----------|-------------|
| id | int | Primary key |
| dateIdx | int | Foreign key to dates table |
| warmingIdx | int | Warming scenario index |
| patchIdx | int | Patch identifier |
| snow | float | Snow amount |
| evap | float | Evapotranspiration |
| netpsn | float | Net photosynthesis |
| depthToGW | float | Depth to groundwater |
| vegAccessWater | float | Vegetation-accessible water |
| Qout | float | Water outflow |
| litter | float | Litter carbon/biomass |
| soil | float | Soil carbon/biomass |
| heightOver | float | Overstory vegetation height |
| transOver | float | Overstory transpiration |
| heightUnder | float | Understory vegetation height |
| transUnder | float | Understory transpiration |
| leafCOver | float | Overstory leaf carbon |
| stemCOver | float | Overstory stem carbon |
| rootCOver | float | Overstory root carbon |
| leafCUnder | float | Understory leaf carbon |
| stemCUnder | float | Understory stem carbon |
| rootCUnder | float | Understory root carbon |

---

# Table: dates

Lookup table used to map simulation date indices to calendar dates.

| Column | Type | Description |
|----------|----------|-------------|
| id | int | Primary key |
| date | datetime(6) | Full simulation date/time |
| year | int | Year |
| month | int | Month |
| day | int | Day |

---

# Table: firedata

Stores fire simulation results for a specific date and warming scenario.

| Column | Type | Description |
|----------|----------|-------------|
| id | int | Primary key |
| warmingIdx | int | Warming scenario index |
| year | int | Year |
| month | int | Month |
| day | int | Day |
| gridHeight | int | Fire grid height |
| gridWidth | int | Fire grid width |
| _dataList | mediumtext | Serialized fire grid data |

### Notes

The `_dataList` field contains the full fire state grid used by the Unity fire visualization system.

---

# Table: patchdata

Stores patch metadata and spatial configuration.

| Column | Type | Description |
|----------|----------|-------------|
| id | int | Primary key |
| patchId | int | RHESSys patch identifier |
| _data | mediumtext | Serialized patch metadata |

### Notes

Patch information is stored as serialized data rather than normalized relational fields.

---

# Table: terraindata

Stores monthly terrain overlays and landscape raster data.

| Column | Type | Description |
|----------|----------|-------------|
| id | int | Primary key |
| warmingIdx | int | Warming scenario index |
| year | int | Year |
| month | int | Month |
| gridSize | int | Terrain grid dimension |
| pixelGrainSize | int | Spatial resolution of each cell |
| decimalPrecision | int | Precision used in stored values |
| _dataList | mediumtext | Serialized terrain raster data |

### Notes

Used to drive landscape-scale visualizations such as vegetation, snow, moisture, or other raster-based simulation layers.

---

# Table: waterdata

Stores watershed-scale hydrologic outputs.

| Column | Type | Description |
|----------|----------|-------------|
| index | int | Primary key |
| year | int | Year |
| month | int | Month |
| day | int | Day |
| QBase | float | Baseflow discharge |
| QWarm1 | float | Streamflow under warming scenario +1 |
| QWarm2 | float | Streamflow under warming scenario +2 |
| QWarm4 | float | Streamflow under warming scenario +4 |
| QWarm6 | float | Streamflow under warming scenario +6 |
| precipitation | float | Precipitation amount |

---

# Entity Relationships

## cubedata

```text
dateIdx → dates.id
patchIdx → patchdata.patchId
```

Each cubedata record represents:

```text
Date
    +
Warming Scenario
    +
Patch
    =
Ecological State
```

---

## firedata

Each record represents:

```text
Date
    +
Warming Scenario
    =
Fire Grid Snapshot
```

---

## terraindata

Each record represents:

```text
Year
    +
Month
    +
Warming Scenario
    =
Terrain Raster Snapshot
```

---

## waterdata

Each record represents:

```text
Date
    =
Hydrologic Output
```

---

# Historical Notes

This schema was developed for the original Future Mountain RHESSys visualization pipeline.

Key design characteristics:

- Patch-level ecological data stored in `cubedata`
- Fire grids stored as serialized raster data
- Terrain layers stored as serialized raster data
- Watershed hydrology stored separately in `waterdata`
- Temporal indexing managed through the `dates` table

Future versions of the system may migrate to newer RHESSys output formats and expanded patch-family structures introduced in later Central Coast simulations.