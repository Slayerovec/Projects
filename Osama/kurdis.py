import discord
import mysql.connector

from imports import *
from mysql.connector import connect, Error
from discord.ext.commands import (CommandNotFound, BadArgument, MissingRequiredArgument,
                                  CommandOnCooldown)
IGNORE_EXCEPTIONS = (CommandNotFound, BadArgument)

config = {
    'user': 'kurd',
    'password': '',
    'host': '',
    'database': 'kurds',
    'raise_on_warnings': True,
    'auth_plugin': 'mysql_native_password'
}


class Database:

    def __init__(self):
        start = False
        try:
            mysql.connector.connect(**config)
            start = True
        except Exception as e:
            print("Error at:")
            print(e)
            print()
            print("Exiting...")
            exit()
        if start:
            self.db = connect(**config)

    def login(self, username, password):
        dbc = self.db.cursor()
        sql = "SELECT * FROM users WHERE username = %s AND password = %s"
        val = (username, password)
        dbc.execute(sql, val)
        user = dbc.fetchall()
        self.logging(username, password, 1)
        return user

    def check_user(self, discord_id):
        dbc = self.db.cursor()
        sql = f"SELECT * FROM users WHERE discord_id = {discord_id}"
        dbc.execute(sql)
        user_checked = dbc.fetchall()
        return user_checked

    def user_logins(self, username, password):
        dbc = self.db.cursor()
        sql = "SELECT * FROM users WHERE username = %s AND password = %s"
        val = (username, password)
        dbc.execute(sql, val)
        user2 = dbc.fetchall()
        return user2

    def register(self, discord_id, username, password):
        status = 'OK'
        try:
            dbc = self.db.cursor()
            sql = "INSERT INTO users (discord_id, username, password, logged) VALUES (%s, %s, %s, %s)"
            val = (discord_id, username, password, 1)
            dbc.execute(sql, val)
            self.db.commit()
        except Exception as e:
            print(e)
            status = 'NEOK'

        return status

    def logging(self, username, password, logged):
        dbc = self.db.cursor()
        sql = "SELECT * FROM users WHERE username = %s AND password = %s"
        val = (username, password)
        dbc.execute(sql, val)
        user = dbc.fetchall()
        if len(user) != 0:
            sql_update = "UPDATE users SET logged=%s WHERE username=%s AND password=%s"
            val_update = (logged, username, password)
            dbc.execute(sql_update, val_update)
            self.db.commit()
        return True


async def get_prefix(client, message):
    return '/'

intents = discord.Intents.all()
client = commands.Bot(command_prefix=get_prefix, description='PKK', intents=intents)
db = Database()
secret = 0


async def change_secret():
    await client.wait_until_ready()
    while True:
        global secret
        secret = f'{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}{random.randint(0, 9)}'
        print(secret)
        await asyncio.sleep(60 * 30)


class active_user():

    def __init__(self, discord_id, username, password, logged, color):
        self.discord_id = discord_id
        self.username = username
        self.password = password
        self.logged = logged
        self.color = color


active_users = []


@client.event
async def on_ready():
    client.loop.create_task(change_secret())
    print(f"Bot | ID:       {format(client.user.id)}")
    print(f"Bot | Name:     {format(client.user.name)}")
    print(f"Bot | Guilds:   {len(client.guilds)}")
    print(f"Bot is ready to use")


@client.command(name='login', hidden=False, aliases=[])
async def user_login(ctx, username, password):
    await ctx.message.delete()
    if ctx.message.channel.id == 852870764130598922:
            member = get(client.get_all_members(), id=ctx.message.author.id)
            login = db.login(username, password)
            status = 'OK'

            if len(login) == 0:
                status = 'NEOK'
                await member.send('Špatné přihlašovací údaje!')

            if status == 'OK':
                active_users.append(active_user(ctx.message.author.id, username, password, 1, ctx.author.colour))
                await roles_adjust(ctx.message.author.id, 'login')
                await send_embed(ctx.message.author.id, 'přihlásil!')
                await member.send('Přihlasil ses!')


@client.command(name='logout', hidden=False, aliases=[])
async def user_logout(ctx):
    await ctx.message.delete()
    if ctx.message.channel.id == 852870764130598922:
        member = get(client.get_all_members(), id=ctx.message.author.id)

        for user in active_users:
            if user.discord_id == ctx.message.author.id:
                login = db.logging(user.username, user.password, 0)
                await roles_adjust(ctx.message.author.id, 'logout')
                await send_embed(user.discord_id, 'odhlásil')
                active_users.remove(user)
                if login:
                    await member.send('Odhlásil ses!')


@client.command(name='register', hidden=False, aliases=[])
async def user_register(ctx, username, password, key):
    await ctx.message.delete()
    member = get(client.get_all_members(), id=ctx.message.author.id)
    if ctx.message.channel.id == 852870764130598922:
        if key == secret:
            check_user = db.check_user(ctx.message.author.id)
            login = db.user_logins(username, password)
            status = 'OK'
            if len(check_user) == 0:
                if len(login) == 0:
                    if status == 'OK':
                        reg = db.register(ctx.message.author.id, username, password)
                        if reg == 'OK':
                            active_users.append(active_user(ctx.message.author.id, username, password, 1, ctx.author.colour))
                            await roles_adjust(ctx.message.author.id, 'register')
                            await member.send(f'Váš účet byl úspěšně zaregistrován! {username, password}')
                            await send_embed(ctx.message.author.id, 'zaregistroval!')
                        else:
                            await member.send('Posral si to!')
                else:
                    await member.send('Username or PW is taken!')
            else:
                await member.send('NENENE více účtu NENENE')
        else:
            await member.send('https://media2.giphy.com/media/wSSooF0fJM97W/200.gif')
    else:
        await member.send('KMAMSDM')


async def roles_adjust(discord_id, stav):
    logged = 852884618285678642
    unlogged = 852884740787666974
    member = get(client.get_all_members(), id=discord_id)
    if stav == 'login':
        await member.add_roles(member.guild.get_role(logged))
        await member.remove_roles(member.guild.get_role(unlogged))
    elif stav == 'logout':
        await member.add_roles(member.guild.get_role(unlogged))
        await member.remove_roles(member.guild.get_role(logged))
    elif stav == 'register':
        await member.add_roles(member.guild.get_role(logged))


async def send_embed(discord_id, stav):
    channel = client.get_channel(837801659756970084)
    for user in active_users:
        if user.discord_id == discord_id:
            embed = discord.Embed(
                title="Third Eye Software",
                colour=user.color,
                description=f'{user.username} se {stav}',
                timestamp=dt.datetime.utcnow()
            )
            embed.set_footer(text=f"Powered by {client.user.display_name}", icon_url=client.user.avatar_url)
            await channel.send(embed=embed)


@client.command(name='secret', hidden=False, aliases=[])
async def get_secret(ctx):
    if '812016752916430869' in str(ctx.message.author.roles) or '812402808393433118' in str(ctx.message.author.roles):
        member = get(client.get_all_members(), id=ctx.message.author.id)
        await member.send(f'{secret}')


@client.command(name='off', hidden=False, aliases=[])
async def off(ctx):
    if '812016752916430869' in str(ctx.message.author.roles):
        logged = '852884618285678642'
        unlogged = '852884740787666974'
        botOff = '837790055254589440'


@client.event
async def on_command_error(ctx, exc):

    if any([isinstance(exc, error) for error in IGNORE_EXCEPTIONS]):
        pass

    elif isinstance(exc, MissingRequiredArgument):
        await ctx.send("Jeden nebo více argumentu ti chybí dopsat.")

client.remove_command('help')
client.run('')
