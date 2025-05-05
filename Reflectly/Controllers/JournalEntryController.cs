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
            protected readonly ILogger<JournalEntryController> _logger;

            public JournalEntryController(ILogger<JournalEntryController> logger, IJournalEntryService service)
            {
                _logger = logger;
                _service = service;
            }

            [HttpGet()]
            public async Task<IEnumerable<Model.JournalEntry>> Get()
            {
                return await _service.Get();
            }


        //[HttpGet()]
        //public Model.JournalEntry Insert(JournalEntryInsertRequest request)
        //{
        //    return _service.Insert(request);
        //}

        [HttpPut("{id}/activate")]
        public virtual async Task<Model.JournalEntry> Submit(int id)
        {
            return await (_service as IJournalEntryService).Submit(id);
        }


        /*[HttpPut("{id}")]
        public Model.JournalEntry Update(int id, JournalEntryUpdateRequest request)
        {
            return _service.Update(id, request);
        }*/

    }
}
