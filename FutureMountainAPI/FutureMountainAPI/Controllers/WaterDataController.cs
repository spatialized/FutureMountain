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
    public class WaterDataController : ControllerBase
    {
        ///////
        // REMOTE
        ///////

        /// <summary>
        /// Water Data Controller
        /// </summary>
        private readonly WaterDataDbContext _context;

        public WaterDataController(WaterDataDbContext context)
        {
            _context = context;
        }

        // GET: api/CubeData
        [HttpGet]
        public async Task<ActionResult<IEnumerable<WaterDataFrame>>> GetWaterData()
        {
            if (_context.WaterData == null)
            {
                return NotFound();
            }

            return await _context.WaterData.ToListAsync();
        }

        // GET: api/WaterData/5
        [HttpGet("{id}")]
        public async Task<ActionResult<WaterDataFrame>> GetWaterData(int id)
        {
            if (_context.WaterData == null)
            {
                return NotFound();
            }

            var waterData = await _context.WaterData.FindAsync(id);

            if (waterData == null)
            {
                return NotFound();
            }

            return waterData;
        }

        //// GET: api/WaterData/5
        //[HttpGet("{index}")]
        //public async Task<ActionResult<IEnumerable<WaterDataFrame>>> GetWaterData(int index)
        //{
        //    if (_context.WaterData == null)
        //    {
        //        return NotFound();
        //    }

        //    var waterData = await _context.WaterData.Where(x => x.index == index)
        //        .ToListAsync();

        //    if (waterData == null)
        //    {
        //        return NotFound();
        //    }

        //    return waterData;
        //}


        // GET: api/WaterData/-1/1/1
        //[HttpGet("{patchIdx}/{warmingIdx}/{dateIdx}")]
        //public async Task<ActionResult<IEnumerable<CubeData>>> GetWaterData(int patchIdx, int warmingIdx, int dateIdx)
        //{
        //    if (_context.CubeData == null)
        //    {
        //        return NotFound();
        //    }

        //    var cubeData = await _context.CubeData
        //        .Where(x => x.patchIdx == patchIdx && x.warmingIdx == warmingIdx && x.dateIdx == dateIdx).ToListAsync();

        //    if (cubeData == null)
        //    {
        //        return NotFound();
        //    }

        //    return cubeData;
        //}


        // GET: api/CubeData/-1/1/1/10
        //[HttpGet("{patchIdx}/{warmingIdx}/{dateIdxStart}/{dateIdxEnd}")]
        //public async Task<ActionResult<IEnumerable<CubeData>>> GetWaterData(int patchIdx, int warmingIdx,
        //    int dateIdxStart, int dateIdxEnd)
        //{
        //    if (_context.CubeData == null)
        //    {
        //        return NotFound();
        //    }

        //    var cubeData = await _context.CubeData.Where(x =>
        //        x.patchIdx == patchIdx && x.warmingIdx == warmingIdx && x.dateIdx > dateIdxStart &&
        //        x.dateIdx < dateIdxEnd).ToListAsync();

        //    if (cubeData == null)
        //    {
        //        return NotFound();
        //    }

        //    return cubeData;
        //}

        private bool WaterDataExists(int id)
        {
            return (_context.WaterData?.Any(e => e.index == id)).GetValueOrDefault();
        }
        
    }
}
