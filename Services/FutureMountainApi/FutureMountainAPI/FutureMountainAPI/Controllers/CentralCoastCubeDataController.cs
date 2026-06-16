using FutureMountainAPI.DAL;
using FutureMountainAPI.Models.CentralCoast;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI.Controllers
{
    [Route("api/centralcoast/CubeData")]
    [ApiController]
    public class CentralCoastCubeDataController : ControllerBase
    {
        private readonly CentralCoastDbContext _context;

        public CentralCoastCubeDataController(CentralCoastDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<CentralCoastCubeDataPrototypeDto>>> GetCubeData()
        {
            if (!_context.CubeData.Any())
            {
                return NotFound();
            }

            var rows = await _context.CubeData.ToListAsync();
            return rows.Select(CentralCoastCubeDataPrototypeDto.FromRow).ToList();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CentralCoastCubeDataPrototypeDto>> GetCubeData(int id)
        {
            var cubeData = await _context.CubeData.FindAsync(id);

            if (cubeData == null)
            {
                return NotFound();
            }

            return CentralCoastCubeDataPrototypeDto.FromRow(cubeData);
        }

        [HttpGet("{patchIdx}/{warmingIdx}")]
        public async Task<ActionResult<IEnumerable<CentralCoastCubeDataPrototypeDto>>> GetCubeData(int patchIdx, int warmingIdx)
        {
            var rows = await _context.CubeData
                .Where(row => row.patchID == patchIdx && row.warmingIdx == warmingIdx)
                .ToListAsync();

            if (!rows.Any())
            {
                return NotFound();
            }

            return rows.Select(CentralCoastCubeDataPrototypeDto.FromRow).ToList();
        }

        [HttpGet("{patchIdx}/{warmingIdx}/{dateIdx}")]
        public async Task<ActionResult<IEnumerable<CentralCoastCubeDataPrototypeDto>>> GetCubeData(
            int patchIdx,
            int warmingIdx,
            int dateIdx)
        {
            var rows = await _context.CubeData
                .Where(row => row.patchID == patchIdx && row.warmingIdx == warmingIdx && row.dateIdx == dateIdx)
                .ToListAsync();

            if (!rows.Any())
            {
                return NotFound();
            }

            return rows.Select(CentralCoastCubeDataPrototypeDto.FromRow).ToList();
        }

        [HttpGet("{patchIdx}/{warmingIdx}/{dateIdxStart}/{dateIdxEnd}")]
        public async Task<ActionResult<IEnumerable<CentralCoastCubeDataPrototypeDto>>> GetCubeData(
            int patchIdx,
            int warmingIdx,
            int dateIdxStart,
            int dateIdxEnd)
        {
            var rows = await _context.CubeData
                .Where(row =>
                    row.patchID == patchIdx &&
                    row.warmingIdx == warmingIdx &&
                    row.dateIdx > dateIdxStart &&
                    row.dateIdx < dateIdxEnd)
                .ToListAsync();

            if (!rows.Any())
            {
                return NotFound();
            }

            return rows.Select(CentralCoastCubeDataPrototypeDto.FromRow).ToList();
        }
    }
}
