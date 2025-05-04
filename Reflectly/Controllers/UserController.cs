using Microsoft.AspNetCore.Mvc;
using Reflectly.Services;
using Microsoft.AspNetCore.Mvc;
using Reflectly.Model.Requests;
using Reflectly.Model;

namespace Reflectly.Controllers
{
        [ApiController]
        [Route("[controller]")]

        public class UserController : ControllerBase
        {
            protected readonly IUserService _service;
            protected readonly ILogger<WeatherForecastController> _logger;

            public UserController(ILogger<WeatherForecastController> logger, IUserService service)
            {
                _logger = logger;
                _service = service;
            }

            [HttpGet()]

            public async Task<IEnumerable<Model.User>> Get()
            {
                return await _service.Get();
            }

            [HttpGet()]
            public Model.User Insert(UserInsertRequest request)
            {
                return _service.Insert(request);
            }

            [HttpPut("{id}")]
            public Model.User Update(int id, UserUpdateRequest request)
            {
                return _service.Update(id, request);
            }

        }
}
