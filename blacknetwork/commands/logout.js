const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
const mysql = require('mysql');
const fs = require('fs');

exports.run = (client, message, args, con, tools) => {
    let mChannel = message.mentions.channels.first()
    let moderator = message.author;
    let argsname = args.shift()
    let bmuser = message.author;
    let user = message.author.id;
    let argsresult = args.join(` `);
    var sql = `SELECT * FROM users WHERE Discord = ?`;
    message.delete()
    con.query(sql,[user], (err, results) =>{
        Object.keys(results).forEach(function(key, value) {
            var rows = results[key];
            console.log(rows.Log)
            if (rows.Log == '1'){
                message.member.roles.add(Logout);
                message.member.roles.remove(Logged);
                var embed2 = new MessageEmbed()
                    .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                    .setTitle('Logout')
                    .setDescription(`<${rows.Tel}> se Odhlásil/a z **BlackNetwork**. :white_check_mark:`)
                    .setThumbnail("https://i.imgur.com/w4X8AMU.png")
                    .setColor("Black")
                    .setFooter('Powered by chinese kid')
                    .setTimestamp()
                client.channels.cache.get(Log).send(embed2)
                var emb = new MessageEmbed()
                    .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                    .setTitle('Log')
                    .setDescription(`Úspěšně si se Odhlásil/a na BlackNetwork pane/paní ${rows.Jmeno}.`)
                    .addField("Zůstatek", `Váš zůstatek činí: ${rows.token}x **Dcoin**`)
                    .setColor("RANDOM")
                    .setThumbnail("https://i.imgur.com/w4X8AMU.png")
                    .setFooter('Powered by chinese kid')
                    .setTimestamp()
                message.channel.send(emb)
                con.query('UPDATE users SET Log = ? WHERE lastlog = ? AND Log = ?', ["0", ${rows.Tel}, "1"]);
            } else {
                return message.author.send("⛔ | Účet už je odhlášen!");
            }
        });
    });


}

