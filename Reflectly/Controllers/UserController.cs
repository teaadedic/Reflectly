using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Reflectly.Model;
using Reflectly.Model.Requests;
using Reflectly.Model.SearchObjects;
using Reflectly.Services;
using System.Threading.Tasks;

namespace Reflectly.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : BaseCRUDController<User, BaseSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        private readonly IUserService _userService;

        public UserController(ILogger<BaseController<User, BaseSearchObject>> logger, IUserService service)
            : base(logger, service)
        {
            _userService = service;
        }

        // ✅ Dozvoli registraciju bez autentifikacije
        [AllowAnonymous]
        [HttpPost]
        public override Task<User> Insert([FromBody] UserInsertRequest request)
        {
            return base.Insert(request);
        }

        // ✅ Dodaj login endpoint
        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserLoginRequest request)
        {
            var user = await _userService.Login(request.UserName, request.Password);

            if (user == null)
                return Unauthorized("Incorrect username or password.");

            return Ok(user);
        }
    }
}
