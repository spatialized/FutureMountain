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
    public class FireDataController : ControllerBase
    {
        /// <summary>
        /// Fire Data Controller
        /// </summary>
        private readonly FireDataDbContext _context;

        public FireDataController(FireDataDbContext context)
        {
            _context = context;
        }

        // GET: api/CubeData
        [HttpGet]
        public async Task<ActionResult<IEnumerable<FireDataFrameJSONRecord>>> GetFireData()
        {
            if (!_context.FireData.Any())
            {
                return NotFound();
            }

            return await _context.FireData.ToListAsync();
        }


        // GET: api/FireData/5
        [HttpGet("{warmingIdx}")]
        public async Task<ActionResult<List<FireDataFrameJSONRecord>>> GetFireData(int warmingIdx)
        {
            if (_context.FireData == null)
            {
                return NotFound();
            }

            var fireData = _context.FireData.Where(x => x.warmingIdx == warmingIdx);

            if (!fireData.Any())
            {
                return NotFound();
            }

            return fireData.ToList();
        }

        // GET: api/FireData/5/15
        //[HttpGet("{startIdx}/{endIdx}")]
        //public async Task<ActionResult<IEnumerable<FireDataFrameJSONRecord>>> GetFireDataRange(int startIdx, int endIdx)
        //{
        //    if (_context.FireData == null)
        //    {
        //        return NotFound();
        //    }

        //    var fireData = await _context.FireData.Where(x => x.warmingIdx >= startIdx &&
        //                                                        x.warmingIdx <= endIdx).ToListAsync();

        //    if (fireData == null)
        //    {
        //        return NotFound();
        //    }

        //    return fireData;
        //}

        
        private bool FireDataExists(int id)
        {
            return (_context.FireData?.Any(e => e.id == id)).GetValueOrDefault();
        }


        private bool FireDataExistsForWarmingIdx(int warmingIdx)
        {
            return (_context.FireData?.Any(e => e.warmingIdx == warmingIdx)).GetValueOrDefault();
        }

    }
}
