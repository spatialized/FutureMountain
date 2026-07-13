 using FutureMountainAPI.Models;
  using Microsoft.AspNetCore.Mvc;

  namespace FutureMountainAPI.Controllers
  {
      [Route("api/centralcoastv3/FireData")]
      [ApiController]
      public class CentralCoastV3FireDataController : ControllerBase
      {
          [HttpGet("{scenarioIdx}")]
          public ActionResult<List<FireDataFrameJSONRecord>> GetFireData(int scenarioIdx)
          {
              return new List<FireDataFrameJSONRecord>();
          }
      }
  }