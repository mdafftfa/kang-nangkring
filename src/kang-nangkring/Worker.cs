using Discord;
using Discord.WebSocket;

namespace kang_nangkring;

public class Worker(ILogger<Worker> logger, IConfiguration config) : BackgroundService
{
    private readonly DiscordSocketClient _client = new(new DiscordSocketConfig
    {
        GatewayIntents = GatewayIntents.Guilds | GatewayIntents.GuildVoiceStates,
        MessageCacheSize = 0
    });

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _client.Log += (msg) => { logger.LogInformation(msg.Message); return Task.CompletedTask; };

        _client.Ready += async () =>
        {
            var guildCommand = new SlashCommandBuilder()
                .WithName("kang-nangkring")
                .WithDescription("Bot nongkrong di Voice Channel")
                .AddOption(new SlashCommandOptionBuilder()
                    .WithName("setnongki")
                    .WithDescription("Set channel tempat nongkrong")
                    .WithType(ApplicationCommandOptionType.SubCommand)
                    .AddOption("channel", ApplicationCommandOptionType.Channel, "Voice channel ID", isRequired: true))
                .AddOption(new SlashCommandOptionBuilder()
                    .WithName("leave")
                    .WithDescription("Suruh bot pulang")
                    .WithType(ApplicationCommandOptionType.SubCommand))
                .AddOption(new SlashCommandOptionBuilder()
                    .WithName("help")
                    .WithDescription("Bantuan penggunaan")
                    .WithType(ApplicationCommandOptionType.SubCommand));

            try {
                await _client.CreateGlobalApplicationCommandAsync(guildCommand.Build());
            } catch (Exception ex) { logger.LogError(ex.ToString()); }
        };

        _client.SlashCommandExecuted += async (command) =>
        {
            var subCommand = command.Data.Options.First();

            if (subCommand.Name == "setnongki")
            {
                var channel = subCommand.Options.First().Value as IVoiceChannel;
                if (channel != null)
                {
                    await channel.ConnectAsync();
                    await command.RespondAsync($"✅ Siap bos, nangkring di **{channel.Name}**!");
                }
            }
            else if (subCommand.Name == "leave")
            {
                var guild = _client.GetGuild(command.GuildId!.Value);
                if (guild.CurrentUser.VoiceChannel != null)
                {
                    await guild.CurrentUser.VoiceChannel.DisconnectAsync();
                    await command.RespondAsync("👋 Cabut dulu ya!");
                }
                else await command.RespondAsync("❌ Lah, kan lagi gak nongki.");
            }
            else if (subCommand.Name == "help")
            {
                await command.RespondAsync("Gunakan `/kang-nangkring setnongki` lalu pilih channel!");
            }
        };

        var token = config["DiscordToken"];
        await _client.LoginAsync(TokenType.Bot, token);
        await _client.StartAsync();

        await Task.Delay(-1, stoppingToken);
    }

    public override async Task StopAsync(CancellationToken cancellationToken)
    {
        await _client.StopAsync();
        await base.StopAsync(cancellationToken);
    }
}