using Reflectly.Model.Requests;
using Reflectly.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Services
{
    public interface IMoodEntryService : ICRUDService<Model.MoodEntry, MoodEntrySearchObject,MoodEntryInsertRequest, MoodEntryUpdateRequest>
    {
        
    }
    
}
