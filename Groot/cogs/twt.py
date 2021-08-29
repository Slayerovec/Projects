import html2text
import feedparser
from bs4 import BeautifulSoup
from imports import *
jsons = jsons.jsons()
con = connection.Con()


class Twitter(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.rss = {}
        self.awake = True
        self.tools = tools.Tools(client, jsons)
        self.twitter_loop.add_exception_type(asyncpg.PostgresConnectionError)

    @commands.Cog.listener()
    async def on_ready(self):
        if self.awake:
            self.twitter_loop.start()

    @commands.command(name='add_twitter', hidden=True, aliases=[])
    async def add_twitter(self, ctx, user):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            twitter = con.get_twitter_user(user)
            if twitter:
                ms = f'**Je to ono?**' + "\n" + "\n" \
                       f'https://twitter.com/{twitter[0]["username"]}'
                reaction_msg = await self.tools.emoji_check(ctx, ms)
                if reaction_msg:
                    if jsons.set_twitter('channels', twitter[0]["username"].lower(), int(twitter[0]['id'])):
                        await ctx.send(f'Přidal si {twitter[0]["name"]}!')
            else:
                await ctx.send('Posral si to!')

    @commands.command(name='del_twitter', hidden=True, aliases=[])
    async def del_twitter(self, ctx, user):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            twitter = jsons.get_twitter('channels')[f'{user.lower()}']
            if twitter:
                ms = f'**Je to ono?**' + "\n" + "\n" \
                        f'https://twitter.com/{user.lower()}'
                reaction_msg = await self.tools.emoji_check(ctx, ms)
                if reaction_msg:
                    if jsons.del_twitter('channels', user.lower()):
                        await ctx.send(f'Odebral si {user.lower()}!')
            else:
                await ctx.send('Posral si to!')

    async def send_tweets(self, user, data):
        link = f'https://twitter.com/{user}/status/' + data['id']
        async for guild in self.client.fetch_guilds(limit=150):
            channel_id = jsons.get_channels(guild.id, 'twitter')
            if channel_id is not None:
                channel = self.client.get_channel(channel_id)
                await channel.send(link)

    @tasks.loop(minutes=30.0)
    async def twitter_loop(self):
        twitters = dict.copy(jsons.get_twitter('channels'))
        tt = dt.datetime.utcnow()
        time = tt - dt.timedelta(minutes=30)
        ntime = time.strftime(f"%Y-%m-%dT%H:%M:%S")+".000Z"
        if self.awake:
            ntime = jsons.get_twitter('settings')['time']
        for user in twitters:
            tweets = con.get_twitter_user_tweets(twitters[f'{user}'], ntime)
            if tweets['meta']['result_count'] != 0:
                if not self.awake:
                    jsons.set_twitter('settings', 'time', ntime)
                for i in range(0, len(tweets['data'])):
                    data = tweets['data'][i]
                    await self.send_tweets(user, data)
        self.awake = False


def setup(client):
    client.add_cog(Twitter(client))
