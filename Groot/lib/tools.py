from imports import *


class Tools:

    def __init__(self, client, jsons):
        self.client = client
        self.name = 'Tools'
        self.jsons = jsons

    async def emoji_check(self, ctx, ms):
        msg = await ctx.channel.send(ms)
        yes = '☑'
        no = '❌'
        await msg.add_reaction(yes)
        await msg.add_reaction(no)

        def check(reaction, user):
            return reaction.message.id == msg.id and user.id == ctx.message.author.id and not user.bot
        try:
            reaction_msg = await self.client.wait_for('reaction_add', check=check, timeout=30.0)
        except asyncio.TimeoutError:
            await msg.delete()
            await ctx.send(f'Neodpovedel si. Musíš dát **reakci**.')
            return False

        await msg.delete()
        if str(reaction_msg[0]) == yes:
            return True
        elif str(reaction_msg[0]) == no:
            return False

    async def answer_check(self, ctx, answer):
        msg = await ctx.send(answer)

        def is_correct(m):
            return m.author.id == ctx.message.author.id and not ctx.message.author.bot
        try:
            guess = await self.client.wait_for('message', check=is_correct, timeout=30.0)
        except asyncio.TimeoutError:
            await msg.delete()
            await ctx.send(f'Nestihl si odpovědět, zkusto znovu.')
            return None

        await msg.delete()
        content = guess.content
        await guess.delete()
        return content

    async def check_role(self, ctx, role):
        if ctx.message.guild is not None:
            await ctx.message.delete()
            if str(self.jsons.get_roles(ctx.message.guild.id, role)) in str(ctx.message.author.roles):
                return True
        else:
            if role != 'admin':
                return True
        return False

    async def manage_roles(self, guild, author, role_name):
        if guild is not None:
            member = get(self.client.get_all_members(), id=author.id)
            role = self.jsons.get_roles(guild, role_name)
            if role is not None:
                if str(role) not in str(member.roles):
                    await member.add_roles(member.guild.get_role(role), atomic=True)
                else:
                    await member.remove_roles(member.guild.get_role(role), atomic=True)

    async def create_group_rooms(self, name, author, category, default_role):
        overwrites_voice = {
            default_role: discord.PermissionOverwrite(connect=False, view_channel=False),
            author: discord.PermissionOverwrite(connect=True, move_members=True, view_channel=True)
        }
        overwrites_text = {
            default_role: discord.PermissionOverwrite(view_channel=False),
            author: discord.PermissionOverwrite(view_channel=True)
        }
        text = await category.create_text_channel(name, overwrites=overwrites_text)
        voice = await category.create_voice_channel(name, overwrites=overwrites_voice)
        return text, voice

    async def edit_group_rooms(self, member, voice, text):
        overwrites_voice = {
            member: discord.PermissionOverwrite(connect=True)
        }
        overwrites_text = {
            member: discord.PermissionOverwrite(view_channel=True)
        }
        await voice.set_permissions(overwrites=overwrites_voice)
        await text.set_permissions(overwrites=overwrites_text)

    async def delete_group_rooms(self, text, voice):
        await self.client.get_channel(text).delete()
        await self.client.get_channel(voice).delete()
