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
    public class InitialJournalEntryState : BaseState
    {
        public InitialJournalEntryState(IServiceProvider serviceProvder, Database.ReflectlyContext context, IMapper mapper) : base(serviceProvder, context, mapper) 
        {

        }
        public override async Task<JournalEntry> Insert(JournalEntryInsertRequest request)
        {
            //TODO: EF CALL
            var set = _context.Set<Database.JournalEntry>();

            var entity = _mapper.Map<Database.JournalEntry>(request);

            entity.StateMachine = "draft";

            set.Add(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<JournalEntry>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await  base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
