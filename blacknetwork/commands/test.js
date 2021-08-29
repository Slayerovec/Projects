const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
exports.run = (client, message, args, tools) => {
    js = [ SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie ]
    json = JSON.stringify(js)
    message.delete()
    var embed = new MessageEmbed()
        .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
        .setTitle("Příkazy")
        .setThumbnail('https://i.imgur.com/z7BOUc3.png')
        .setDescription('Příkazy, které můžete použít např:./commands (ukáže ti přesně tohle)')

        .setURL('https://www.youtube.com/watch?v=4aRunhg5JwQ')
        .setColor("WHITE")
        .setFooter('Powered by chinese kid')
        .setTimestamp()
        Object.keys(js).forEach(function(key) {
            var dat = js[key]
            embed.addField(key, dat, true)
        })
        console.log(embed.toJSON())
        console.log(15 % 2)
    message.channel.send(embed)
}