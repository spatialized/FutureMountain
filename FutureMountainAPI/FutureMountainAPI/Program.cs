using FutureMountainAPI;
using Microsoft.EntityFrameworkCore;
//using MySql.Data.EntityFrameworkCore;
//using MySqlConnector;
using System.Configuration;
//using System.Data.Entity;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.WebHost.UseUrls("https://*:7273;");
//builder.WebHost.UseUrls("https://*:5001;http://*:5000;http://*:80;http://*:5550;http://*:5560");

builder.Services.AddControllers();

string _policyName = "CorsPolicy";

// Local MSSQL
//string connectionString = "Server=DESKTOP-BGU64QR\\SQLEXPRESS;Initial Catalog=FutureMountain;User ID=REDACTED_USER;password=REDACTED_PASSWORD;";
// Remote MySQL
//DbConfiguration.SetConfiguration(new MySqlEFConfiguration());

string connectionString = "Server=REDACTED_HOST;User ID=REDACTED_USER;Password=REDACTED_PASSWORD;Database=defaultdb";
//string connectionString = "server=localhost;user=REDACTED_USER;password=REDACTED_PASSWORD;database=ef"

//var test = System.Configuration.ConfigurationManager.ConnectionStrings["CubeDataDbContext"].ConnectionString;


// Remote MySQL
//builder.Services.AddDbContext<CubeDataDbContext>()
ServerVersion.AutoDetect(connectionString);


// Local MSSQL

//builder.Services.AddDbContext<CubeDataDbContext>(options => options.UseSqlServer(
//        System.Configuration.ConfigurationManager.ConnectionStrings["CubeDataDbContext"].ConnectionString)
//    .EnableDetailedErrors(true));
//builder.Services.AddDbContext<DateDbContext>(options => options.UseSqlServer(
//        System.Configuration.ConfigurationManager.ConnectionStrings["CubeDataDbContext"].ConnectionString)
//    .EnableDetailedErrors(true));

builder.Services.AddDbContext<CubeDataDbContext>(options => options.UseSqlServer(connectionString).EnableDetailedErrors(true));
builder.Services.AddDbContext<DateDbContext>(options => options.UseSqlServer(connectionString).EnableDetailedErrors(true));

// Default Policy
builder.Services.AddCors(options =>
{
    options.AddPolicy(name: _policyName, builder =>
        {
            builder.AllowAnyOrigin()
                .AllowAnyHeader()
                .AllowAnyMethod();
        });

    //options.AddDefaultPolicy(
    //    builder =>
    //    {
    //        //builder.WithOrigins("https://localhost:90", "http://localhost:80", "http://localhost:5550", "http://localhost:5560",
    //        //                    "http://192.168.0.32:80", "http://192.168.0.32:90", "http://192.168.0.32:5550", "http://192.168.0.32:5560")
    //        builder.WithOrigins("*")
    //                            .AllowAnyHeader()
    //                            .AllowAnyMethod();
    //    });
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

app.UseCors(_policyName);
app.UseAuthorization();

app.MapControllers();

app.Run();
