using Microsoft.AspNetCore.Mvc;
using Reflectly.Services;
using Reflectly.Model;


namespace Reflectly.Controllers
{
    [ApiController]

    public class MoodEntryController : BaseController<Model.MoodEntry, Model.SearchObjects.MoodEntrySearchObject>
    {

        public MoodEntryController(ILogger<BaseController<MoodEntry, Model.SearchObjects.MoodEntrySearchObject>> logger, IMoodEntryService service) 
            : base(logger, service)
        {
        }
    }
}
