using FutureMountainAPI;
using Microsoft.EntityFrameworkCore;
using System.Configuration;

var builder = WebApplication.CreateBuilder(args);

//builder.WebHost.UseUrls("https://*:44301;");      // COMMENTED 10/5/24
builder.WebHost.UseUrls("http://*:13198;");

//builder.WebHost.UseUrls("https://*:5001;http://*:5000;http://*:80;http://*:5550;http://*:5560");

builder.Services.AddControllers();

//string connectionString = "Server=localhost\\SQLEXPRESS;Database=FutureMountain;Trusted_Connection=True;";    // WORKS
//string connectionString = "Server=localhost\\SQLEXPRESS;Database=FutureMountain;Trusted_Connection=True;";    // WORKS
//string connectionString = "Server=localhost\\SQLEXPRESS;Initial Catalog=FutureMountain;Integrated Security=True";
// string connectionString = "Server=localhost\\SQLEXPRESS;Initial Catalog=FutureMountain;user id=REDACTED_USER;password=REDACTED_PASSWORD;Connection Timeout=120;Integrated Security=True";
string _policyName = "CorsPolicy";

//DbConfiguration.SetConfiguration(new MySqlEFConfiguration());

// Local MSSQL
//string connectionString = "Server=DESKTOP-BGU64QR\\SQLEXPRESS;Initial Catalog=FutureMountain;User ID=REDACTED_USER;password=REDACTED_PASSWORD;";


// Local MySQL
//string connectionString = configuration.GetConnectionString("CubeDataDbContext");
// Replace with your connection string.
//string connectionString = "server=localhost;user=REDACTED_USER;password=REDACTED_PASSWORD;database=ef";
//string connectionString =
//    "server=localhost; user=REDACTED_USER; password=REDACTED_PASSWORD; port=3306; database=defaultdb;";

string connectionString =
    "server=localhost; user=REDACTED_USER; password=REDACTED_PASSWORD; database=defaultdb;";
//string connectionString =
//    "server=localhost; user=REDACTED_USER; password=REDACTED_PASSWORD; database=defaultdb;";

// Replace with your server version and type.
// Use 'MariaDbServerVersion' for MariaDB.
// Alternatively, use 'ServerVersion.AutoDetect(connectionString)'.
// For common usages, see pull request #1233.
//var serverVersion = new MySqlServerVersion(new Version(8, 0, 36));

var serverVersion = ServerVersion.AutoDetect(connectionString);

// Replace 'YourDbContext' with the name of your own DbContext derived class.
builder.Services.AddDbContext<CubeDataDbContext>(
    dbContextOptions => dbContextOptions
        .UseMySql(connectionString, serverVersion)
        // The following three options help with debugging, but should
        // be changed or removed for production.
        .LogTo(Console.WriteLine, LogLevel.Information)
        .EnableSensitiveDataLogging()
        .EnableDetailedErrors());
builder.Services.AddDbContext<DateDbContext>(
    dbContextOptions => dbContextOptions
        .UseMySql(connectionString, serverVersion)
        // The following three options help with debugging, but should
        // be changed or removed for production.
        .LogTo(Console.WriteLine, LogLevel.Information)
        .EnableSensitiveDataLogging()
        .EnableDetailedErrors());

//builder.Services.AddDbContext<CubeDataDbContext>(options => options.UseMySql(connectionString, serverVersion).EnableDetailedErrors(true));
//builder.Services.AddDbContext<DateDbContext>(options => options.UseMySql(connectionString, serverVersion).EnableDetailedErrors(true));




// Remote MySQL

//string connectionString =
//    "Server=REDACTED_HOST; User ID=REDACTED_USER; Password=REDACTED_PASSWORD; port=16751; Database=defaultdb;";

//var serverVersion = ServerVersion.AutoDetect(connectionString);
//builder.Services.AddDbContext<CubeDataDbContext>(options => options.UseMySql(connectionString, serverVersion).EnableDetailedErrors(true));
//builder.Services.AddDbContext<DateDbContext>(options => options.UseMySql(connectionString, serverVersion).EnableDetailedErrors(true));


// Local MSSQL

//builder.Services.AddDbContext<CubeDataDbContext>(options => options.UseSqlServer(
//        System.Configuration.ConfigurationManager.ConnectionStrings["CubeDataDbContext"].ConnectionString)
//    .EnableDetailedErrors(true));
//builder.Services.AddDbContext<DateDbContext>(options => options.UseSqlServer(
//        System.Configuration.ConfigurationManager.ConnectionStrings["CubeDataDbContext"].ConnectionString)
//    .EnableDetailedErrors(true));

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

//app.Logger.LogInformation("Starting Future Mountain API... connectionString:" + connectionString);

app.Run();
