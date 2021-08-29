from datetime import datetime, timedelta
from psutil import Process, virtual_memory
from discord import __version__ as discord_version
from platform import python_version
from time import time
from imports import *
jsons = jsons.jsons()


class Info(commands.Cog):

    def __init__(self, client):
        self.client = client

    @commands.command(name="ping")
    async def ping(self, ctx):
        start = time()
        message = await ctx.send(f"Pong! latency: {self.client.latency*1000:,.0f} ms.")
        end = time()
        await message.edit(content=f"Pong! latency: {self.client.latency*1000:,.0f} ms. Response time: {(end-start)*1000:,.0f} ms.")

    @commands.command(name="show_bot_stats")
    async def show_bot_stats(self, ctx):
        embed = Embed(
            title="Bot stats",
            colour=ctx.author.colour,
            thumbnail=self.client.user.avatar_url,
            timestamp=datetime.utcnow()
            )

        proc = Process()
        with proc.oneshot():
            uptime = timedelta(seconds=time()-proc.create_time())
            cpu_time = timedelta(seconds=(cpu := proc.cpu_times()).system + cpu.user)
            mem_total = virtual_memory().total / (1024**2)
            mem_of_total = proc.memory_percent()
            mem_usage = mem_total * (mem_of_total / 100)
        fields = [
            ("**Bot version**", jsons.get_groot('version'), True),
            ("**Python version**", python_version(), True),
            ("**Discord.py version**", discord_version, True),
            ("**Uptime**", uptime, True),
            ("**CPU time**", cpu_time, True),
            ("**Memory usage**", f"{mem_usage:,.3f} / {mem_total:,.0f} MiB ({mem_of_total:.0f}%)", True),
            ("**Users**", f"{len(self.client.users):,}", True)
        ]

        for name, value, inline in fields:
            embed.add_field(name=name, value=value, inline=inline)

        await ctx.send(embed=embed)

    @commands.command(name="userinfo", aliases=["memberinfo", "ui", "mi"])
    async def user_info(self, ctx, target: Optional[Member]):
        target = target or ctx.author

        embed = Embed(
            title="User information",
            colour=target.colour,
            timestamp=datetime.utcnow()
        )

        embed.set_thumbnail(url=target.avatar_url)

        fields = [
            ("Name", str(target), True),
            ("ID", target.id, True),
            ("Bot?", target.bot, True),
            ("Top role", target.top_role.mention, True),
            ("Status", str(target.status).title(), True),
            ("Activity", f"{str(target.activity.type).split('.')[-1].title() if target.activity else 'N/A'} {target.activity.name if target.activity else ''}", True),
            ("Created at", target.created_at.strftime("%d/%m/%Y %H:%M:%S"), True),
            ("Joined at", target.joined_at.strftime("%d/%m/%Y %H:%M:%S"), True),
            ("Boosted", bool(target.premium_since), True)
        ]

        for name, value, inline in fields:
            embed.add_field(name=name, value=value, inline=inline)

        await ctx.send(embed=embed)

    @commands.command(name="serverinfo", aliases=["guildinfo", "si", "gi"])
    async def server_info(self, ctx):
        embed = Embed(
            title="Server information",
            colour=ctx.guild.owner.colour,
            timestamp=datetime.utcnow()
        )

        embed.set_thumbnail(url=ctx.guild.icon_url)

        fields = [
            ("ID", ctx.guild.id, True),
            ("Owner", ctx.guild.owner, True),
            ("Region", ctx.guild.region, True),
            ("Created at", ctx.guild.created_at.strftime("%d/%m/%Y %H:%M:%S"), True),
            ("Members", len(ctx.guild.members), True),
            ("Humans", len(list(filter(lambda m: not m.bot, ctx.guild.members))), True),
            ("Bots", len(list(filter(lambda m: m.bot, ctx.guild.members))), True),
            ("Banned members", len(await ctx.guild.bans()), True),
            ("Text channels", len(ctx.guild.text_channels), True),
            ("Voice channels", len(ctx.guild.voice_channels), True),
            ("Categories", len(ctx.guild.categories), True),
            ("Roles", len(ctx.guild.roles), True),
            ("Invites", len(await ctx.guild.invites()), True)
        ]

        for name, value, inline in fields:
            embed.add_field(name=name, value=value, inline=inline)

        await ctx.send(embed=embed)


def setup(client):
    client.add_cog(Info(client))
