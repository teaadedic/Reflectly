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

namespace Reflectly.Services
{
    public class JournalEntryService : BaseCRUDService<Model.JournalEntry, Database.JournalEntry, JournalEntrySearchObject, JournalEntryInsertRequest, JournalEntryUpdateRequest>, IJournalEntryService
    {
        public JournalEntryService(ReflectlyContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
 