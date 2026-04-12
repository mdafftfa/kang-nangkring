using NetCord;
using NetCord.Gateway;
using NetCord.Rest;
using NetCord.Services.ApplicationCommands;

namespace kang_nangkring.Commands;

[SlashCommand("kang-nangkring", "Command utama untuk mengatur bot kang nangkring", Contexts = [InteractionContextType.Guild])]
public class KangNangkringCommand : ApplicationCommandModule<ApplicationCommandContext>
{

    [SubSlashCommand("help", "Melihat daftar perintah")]
    public async Task HelpAsync()
    {

        EmbedProperties properties = new EmbedProperties();
        properties.WithTitle("📋 Daftar Perintah Kang Nangkring");

        string description = 
        "- `/kang-nangkring help` : Menampilkan daftar perintah Kang Nangkring.\n" +
        "- `/kang-nangkring setnongki <voice_channel>` : Meluncur ke Voice Channel (TAB untuk autocomplete).\n" +
        "- `/kang-nangkring leave` : Mengeluarkan bot dari voice channel.";

        properties.WithDescription(description);
        await RespondAsync(InteractionCallback.Message(new InteractionMessageProperties().WithEmbeds([properties])));
    }

    [SubSlashCommand("setnongki", "Set voice channel untuk nongkrong")]
    public async Task SetNongkiAsync(
        [SlashCommandParameter(Name = "voice_channel", Description = "Pilih voice channel")] 
        VoiceGuildChannel channel)
    {
        GatewayClient client = Context.Client;
        var guild = Context.Guild;

        if (guild == null)
        {
            await RespondAsync(InteractionCallback.Message("Perintah ini hanya bisa digunakan di dalam server."));
            return;
        }

        await client.UpdateVoiceStateAsync(new VoiceStateProperties(guild.Id, channel.Id));

        await RespondAsync(InteractionCallback.Message($"Siapp, sedang meluncur ke channel **{channel.Name}**"));
    }

    [SubSlashCommand("leave", "Bot keluar dari voice channel")]
    public async Task LeaveAsync()
    {
        GatewayClient client = Context.Client;
        var guildId = Context.Interaction.GuildId;

        if (guildId.HasValue)
        {
            await client.UpdateVoiceStateAsync(new VoiceStateProperties(guildId.Value, null));
            await RespondAsync(InteractionCallback.Message("Bot telah pamit dari channel nongki."));
        }
    }
}