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
using Reflectly.Model.SearchObjects;
using Reflectly.Services.JournalEntryStateMachine;

namespace Reflectly.Services
{
    public class JournalEntryService : BaseCRUDService<Model.JournalEntry, Database.JournalEntry, JournalEntrySearchObject, JournalEntryInsertRequest, JournalEntryUpdateRequest>, IJournalEntryService
    {
        public BaseState _baseState { get; set; }
        public JournalEntryService(BaseState baseState, ReflectlyContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState; 
        }
        
        public override Task<Model.JournalEntry> Insert(JournalEntryInsertRequest insert)
        {
            var state = _baseState.CreateState("initial");

            return state.Insert(insert);
        }

        
        public async Task<Model.JournalEntry> Update(Guid id, JournalEntryUpdateRequest update)
        {
            var entity = await _context.JournalEntries.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);
            return await state.Update(id, update);
        }
         
        public async Task<Model.JournalEntry> Submit(Guid id)
        {
            var entity = await _context.JournalEntries.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Submit(id);
        }

        public async Task<Model.JournalEntry> Archive(Guid id)
        {
            var entity = await _context.JournalEntries.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Archive(id);
        }

        public async Task<List<string>> AllowedActions(Guid id)
        {
            var entity = await _context.JournalEntries.FindAsync(id);

            var state = _baseState.CreateState(entity?.StateMachine ?? "initial");

            return await state.AllowedActions();
        }

        //public Task<List<Model.JournalEntry>> Get()
        //{
        //    throw new NotImplementedException();
        //}

        //Model.JournalEntry IJournalEntryService.Insert(JournalEntryInsertRequest request)
        //{
        //    throw new NotImplementedException();
        //}
    }
}
 