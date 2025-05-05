using Reflectly.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Services
{
    public interface IMoodEntryService : IService<Model.MoodEntry, MoodEntrySearchObject>
    {
    }
}
