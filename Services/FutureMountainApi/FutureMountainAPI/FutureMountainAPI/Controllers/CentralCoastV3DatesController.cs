using FutureMountainAPI.DAL;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI.Controllers
{
    [Route("api/centralcoastv3/Dates")]
    [ApiController]
    public class CentralCoastV3DatesController : ControllerBase
    {
        private readonly CentralCoastV3DbContext _context;

        public CentralCoastV3DatesController(CentralCoastV3DbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Date>>> GetDates()
        {
            if (_context.Dates == null)
            {
                return NotFound();
            }

            return await _context.Dates.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Date>> GetDate(int id)
        {
            var date = await _context.Dates.FindAsync(id);

            if (date == null)
            {
                return NotFound();
            }

            return date;
        }

        [HttpGet("{year}/{month}/{day}")]
        public async Task<ActionResult<IEnumerable<Date>>> GetDate(int year, int month, int day)
        {
            var date = await _context.Dates
                .Where(row => row.year == year && row.month == month && row.day == day)
                .ToListAsync();

            if (!date.Any())
            {
                return NotFound();
            }

            return date;
        }
    }
}
