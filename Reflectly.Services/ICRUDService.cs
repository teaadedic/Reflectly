﻿using Reflectly.Model;
using Reflectly.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Services
{
    public interface ICRUDService <T, TSearch, TInsert, TUpdate> : IService< T, TSearch> where TSearch : class
    {
        Task<T> Insert(TInsert insert);
        Task<T> Update(Guid id, TUpdate update);
    }
}
