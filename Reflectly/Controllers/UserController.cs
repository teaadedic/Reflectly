using Microsoft.AspNetCore.Mvc;
using Reflectly.Services;
using Microsoft.AspNetCore.Mvc;
using Reflectly.Model.Requests;
using Reflectly.Model;

namespace Reflectly.Controllers
{
        [ApiController]
        [Route("[controller]")]

        public class UserController : BaseCRUDController<Model.User, Model.SearchObjects.BaseSearchObject, Model.Requests.UserInsertRequest, Model.Requests.UserUpdateRequest>
        {
           

            public UserController(ILogger<BaseController<User, Model.SearchObjects.BaseSearchObject>> logger, IUserService service): base(logger, service)
            {
                
            }

          

        }
}
