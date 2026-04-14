using kang_nangkring;
using Microsoft.Extensions.Hosting;

using NetCord.Hosting.Gateway;
using NetCord.Hosting.Services;
using NetCord.Hosting.Services.ApplicationCommands;
using NetCord.Hosting.Services.Commands;
using NetCord.Services.ApplicationCommands;

var builder = Host.CreateApplicationBuilder(args);

builder.Services.AddDiscordGateway(options =>
{
    options.Token = "MTQ5MzE0NzY2NTczNzcxMTYzNg.GFOwkk._dErwgg0XJBLAJD_XXqxahie712xlHVg9Zdzog";
    options.Intents = NetCord.Gateway.GatewayIntents.Guilds | NetCord.Gateway.GatewayIntents.GuildVoiceStates;
}
);


builder.Services.AddApplicationCommands();

var host = builder.Build();

host.AddModules(typeof(Program).Assembly);

await host.RunAsync();
