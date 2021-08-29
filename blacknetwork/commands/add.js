const { Client, MessageEmbed } = require('discord.js');
const { LogBlackNetwork } = require ('./cfg.json');
const mysql = require('mysql');
exports.run = (client, message, args, con, tools) => {
    var argsname = args.shift()
    var argsname2 = args.shift()
    let mChannel = message.mentions.channels.first()
    var bmuser = message.author.id;
    var sql = `SELECT * FROM users WHERE Jmeno = ?`;
    var example = argsname2 / 10
    message.delete()
    if (example) {
        if(message.member.roles.cache.some(r=>["Správce"].includes(r.name)) ) {
            if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
                con.query(sql,[argsname], (err, results) =>{  /// ten co to používá vše
                    Object.keys(results).forEach(function(key) {
                        var rows = results[key];
                        var token = parseInt(argsname2) + parseInt(rows.token);
                            con.query('UPDATE users SET token = ? WHERE Tel = ?', [token, rows.Tel]);
                        let embed2 = new MessageEmbed()
                            .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                            .setTitle('Dcoin ADD')
                            .setDescription(`BlackNetwork přidal **${argsname2} Dcoinů** uživateli ${rows.Jmeno}`)
                            .setThumbnail("https://i.imgur.com/y00EFzS.png")
                            .setFooter('Transakce provedena')
                            .setColor("Green")
                            .setTimestamp()
                        message.channel.send(embed2)
                        client.channels.cache.find(channel => channel.name === rows.Discord).send(embed2)
                        let embed3 = new MessageEmbed()
                            .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                            .setTitle('Log')
                            .setDescription(`BlackNetwork přidal Uživateli: ${rows.Jmeno} počet: ${argsname2} :white_check_mark:`)
                            .setColor(`RANDOM`)
                            .setThumbnail("https://i.imgur.com/y00EFzS.png")
                            .setFooter('Powered by chinese kid')
                            .setTimestamp()
                        client.channels.cache.get(LogBlackNetwork).send(embed3)
                    })
                });
            } else {
                message.author.send('Musíš se nejdřív přihlásit');
            }
        } else {
            message.author.send('Nejsi správce!');
        }
    } else {
        message.author.send('Zadej číslici!');
    }

}