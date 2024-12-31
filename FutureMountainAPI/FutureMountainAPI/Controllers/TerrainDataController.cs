using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FutureMountainAPI;
using FutureMountainAPI.DAL;
using FutureMountainAPI.Models;

//using .EntityFrameworkCore;

namespace FutureMountainAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TerrainDataController : ControllerBase
    {
        /// <summary>
        /// Terrain Data Controller
        /// </summary>
        private readonly TerrainDataDbContext _context;

        public TerrainDataController(TerrainDataDbContext context)
        {
            _context = context;
        }

        // GET: api/CubeData
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TerrainDataFrameJSONRecord>>> GetTerrainData()
        {
            if (!_context.TerrainData.Any())
            {
                return NotFound();
            }

            return await _context.TerrainData.ToListAsync();
        }


        // GET: api/TerrainData/5
        [HttpGet("{warmingIdx}")]
        public async Task<ActionResult<List<TerrainDataFrameJSONRecord>>> GetTerrainData(int warmingIdx)
        {
            if (_context.TerrainData == null)
            {
                return NotFound();
            }

            var terrainData = _context.TerrainData.Where(x => x.warmingIdx == warmingIdx);

            if (!terrainData.Any())
            {
                return NotFound();
            }

            return terrainData.ToList();
        }

        // GET: api/TerrainData/5/15
        [HttpGet("{startIdx}/{endIdx}")]
        public async Task<ActionResult<IEnumerable<TerrainDataFrameJSONRecord>>> GetTerrainDataRange(int startIdx, int endIdx)
        {
            if (_context.TerrainData == null)
            {
                return NotFound();
            }

            var terrainData = await _context.TerrainData.Where(x => x.id >= startIdx &&
                                                                x.id <= endIdx).ToListAsync();

            if (terrainData == null)
            {
                return NotFound();
            }

            return terrainData;
        }


        private bool TerrainDataExists(int id)
        {
            return (_context.TerrainData?.Any(e => e.id == id)).GetValueOrDefault();
        }


        private bool TerrainDataExistsForWarmingIdx(int warmingIdx)
        {
            return (_context.TerrainData?.Any(e => e.warmingIdx == warmingIdx)).GetValueOrDefault();
        }

    }
}
