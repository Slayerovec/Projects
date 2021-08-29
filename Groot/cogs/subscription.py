from imports import *
jsons = jsons.jsons()


class Subscription(commands.Cog):
    def __init__(self, client):
        self.client = client
        self.tools = tools.Tools(client, jsons)
        self.channel = None
        self.msg_id = None
        self.author = None

    async def process_reaction(self, payload: RawReactionActionEvent) -> None:
        if payload.event_type == 'REACTION_ADD':
            print(payload)
        elif payload.event_type == 'REACTION_REMOVE':
            print(payload)

    @commands.Cog.listener()
    async def on_raw_reaction_add(self, payload: RawReactionActionEvent):
        print(payload)
        if payload.channel_id == jsons.get_channels(payload.guild_id, 'role'):
            await self.process_reaction(payload)

    @commands.Cog.listener()
    async def on_raw_reaction_remove(self, payload: RawReactionActionEvent):
        print(payload)
        if payload.channel_id == jsons.get_channels(payload.guild_id, 'role'):
            await self.process_reaction(payload)

    @commands.command(name='set_sub', hidden=True, aliases=[])
    async def set_sub(self, ctx, name):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            if len(ctx.message.channel_mentions) != 0:
                channel = ctx.message.channel_mentions[0].id
                ms = f'**Zadej text.**'
                answer = await self.tools.answer_check(ctx, ms)
                channel = self.client.get_channel(channel)
                embed = Embed(
                    title=name,
                    description=answer,
                    colour=ctx.guild.owner.colour,
                    timestamp=dt.datetime.utcnow(),
                    author='preview'
                )
                await self.tools.answer_check(ctx, embed)


def setup(client):
    client.add_cog(Subscription(client))
