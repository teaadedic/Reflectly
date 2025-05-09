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

        //Ovo ne radi ni sa int id ni sa Guid veze se za IJournalEntryService
        /*public override async Task<Model.JournalEntry> Update(int id, JournalEntryUpdateRequest update)
        {
            var entity = await _context.JournalEntries.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);
            return await state.Update(id, update);
        }*/

        public async Task<Model.JournalEntry> Submit(int id)
        {
            var entity = await _context.JournalEntries.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Submit(id);
        }
    }
}
 