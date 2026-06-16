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

namespace FutureMountainAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PatchDataController : ControllerBase
    {
        /// <summary>
        /// Patch Data Controller
        /// </summary>
        private readonly PatchDataDbContext _context;

        public PatchDataController(PatchDataDbContext context)
        {
            _context = context;
        }

        // GET: api/PatchData
        [HttpGet]
        public async Task<ActionResult<IEnumerable<PatchDataRecord>>> GetPatchData()
        {
            if (!_context.PatchData.Any())
            {
                return NotFound();
            }

            return await _context.PatchData.ToListAsync();
        }


        // GET: api/PatchData/1203612
        [HttpGet("{patchId}")]
        public async Task<ActionResult<List<PatchDataRecord>>> GetPatchData(int patchId)
        {
            if (_context.PatchData == null)
            {
                return NotFound();
            }

            var patchData = _context.PatchData.Where(x => x.patchID == patchId);

            if (!patchData.Any())
            {
                return NotFound();
            }

            return patchData.ToList();
        }
        
        private bool PatchDataExists(int id)
        {
            return (_context.PatchData?.Any(e => e.id == id)).GetValueOrDefault();
        }


        private bool PatchDataExistsForPatchId(int patchId)
        {
            return (_context.PatchData?.Any(e => e.patchID == patchId)).GetValueOrDefault();
        }

    }
}
