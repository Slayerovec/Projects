from imports import *
con = connection.Con()
jsons = jsons.jsons()


class Youtube(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.youtube.add_exception_type(asyncpg.PostgresConnectionError)

    @commands.Cog.listener()
    async def on_ready(self):
        self.youtube.start()

    async def video_post(self, youtube, url):
        embed = discord.Embed(title=youtube['title'], url=url, description=youtube['description'])
        embed.set_author(name=youtube['channelTitle'], icon_url=self.client.user.avatar_url)
        embed.set_image(url=youtube['thumbnails']['maxres']['url'] + '?refresh=yesplease')
        embed.set_footer(text=f"Powered by {self.client.user.display_name}", icon_url=self.client.user.avatar_url)
        async for guild in self.client.fetch_guilds(limit=150):
            channel_id = jsons.get_channels(guild.id, 'videos')
            if channel_id is not None:
                channel = self.client.get_channel(channel_id)
                await channel.send(embed=embed)

    @commands.command(name='add_yt', hidden=True, aliases=[])
    async def add_yt(self, ctx, ytbers, id):
        if str(jsons.get_roles(ctx.message.guild.id, 'admin')) in str(ctx.message.author.roles):
            if con.get_youtube_videos(id):
                if jsons.set_youtube('channels', ytbers, id):
                    await ctx.message.delete()
                    await ctx.send(f'Přidal si {ytbers}!')
            else:
                await ctx.send('Posral si to!')

    @tasks.loop(minutes=10.0)
    async def youtube(self):
        channels = dict.copy(jsons.get_youtube('channels'))
        for ytbers in channels:
            youtube = con.get_youtube_videos(channels[ytbers])['items'][0]['snippet']
            url = 'https://www.youtube.com/watch?v=' + youtube['thumbnails']['default']['url'].split('/')[4]
            published = youtube['publishedAt'].split('T')[0].split('-')
            last = jsons.get_youtube_time(ytbers).split('-')
            if int(last[0]) + int(last[1]) + int(last[2]) <= int(published[0]) + int(published[1]) + int(published[2]):
                if jsons.set_youtube('settings', ytbers, str(youtube['publishedAt'].split('T')[0])):
                    await self.video_post(youtube, url)


def setup(client):
    client.add_cog(Youtube(client))
