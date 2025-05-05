using Reflectly.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Reflectly.Model;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Reflectly.Model.Requests;
using Reflectly.Services.JournalEntryStateMachine;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace Reflectly.Services
{
    public class JournalEntryService : IJournalEntryService
    {

        ReflectlyContext _context;

        public IMapper _mapper {  get; set; }

        public BaseState _baseState { get; set; }

        public JournalEntryService(BaseState baseState, ReflectlyContext context, IMapper mapper) : base(context, mapper) 
        {
            _context = context;
            _mapper = mapper;
            _baseState = baseState;
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

        public override Task<Model.JournalEntry> Insert(JournalEntryInsertRequest insert)
        {
            var state = _baseState.CreateState("initial");

            return state.Insert(insert);
        }

        public override async Task<Model.JournalEntry> Update(int id, JournalEntryUpdateRequest update)
        {
            var entity = await _context.JournalEntries.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);
            
            return await state.Update(id, update);
        }

        public async Task<Model.JournalEntry> Submit(int id)
        {
            var entity = await _context.JournalEntries.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Submit(id);
        }

        /*public Model.JournalEntry Update(int id, JournalEntryUpdateRequest request)
        {
            throw new NotImplementedException();
        }*/
    }
}
 