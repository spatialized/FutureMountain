using FutureMountainAPI.DAL;
using FutureMountainAPI.Models.CentralCoastV3;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI.Controllers
{
    [Route("api/centralcoastv3/CubeData")]
    [ApiController]
    public class CentralCoastV3CubeDataController : ControllerBase
    {
        private readonly CentralCoastV3DbContext _context;

        public CentralCoastV3CubeDataController(CentralCoastV3DbContext context)
        {
            _context = context;
        }

        // [HttpGet]
        // public async Task<ActionResult<IEnumerable<CentralCoastV3CubeDataPrototypeDto>>> GetCubeData()
        // {
        //     if (!_context.CubeData.Any())
        //     {
        //         return NotFound();
        //     }

        //     var rows = await _context.CubeData.ToListAsync();
        //     return rows.Select(CentralCoastV3CubeDataPrototypeDto.FromRow).ToList();
        // }

        // [HttpGet("{id}")]
        // public async Task<ActionResult<CentralCoastV3CubeDataPrototypeDto>> GetCubeData(int id)
        // {
        //     var cubeData = await _context.CubeData.FindAsync(id);

        //     if (cubeData == null)
        //     {
        //         return NotFound();
        //     }

        //     return CentralCoastV3CubeDataPrototypeDto.FromRow(cubeData);
        // }

        [HttpGet("{patchIdx}/{scenarioIdx}")]
        public async Task<ActionResult<IEnumerable<CentralCoastV3CubeDataPrototypeDto>>> GetCubeData(int patchIdx, int scenarioIdx)
        {
            var rows = await _context.CubeData
                .Where(row => row.patchID == patchIdx && row.scenarioIdx == scenarioIdx)
                .ToListAsync();

            if (!rows.Any())
            {
                return NotFound();
            }

            return rows.Select(CentralCoastV3CubeDataPrototypeDto.FromRow).ToList();
        }

        [HttpGet("{patchIdx}/{scenarioIdx}/{dateIdx}")]
        public async Task<ActionResult<IEnumerable<CentralCoastV3CubeDataPrototypeDto>>> GetCubeData(
            int patchIdx,
            int scenarioIdx,
            int dateIdx)
        {
            var rows = await _context.CubeData
                .Where(row => row.patchID == patchIdx && row.scenarioIdx == scenarioIdx && row.dateIdx == dateIdx)
                .ToListAsync();

            if (!rows.Any())
            {
                return NotFound();
            }

            return rows.Select(CentralCoastV3CubeDataPrototypeDto.FromRow).ToList();
        }

        [HttpGet("{patchIdx}/{scenarioIdx}/{dateIdxStart}/{dateIdxEnd}")]
        public async Task<ActionResult<IEnumerable<CentralCoastV3CubeDataPrototypeDto>>> GetCubeData(
            int patchIdx,
            int scenarioIdx,
            int dateIdxStart,
            int dateIdxEnd)
        {
            var rows = await _context.CubeData
                .Where(row =>
                    row.patchID == patchIdx &&
                    row.scenarioIdx == scenarioIdx &&
                    row.dateIdx > dateIdxStart &&
                    row.dateIdx < dateIdxEnd)
                .ToListAsync();

            if (!rows.Any())
            {
                return NotFound();
            }

            return rows.Select(CentralCoastV3CubeDataPrototypeDto.FromRow).ToList();
        }
    }
}
