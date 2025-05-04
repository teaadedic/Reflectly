using Reflectly.Model;
using Reflectly.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Services
{
    public interface IJournalEntryService
    {
        Task<List<Model.JournalEntry>> Get();
        //JournalEntry Insert(JournalEntryInsertRequest request);
        JournalEntry Update(int id, JournalEntryUpdateRequest request);
    }
}


