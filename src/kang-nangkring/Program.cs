using NetCord.Hosting.Gateway;
using NetCord.Hosting.Services;
using NetCord.Hosting.Services.ApplicationCommands;

var builder = Host.CreateApplicationBuilder(args);

builder.Services.AddDiscordGateway(options =>
{
    options.Token = builder.Configuration["Discord:Token"];
    options.Intents = NetCord.Gateway.GatewayIntents.Guilds | NetCord.Gateway.GatewayIntents.GuildVoiceStates;
});


builder.Services.AddApplicationCommands();

var host = builder.Build();

host.AddModules(typeof(Program).Assembly);

await host.RunAsync();