using Discord;
using Discord.WebSocket;

namespace kang_nangkring;

public class Worker(ILogger<Worker> logger, IConfiguration config) : BackgroundService
{
    private readonly DiscordSocketClient _client = new(new DiscordSocketConfig
    {
        GatewayIntents = GatewayIntents.Guilds | GatewayIntents.GuildVoiceStates,
        MessageCacheSize = 0,
        HandlerTimeout = 10000 
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
                    .AddOption("channel", ApplicationCommandOptionType.Channel, "Voice channel", isRequired: true))
                .AddOption(new SlashCommandOptionBuilder()
                    .WithName("leave")
                    .WithDescription("Suruh bot pulang")
                    .WithType(ApplicationCommandOptionType.SubCommand))
                .AddOption(new SlashCommandOptionBuilder()
                    .WithName("help")
                    .WithDescription("Bantuan penggunaan")
                    .WithType(ApplicationCommandOptionType.SubCommand));
;

            try {
                await _client.CreateGlobalApplicationCommandAsync(guildCommand.Build());
            } catch (Exception ex) { logger.LogError(ex.ToString()); }
        };

        _client.SlashCommandExecuted += async (command) =>
        {
            // Jalankan di thread berbeda agar tidak memblokir gateway
            _ = Task.Run(async () => {
                await command.DeferAsync();
                var subCommand = command.Data.Options.First();

                if (subCommand.Name == "setnongki")
                {
                    var channel = subCommand.Options.First().Value as IVoiceChannel;
                    if (channel != null)
                    {
                        try {
                            // Mencoba koneksi dengan timeout manual
                            var connectTask = channel.ConnectAsync(selfDeaf: true);
                            if (await Task.WhenAny(connectTask, Task.Delay(8000)) == connectTask)
                            {
                                await command.FollowupAsync($"✅ Siap bos, nangkring di **{channel.Name}**!");
                            }
                            else
                            {
                                await command.FollowupAsync("⚠️ Koneksi lambat, tapi aku coba terus...");
                            }
                        } catch (Exception ex) {
                            await command.FollowupAsync("❌ Gagal masuk. Cek izin Connect di channel!");
                            logger.LogError($"Voice Error: {ex.Message}");
                        }
                    }
                }
                else if (subCommand.Name == "leave")
                {
                    var guild = _client.GetGuild(command.GuildId!.Value);
                    if (guild?.CurrentUser.VoiceChannel != null)
                    {
                        await guild.CurrentUser.VoiceChannel.DisconnectAsync();
                        await command.FollowupAsync("👋 Cabut dulu ya!");
                    }
                } else if (subCommand.Name == "help")
                {
                    await command.FollowupAsync("Gunakan `/kang-nangkring setnongki [channel]` untuk mulai nangkring!");
                }
            });
        };

        await _client.LoginAsync(TokenType.Bot, config["DiscordToken"]);
        await _client.StartAsync();
        await Task.Delay(-1, stoppingToken);
    }
}