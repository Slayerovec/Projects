from imports import *
jsons = jsons.jsons()
con = connection.Con()
db = db.Database()


class Twitch(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.streamers = {}
        self.tools = tools.Tools(client, jsons)
        self.wake = True

    def cog_unload(self):
        self.clips.cancel()
        self.stream.cancel()

    @commands.Cog.listener()
    async def on_ready(self):
        if self.wake:
            self.clips.start()
            self.stream.start()

    async def stream_post(self, data, user):
        c = data[0]
        d = user[0]
        embed = discord.Embed(title=c['title'],
                            url=f'https://www.twitch.tv/{c["user_login"]}',
                            timestamp=dt.datetime.utcnow(),
                            description=d['description'])
        embed.add_field(
            name="Streamer",
            value=(f'{c["user_name"]} začal/a streamovat!'),
            inline=True
        )
        embed.add_field(
            name="Currently playing",
            value=(f'{c["game_name"]}'),
            inline=True
        )
        embed.add_field(
            name="Viewers",
            value=(f'{c["viewer_count"]}'),
            inline=True
        )
        embed.set_author(name=c['user_name'], icon_url=d['profile_image_url'])
        embed.set_image(url=f'https://static-cdn.jtvnw.net/previews-ttv/live_user_{c["user_login"]}-1920x1080.jpg' + '?refresh=yesplease')
        embed.set_footer(text=f"Powered by {self.client.user.display_name}", icon_url=self.client.user.avatar_url)
        async for guild in self.client.fetch_guilds(limit=150):
            channel_id = jsons.get_channels(guild.id, 'streams')
            if channel_id is not None:
                channel = self.client.get_channel(channel_id)
                await channel.send(embed=embed)

    async def clips_post(self, c):
        user = con.get_twitch_user(c['creator_name'])
        creator = 'Not connected!'
        connected_twitch = db.get_users_twitch()
        for accs in connected_twitch:
            if connected_twitch[f'{accs}'] == user[0]['id']:
                creator = f'<@{accs}>'
        embed = discord.Embed(title=c['title'], url=c['url'], description=f'**Author**: {creator}, **Created at**: {c["created_at"]}', timestamp=dt.datetime.utcnow())
        embed.set_author(name=c['creator_name'], icon_url=user[0]['profile_image_url'])
        embed.set_image(url=c['thumbnail_url'] + '?refresh=yesplease')
        embed.set_footer(text=f"Powered by {self.client.user.display_name}", icon_url=self.client.user.avatar_url)
        async for guild in self.client.fetch_guilds(limit=150):
            channel_id = jsons.get_channels(guild.id, 'clips')
            if channel_id is not None:
                channel = self.client.get_channel(channel_id)
                await channel.send(embed=embed)

    @commands.command(name='add_tw', hidden=True, aliases=[])
    async def add_tw(self, ctx, streamer):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            twitch = con.get_twitch_user(streamer)
            if twitch:
                ms = f'**Je to ono?**' + "\n" + "\n" \
                                            f'https://twitch.tv/{twitch[0]["login"]}'
                reaction_msg = await self.tools.emoji_check(ctx, ms)
                if reaction_msg:
                    if jsons.set_twitch('channels', twitch[0]["login"].lower(), False):
                        await ctx.send(f'Přidal si {twitch[0]["login"].lower()}!')
            else:
                await ctx.send('Posral si to!')

    @commands.command(name='del_tw', hidden=True, aliases=[])
    async def del_tw(self, ctx, streamer):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            streamer = streamer.lower()
            twitch = dict.copy(jsons.get_twitch('channels'))
            for streamers in twitch:
                if streamers == streamer:
                    ms = f'**Je to ono?**' + "\n" + "\n" \
                        f'https://twitch.tv/{streamer}'
                    reaction_msg = await self.tools.emoji_check(ctx, ms)
                    if reaction_msg:
                        if jsons.del_twitch('channels', streamer):
                            await ctx.send(f'Odebral si {streamer}!')

    @tasks.loop(minutes=10.0)
    async def clips(self):
        tt = dt.datetime.utcnow()
        time = tt - dt.timedelta(minutes=10)
        ntime = time.strftime(f"%Y-%m-%dT%H:%M:%S")+"Z"
        clips = con.get_twitch_clips(ntime)
        if len(clips) != 0:
            for i in range(0, len(clips)):
                c = clips[i]
                await self.clips_post(c)

    @tasks.loop(minutes=10.0)
    async def stream(self):
        twitch = dict.copy(jsons.get_twitch('channels'))
        for streamer in twitch:
            if self.wake:
                self.streamers[f'{streamer}'] = twitch[f'{streamer}']
            if not self.streamers[f'{streamer}']:
                self.streamers[f'{streamer}'] = True
                data = con.get_twitch_status(streamer)
                user = con.get_twitch_user(streamer)
                if len(data) != 0:
                    await self.stream_post(data, user)
                else:
                    self.streamers[f'{streamer}'] = False
        self.wake = False


def setup(client):
    client.add_cog(Twitch(client))
