using AutoMapper;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using Reflectly.Model;
using Reflectly.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;


namespace Reflectly.Services.JournalEntryStateMachine
{
    public class DraftJournalEntryState : BaseState
    {
        public DraftJournalEntryState(IServiceProvider serviceProvder, Database.ReflectlyContext context, IMapper mapper) : base(serviceProvder, context, mapper)
        {

        }
        public async Task<JournalEntry> Update(Guid id, JournalEntryUpdateRequest update)
        {
            var set = _context.Set<Database.JournalEntry>();

            var entity = await set.FindAsync(id);

            _mapper.Map(update, entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.JournalEntry>(entity);
        }
        public async Task<JournalEntry> Submit(Guid id)
        {
            var set = _context.Set<Database.JournalEntry>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "submit";

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.JournalEntry>(entity);
        }
    }
}
