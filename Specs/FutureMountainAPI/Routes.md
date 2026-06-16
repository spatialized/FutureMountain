# Future Mountain API Routes

Last updated: 2026-06-16

## Big Creek Routes

### CubeData

Base route:

```text
/api/CubeData
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/CubeData` | All cube rows |
| `GET /api/CubeData/{id}` | One row by database id |
| `GET /api/CubeData/{patchIdx}/{warmingIdx}` | Cube rows for patch/cube and warming |
| `GET /api/CubeData/{patchIdx}/{warmingIdx}/{dateIdx}` | Cube rows for one date index |
| `GET /api/CubeData/{patchIdx}/{warmingIdx}/{dateIdxStart}/{dateIdxEnd}` | Cube rows in a date-index range |

### WaterData

Base route:

```text
/api/WaterData
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/WaterData` | All water rows |
| `GET /api/WaterData/{index}` | One water frame by index |
| `GET /api/WaterData/{startIdx}/{endIdx}` | Water frames in an index range |
| `GET /api/WaterData/max/{warmingIdx}` | Maximum streamflow for warming index |
| `GET /api/WaterData/min/{warmingIdx}` | Minimum precipitation for warming index |
| `GET /api/WaterData/total/{year}` | Total precipitation for one year |
| `GET /api/WaterData/total` | Annual precipitation totals for timeline |
| `GET /api/WaterData/maxtotal` | Maximum annual precipitation total |

### FireData

Base route:

```text
/api/FireData
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/FireData` | All fire frames |
| `GET /api/FireData/{warmingIdx}` | Fire frames for warming index |

### PatchData

Base route:

```text
/api/PatchData
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/PatchData` | All patch records |
| `GET /api/PatchData/{patchId}` | Patch records for one patch id |

### TerrainData

Base route:

```text
/api/TerrainData
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/TerrainData` | All terrain frames |
| `GET /api/TerrainData/{warmingIdx}` | Terrain frames for warming index |
| `GET /api/TerrainData/{startIdx}/{endIdx}` | Terrain frames in id/index range |

### Dates

Base route:

```text
/api/Dates
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/Dates` | All date rows |
| `GET /api/Dates/{id}` | Date row by id/date index |
| `GET /api/Dates/{year}/{month}/{day}` | Date row matching calendar date |

## Central Coast Routes

Central Coast prototype routes mirror the Unity-facing Big Creek route shapes
where practical.

### Central Coast CubeData

Base route:

```text
/api/centralcoast/CubeData
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/centralcoast/CubeData` | All Central Coast cube rows shaped as prototype DTOs |
| `GET /api/centralcoast/CubeData/{id}` | One row by database id |
| `GET /api/centralcoast/CubeData/{patchIdx}/{warmingIdx}` | Rows for zone/patch identity and warming |
| `GET /api/centralcoast/CubeData/{patchIdx}/{warmingIdx}/{dateIdx}` | Rows for one date index |
| `GET /api/centralcoast/CubeData/{patchIdx}/{warmingIdx}/{dateIdxStart}/{dateIdxEnd}` | Rows in a date-index range |

### Central Coast WaterData

Base route:

```text
/api/centralcoast/WaterData
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/centralcoast/WaterData` | All water frames |
| `GET /api/centralcoast/WaterData/{index}` | One water frame by index |
| `GET /api/centralcoast/WaterData/total` | Annual precipitation totals for timeline |
| `GET /api/centralcoast/WaterData/maxtotal` | Maximum annual precipitation total |

### Central Coast PatchData

Base route:

```text
/api/centralcoast/PatchData
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/centralcoast/PatchData` | All patch-map footprint rows shaped as prototype DTOs |
| `GET /api/centralcoast/PatchData/{patchId}` | Patch-map footprint rows for one zone/patch id |

### Central Coast TerrainData

Base route:

```text
/api/centralcoast/TerrainData
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/centralcoast/TerrainData` | All Central Coast terrain frames |
| `GET /api/centralcoast/TerrainData/{warmingIdx}` | Terrain frames for warming index |

### Central Coast Dates

Base route:

```text
/api/centralcoast/Dates
```

Routes:

| Route | Purpose |
| --- | --- |
| `GET /api/centralcoast/Dates` | All date rows |
| `GET /api/centralcoast/Dates/{id}` | Date row by id/date index |
| `GET /api/centralcoast/Dates/{year}/{month}/{day}` | Date row matching calendar date |

## Development Route

The default ASP.NET template `WeatherForecast` controller still exists:

```text
GET /WeatherForecast
```

It is not part of the Unity runtime contract.
