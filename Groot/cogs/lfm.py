from imports import *
jsons = jsons.jsons()
rooms = db.Rooms()
db = db.Database()


class lfm_player():

    def __init__(self, author, game_class):
        self.author = author
        self.init_time = dt.datetime.now()
        self.time_diff = dt.timedelta(seconds=0)
        self.group = None
        self.game = game_class
        self.number = f'{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}'
        number = 0
        if len(index_numbers) == 0:
            index_numbers.append(self.number)
        else:
            for index in index_numbers:
                if index == self.number:
                    lfm_player(author, game_class)
                else:
                    number = number + 1
        if number == len(index_numbers):
            index_numbers.append(self.number)


class Group:

    def __init__(self, author, text_id, voice_id, game_class):
        self.creator = author
        self.players = []
        self.number = f'{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}'
        self.text_id = text_id
        self.voice_id = voice_id
        self.game = game_class

# check for inactive matchmaking search status every n minutes, after this, remove player from list
async def check_lfm_state():
    while(True):
        for player in player_list:
            player.time_diff = dt.datetime.now() - player.init_time
            if int((player.time_diff.total_seconds() / 60) % 60) > 30:
                player_list.remove(player)
        await asyncio.sleep(60)


def exists(iterable):
    for element in iterable:
        if element:
            return True
    return False


player_list = []
group_list = []
index_numbers = []


class LFM(commands.Cog):

    def __init__(self, client):
        self.client = client
        self.tools = tools.Tools(client, jsons)
        self.game_types = jsons.get_lfm_settings()['game_types']
        self.group_size = jsons.get_lfm_settings()['group_size']

    @commands.Cog.listener()
    async def on_ready(self):
        #self.client.loop.create_task(check_lfm_state())
        self.client.loop.create_task(self.lfm_info())
        self.client.loop.create_task(self.room_status())

    async def room_status(self):
        while True:
            room = rooms.get_room()
            for r in room:
                time = dt.datetime.now()
                room_time = room[f'{r}']['time']
                channel = self.client.get_channel(room[f'{r}']['voice_room_id'])
                if channel is not None:
                    if time.day == room_time['day']:
                        time_count = time.hour * 60 + time.minute
                        room_time_count = int(room_time['hour']) * 60 + int(room_time['minute']) + 30
                        if time_count > room_time_count:
                            if len(channel.members) == 0:
                                await self.delete(room[f'{r}']['voice_room_id'], room[f'{r}']['text_room_id'])
                                for group in group_list:
                                    if group.voice_id == room[f'{r}']['voice_room_id']:
                                        group_list.remove(group)
                else:
                    rooms.delete_room(room[f'{r}']['voice_room_id'])

            await asyncio.sleep(60)

    async def delete(self, voice, text):
        rooms.delete_room(voice)
        await self.tools.delete_group_rooms(voice, text)

    async def lfm_info(self):
        while(True):
            g = {}
            g_g = {}
            title = 'These users are searching for teammates!'
            embed = discord.Embed(title=title, color=0xff0000, description='**Players searching**:')

            for games in self.game_types:
                g[f'{games}'] = []
                if len(player_list) != 0:
                    for player in player_list:
                        if player.group is None:
                            if player.game == games:
                                time_diff = str(int(player.time_diff.total_seconds() / 60) % 60) + ' min'
                                g[f'{games}'].append(f'{player.author.name}: {time_diff} */* {player.number}')

                if len(g[f'{games}']) != 0:
                    msg = ' **|** '.join(g[f'{games}'])
                else:
                    msg = 'Empty'

                embed.add_field(name=games, value=f'{msg}', inline=False)

            embed.add_field(name='\u200b', value='**Groups searching**:', inline=True)
            for games in self.game_types:
                g_g[f'{games}'] = []
                if len(group_list) != 0:
                    for group in group_list:
                        if group.game == games:
                            g_g[f'{games}'].append(f'{group.creator.name}: {len(group.players)}/{self.group_size} *|* {group.number}')

                if len(g_g[f'{games}']) != 0:
                    msg_g = ' **|** '.join(g_g[f'{games}'])
                else:
                    msg_g = 'Empty'
                embed.add_field(name=games, value=f'{msg_g}', inline=False)
            async for guild in self.client.fetch_guilds(limit=150):
                channel_id = jsons.get_channels(guild.id, 'lfm_status')
                channel = self.client.get_channel(channel_id)
                if channel is not None:
                    if channel.last_message_id is not None:
                        msg = await channel.fetch_message(channel.last_message_id)
                        await msg.edit(embed=embed)
                    else:
                        await channel.send(embed=embed)

            await asyncio.sleep(10)

    @commands.command(name='lfm', hidden=True, aliases=[])
    async def lfm(self, ctx, m):
        can = await self.tools.check_role(ctx, 'verified')
        if can:
            game_class = 'Nevím'

            if exists(x for x in self.game_types if m == x):
                game_class = m

            if game_class != 'Nevím':
                if exists(x for x in player_list if x.author.id == ctx.message.author.id):
                    for player in player_list:
                        # renew timestamp for already existing player
                        if player.author.id == ctx.message.author.id:
                            player.init_time = dt.datetime.now()
                            player.time_diff = dt.timedelta(seconds=0)
                else:
                    # register new player
                    if not exists(x for x in group_list if x.author.id == ctx.message.author.id):
                        player_list.append(lfm_player(ctx.message.author, game_class))
            else:
                await ctx.reply('Musíš zadat hru /mmsearch csgo nebo lol nebo valorant')

    @commands.command(name='lfm_stop', hidden=True, aliases=[])
    async def lfm_stop(self, ctx):
        can = await self.tools.check_role(ctx, 'verified')
        if can:
            for player in player_list:
                if player.author.id == ctx.message.author.id:
                    player_list.remove(player)

    @commands.command(name='lfm_leave', hidden=True, aliases=[])
    async def lfm_leave(self, ctx):
        can = await self.tools.check_role(ctx, 'verified')
        if can:
            for group in group_list:
                if group.author.id == ctx.message.author.id:
                    for player in player_list:
                        player_list.remove(player)
                else:
                    player_list.remove(player)

    @commands.command(name='create_group', hidden=True, aliases=[])
    async def create_group(self, ctx, m):
        can = await self.tools.check_role(ctx, 'verified')
        if can:
            game_class = m
            if not exists(x for x in group_list if x.author.id == ctx.message.author.id):
                guild = ctx.guild
                author = get(self.client.get_all_members(), id=ctx.message.author.id)
                category = get(ctx.guild.categories, id=jsons.get_categories(guild.id, 'lfm'))
                number = len(category.channels)

                if number == 1:
                    number = 1
                elif 2 <= number <= 3:
                    number = number - 1
                elif number >= 4:
                    number = number - 1
                    number = (number / 2) + 1

                name = f"{ctx.message.author.name} room #{int(number)}"
                text, voice = await self.tools.create_group_rooms(name, author, category, ctx.guild.default_role)
                voice_id = voice.id
                text_id = text.id
                time = {
                    "month":  voice.created_at.month,
                    "day":  voice.created_at.day,
                    "hour":  voice.created_at.hour,
                    "minute":  voice.created_at.minute,
                }
                rooms.insert_room(ctx.message.author.id, text_id, voice_id, time)
                group_list.append(Group(ctx.message.author, text_id, voice_id, game_class))
                if exists(x for x in player_list if x.author.id == ctx.message.author.id):
                    for player in player_list:
                        if player.author.id == ctx.message.author.id:
                            player_list.remove(player)

    @commands.command(name='invite', hidden=True, aliases=[])
    async def invite(self, ctx, number):
        can = await self.tools.check_role(ctx, 'verified')
        if can:
            if exists(x for x in group_list if x.creator.id == ctx.message.author.id):
                for group in group_list:
                    group_text = self.client.get_channel(group.text_id)
                    if group.creator.id == ctx.message.author.id:
                        if ctx.message.channel.id == group.text_id:
                            if number.isdigit():
                                if exists(x for x in player_list if x.number == number):
                                    for player in player_list:
                                        if player.number == number:
                                            author = get(self.client.get_all_members(), id=player.author.id)
                                            await self.invite_sended(group, player, author)
                                else:
                                    await group_text.send('Nikdo takový neexistuje!')
                            else:
                                await group_text.send('Zadej číslo!')
                        else:
                            await group_text.send('Tady piš!')
            else:
                await ctx.send('Nejsi leader skupiny!')

    async def invite_sended(self, group, player, author):
        time = 60
        text = f'Byl si pozván do skupiny od **{group.creator}**, napiš **accept** nebo **/accept** pro příjmutí pozvánky do skupiny \n'

        def is_correct(m):
            return m.author.id == author.id

        msg = await author.send(text + f'Zbývá ti **{time}** sekund')

        try:
            guess = await self.client.wait_for('message', check=is_correct, timeout=time)
        except asyncio.TimeoutError:
            player_list.remove(player)
            return await msg.edit(content=f'Nestihl si příjmout pozvánku do grupy.')

        if guess.content == 'accept' or guess.content == '/accept':
            await msg.edit(content=f'Příjmul si pozvánku do skupiny **{group.creator}**')
            player_list.remove(player)
            for groups in group_list:
                if groups.number == group.number:
                    group.players.append(player)
                    for players in player_list:
                        if players.number == player.number:
                            players.group = groups
                            await self.tools.edit_group_rooms(author, groups.voice_id, groups.text_id)


def setup(client):
    client.add_cog(LFM(client))
