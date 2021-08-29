const { Client, MessageEmbed } = require('discord.js');
const mysql = require('mysql');
exports.run = (client, message, args, con, tools) => {
    let mChannel = message.mentions.channels.first()
    var bmuser = message.author.id;
    var sql = `SELECT * FROM users WHERE Discord = ?`;
    message.delete()
    if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
        con.query(sql,[bmuser], (err, result) =>{ //// tomu komu posílam tokeny získam info
            Object.keys(result).forEach(function(key) {
                var row2 = result[key];
                let embed2 = new MessageEmbed()
                    .setAuthor(`Blacknetwork`, client.user.displayAvatarURL())
                    .setTitle('Account')
                    .setDescription(`Tady vidíš přehled svého Účtu`)
                    .addField("Jméno", `${row2.Jmeno}`)
                    .addField("Tel. Číslo", `${row2.Tel}`, true)
                    .addField("Heslo", `${row2.PW}`, true)
                    .addField("Dcoin", `${row2.token}`, true)
                    .setThumbnail("https://i.imgur.com/pLcRypU.png")
                    .setColor("RANDOM")
                    .setFooter('Powered by chinese kid')
                    .setTimestamp()
                message.channel.send(embed2)
            })
        });
    } else {
        let embed3 = new MessageEmbed()
        message.author.send('Musíš se nejdřív přihlásit');
    }
}