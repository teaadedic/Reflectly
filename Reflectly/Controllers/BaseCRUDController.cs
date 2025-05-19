using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Reflectly.Model;
using Reflectly.Model.SearchObjects;
using Reflectly.Services;

namespace Reflectly.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class BaseCRUDController<T, TSearch, TInsert, TUpdate> : BaseController<T, TSearch> where T : class where TSearch : class
    {
        public readonly ICRUDService<T, TSearch, TInsert, TUpdate> _service;
        private readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseCRUDController(ILogger<BaseController<T, TSearch>> logger, ICRUDService<T, TSearch, TInsert, TUpdate> service)
            : base(logger, service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpPost]
        [Authorize]
        public virtual async Task<T> Insert([FromBody]TInsert insert)
        {
            return await _service.Insert(insert);
        }

        [HttpPut ("{id}")]
        public virtual async Task<T> Update([FromRoute] Guid id, [FromBody] TUpdate update)
        {
            return await _service.Update(id, update);
        }

    }
    
}
