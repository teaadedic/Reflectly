using Microsoft.EntityFrameworkCore;
using Reflectly.Services.Database;
using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Reflectly.Model.SearchObjects;
using Reflectly.Model;

namespace Reflectly.Services
{
    public class BaseService<T, TDb, TSearch> : IService<T, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {

        protected ReflectlyContext _context;

        protected  IMapper _mapper { get; set; }

        public BaseService(ReflectlyContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }


        public virtual async Task<PagedResult<T>> Get(TSearch? search = null)
        {
            var query = _context.Set<TDb>().AsQueryable();

            PagedResult<T> result = new PagedResult<T>();

            result.Count = await query.CountAsync();

            query = AddFilter(query, search);


            if(search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.Page.Value*search.PageSize.Value); 
            }

            var list = await query.ToListAsync();

            var tmp = _mapper.Map<List<T>>(list);
            result.Result = tmp;
            return result;
        }


        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb>  query, TSearch? search = null)
        {
            return query;
        }

        public virtual async Task<T> GetById(int id)
        {
            var entity = await _context.Set<TDb>().FindAsync();

            return _mapper.Map<T>(entity);
        }

    }
}
