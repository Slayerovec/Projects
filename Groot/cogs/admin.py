from imports import *
muted = db.Mute()
jsons = jsons.jsons()


class Admin(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.tools = tools.Tools(client, jsons)

    @commands.Cog.listener()
    async def on_ready(self):
        self.client.loop.create_task(self.control_mute())

    async def control_mute(self):
        muted_members = muted.get_muted()
        for members in muted_members:
            time = dt.datetime.now()
            muted_time = muted_members[f'{members}']['created_at']
            time_count = time.hour * 60 + time.minute
            room_time_count = int(muted_time['hour']) * 60 + int(muted_time['minute']) + muted_members[f'{members}']['time']
            if time_count > room_time_count:
                member = get(self.client.get_all_members(), id=muted_members[f'{members}']['muted_id'])
                role = jsons.get_roles(muted_members[f'{members}']['guild_id'], 'muted')
                await member.remove_roles(member.guild.get_role(role), atomic=True)
                muted.delete_room(muted_members[f'{members}']['muted_id'])

    @commands.command(name='purge', hidden=True, aliases=[])
    async def purge(self, ctx, amount: int):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            await ctx.message.delete()
            await ctx.channel.purge(limit=amount)

    @commands.command(name='mute', hidden=True, aliases=[])
    async def mute(self, ctx, number: int, reason):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            if not '@' in str(reason):
                for mentions in ctx.message.mentions:
                    await self.tools.manage_roles(ctx.message.guild.id, mentions, 'muted')
                    time = dt.datetime.now()
                    created_at = {
                        "month":  time.month,
                        "day":  time.day,
                        "hour":  time.hour,
                        "minute":  time.minute,
                    }
                    muted.insert_muted(ctx.message.author.id, mentions.id, number, reason, created_at)
            else:
                await ctx.message.author.send('Na něco si zapomněl!')

    @commands.command(name='starte', hidden=True, aliases=[])
    async def startE(self, ctx):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            for member in self.client.get_all_members():
                if not member.bot:
                    await member.add_roles(member.guild.get_role(jsons.get_roles(ctx.message.guild.id, 'verified')), atomic=True)

    @commands.command(name='add_status', hidden=True, aliases=[])
    async def add_status(self, ctx, status):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            if jsons.set_status(status):
                await ctx.channel.send(f'Přidal si **{status}** status id **{len(jsons.get_groot("status"))}**')
                await self.status(ctx)

    @commands.command(name='status', hidden=True, aliases=[])
    async def status(self, ctx):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            status = jsons.get_groot('status')
            embed = discord.Embed(title='Bot statusy',
                                  timestamp=dt.datetime.utcnow())
            for i in range(0, len(status)):
                embed.add_field(
                    name=f'Číslo: {i}',
                    value=status[i],
                    inline=True
                )
            await ctx.channel.send(embed=embed)

    @commands.command(name='del_status', hidden=True, aliases=[])
    async def del_status(self, ctx):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            await self.status(ctx)

            def check(m):
                return m.author.id == ctx.message.author.id and not m.author.bot and m.content.isdigit()
            try:
                reaction_msg = await self.client.wait_for('message', check=check, timeout=60.0)
            except asyncio.TimeoutError:
                return await ctx.send(f'Neodpovedel si')
            answer = int(reaction_msg.content)
            status = list.copy(jsons.get_groot('status'))
            if len(status) != 1 and len(status) > answer:
                if jsons.del_status(answer):
                    await ctx.channel.send(f'Odebral si **{status[answer]}** status id **{answer}**')
            else:
                await ctx.channel.send('Zdal si špatné číslo!')

    @commands.command(name='announce', hidden=True, aliases=[])
    async def announce(self, ctx, msg):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            channel_id = jsons.get_channels(ctx.message.guild.id, 'announce')
            if channel_id is not None:
                channel = self.client.get_channel(channel_id)
                embed = discord.Embed(
                    title='Oznámení',
                    description=msg,
                    color=0xFF5733,
                    timestamp=dt.datetime.utcnow(),

                )
                embed.set_author(name=ctx.author.display_name, icon_url=ctx.author.avatar_url)
                embed.set_footer(text=f"Powered by {self.client.user.display_name}", icon_url=self.client.user.avatar_url)

                await channel.send(embed=embed)

    @commands.command(name='embed', hidden=True, aliases=[])
    async def embed(self, ctx):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            a = ctx.message.content
            an = a.split('/embed')
            title = an[1].split('title= ')
            description = title[1].split('dsc= ')
            embed = discord.Embed(
                title=description[0],
                description=description[1],
                color=0xFF5733,
                timestamp=dt.datetime.utcnow(),

            )
            embed.set_author(name=ctx.author.display_name, icon_url=ctx.author.avatar_url)
            embed.set_footer(text=f"Powered by {self.client.user.display_name}", icon_url=self.client.user.avatar_url)

            await ctx.channel.send(embed=embed)

    @commands.command(name='role', hidden=True, aliases=[])
    async def role(self, ctx, user: discord.Member, *, role: discord.Role):
        can = await self.tools.check_role(ctx, 'admin')
        if can:
            if role.position > ctx.author.top_role.position:
                return await ctx.send('**:x: | That role is above your top role!**')
            if role in user.roles:
                await user.remove_roles(role)
                await ctx.send(f"Removed {role} from {user.mention}")
            else:
                await user.add_roles(role)
                await ctx.send(f"Added {role} to {user.mention}")


def setup(client):
    client.add_cog(Admin(client))
