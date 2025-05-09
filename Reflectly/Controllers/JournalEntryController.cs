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

        [HttpPut("{id}/activate")]
        public virtual async Task<Model.JournalEntry> Submit(int id)
        {
            return await (_service as IJournalEntryService).Submit(id);
        }

    }
}
