const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
const mysql = require('mysql');

exports.run = (client, message, args, con, tools) => {
    let mChannel = message.mentions.channels.first()
    let moderator = message.author;
    let bmuser = message.author.id
    let argsresult = args.join(` `);
    var sql = `SELECT * FROM users`;
    message.delete()
    if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
        if(message.member.roles.cache.some(r=>["Správce"].includes(r.name)) ) {
            con.query(sql, (err, results) =>{
                Object.keys(results).forEach(function(key, value) {
                    var rows = results[key];
                    if (rows.length != 0){
                        let embed2 = new MessageEmbed()
                            .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                            .setTitle('Mass Messages')
                            .setDescription(`${argsresult}`)
                            .setThumbnail("https://i.imgur.com/bHZM9o2.png")
                            .setColor("RANDOM")
                            .setFooter('From: ' + 'BlackNetwork' + ' ' + 'To: ' + rows.Jmeno)
                            .setTimestamp()
                        client.channels.cache.find(channel => channel.name === rows.Discord).send(embed2)
                        let embed3 = new MessageEmbed()
                            .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                            .setTitle('Log')
                            .setDescription(`Správce ${bmuser} použil/a DMS. :white_check_mark: *(${argsresult})*`)
                            .setThumbnail("https://i.imgur.com/bHZM9o2.png")
                            .setColor(`RANDOM`)
                            .setTimestamp()
                        client.channels.cache.get(LogBlackNetwork).send(embed3)
                    } else {
                        message.author.send('Uživatel není online nebo si zadal špatné jméno!');
                    }
                })
            });
        } else {
            message.author.send('Nemáš na to práva!');
        }
    } else {
        message.author.send('Musíš se nejdřív přihlásit');
    }
}