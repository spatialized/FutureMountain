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

            return await _context.CubeData
                .Select(row => new CentralCoastCubeDataPrototypeDto
                {
                    id = row.id,
                    dateIdx = row.dateIdx,
                    warmingIdx = row.warmingIdx,
                    patchIdx = (int)row.patchID,
                    snow = 0,
                    evap = row.canopyevap + row.groundevap,
                    netpsn = row.netpsnOver + row.netpsnUnder,
                    depthToGW = row.depthToGW,
                    vegAccessWater = row.vegAccessWater,
                    qout = row.Qout,
                    litter = row.litterc,
                    soil = row.soilc,
                    heightOver = row.heightOver,
                    transOver = row.transOver,
                    heightUnder = row.heightUnder,
                    transUnder = row.transUnder,
                    leafCOver = row.leafCOver,
                    stemCOver = row.stemCOver,
                    rootCOver = row.rootCOver,
                    leafCUnder = row.leafCUnder,
                    stemCUnder = row.stemCUnder,
                    rootCUnder = row.rootCUnder
                })
                .ToListAsync();
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
            var cubeData = await _context.CubeData
                .Where(row => row.patchID == patchIdx && row.warmingIdx == warmingIdx)
                .Select(row => new CentralCoastCubeDataPrototypeDto
                {
                    id = row.id,
                    dateIdx = row.dateIdx,
                    warmingIdx = row.warmingIdx,
                    patchIdx = (int)row.patchID,
                    snow = 0,
                    evap = row.canopyevap + row.groundevap,
                    netpsn = row.netpsnOver + row.netpsnUnder,
                    depthToGW = row.depthToGW,
                    vegAccessWater = row.vegAccessWater,
                    qout = row.Qout,
                    litter = row.litterc,
                    soil = row.soilc,
                    heightOver = row.heightOver,
                    transOver = row.transOver,
                    heightUnder = row.heightUnder,
                    transUnder = row.transUnder,
                    leafCOver = row.leafCOver,
                    stemCOver = row.stemCOver,
                    rootCOver = row.rootCOver,
                    leafCUnder = row.leafCUnder,
                    stemCUnder = row.stemCUnder,
                    rootCUnder = row.rootCUnder
                })
                .ToListAsync();

            if (!cubeData.Any())
            {
                return NotFound();
            }

            return cubeData;
        }

        [HttpGet("{patchIdx}/{warmingIdx}/{dateIdx}")]
        public async Task<ActionResult<IEnumerable<CentralCoastCubeDataPrototypeDto>>> GetCubeData(
            int patchIdx,
            int warmingIdx,
            int dateIdx)
        {
            var cubeData = await _context.CubeData
                .Where(row => row.patchID == patchIdx && row.warmingIdx == warmingIdx && row.dateIdx == dateIdx)
                .Select(row => new CentralCoastCubeDataPrototypeDto
                {
                    id = row.id,
                    dateIdx = row.dateIdx,
                    warmingIdx = row.warmingIdx,
                    patchIdx = (int)row.patchID,
                    snow = 0,
                    evap = row.canopyevap + row.groundevap,
                    netpsn = row.netpsnOver + row.netpsnUnder,
                    depthToGW = row.depthToGW,
                    vegAccessWater = row.vegAccessWater,
                    qout = row.Qout,
                    litter = row.litterc,
                    soil = row.soilc,
                    heightOver = row.heightOver,
                    transOver = row.transOver,
                    heightUnder = row.heightUnder,
                    transUnder = row.transUnder,
                    leafCOver = row.leafCOver,
                    stemCOver = row.stemCOver,
                    rootCOver = row.rootCOver,
                    leafCUnder = row.leafCUnder,
                    stemCUnder = row.stemCUnder,
                    rootCUnder = row.rootCUnder
                })
                .ToListAsync();

            if (!cubeData.Any())
            {
                return NotFound();
            }

            return cubeData;
        }

        [HttpGet("{patchIdx}/{warmingIdx}/{dateIdxStart}/{dateIdxEnd}")]
        public async Task<ActionResult<IEnumerable<CentralCoastCubeDataPrototypeDto>>> GetCubeData(
            int patchIdx,
            int warmingIdx,
            int dateIdxStart,
            int dateIdxEnd)
        {
            var cubeData = await _context.CubeData
                .Where(row =>
                    row.patchID == patchIdx &&
                    row.warmingIdx == warmingIdx &&
                    row.dateIdx > dateIdxStart &&
                    row.dateIdx < dateIdxEnd)
                .Select(row => new CentralCoastCubeDataPrototypeDto
                {
                    id = row.id,
                    dateIdx = row.dateIdx,
                    warmingIdx = row.warmingIdx,
                    patchIdx = (int)row.patchID,
                    snow = 0,
                    evap = row.canopyevap + row.groundevap,
                    netpsn = row.netpsnOver + row.netpsnUnder,
                    depthToGW = row.depthToGW,
                    vegAccessWater = row.vegAccessWater,
                    qout = row.Qout,
                    litter = row.litterc,
                    soil = row.soilc,
                    heightOver = row.heightOver,
                    transOver = row.transOver,
                    heightUnder = row.heightUnder,
                    transUnder = row.transUnder,
                    leafCOver = row.leafCOver,
                    stemCOver = row.stemCOver,
                    rootCOver = row.rootCOver,
                    leafCUnder = row.leafCUnder,
                    stemCUnder = row.stemCUnder,
                    rootCUnder = row.rootCUnder
                })
                .ToListAsync();

            if (!cubeData.Any())
            {
                return NotFound();
            }

            return cubeData;
        }
    }
}
