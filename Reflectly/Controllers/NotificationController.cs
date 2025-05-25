using Microsoft.AspNetCore.Mvc;
using Reflectly.Model;
using Reflectly.Model.Requests;
using Reflectly.Model.SearchObjects;
using Reflectly.Services;
using Microsoft.EntityFrameworkCore;
using Reflectly.Services.Database;

namespace Reflectly.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NotificationController : BaseCRUDController<Model.JournalEntry, JournalEntrySearchObject, JournalEntryInsertRequest, JournalEntryUpdateRequest>
    {
        private readonly ReflectlyContext _context;

        public NotificationController(
            ILogger<BaseController<Model.JournalEntry, JournalEntrySearchObject>> logger,
            ICRUDService<Model.JournalEntry, JournalEntrySearchObject, JournalEntryInsertRequest, JournalEntryUpdateRequest> service,
            ReflectlyContext context)
            : base(logger, service)
        {
            _context = context;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] NotificationRegisterRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Token))
                return BadRequest("Token is required");

            var exists = await _context.DeviceTokens.AnyAsync(t => t.Token == request.Token);

            if (!exists)
            {
                _context.DeviceTokens.Add(new DeviceToken
                {
                    Token = request.Token,
                    RegisteredAt = DateTime.UtcNow
                });

                await _context.SaveChangesAsync();
            }

            return Ok(new { message = "Token registered successfully" });
        }

        [HttpGet("tokens")]
        public async Task<IActionResult> GetTokens()
        {
            var tokens = await _context.DeviceTokens.Select(t => t.Token).ToListAsync();
            return Ok(tokens);
        }

        [HttpPost("send")]
        public async Task<IActionResult> Send([FromQuery] string token)
        {
            var service = new NotificationService();
            await service.SendNotificationAsync(token, "Reflectly Reminder", "Take a moment to reflect today.");
            return Ok(new { message = "Notification sent!" });
        }
    }
}
