using FirebaseAdmin.Messaging;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Google.Apis.Auth.OAuth2;
using FirebaseAdmin;
using Reflectly.Services.Database;
using Reflectly.Services;
using Reflectly.Model;
using Microsoft.Extensions.DependencyInjection;

namespace Reflectly.Services
{
    public class ReminderScheduler : BackgroundService
    {
        private readonly IServiceProvider _services;
        private readonly ILogger<ReminderScheduler> _logger;
        private static bool _initialized = false;

        public ReminderScheduler(IServiceProvider services, ILogger<ReminderScheduler> logger)
        {
            _services = services;
            _logger = logger;

            if (!_initialized)
            {
                FirebaseApp.Create(new AppOptions
                {
                    Credential = GoogleCredential.FromFile("serviceAccountKey.json")
                });
                _initialized = true;
            }
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                var now = DateTime.UtcNow;
                if (now.Hour == 9 && now.Minute == 0)
                {
                    await SendDailyReminders();
                    await Task.Delay(TimeSpan.FromMinutes(60), stoppingToken);
                }

                await Task.Delay(TimeSpan.FromSeconds(30), stoppingToken);
            }
        }

        private async Task SendDailyReminders()
        {
            using var scope = _services.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<ReflectlyContext>();
            var tokens = context.DeviceTokens.Select(t => t.Token).ToList();

            foreach (var token in tokens)
            {
                var message = new Message
                {
                    Token = token,
                    Notification = new Notification
                    {
                        Title = "Reflectly Reminder",
                        Body = "Take a moment to reflect today 🌱"
                    }
                };

                try
                {
                    await FirebaseMessaging.DefaultInstance.SendAsync(message);
                    _logger.LogInformation($"Reminder sent to {token}");
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Failed to send to {token}: {ex.Message}");
                }
            }
        }
    }
}
