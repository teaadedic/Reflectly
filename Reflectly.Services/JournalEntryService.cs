using Reflectly.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Reflectly.Model;

namespace Reflectly.Services
{
    public class JournalEntryService : IJournalEntryService
    {

        ReflectlyContext _context;

        public JournalEntryService(ReflectlyContext context)
        {
            _context = context;
        }

        public List<Model.JournalEntry> Get()
        {
            var entitnyList = _context.JournalEntries.ToList();

            var list= new List<Model.JournalEntry>();
            foreach (var journalEntry in entitnyList)
            {
                list.Add(new Model.JournalEntry() 
                {
                     UserId = journalEntry.UserId,
                     JournalEntryId = journalEntry.JournalEntryId,
                     PromptText = journalEntry.PromptText, 
                     ResponseText = journalEntry.ResponseText,
                     Timestamp = journalEntry.Timestamp,
                     LinkedMoodEntryId = journalEntry.LinkedMoodEntryId,

                });
            }

            return list;
        }

    }
}
 