using Microsoft.EntityFrameworkCore;
using Reflectly.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using Reflectly.Model.SearchObjects;

namespace Reflectly.Services
{
    public class MoodEntryService : BaseService<Model.MoodEntry, Database.MoodEntry, MoodEntrySearchObject>, IMoodEntryService
    {

        ReflectlyContext _context;

        public IMapper _mapper { get; set; }

        public MoodEntryService(ReflectlyContext context, IMapper mapper) : base(context, mapper)
        {
        }


        public override IQueryable<MoodEntry> AddFilter(IQueryable<MoodEntry> query, MoodEntrySearchObject? search = null)
        {
            if (!string.IsNullOrEmpty(search?.MoodEmoji))
            {
                query = query.Where(x => x.MoodEmoji.StartsWith(search.MoodEmoji));
            }

            if (!string.IsNullOrEmpty(search?.FTS))
            {
                query = query.Where(x => x.MoodEmoji.Contains(search.FTS));
            }
            return base.AddFilter(query, search);
        }

    }
}
