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
    public class WaterDataController : ControllerBase
    {
        /// <summary>
        /// Water Data Controller
        /// </summary>
        private readonly WaterDataDbContext _context;

        public WaterDataController(WaterDataDbContext context)
        {
            _context = context;
        }

        // GET: api/WaterData
        [HttpGet]
        public async Task<ActionResult<IEnumerable<WaterDataFrame>>> GetWaterData()
        {
            if (!_context.WaterData.Any())
            {
                return NotFound();
            }

            return await _context.WaterData.ToListAsync();
        }


        // GET: api/WaterData/5
        [HttpGet("{index}")]
        public async Task<ActionResult<WaterDataFrame>> GetWaterData(int index)
        {
            if (_context.WaterData == null)
            {
                return NotFound();
            }

            var waterData = _context.WaterData.Where(x => x.index == index).FirstOrDefault();

            if (waterData == null)
            {
                return NotFound();
            }

            return waterData;
        }

        // GET: api/WaterData/5/15
        [HttpGet("{startIdx}/{endIdx}")]
        public async Task<ActionResult<IEnumerable<WaterDataFrame>>> GetWaterDataRange(int startIdx, int endIdx)
        {
            if (_context.WaterData == null)
            {
                return NotFound();
            }

            var waterData = await _context.WaterData.Where(x => x.index >= startIdx &&
                                                                x.index <= endIdx).ToListAsync();

            if (waterData == null)
            {
                return NotFound();
            }

            return waterData;
        }


        // GET: api/WaterData/max/4
        [HttpGet("max/{warmingIdx}")]
        public ActionResult<float> GetQMaxForWarmingIdx(int warmingIdx = -1)
        {
            if (!_context.WaterData.Any())
            {
                return NotFound();
            }

            float max = 0f;
            switch (warmingIdx)
            {
                case 0:
                    max = _context.WaterData.Max(x => x.QBase);
                    break;
                case 1:
                    max = _context.WaterData.Max(x => x.QWarm1);
                    break;
                case 2:
                    max = _context.WaterData.Max(x => x.QWarm2);
                    break;
                case 3:
                    max = _context.WaterData.Max(x => x.QWarm4);
                    break;
                case 4:
                    max = _context.WaterData.Max(x => x.QWarm6);
                    break;
                default:
                    break;
            }

            return max;
        }


        // GET: api/WaterData/min/4
        [HttpGet("min/{warmingIdx}")]
        public ActionResult<float> GetPrecipitationMinForWarmingIdx(int warmingIdx)
        {
            if (!_context.WaterData.Any())
            {
                return NotFound();
            }

            float min = 0f;
            switch (warmingIdx)
            {
                case 0:
                    min = _context.WaterData.Min(x => x.QBase);
                    break;
                case 1:
                    min = _context.WaterData.Min(x => x.QWarm1);
                    break;
                case 2:
                    min = _context.WaterData.Min(x => x.QWarm2);
                    break;
                case 3:
                    min = _context.WaterData.Min(x => x.QWarm4);
                    break;
                case 4:
                    min = _context.WaterData.Min(x => x.QWarm6);
                    break;
                default:
                    break;
            }

            return min;
        }

        // GET: api/WaterData/min/4
        [HttpGet("total/{year}")]
        public ActionResult<float> GetTotalPrecipitationForYear(int year)
        {
            if (!_context.WaterData.Any())
            {
                return NotFound();
            }

            float total = _context.WaterData.Where(x => x.year == year).Sum(x => x.precipitation);
            return total;
        }


        // GET: api/WaterData/min/4
        [HttpGet("total")]
        public ActionResult<List<PrecipByYear>> GetTotalPrecipitationForAllYears()
        {
            if (!_context.WaterData.Any())
            {
                return NotFound();
            }

            int year = 1942;
            int firstYear = _context.WaterData.Min(x => x.year);

            //var distinctPeople = people.DistinctBy(p => p.Id);
            //_ = blogs.DistinctBy(b => b.Id);
            //_ = blogs.GroupBy(b => b.Id).Select(g => g.First());

            //List<WaterDataFrame> years = _context.WaterData.DistinctBy(x => x.year).ToList();
            List<WaterDataFrame> years = _context.WaterData.GroupBy(x => x.year)
                                        .Select(y => y.First()).ToList();
            List<PrecipByYear> precipByYearList = new List<PrecipByYear>();

            for (int i = 0; i < years.Count(); i++)
            {
                int testYear = years[i].year;
                year = i + firstYear;

                //float total = _context.WaterData.Where(x => x.year == year).Sum(x => x.precipitation);
                float total = _context.WaterData.Where(x => x.year == year)
                    .Select(x => x.precipitation).Sum();
                
                PrecipByYear py = new PrecipByYear();
                py.precipitation = total;
                py.year = year;

                precipByYearList.Add(py);
            }

            return precipByYearList;
        }


        // GET: api/WaterData/min/4
        [HttpGet("maxtotal")]
        public ActionResult<float> GetMaxTotalPrecipitationPerYear()
        {
            if (!_context.WaterData.Any())
            {
                return NotFound();
            }

            int year = 1942;
            int firstYear = _context.WaterData.Min(x => x.year);

            List<WaterDataFrame> years = _context.WaterData.GroupBy(x => x.year)
                .Select(y => y.First()).ToList();
            List<PrecipByYear> precipByYearList = new List<PrecipByYear>();

            for (int i = 0; i < years.Count(); i++)
            {
                int testYear = years[i].year;
                year = i + firstYear;

                //float total = _context.WaterData.Where(x => x.year == year).Sum(x => x.precipitation);
                float total = _context.WaterData.Where(x => x.year == year)
                    .Select(x => x.precipitation).Sum();

                PrecipByYear py = new PrecipByYear();
                py.precipitation = total;
                py.year = year;

                precipByYearList.Add(py);
            }

            float max = -1000;
            foreach (PrecipByYear py in precipByYearList)
            {
                if(py.precipitation > max)
                    max = py.precipitation;
            }

            return max;
        }

        // GET: api/WaterData/-1/1/1
        //[HttpGet("{patchIdx}/{warmingIdx}/{dateIdx}")]
        //public async Task<ActionResult<IEnumerable<CubeData>>> GetWaterData(int patchIdx, int warmingIdx, int dateIdx)
        //{
        //    if (_context.CubeData == null)
        //    {
        //        return NotFound();
        //    }

        //    var cubeData = await _context.CubeData
        //        .Where(x => x.patchIdx == patchIdx && x.warmingIdx == warmingIdx && x.dateIdx == dateIdx).ToListAsync();

        //    if (cubeData == null)
        //    {
        //        return NotFound();
        //    }

        //    return cubeData;
        //}


        // GET: api/CubeData/-1/1/1/10
        //[HttpGet("{patchIdx}/{warmingIdx}/{dateIdxStart}/{dateIdxEnd}")]
        //public async Task<ActionResult<IEnumerable<CubeData>>> GetWaterData(int patchIdx, int warmingIdx,
        //    int dateIdxStart, int dateIdxEnd)
        //{
        //    if (_context.CubeData == null)
        //    {
        //        return NotFound();
        //    }

        //    var cubeData = await _context.CubeData.Where(x =>
        //        x.patchIdx == patchIdx && x.warmingIdx == warmingIdx && x.dateIdx > dateIdxStart &&
        //        x.dateIdx < dateIdxEnd).ToListAsync();

        //    if (cubeData == null)
        //    {
        //        return NotFound();
        //    }

        //    return cubeData;
        //}

        private bool WaterDataExists(int id)
        {
            return (_context.WaterData?.Any(e => e.index == id)).GetValueOrDefault();
        }
        
    }
}
