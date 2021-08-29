const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
const mysql = require('mysql');
exports.run = (client, message, args, con, tools) => {
    let mChannel = message.mentions.channels.first()
    let moderator = message.author;
    let argsname = args.shift()
    let bmuser = message.author.id
    let argsresult = args.join(` `);
    var test = [argsname, '1']
    var sql = `SELECT * FROM users WHERE Jmeno = ? AND log = ?`;
    if (argsname == 'BlackNetwork') {
        var sql = `SELECT * FROM users WHERE Spravce = ?`;
        var test = ['1']
    }
    var sql2 = `SELECT * FROM users WHERE Discord = ? AND log = ?`;
    message.delete()
    if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
        con.query(sql, test, (err, results) =>{
            if (err) { throw err }
            Object.keys(results).forEach(function(key, value) {
                var rows = results[key];
                con.query(sql2,[bmuser, '1'], (err, results) =>{
                    Object.keys(results).forEach(function(key, value) {
                        var row = results[key];
                        if (rows.length != 0){
                            if (argsname == 'BlackNetwork') {
                                row.Jmeno = 'BlackNetwork'
                            }
                            var embed2 = new MessageEmbed()
                                .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                                .setTitle('Direct Message')
                                .setDescription(`${argsresult}`)
                                .setThumbnail("https://i.imgur.com/bHZM9o2.png")
                                .setColor("RANDOM")
                                .setTimestamp()
                                .setFooter('From: ' + row.Jmeno + ' ' + 'To: ' + rows.Jmeno)
                            client.channels.cache.find(channel => channel.name === rows.Discord).send(embed2)
                            var embed3 = new MessageEmbed()
                                .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                                .setTitle('Log')
                                .setDescription(`${rows.Jmeno} použil/a DMS. :white_check_mark: *(${argsresult})*`)
                                .setThumbnail("https://i.imgur.com/bHZM9o2.png")
                                .setColor(`RANDOM`)
                                .setFooter('Powered by chinese kid')
                                .setTimestamp()
                            client.channels.cache.get(LogBlackNetwork).send(embed3)
                        } else {
                            message.author.send('Uživatel není online nebo si zadal špatné jméno!');
                        }
                    })
                });
            })
        });
    } else {
        message.author.send('Musíš se nejdřív přihlásit');
    }
}