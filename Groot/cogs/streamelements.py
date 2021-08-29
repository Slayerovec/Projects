from imports import *
con = connection.Con()
jsons = jsons.jsons()


class Elements(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.tools = tools.Tools(client, jsons)

    @commands.command(name='eleme', hidden=True, aliases=[])
    async def eleme(self, ctx):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            user = 'stornoo'
            amount = 50
            asd = con.add_ele_points(user, amount)
            await ctx.channel.send(f'{asd["message"]} now have {asd["newAmount"]}')


def setup(client):
    client.add_cog(Elements(client))
