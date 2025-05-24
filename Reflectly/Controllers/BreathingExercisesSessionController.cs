using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Reflectly.Model;
using Reflectly.Model.SearchObjects;
using Reflectly.Services;

namespace Reflectly.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]

    public class BreathingExercisesSessionController :BaseController<Model.BreathingExerciseSession, BreathingExercisesSessionSearchObject>
    {
        public BreathingExercisesSessionController(ILogger<BaseController<BreathingExerciseSession, Model.SearchObjects.BreathingExercisesSessionSearchObject>> logger, IBreathingExercisesSessionService service) : base(logger, service)
        {

        }
    }
}
