from imports import *
from discord.ext.commands import (CommandNotFound, BadArgument, MissingRequiredArgument,
                                  CommandOnCooldown)
jsons = jsons.jsons()
log = log.log()
IGNORE_EXCEPTIONS = (CommandNotFound, BadArgument)


async def get_prefix(client, message):
    member = message.author
    if member:
        prefix = jsons.get_pref(member.id)
        if prefix is not None:
            return jsons.get_pref(member.id)
        else:
            jsons.set_pref(member.id, '/')
            return '/'
    else:
        return '/'

intents = discord.Intents.all()
client = commands.Bot(command_prefix=get_prefix, description='Já jsem Groot, váš kamoš.', intents=intents)

load_dotenv()
TOKEN = os.getenv('DISCORD_TOKEN')


for filename in os.listdir('./cogs'):
    if filename.endswith('.py'):
        if filename == 'test.py' or filename == 'music.py':
            client.load_extension(f'cogs.{filename[:-3]}')
            print(f"Cogs loaded {format(filename[:-3])}")


@client.event
async def on_ready():
    print(f"Bot | ID:       {format(client.user.id)}")
    print(f"Bot | Name:     {format(client.user.name)}")
    print(f"Bot | Guilds:   {len(client.guilds)}")
    print(f"Bot is ready to use")


@client.event
async def on_command_error(ctx, exc):

    if any([isinstance(exc, error) for error in IGNORE_EXCEPTIONS]):
        pass

    elif isinstance(exc, MissingRequiredArgument):
        await ctx.send("Jeden nebo více argumentu ti chybí dopsat.")

    elif isinstance(exc, CommandOnCooldown):
        await ctx.send(f"Ten command je na {str(exc.cooldown.type).split('.')[-1]} cooldown. Zkus znova za {exc.retry_after:,.2f} secs.")

    else:
        today = date.today()
        time = dt.datetime.now().strftime('%H:%M')
        author = ctx.message.author
        content = ctx.message.content
        guild_name = 'direct message'
        guild_id = ctx.message.author
        log_type = 'error'
        if ctx.message.guild is not None:
            guild_name = ctx.message.guild.name
            guild_id = ctx.message.guild.id

        text = f"[{today} v {time}]  [Error]: {exc} na serveru {guild_name} id = {guild_id} [Zpráva]: {author}: {content}"
        log.log_save(today, text, log_type)
        channel = client.get_channel(jsons.get_channels(828976703954878506, 'logs'))
        embed = discord.Embed(
            title=f'{guild_name} id = {guild_id}',
            description=f'{exc} - {content}',
            color=0xFF2D00,
            timestamp=dt.datetime.utcnow()
        )
        embed.set_author(name="Error REPORT", icon_url=client.user.avatar_url)
        embed.set_footer(text=f"Requested by {ctx.author.display_name}", icon_url=ctx.author.avatar_url)

        await channel.send(embed=embed)
        await ctx.send('Něco se pokazilo, zkus to znovu nebo kontaktuj **moderatory** / **administratora**')


@client.event
async def on_error(err, *args, **kwargs):
    if err == "on_command_error":
        await args[0].send("Něco se posralo volej kadyho! nebo někoho kompetetnějšího.")
    raise


@client.event
async def on_command_completion(ctx):
    today = date.today()
    time = dt.datetime.now().strftime('%H:%M')
    command = ctx.command.name
    cog = ctx.command.cog_name
    failed = ctx.command_failed
    author = ctx.message.author
    guild_name = 'direct message'
    guild_id = ctx.message.author
    log_type = 'commands'
    text = f"[{today} v {time}]  [Command]: {author} použil/a {command} / {cog} a byl neúspěšný? - {failed}"
    log.log_save(today, text, log_type)

    if ctx.message.guild is not None:
        guild_name = ctx.message.guild.name
        guild_id = ctx.message.guild.id

    embed = discord.Embed(
        title=f'{guild_name} id = {guild_id}',
        description=f'[Command]: {author} použil/a {command} / {cog} a byl neúspěšný? - {failed}',
        color=0x2DFF00,
        timestamp=dt.datetime.utcnow()
    )
    embed.set_author(name="Command LOG", icon_url=client.user.avatar_url)
    embed.set_footer(text=f"Requested by {ctx.author.display_name}", icon_url=ctx.author.avatar_url)
    channel_id = jsons.get_channels(828976703954878506, 'commands_log')
    if channel_id is not None:
        channel = client.get_channel(channel_id)
        await channel.send(embed=embed)

client.remove_command('help')
client.run(TOKEN)
