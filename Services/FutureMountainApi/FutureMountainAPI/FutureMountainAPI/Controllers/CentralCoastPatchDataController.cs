using FutureMountainAPI.DAL;
using FutureMountainAPI.Models.CentralCoast;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI.Controllers
{
    [Route("api/centralcoast/PatchData")]
    [ApiController]
    public class CentralCoastPatchDataController : ControllerBase
    {
        private readonly CentralCoastDbContext _context;

        public CentralCoastPatchDataController(CentralCoastDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<CentralCoastPatchDataPrototypeDto>>> GetPatchData()
        {
            if (!_context.PatchData.Any())
            {
                return NotFound();
            }

            return await _context.PatchData
                .Select(row => new CentralCoastPatchDataPrototypeDto
                {
                    id = row.id,
                    patchID = row.zoneID,
                    _data = row.data
                })
                .ToListAsync();
        }

        [HttpGet("{patchId}")]
        public async Task<ActionResult<List<CentralCoastPatchDataPrototypeDto>>> GetPatchData(int patchId)
        {
            var patchData = await _context.PatchData
                .Where(row => row.zoneID == patchId)
                .Select(row => new CentralCoastPatchDataPrototypeDto
                {
                    id = row.id,
                    patchID = row.zoneID,
                    _data = row.data
                })
                .ToListAsync();

            if (!patchData.Any())
            {
                return NotFound();
            }

            return patchData;
        }
    }
}
