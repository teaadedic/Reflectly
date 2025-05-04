using Reflectly.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Reflectly.Model;
using AutoMapper;
using Microsoft.EntityFrameworkCore;

namespace Reflectly.Services
{
    public class JournalEntryService : IJournalEntryService
    {

        ReflectlyContext _context;

        public IMapper _mapper {  get; set; }

        public JournalEntryService(ReflectlyContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<Model.JournalEntry>> Get()
        {
            var entitnyList = await _context.JournalEntries.ToListAsync();

            //var list= new List<Model.JournalEntry>();
            //foreach (var journalEntry in entitnyList)
            //{
            //    list.Add(new Model.JournalEntry() 
            //    {
            //         UserId = journalEntry.UserId,
            //         JournalEntryId = journalEntry.JournalEntryId,
            //         PromptText = journalEntry.PromptText, 
            //         ResponseText = journalEntry.ResponseText,
            //         Timestamp = journalEntry.Timestamp,
            //         LinkedMoodEntryId = journalEntry.LinkedMoodEntryId,

            //    });
            //}

            //return list;

            return _mapper.Map<List<Model.JournalEntry>>(entitnyList);
        }

    }
}
 