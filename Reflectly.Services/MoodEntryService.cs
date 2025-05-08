using Microsoft.EntityFrameworkCore;
using Reflectly.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using Reflectly.Model.SearchObjects;
using Reflectly.Model.Requests;

namespace Reflectly.Services
{
    public class MoodEntryService : BaseCRUDService<Model.MoodEntry, Database.MoodEntry, MoodEntrySearchObject, MoodEntryInsertRequest, MoodEntryUpdateRequest>, IMoodEntryService
    {
        public MoodEntryService(ReflectlyContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
