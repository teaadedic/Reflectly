using Cqrs.Hosts;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using Reflectly;
using Reflectly.Filters;
using Reflectly.Services;
using Reflectly.Services.Database;
using Reflectly.Services.JournalEntryStateMachine;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddTransient<IJournalEntryService, JournalEntryService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IMoodEntryService, MoodEntryService>();
builder.Services.AddTransient<IBreathingExercisesSessionService, BreathingExercisesSessionService>();

builder.Services.AddTransient<BaseState>();
builder.Services.AddTransient<InitialJournalEntryState>();
builder.Services.AddTransient<DraftJournalEntryState>();
builder.Services.AddTransient<SubmitJournalEntryState>();
builder.Services.AddHostedService<ReminderScheduler>();

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
})
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;
    });



builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});


// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuck le
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
        new OpenApiSecurityScheme
        {
            Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
        },
        new string[]{}
    } });

 });

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<ReflectlyContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IUserService));
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme< AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null); 

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");

app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();
