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
using Microsoft.Extensions.Logging;

namespace Reflectly.Services.JournalEntryStateMachine
{
    public class DraftJournalEntryState : BaseState
    {

        protected ILogger<DraftJournalEntryState> _logger;

        public DraftJournalEntryState(ILogger<DraftJournalEntryState> logger, IServiceProvider serviceProvder, Database.ReflectlyContext context, IMapper mapper) : base(serviceProvder, context, mapper)
        {
            _logger = logger;
        }
        public async Task<JournalEntry> Update(Guid id, JournalEntryUpdateRequest update)
        {
            var set = _context.Set<Database.JournalEntry>();

            var entity = await set.FindAsync(id);

            _mapper.Map(update, entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.JournalEntry>(entity);
        }


        public override async Task<JournalEntry> Submit(Guid id)
        {

            _logger.LogInformation($" Submiting entry:  {id}");

            _logger.LogWarning($"W: Submiting entry:  {id}");

            _logger.LogError($"E : Submiting entry:  {id}");

            var set = _context.Set<Database.JournalEntry>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "submit";

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.JournalEntry>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Submit");

            return list;
        }
    }
}
