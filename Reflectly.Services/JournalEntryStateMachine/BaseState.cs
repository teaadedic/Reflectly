using AutoMapper;
using Microsoft.Extensions.DependencyInjection;
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
            throw new Exception("Not allowed");
        }

        public virtual Task<Model.JournalEntry> Update(int id,JournalEntryUpdateRequest request)
        {
            throw new Exception("Not allowed");
        }

        public virtual Task<Model.JournalEntry> Submit(int id)
        {
            throw new Exception("Not allowed");
        }
        public virtual Task<Model.JournalEntry> Archive(int id)
        {
            throw new Exception("Not allowed");
        }

        public virtual Task<Model.JournalEntry> Delete(int id)
        {
            throw new Exception("Not allowed");
        }

        public BaseState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return _serviceProvider.GetService<InitialJournalEntryState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftJournalEntryState>();
                    break;
                case "submit":
                    return _serviceProvider.GetService<SubmitJournalEntryState>();
                    break;
                default:
                    throw new Exception("Not allowed");
            }
        }
    }
}
