using FutureMountainAPI.DAL;
using FutureMountainAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI.Controllers
{
    [Route("api/centralcoastv3/TerrainData")]
    [ApiController]
    public class CentralCoastV3TerrainDataController : ControllerBase
    {
        private readonly CentralCoastV3DbContext _context;

        public CentralCoastV3TerrainDataController(CentralCoastV3DbContext context)
        {
            _context = context;
        }

        [HttpGet("{scenarioIdx}")]
          public async Task<ActionResult<List<TerrainDataFrameJSONRecord>>> GetTerrainData(int scenarioIdx)
          {
              var terrainData = await _context.TerrainData
                  .Where(row => row.scenarioIdx == scenarioIdx)
                  .Select(row => new TerrainDataFrameJSONRecord
                  {
                      id = row.id,
                      warmingIdx = row.scenarioIdx, 
                      year = row.year,
                      month = row.month,
                      gridSize = row.gridSize,
                      pixelGrainSize = row.pixelGrainSize,
                      decimalPrecision = row.decimalPrecision,
                      _dataList = row._dataList
                  })
                  .ToListAsync();

              if (!terrainData.Any()) return NotFound();
              return terrainData;
          }
      }
  }
