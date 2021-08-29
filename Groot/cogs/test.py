from imports import *
con = connection.Con()
jsons = jsons.jsons()
rooms = db.Rooms()
db = db.Database()
#csgo = csko.csko()
to_img = img.Img()


class Test(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.tools = tools.Tools(client, jsons)

    @commands.command(name='test', hidden=True, aliases=[])
    async def test(self, ctx):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            guild = ctx.author


def setup(client):
    client.add_cog(Test(client))
