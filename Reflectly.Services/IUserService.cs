using Reflectly.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Services
{
    public interface IUserService:ICRUDService<Model.User, Model.SearchObjects.BaseSearchObject, Model.Requests.UserInsertRequest, Model.Requests.UserUpdateRequest>
    {
        Model.User Insert(UserInsertRequest request);
        Model.User Update(Guid id, UserUpdateRequest request);

        public Task<Model.User> Login(string username, string password);
       

    }
}



