using Reflectly.Model.Requests;
using Reflectly.Model.SearchObjects;
using Reflectly.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using Reflectly.Services.Database;

namespace Reflectly.Services
{
    public class BreathingExercisesSessionService : BaseService<Model.BreathingExerciseSession, Database.BreathingExerciseSession, BreathingExercisesSessionSearchObject>, IBreathingExercisesSessionService
    {
        public BreathingExercisesSessionService(ReflectlyContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
