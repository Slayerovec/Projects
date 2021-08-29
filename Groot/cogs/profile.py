from imports import *
jsons = jsons.jsons()
db = db.Database()
con = connection.Con()


class Profiler(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.tools = tools.Tools(client, jsons)

    @commands.command(name='register', hidden=True, aliases=[])
    async def register(self, ctx):
        can = await self.tools.check_role(ctx, 'verified')
        if can:
            register = db.insert_user(ctx.message.author.id, ctx.message.author.name, 1)
            member = get(self.client.get_all_members(), id=ctx.message.author.id)
            if register:
                await self.profile(ctx)
            else:
                await ctx.send('Váš účet je již zaregistrován!')

    @commands.command(name='profile', hidden=True, aliases=[])
    async def profile(self, ctx):
        can = await self.tools.check_role(ctx, 'verified')
        if can:
            user_data = db.get_user(ctx.message.author.id)
            member = get(self.client.get_all_members(), id=ctx.message.author.id)
            if user_data is not None:
                embed = discord.Embed(
                    title='Profil',
                    description='Informace o Vašem účtě.',
                    color=0xFF5733,
                    timestamp=dt.datetime.utcnow())
                for k in user_data['data']:
                    if len(k) != 0:
                        value = user_data['data'][k]['connected']
                        if value:
                            msg = 'připojeno'
                        else:
                            msg = f'nepřipojeno, pro připojení účtu napiš /set_profile {k}'
                        embed.add_field(
                            name=user_data['data'][k]['description'],
                            value=msg,
                            inline=True
                        )

                for v in user_data['level_data']:
                    msg_list = []
                    for p in user_data['level_data'][v]:
                        msg_list.append(f"**{p}**: {user_data['level_data'][v][p]}")
                    msg = ' **|** '.join(msg_list)
                    embed.add_field(
                         name=v,
                         value=msg,
                         inline=False
                    )
                embed.set_author(name=ctx.author.display_name, icon_url=ctx.author.avatar_url)
                embed.set_footer(text=f"Powered by {self.client.user.display_name}", icon_url=self.client.user.avatar_url)
                await member.send(embed=embed)
            else:
                await ctx.send('Nejdřív se musíš zaregistrovat')

    @commands.command(name='set_profile', hidden=True, aliases=[])
    async def set_profile(self, ctx, asd):
        can = await self.tools.check_role(ctx, 'verified')
        if can:
            user_data = db.get_user(ctx.message.author.id)
            if user_data is not None:
                need = []
                for k in user_data['data']:
                    if not user_data['data'][f'{k}']['connected']:
                        need.append(k)
                for i in range(0, len(need)):
                    platform = asd.lower()
                    if platform == need[i]:
                        if not user_data['data'][f'{platform}']['connected']:
                            answer = f'Napiš své jméno na {platform}. **POZOR na velká písmena, je to key sensitive!**'
                            member = get(self.client.get_all_members(), id=ctx.message.author.id)

                            if platform == 'twitch':
                                answer_check_add = await self.tools.answer_check(ctx, answer)
                                if answer_check_add is not None:
                                    user = con.get_twitch_user(answer_check_add.lower())
                                    done = await self.add_twitch_account(ctx, user)
                                    if done:
                                        await ctx.send(f'Připojil si na svůj účet, účet z twitche {user[0]["login"]}!')
                            elif platform == 'faceit':
                                answer_check_add = await self.tools.answer_check(ctx, answer)
                                if answer_check_add is not None:
                                    user = con.get_faceit_user_by_name(answer_check_add)
                                    done = await self.add_faceit_account(ctx, user)
                                    if done:
                                        await ctx.send(f'Připojil si na svůj účet, účet z faceit {user["nickname"]}!')
                            else:
                                await ctx.send(f'Na ostatní platformy nemáme zařízený API access, takže až to půjde tak to půjde. btw kady to posral.')
                        else:
                            answer_delete = f'Chceš odstranit svůj účet na {platform}?' + "\n" + 'Pokud ano, odepiš ANO, pokud ne odepiš NE.'
                            answer_check_delete = await self.tools.answer_check(ctx, answer_delete)
                            if answer_check_delete == 'ano':
                                db.update_add_user(ctx.message.author.id, 'data', platform, 'connected', False)

            else:
                await ctx.send('Nejdřív se musíš zaregistrovat')

    async def add_twitch_account(self, ctx, user):
        if user is not None:
            ms = f'**Je to tvůj twitch účet?**' + "\n" + "\n" \
                f'https://twitch.tv/{user[0]["login"]}'

            reaction_msg = await self.tools.emoji_check(ctx, ms)
            if reaction_msg:
                if db.update_add_user(ctx.message.author.id, 'data', 'twitch', 'id', user[0]['id']):
                    if db.update_add_user(ctx.message.author.id, 'data', 'twitch', 'login', user[0]['login']):
                        db.update_add_user(ctx.message.author.id, 'data', 'twitch', 'connected', True)
                        return True
        return False

    async def add_faceit_account(self, ctx, user):
        if user is not None:
            ms = f'**Je to tvůj faceit účet?**' + "\n" + "\n" \
                f'https://www.faceit.com/en/players/{user["nickname"]}'

            reaction_msg = await self.tools.emoji_check(ctx, ms)
            if reaction_msg:
                if db.update_add_user(ctx.message.author.id, 'data', 'faceit', 'id', user['player_id']):
                    if db.update_add_user(ctx.message.author.id, 'data', 'faceit', 'login', user['nickname']):
                        db.update_add_user(ctx.message.author.id, 'data', 'faceit', 'connected', True)
                        return True
        return False


def setup(client):
    client.add_cog(Profiler(client))
