using Microsoft.AspNetCore.Mvc;
using Reflectly.Model.Requests;
using Reflectly.Services;
using Reflectly.Model;


namespace Reflectly.Controllers
{
    [ApiController]
        [Route("[controller]")]

        public class JournalEntryController : ControllerBase
    {
            protected readonly IJournalEntryService _service;
            protected readonly ILogger<WeatherForecastController> _logger;

            public JournalEntryController(ILogger<WeatherForecastController> logger, IJournalEntryService service)
            {
                _logger = logger;
                _service = service;
            }

            [HttpGet()]
            public async Task<IEnumerable<Model.JournalEntry>> Get()
            {
                return await _service.Get();
            }

        //Dodati u User Controller
        //[HttpGet()]
        //public Model.JournalEntry Insert(JournalEntryInsertRequest request)
        //{
        //    return _service.Insert(request);
        //}
        [HttpPut("{id}")]
        public Model.JournalEntry Update(int id, JournalEntryUpdateRequest request)
        {
            return _service.Update(id, request);
        }

        }
}
