using FutureMountainAPI;
using Microsoft.EntityFrameworkCore;
using System.Configuration;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.WebHost.UseUrls("https://*:5001;http://*:5000;http://*:80;http://*:5550;http://*:5560");

builder.Services.AddControllers();

//string connectionString = "Server=localhost\\SQLEXPRESS;Database=FutureMountain;Trusted_Connection=True;";    // WORKS
//string connectionString = "Server=localhost\\SQLEXPRESS;Database=FutureMountain;Trusted_Connection=True;";    // WORKS
//string connectionString = "Server=localhost\\SQLEXPRESS;Initial Catalog=FutureMountain;Integrated Security=True";
string connectionString = "Server=localhost\\SQLEXPRESS;Initial Catalog=FutureMountain;user id=REDACTED_USER;password=REDACTED_PASSWORD;Connection Timeout=120;Integrated Security=True";

//var test = System.Configuration.ConfigurationManager.ConnectionStrings["CubeDataDbContext"].ConnectionString;

//builder.Services.AddDbContext<CubeDataDbContext>(options => options.UseSqlServer(
//    System.Configuration.ConfigurationManager.ConnectionStrings["CubeDataDbContext"].ConnectionString));
builder.Services.AddDbContext<CubeDataDbContext>(options => options.UseSqlServer(connectionString).EnableDetailedErrors(true));
builder.Services.AddDbContext<DateDbContext>(options => options.UseSqlServer(connectionString).EnableDetailedErrors(true));

// Default Policy
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(
        builder =>
        {
            builder.WithOrigins("https://localhost:90", "http://localhost:80", "http://localhost:5550", "http://localhost:5560",
                                "http://192.168.0.32:80", "http://192.168.0.32:5550", "http://192.168.0.32:5560")
                                .AllowAnyHeader()
                                .AllowAnyMethod();
        });
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseAuthorization();

app.MapControllers();

app.Run();
