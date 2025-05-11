using AutoMapper;
using Microsoft.Extensions.DependencyInjection;
using Reflectly.Model;
using Reflectly.Model.Requests;
using Reflectly.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Services.JournalEntryStateMachine
{
    public class BaseState
    {
        protected ReflectlyContext _context;

        protected IMapper _mapper { get; set; }

        public IServiceProvider _serviceProvider { get; set; }

        public BaseState(IServiceProvider serviceProvder,ReflectlyContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvder;
        }
        public virtual Task<Model.JournalEntry> Insert(JournalEntryInsertRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.JournalEntry> Update(Guid id,JournalEntryUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.JournalEntry> Submit(Guid id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.JournalEntry> Archive(Guid id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.JournalEntry> Delete(Guid id)
        {
            throw new UserException("Not allowed");
        }

        public BaseState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                case null:
                    return _serviceProvider.GetService<InitialJournalEntryState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftJournalEntryState>();
                    break;
                case "submit":
                    return _serviceProvider.GetService<SubmitJournalEntryState>();
                    break;
                default:
                    throw new UserException("Not allowed");
            }
        }


        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }
    }
}
