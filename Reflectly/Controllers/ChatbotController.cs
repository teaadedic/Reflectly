using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using Reflectly.Services;


[ApiController]
[Route("api/[controller]")]
public class ChatbotController : ControllerBase
{
    private readonly DialogflowService _dialogflowService;

    public ChatbotController()
    {
        _dialogflowService = new DialogflowService();
    }

    [HttpPost("message")]
    public async Task<IActionResult> PostMessage([FromBody] ChatRequest request)
    {
        if (string.IsNullOrEmpty(request.Message))
            return BadRequest("Message is required.");

        var sessionId = Guid.NewGuid().ToString();  
        var responseText = await _dialogflowService.DetectIntentAsync(sessionId, request.Message);

        return Ok(new { reply = responseText });
    }
}

public class ChatRequest
{
    public string Message { get; set; }
}
