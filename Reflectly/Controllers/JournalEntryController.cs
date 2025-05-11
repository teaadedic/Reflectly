using Microsoft.AspNetCore.Mvc;
using Reflectly.Model.Requests;
using Reflectly.Services;
using Reflectly.Model;


namespace Reflectly.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class JournalEntryController : BaseCRUDController<Model.JournalEntry, Model.SearchObjects.JournalEntrySearchObject, Model.Requests.JournalEntryInsertRequest, Model.Requests.JournalEntryUpdateRequest>
    {


        public JournalEntryController(ILogger<BaseController<JournalEntry, Model.SearchObjects.JournalEntrySearchObject>> logger, IJournalEntryService service) : base(logger, service)
        {

        }

        [HttpPut("{id}/submit")]
        public virtual async Task<Model.JournalEntry> Submit(Guid id)
        {
            return await (_service as IJournalEntryService).Submit(id);
        }

        [HttpPut("{id}/archive")]
        public virtual async Task<Model.JournalEntry> Archive(Guid id)
        {
            return await (_service as IJournalEntryService).Archive(id);
        }


        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(Guid id)
        {
            return await (_service as IJournalEntryService).AllowedActions(id);
        }

    }
}
