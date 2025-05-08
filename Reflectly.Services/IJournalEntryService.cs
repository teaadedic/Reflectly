using Reflectly.Model;
using Reflectly.Model.Requests;
using Reflectly.Model.SearchObjects;
using Reflectly.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Services
{
    public interface IJournalEntryService: ICRUDService<JournalEntry,JournalEntrySearchObject, JournalEntryInsertRequest, JournalEntryUpdateRequest>
    {
        
    }
}




