using Microsoft.AspNetCore.Mvc;
using Reflectly.Services;
using Reflectly.Model;
using Microsoft.AspNetCore.Authorization;

namespace Reflectly.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]

    public class MoodEntryController : BaseCRUDController<Model.MoodEntry, Model.SearchObjects.MoodEntrySearchObject, Model.Requests.MoodEntryInsertRequest, Model.Requests.MoodEntryUpdateRequest>
    {


        public MoodEntryController(ILogger<BaseController<MoodEntry, Model.SearchObjects.MoodEntrySearchObject>> logger, IMoodEntryService service) : base(logger, service)
        {

        }

    }
}
