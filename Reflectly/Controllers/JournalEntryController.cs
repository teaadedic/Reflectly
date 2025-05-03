using Microsoft.AspNetCore.Mvc;
using Reflectly.Services;


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
            public IEnumerable<Model.JournalEntry> Get()
            {
                return  _service.Get();
            }
        }
}
