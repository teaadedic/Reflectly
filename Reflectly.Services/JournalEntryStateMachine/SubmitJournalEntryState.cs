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
        
    }
}
