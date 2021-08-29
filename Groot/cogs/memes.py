import feedparser
from bs4 import BeautifulSoup
from imports import *
con = connection.Con()
jsons = jsons.jsons()

class Memes(commands.Cog):
    def __init__(self, client):
        self.client = client
        self.rss = {}
        self.wake = True

    @commands.Cog.listener()
    async def on_ready(self):
        if self.wake:
            self.memes_loop.start()

    async def send_memes(self, entry, feed):
        img = None
        video = None
        soup = BeautifulSoup(entry['summary'], 'html.parser')
        img = soup.find('img')
        video = soup.find('source', type='video/mp4')
        if img is not None:
            img = img.get('src')
        elif video is not None:
            video = video.get('src')

        if img is not None:
            if len(entry['title']) > 250:
                entry['title'] = 'Title'
            embed = discord.Embed(
                title=entry['title'], url=entry['link'],
                color=0xe74c3c,
                timestamp=dt.datetime.utcnow()
            )
            embed.set_image(url=img)

            embed.set_author(name=feed, icon_url=self.client.user.avatar_url)
            embed.set_footer(text=f'{entry["published"]} from { feed }')
            async for guild in self.client.fetch_guilds(limit=150):
                channel_id = jsons.get_channels(guild.id, 'memes')
                if channel_id is not None:
                    channel = self.client.get_channel(channel_id)
                    await channel.send(embed=embed)
        else:
            if video is not None:
                msg = f'**{entry["title"]}**' + "\n" + "\n" \
                        f'**{entry["link"]}**' + "\n" + "\n" \
                        f'{video}'
            else:
                msg = entry["link"]
            async for guild in self.client.fetch_guilds(limit=150):
                channel_id = jsons.get_channels(guild.id, 'memes')
                if channel_id is not None:
                    channel = self.client.get_channel(channel_id)
                    await channel.send(msg)

    @tasks.loop(minutes=7.0)
    async def memes_loop(self):
        memes = dict.copy(jsons.get_rss('memes'))
        for feed in memes:
            if self.wake:
                self.rss[f'{feed}'] = None
            if con.test_connection(memes[feed]):
                d = feedparser.parse(memes[feed])
                if len(d.entries) != 0:
                    entry = d.entries[0]
                    if self.wake or self.rss[f'{feed}'] != entry['id']:
                        self.rss[f'{feed}'] = entry['id']
                        await self.send_memes(entry, feed)

        self.wake = False


def setup(client):
    client.add_cog(Memes(client))
