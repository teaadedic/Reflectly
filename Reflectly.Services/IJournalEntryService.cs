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
        Task<JournalEntry> Submit(Guid id);
        
        Task<JournalEntry> Update(Guid id, JournalEntryUpdateRequest update);

        Task<JournalEntry> Archive(Guid id);

        Task<List<string>> AllowedActions(Guid id);

        //Task<List<Model.JournalEntry>> Get();
        //JournalEntry Insert(JournalEntryInsertRequest request);
    }
}




