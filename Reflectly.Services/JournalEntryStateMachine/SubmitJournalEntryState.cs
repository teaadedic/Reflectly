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


namespace Reflectly.Services.JournalEntryStateMachine
{
    public class SubmitJournalEntryState : BaseState
    {
        public SubmitJournalEntryState(IServiceProvider serviceProvder, Database.ReflectlyContext context, IMapper mapper) : base(serviceProvder, context, mapper)
        {

        }

        public override async Task<JournalEntry> Archive(Guid id)
        {
                var set = _context.Set<Database.JournalEntry>();

                var entity = await set.FindAsync(id);

                entity.StateMachine = "draft";

                await _context.SaveChangesAsync();
                return _mapper.Map<Model.JournalEntry>(entity);
     
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Archive");

            return list;
        }

    }
}
