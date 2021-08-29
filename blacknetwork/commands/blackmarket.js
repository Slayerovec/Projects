const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
const mysql = require('mysql');
exports.run = (client, message, args, con, tools) => {
    let mChannel = message.mentions.channels.first()
    let moderator = message.author;
    var bmuser = message.author.id;
    var sql = `SELECT * FROM users WHERE log = ? AND Discord = ?`;
    let argsresult = args.join(` `);
    message.delete()
    if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
        con.query(sql,["1", bmuser], (err, results) =>{
            Object.keys(results).forEach(function(key, value) {
                var rows = results[key];
                let embed2 = new MessageEmbed()
                    .setAuthor(`${rows.Jmeno}`, client.user.displayAvatarURL())
                    .setTitle('Message')
                    .setDescription(`${argsresult}`)
                    .setColor("RANDOM")
                    .setFooter('Powered by chinese kid')
                    .setTimestamp()
                client.channels.cache.get(Chat).send(embed2)
                let embed3 = new MessageEmbed()
                    .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                    .setTitle('Log')
                    .setDescription(`<@${bmuser}> použil/a blackmarket. :white_check_mark: *(${argsresult})*`)
                    .setColor(`RANDOM`)
                    .setFooter('Powered by chinese kid')
                    .setTimestamp()
                client.channels.cache.get(LogBlackNetwork).send(embed3)
            })
        });
    } else {
        message.author.send('Musíš se nejdřív přihlásit');
    }

}