using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FutureMountainAPI;

namespace FutureMountainAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DatesController : ControllerBase
    {
        private readonly DateDbContext _context;

        public DatesController(DateDbContext context)
        {
            _context = context;
        }

        // GET: api/Dates
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Date>>> GetDates()
        {
          if (_context.Dates == null)
          {
              return NotFound();
          }
            return await _context.Dates.ToListAsync();
        }

        // GET: api/Dates/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Date>> GetDate(int id)
        {
          if (_context.Dates == null)
          {
              return NotFound();
          }
            var date = await _context.Dates.FindAsync(id);

            if (date == null)
            {
                return NotFound();
            }

            return date;
        }

        // GET: api/Dates/1942/10/1
        [HttpGet("{year}/{month}/{day}")]
        public async Task<ActionResult<IEnumerable<Date>>> GetDate(int year, int month, int day)
        {
            if (_context.Dates == null)
            {
                return NotFound();
            }

            var date = await _context.Dates.Where(x => x.year == year && x.month == month && x.day == day).ToListAsync();

            if (date == null)
            {
                return NotFound();
            }

            return date;
        }

        // PUT: api/Dates/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutDate(int id, Date date)
        {
            if (id != date.id)
            {
                return BadRequest();
            }

            _context.Entry(date).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DateExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Dates
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Date>> PostDate(Date date)
        {
          if (_context.Dates == null)
          {
              return Problem("Entity set 'DateDbContext.Dates'  is null.");
          }
            _context.Dates.Add(date);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetDate", new { id = date.id }, date);
        }

        // DELETE: api/Dates/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteDate(int id)
        {
            if (_context.Dates == null)
            {
                return NotFound();
            }
            var date = await _context.Dates.FindAsync(id);
            if (date == null)
            {
                return NotFound();
            }

            _context.Dates.Remove(date);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool DateExists(int id)
        {
            return (_context.Dates?.Any(e => e.id == id)).GetValueOrDefault();
        }
    }
}
