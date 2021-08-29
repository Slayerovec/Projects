from imports import *
jsons = jsons.jsons()
db = db.Database()
config = jsons.get_csgo_settings()
server_info = csgo.server_info(config)


class ServerCS(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.tools = tools.Tools(client, jsons)
        self.cur_page = {}
        self.max_page = {}

    @commands.Cog.listener()
    async def on_ready(self):
        self.client.loop.create_task(self.refresh_server_info(self))
        async for guild in self.client.fetch_guilds(limit=150):
            self.cur_page[f'{guild.id}'] = 1
            self.max_page[f'{guild.id}'] = 1

    @commands.Cog.listener()
    async def on_raw_reaction_add(self, payload: RawReactionActionEvent):
        if payload.channel_id == jsons.get_channels(payload.guild_id, 'servers'):
            if not payload.member.bot:
                if server_info.config.get('msg_id')[f'{payload.guild_id}'] == payload.message_id:
                    left = '⬅️'
                    right = '➡️'
                    page = self.cur_page[f'{payload.guild_id}']
                    if payload.emoji.name == left:
                        page = page - 1
                    elif payload.emoji.name == right:
                        page = page + 1

                    if page == 0:
                        page = 1
                    elif page >= self.max_page[f'{payload.guild_id}']:
                        page = self.max_page[f'{payload.guild_id}']

                    if server_info.status:
                        await self.servers(page, payload.guild_id)
                    channel = self.client.get_channel(payload.channel_id)
                    r = await channel.fetch_message(server_info.config.get('msg_id')[f'{payload.guild_id}'])
                    await r.remove_reaction(payload.emoji.name, payload.member)

    @staticmethod
    async def refresh_server_info(self):
        while(True):
            await server_info.get()
            async for guild in self.client.fetch_guilds(limit=150):
                await self.servers(self.cur_page[f'{guild.id}'], guild.id)
            await asyncio.sleep(config.get('refresh_time'))

    async def servers(self, curr_page, guild):
        if server_info.status:
            channel_id = jsons.get_channels(guild, 'servers')
            if channel_id is not None:
                channel = self.client.get_channel(channel_id)
                max_page = len(server_info.servers)/4
                if type(max_page) == float:
                    max_page = int(max_page) + 1

                if curr_page == 1:
                    number = 0
                else:
                    number = 0 + (4 * (curr_page - 1))

                self.cur_page[f'{guild}'] = curr_page
                self.max_page[f'{guild}'] = max_page
                await self.servers_status(channel, guild, curr_page, max_page, number)
        else:
            await asyncio.sleep(30)
            await self.servers(self.cur_page[f'{guild}'], guild)

    @commands.command(name='server', hidden=True, aliases=[])
    async def server(self, ctx, number: int):
        can = await self.tools.check_role(ctx, 'verified')
        if can and server_info.status:
            if len(server_info.servers) >= number and number > 0:
                number = number - 1
                embed = discord.Embed(
                    title='CS:GO Servery',
                    description=f'Informace o serveru',
                    color=0xFF5733,
                    timestamp=dt.datetime.utcnow(),
                    thumbnail=config.get('custom_thumb'))
                embed.add_field(name=server_info.servers[number]['server_name'], value='\u200b', inline=True)
                embed.add_field(name=server_info.servers[number]['connect_link'], value='\u200b', inline=False)
                embed.add_field(name='Map', value=server_info.servers[number]['curr_map'], inline=True)
                embed.add_field(name='Players', value=server_info.servers[number]['players'], inline=True)
                embed.add_field(name='Ping', value=server_info.servers[number]['ping'], inline=True)
                await ctx.send(embed=embed)
        else:
            await ctx.send('Not ready!')

    @commands.command(name='ip', hidden=True, aliases=[])
    async def ip(self, ctx):
        can = await self.tools.check_role(ctx, 'verified')
        if can and server_info.status:
            embed = discord.Embed(
                title='CS:GO Servery',
                description='IPs, Connections',
                color=0xFF5733,
                timestamp=dt.datetime.utcnow(),
                thumbnail=config.get('custom_thumb'))
            for i in range(0, len(server_info.servers)):
                embed.add_field(
                    name=f'{server_info.servers[i]["server_name"]}  | | {server_info.servers[i]["players"]}',
                    value=server_info.servers[i]['connect_link'],
                    inline=False
                )
            embed.set_author(name=ctx.author.display_name, icon_url=ctx.author.avatar_url)
            embed.set_footer(text=f"Powered by {self.client.user.display_name}", icon_url=self.client.user.avatar_url)
            await ctx.send(embed=embed)
        else:
            await ctx.send('Not ready!')

    @commands.command(name='servercmds', hidden=True, aliases=[])
    async def servercmds(self, ctx):
        can = await self.tools.check_role(ctx, 'verified')
        if can:
            embed = discord.Embed(
                title='CS:GO Servery',
                description='Commands',
                color=0x0000ff,
                timestamp=dt.datetime.utcnow(),
                thumbnail=server_info.config.get('custom_thumb'))
            for command in server_info.config['server_commands']:
                embed.add_field(name=command, value=server_info.config['server_commands'][f'{command}'], inline=False)
            await ctx.send(embed=embed)

    async def servers_status(self, channel, guild, curr_page, page, number):
        max_list = len(server_info.servers) - 1
        last_message = None
        embed = discord.Embed(
            title='CS:GO Servery',
            description=f'Informace o serverech. Stranka ( **{curr_page} / {page} **)',
            color=0xFF5733,
            timestamp=dt.datetime.utcnow(),
            thumbnail=config.get('custom_thumb'))

        for i in range(number, number + 4):
            if i <= max_list:
                embed.add_field(name=server_info.servers[i]['server_name'], value='\u200b', inline=True)
                embed.add_field(name=server_info.servers[i]['connect_link'], value='\u200b', inline=False)
                embed.add_field(name='Map', value=server_info.servers[i]['curr_map'], inline=True)
                embed.add_field(name='Players', value=server_info.servers[i]['players'], inline=True)
                embed.add_field(name='Ping', value=server_info.servers[i]['ping'], inline=True)
                embed.add_field(name='\u200b', value='\u200b', inline=False)

        msg_id = server_info.config.get('msg_id')

        if msg_id[f'{guild}'] == None:
            await channel.send(embed=embed)
            last_message = channel.last_message_id
            msg_id[f'{guild}'] = channel.last_message_id
            jsons.set_csgo_settings('msg_id', msg_id)
        else:
            last_message = msg_id[f'{guild}']
            msg = await channel.fetch_message(msg_id[f'{guild}'])
            await msg.edit(embed=embed)

        rcts = await channel.fetch_message(last_message)

        if len(rcts.reactions) == 0:
            left = '⬅️'
            right = '➡️'
            await rcts.add_reaction(left)
            await rcts.add_reaction(right)


def setup(client):
    client.add_cog(ServerCS(client))
