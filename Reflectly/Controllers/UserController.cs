using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Reflectly.Model;
using Reflectly.Model.Requests;
using Reflectly.Model.SearchObjects;
using Reflectly.Services;
using Reflectly.Services.Database;
using System.Threading.Tasks;

namespace Reflectly.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : BaseCRUDController<Model.User, BaseSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        private readonly IUserService _userService;
        private readonly ReflectlyContext _context;


        public UserController(ILogger<BaseController<Model.User, BaseSearchObject>> logger, IUserService service, ReflectlyContext context)
            : base(logger, service)
        {
            _userService = service;
            _context = context;
        }

        

        [AllowAnonymous]
        [HttpPost]
        public override Task<Model.User> Insert([FromBody] UserInsertRequest request)
        {
            return base.Insert(request);
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserLoginRequest request)
        {
            var user = await _userService.Login(request.UserName, request.Password);

            if (user == null)
                return Unauthorized("Incorrect username or password.");

            return Ok(user);
        }

        [HttpPost("update-fcm-token")]
        public async Task<IActionResult> UpdateFcmToken([FromBody] FcmTokenUpdateRequest request)
        {
            var user = await _context.Users.FindAsync(request.UserId);
            if (user == null) return NotFound();

            user.FcmToken = request.FcmToken;
            user.NotificationsEnabled = true;
            await _context.SaveChangesAsync();
            return Ok();
        }

        [HttpPost("toggle-notifications")]
        public async Task<IActionResult> ToggleNotifications([FromBody] ToggleNotificationRequest request)
        {
            var user = await _context.Users.FindAsync(request.UserId);
            if (user == null) return NotFound();

            user.NotificationsEnabled = request.Enabled;
            await _context.SaveChangesAsync();
            return Ok();
        }

    }
}
