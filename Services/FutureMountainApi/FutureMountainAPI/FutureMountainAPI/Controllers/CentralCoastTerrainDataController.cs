using FutureMountainAPI.DAL;
using FutureMountainAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI.Controllers
{
    [Route("api/centralcoast/TerrainData")]
    [ApiController]
    public class CentralCoastTerrainDataController : ControllerBase
    {
        private readonly CentralCoastDbContext _context;

        public CentralCoastTerrainDataController(CentralCoastDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<TerrainDataFrameJSONRecord>>> GetTerrainData()
        {
            if (!_context.TerrainData.Any())
            {
                return NotFound();
            }

            return await _context.TerrainData
                .Select(row => new TerrainDataFrameJSONRecord
                {
                    id = row.id,
                    warmingIdx = row.warmingIdx,
                    year = row.year,
                    month = row.month,
                    gridSize = row.gridSize,
                    pixelGrainSize = row.pixelGrainSize,
                    decimalPrecision = row.decimalPrecision,
                    _dataList = row._dataList
                })
                .ToListAsync();
        }

        [HttpGet("{warmingIdx}")]
        public async Task<ActionResult<List<TerrainDataFrameJSONRecord>>> GetTerrainData(int warmingIdx)
        {
            var terrainData = await _context.TerrainData
                .Where(row => row.warmingIdx == warmingIdx)
                .Select(row => new TerrainDataFrameJSONRecord
                {
                    id = row.id,
                    warmingIdx = row.warmingIdx,
                    year = row.year,
                    month = row.month,
                    gridSize = row.gridSize,
                    pixelGrainSize = row.pixelGrainSize,
                    decimalPrecision = row.decimalPrecision,
                    _dataList = row._dataList
                })
                .ToListAsync();

            if (!terrainData.Any())
            {
                return NotFound();
            }

            return terrainData;
        }
    }
}
