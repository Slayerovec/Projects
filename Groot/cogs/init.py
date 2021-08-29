from imports import *
from time import time
con = connection.Con()
jsons = jsons.jsons()
db = db.Database()


class Init(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.twt = 'spajkk'
        self.awake = True
        self.streaming = False

    @commands.Cog.listener()
    async def on_ready(self):
        if self.awake:
            self.status.start()
            self.save_all.start()
            self.status_stream.start()

    @commands.command(name='prefix', hidden=True, aliases=[])
    async def prefix(self, ctx, prefix):
        if jsons.set_pref(ctx.message.author.id, prefix):
            await ctx.send(embed=discord.Embed(
                author=self.client.user.name,
                title="Změna prefixu",
                thumbnail=("https://i.imgur.com/z7BOUc3.png"),
                description='Změnil si prefix na **' + prefix + '**',
                color=discord.Color.purple(),
                footer="Powered by Kaddynator"
            ))

    @commands.command(name='restart_prefix', hidden=True, aliases=[])
    async def restart_prefix(self, ctx):
        if jsons.set_pref(ctx.message.author.id, '/'):
            await ctx.send(embed=discord.Embed(
                author=self.client.user.name,
                title="Restart prefixu",
                thumbnail=("https://i.imgur.com/z7BOUc3.png"),
                description='Restartl si prefix na ** / **',
                color=discord.Color.purple(),
                footer="Powered by Kaddynator"
            ))

    @tasks.loop(minutes=30.0)
    async def status(self):
        if not self.streaming:
            await self.client.change_presence(
                status=discord.Status.idle,
                activity=discord.Game(
                    random.choice(jsons.get_groot('status'))
                ))

    @tasks.loop(minutes=10.0)
    async def status_stream(self):
        data = con.get_twitch_status(self.twt)
        if len(data) != 0:
            await self.client.change_presence(
                activity=discord.Streaming(
                    platform='twitch', name=data[0]['title'],
                    game=data[0]['game_name'],
                    twitch_name=self.twt,
                    url="https://www.twitch.tv/spajkk"
                ))
            self.streaming = True
        else:
            self.streaming = False

    @tasks.loop(hours=3.0)
    async def save_all(self):
        if not self.awake:
            jsons.save_all()
            db.save_all()
        else:
            self.awake = False


def setup(client):
    client.add_cog(Init(client))
