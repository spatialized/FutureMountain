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
    public class CubeDataController : ControllerBase
    {
        private readonly CubeDataDbContext _context;

        public CubeDataController(CubeDataDbContext context)
        {
            _context = context;
        }

        // GET: api/CubeData
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CubeData>>> GetCubeData()
        {
          if (_context.CubeData == null)
          {
              return NotFound();
          }
            return await _context.CubeData.ToListAsync();
        }

        // GET: api/CubeData/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CubeData>> GetCubeData(int id)
        {
          if (_context.CubeData == null)
          {
              return NotFound();
          }
            var cubeData = await _context.CubeData.FindAsync(id);

            if (cubeData == null)
            {
                return NotFound();
            }

            return cubeData;
        }

        // PUT: api/CubeData/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPut("{id}")]
        //public async Task<IActionResult> PutCubeData(int id, CubeData cubeData)
        //{
        //    if (id != cubeData.id)
        //    {
        //        return BadRequest();
        //    }

        //    _context.Entry(cubeData).State = EntityState.Modified;

        //    try
        //    {
        //        await _context.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!CubeDataExists(id))
        //        {
        //            return NotFound();
        //        }
        //        else
        //        {
        //            throw;
        //        }
        //    }

        //    return NoContent();
        //}

        // POST: api/CubeData
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        //public async Task<ActionResult<CubeData>> PostCubeData(CubeData cubeData)
        //{
        //  if (_context.CubeData == null)
        //  {
        //      return Problem("Entity set 'CubeDataDbContext.CubeData'  is null.");
        //  }
        //    _context.CubeData.Add(cubeData);
        //    await _context.SaveChangesAsync();

        //    return CreatedAtAction("GetCubeData", new { id = cubeData.id }, cubeData);
        //}

        // DELETE: api/CubeData/5
        //[HttpDelete("{id}")]
        //public async Task<IActionResult> DeleteCubeData(int id)
        //{
        //    if (_context.CubeData == null)
        //    {
        //        return NotFound();
        //    }
        //    var cubeData = await _context.CubeData.FindAsync(id);
        //    if (cubeData == null)
        //    {
        //        return NotFound();
        //    }

        //    _context.CubeData.Remove(cubeData);
        //    await _context.SaveChangesAsync();

        //    return NoContent();
        //}

        private bool CubeDataExists(int id)
        {
            return (_context.CubeData?.Any(e => e.id == id)).GetValueOrDefault();
        }
    }
}
