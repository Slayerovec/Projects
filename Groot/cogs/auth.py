from imports import *
jsons = jsons.jsons()


class Authenticator(commands.Cog):
    def __init__(self, client):
        self.client = client

    @commands.Cog.listener()
    async def on_member_join(self, member):
        if not member.bot:
            answer = f'{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}'
            role = jsons.get_roles(member.guild.id, 'unverified')
            if role is not None:
                if role not in member.roles:
                    await member.add_roles(member.guild.get_role(role), reason='Member join', atomic=True)
                if jsons.set_auth(member.guild.id, member.id, int(answer)):
                    channel_id = jsons.get_channels(member.guild.id, 'verify')
                    if channel_id is not None:
                        channel = self.client.get_channel(channel_id)
                        embed = discord.Embed(
                            title='Authorization',
                            description=f'{member.mention} Vítejte na **{member.guild}** do PM vám byl zaslán authorizační kód. Pro autorizaci, že nejste bot/robot pošlete do **PMky kód**.',
                            color=0xFF5733,
                            timestamp=dt.datetime.utcnow(),
                        )
                        embed.set_author(name=self.client.user.display_name, icon_url=self.client.user.avatar_url)
                        embed.set_footer(text=f"Powered by {self.client.user.display_name}", icon_url=self.client.user.avatar_url)
                        await channel.send(embed=embed)
                        msg = f'Dobrý den,' + "\n" \
                              f'váš autorizační kód je **{answer}**'
                        await member.send(msg)
        else:
            await member.ban(reason='Bot')

    @commands.Cog.listener()
    async def on_message(self, message):
        if message.author.id != self.client.user.id:
            if not message.author.bot and message.channel.type.name == 'private':
                code = jsons.get_auth(message.author.id)
                if code is not None:
                    if int(message.content) == int(code['code']):
                        if jsons.del_auth(message.author.id):
                            member = get(self.client.get_all_members(), id=message.author.id)
                            if member.id == message.author.id:
                                if jsons.get_roles(int(code['guild']), 'verified') is not None and jsons.get_roles(int(code['guild']), 'verified') not in member.roles:
                                    await member.add_roles(member.guild.get_role(jsons.get_roles(int(code['guild']), 'verified')))
                                    await member.remove_roles(member.guild.get_role(jsons.get_roles(int(code['guild']), 'unverified')))
                                    msg = f'Úspěšně si se autorizoval!'
                                    await member.send(msg)


def setup(client):
    client.add_cog(Authenticator(client))
