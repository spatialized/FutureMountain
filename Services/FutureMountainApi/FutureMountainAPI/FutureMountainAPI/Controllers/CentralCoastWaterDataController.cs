using FutureMountainAPI.DAL;
using FutureMountainAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI.Controllers
{
    [Route("api/centralcoast/WaterData")]
    [ApiController]
    public class CentralCoastWaterDataController : ControllerBase
    {
        private readonly CentralCoastDbContext _context;

        public CentralCoastWaterDataController(CentralCoastDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<WaterDataFrame>>> GetWaterData()
        {
            if (!_context.WaterData.Any())
            {
                return NotFound();
            }

            return await _context.WaterData
                .Join(_context.Dates,
                    water => water.dateIdx,
                    date => date.id,
                    (water, date) => new WaterDataFrame
                    {
                        index = water.dateIdx,
                        year = date.year,
                        month = date.month,
                        day = date.day,
                        QBase = water.streamflow,
                        QWarm1 = water.streamflow,
                        QWarm2 = water.streamflow,
                        QWarm4 = water.streamflow,
                        QWarm6 = water.streamflow,
                        precipitation = water.rain
                    })
                .ToListAsync();
        }

        [HttpGet("{index}")]
        public async Task<ActionResult<WaterDataFrame>> GetWaterData(int index)
        {
            var waterData = await _context.WaterData
                .Where(water => water.dateIdx == index || water.id == index)
                .Join(_context.Dates,
                    water => water.dateIdx,
                    date => date.id,
                    (water, date) => new WaterDataFrame
                    {
                        index = water.dateIdx,
                        year = date.year,
                        month = date.month,
                        day = date.day,
                        QBase = water.streamflow,
                        QWarm1 = water.streamflow,
                        QWarm2 = water.streamflow,
                        QWarm4 = water.streamflow,
                        QWarm6 = water.streamflow,
                        precipitation = water.rain
                    })
                .FirstOrDefaultAsync();

            if (waterData == null)
            {
                return NotFound();
            }

            return waterData;
        }

        [HttpGet("total")]
        public async Task<ActionResult<List<PrecipByYear>>> GetTotalPrecipitationForAllYears()
        {
            var totals = await _context.WaterData
                .Join(_context.Dates,
                    water => water.dateIdx,
                    date => date.id,
                    (water, date) => new { date.year, water.rain })
                .GroupBy(row => row.year)
                .Select(group => new PrecipByYear
                {
                    year = group.Key,
                    precipitation = group.Sum(row => row.rain)
                })
                .OrderBy(row => row.year)
                .ToListAsync();

            if (!totals.Any())
            {
                return NotFound();
            }

            return totals;
        }

        [HttpGet("maxtotal")]
        public async Task<ActionResult<float>> GetMaxTotalPrecipitationPerYear()
        {
            var totals = await _context.WaterData
                .Join(_context.Dates,
                    water => water.dateIdx,
                    date => date.id,
                    (water, date) => new { date.year, water.rain })
                .GroupBy(row => row.year)
                .Select(group => group.Sum(row => row.rain))
                .ToListAsync();

            if (!totals.Any())
            {
                return NotFound();
            }

            return totals.Max();
        }
    }
}
