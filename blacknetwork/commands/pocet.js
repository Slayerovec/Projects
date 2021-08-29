const { Client, MessageEmbed } = require('discord.js');
const mysql = require('mysql');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie, Spravce} = require ('./cfg.json');
exports.run = (client, message, args, con, tools) => {
    let mChannel = message.mentions.channels.first()
    var bmuser = message.author.id;
    var sql = `SELECT * FROM users WHERE Discord = ?`;
    message.delete()
    if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
        con.query(sql,[bmuser], (err, results) =>{  /// ten co to používá vše
            Object.keys(results).forEach(function(key, value) {
                var rows = results[key];
                let embed2 = new MessageEmbed()
                    .setAuthor(`Blacknetwork`, client.user.displayAvatarURL())
                    .setTitle('Dcoins')
                    .setDescription(`${rows.Jmeno} máš ${rows.token}x Dcoin`)
                    .setThumbnail("https://i.imgur.com/yMhfSLC.png")
                    .setColor("RANDOM")
                    .setFooter('Powered by chinese kid')
                    .setTimestamp()
                message.channel.send(embed2)
            })
        });
    } else {
        message.author.send('Musíš se nejdřív přihlásit');
    }   

}