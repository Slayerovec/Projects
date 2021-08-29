import feedparser
import html2text
from bs4 import BeautifulSoup
from imports import *
con = connection.Con()
jsons = jsons.jsons()


class News(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.news = {}
        self.wake = True

    async def send_rss_feed(self, entry, feed, images):
        media = True
        if media:
            embed = discord.Embed(
                title=entry['title'], url=entry['link'],
                description=entry['summary'],
                color=0xe74c3c,
                timestamp=dt.datetime.utcnow()
            )
            embed.set_image(url=images + '?refresh=yesplease')

            embed.set_author(name=entry['author'], icon_url=self.client.user.avatar_url)
            embed.set_footer(text=f'{entry["published"]} from { feed }')
            async for guild in self.client.fetch_guilds(limit=150):
                channel_id = jsons.get_channels(guild.id, 'news')
                if channel_id is not None:
                    channel = self.client.get_channel(channel_id)
                    await channel.send(embed=embed)
        else:
            msg = f'**{entry["title"]}**' + "\n" + "\n" \
                  f'{entry["link"]}'
            async for guild in self.client.fetch_guilds(limit=150):
                channel_id = jsons.get_channels(guild.id, 'news')
                if channel_id is not None:
                    channel = self.client.get_channel(channel_id)
                    await channel.send(msg)

    @commands.Cog.listener()
    async def on_ready(self):
        if self.wake:
            self.news_loop.start()

    @tasks.loop(minutes=10.0)
    async def news_loop(self):
        news = dict.copy(jsons.get_rss('news'))
        for feed in news:
            if self.wake:
                self.news[f'{feed}'] = None
            if con.test_connection(news[feed]):
                d = feedparser.parse(news[feed])
                if len(d.entries) != 0:
                    entry = d.entries[0]
                    if self.wake:
                        if self.news[f'{feed}'] != entry['id']:
                            self.news[f'{feed}'] = entry['id']
                            images = None
                            if bool(BeautifulSoup(entry['summary'], "html.parser").find()):
                                soup = BeautifulSoup(entry['summary'], 'html.parser')
                                h = html2text.HTML2Text()
                                h.ignore_links = True
                                h.ignore_images = True
                                entry['summary'] = h.handle(entry['summary'])
                                images = soup.find('img')
                                video = soup.find('video')
                                if images is not None:
                                    images = images.get('src').split('?')[0]
                                elif video is not None:
                                    images = video.get('poster').split('?')[0]

                            if images is None:
                                images = entry['media_content'][0]['url']

                            await self.send_rss_feed(entry, feed, images)
        self.wake = False


def setup(client):
    client.add_cog(News(client))
