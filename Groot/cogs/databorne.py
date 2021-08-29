from imports import *
game = game.Game()
jsons = jsons.jsons()
db = db.Database()


class DataBorne(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.name = 'DataBorne'
        self.tools = tools.Tools(client, jsons)

    @commands.command(name='datab', hidden=True, aliases=[])
    async def datab(self, ctx, username):
        if len(username) < 60:
            print(username)
        else:
            return await ctx.send('Maximální počet charakterů ve jméně je 60')


def setup(client):
    client.add_cog(DataBorne(client))
