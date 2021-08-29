const { Client, MessageEmbed } = require('discord.js');
const mysql = require('mysql');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie, Spravce} = require ('./cfg.json');

exports.run = (client, message, args, con, tools) => {
    var name = args.shift()
    var sql = `SELECT * FROM feedback WHERE killer = ?`;
    var stars = 0
    var count = 0
    message.delete()
    if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
            con.query(sql,[name], (err, data) =>{  /// ten co to používá vše
                if (data.length != 0){
                    var embed = new MessageEmbed()
                        .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                        .setTitle("Review na osobu " + name)
                        .setThumbnail('https://i.imgur.com/ET8hxpC.png')
                        .setDescription('Příkazy, které můžete použít např:./commands (ukáže ti přesně tohle)')
                        .setColor("WHITE")
                        .setFooter('Powered by chinese kid')
                        .setTimestamp()
                        Object.keys(data).forEach(function(key, value) {
                            var dat = data[key]
                            stars = stars + dat.stars
                            count = count + 1
                            embed.addField(dat.cID, dat.feedback, true)
                        })
                        stars = stars / count
                        embed.setDescription('Hodnocení: ' + stars.toFixed(2) + '/10')
                    message.channel.send(embed)
                } else {
                    message.channel.send('Nemá žádný feedbacky.');
                }
            });
    } else {
        message.author.send('Musíš se nejdřív přihlásit');
    }
}