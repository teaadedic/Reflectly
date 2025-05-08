using AutoMapper;
using Reflectly.Model.SearchObjects;
using Reflectly.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Services
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate> : BaseService<T, TDb, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        public BaseCRUDService(ReflectlyContext context, IMapper mapper) : base(context, mapper)
        {

        }

        
        public virtual async Task BeforeInsesrt(TDb entity, TInsert insert)
        {

        }

        public virtual async Task<T> Insert(TInsert insert)
        {
            var set = _context.Set<TDb>();

            TDb entity = _mapper.Map<TDb>(insert);

            set.Add(entity);
            await BeforeInsesrt(entity, insert);
            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);

        }

        public virtual async Task<T> Update(Guid id, TUpdate update)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);

            _mapper.Map(update, entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);



        }

    }
}
