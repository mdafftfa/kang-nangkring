using System.Threading.Tasks;
using NetCord;
using NetCord.Gateway;
using NetCord.Rest;
using NetCord.Services.ApplicationCommands;

namespace kang_nangkring;

[SlashCommand("kang-nangkring", "Command utama untuk mengatur bot kang nangkring", Contexts = [InteractionContextType.Guild])]
public class KangNangkringCommand : ApplicationCommandModule<SlashCommandContext>
{
    
    [SubSlashCommand("setnongki", "Set voice channel untuk nongkrong")]
    public async Task SetNongkiAsync(
        [SlashCommandParameter(Name = "voice_channel_id", Description = "ID dari Voice Channel")] string voiceChannelId)
    {
        var client = Context.Client;
        var guild = Context.Guild;

        if (guild == null) return;

        if (!ulong.TryParse(voiceChannelId, out var channelId))
        {
            await RespondAsync(InteractionCallback.Message("ID Channel tidak valid!"));
            return;
        }

        await client.UpdateVoiceStateAsync(new VoiceStateProperties(guild.Id, channelId));

        await RespondAsync(InteractionCallback.Message($"Siapp, sedang meluncur ke channel ID: {voiceChannelId}"));
    }

    [SubSlashCommand("leave", "Bot keluar dari voice channel")]
    public async Task LeaveAsync()
    {
        var client = Context.Client;
        var guildId = Context.Interaction.GuildId;

        if (guildId.HasValue)
        {
            await client.UpdateVoiceStateAsync(new VoiceStateProperties(guildId.Value, null));
            
            await RespondAsync(InteractionCallback.Message("Bot telah pamit dari channel nongki."));
        }
    }
}