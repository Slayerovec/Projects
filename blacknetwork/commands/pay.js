const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie, Spravce} = require ('./cfg.json');
const mysql = require('mysql');

exports.run = (client, message, args, con, tools) => {
    var argsname = args.shift()
    var argsname2 = args.shift()
    let mChannel = message.mentions.channels.first()
    var bmuser = message.author.id;
    var sql = `SELECT * FROM users WHERE Jmeno = ?`;
    var sql2 = `SELECT * FROM users WHERE Discord = ?`;
    var example = argsname2 / 10
    message.delete()
    if (example) {
        if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
            con.query(sql2,[bmuser], (err, data) =>{  ///  Já
                Object.keys(data).forEach(function(key, value) {
                    var row = data[key];
                    con.query(sql,[argsname], (err, results) =>{ // on
                        Object.keys(results).forEach(function(key, value) {
                            var rows = results[key];
                            if (row.Jmeno != rows.Jmeno){
                                var token = parseInt(argsname2) + parseInt(rows.token);
                                var token2 =  parseInt(row.token) - parseInt(argsname2);
                                if (argsname2 <= row.Token){
                                        con.query('UPDATE users SET token = ? WHERE Tel = ?', [token, row.Tel]);
                                        con.query('UPDATE users SET token = ? WHERE Tel = ?', [token, rows.Tel]);
                                    let embed2 = new MessageEmbed()
                                        .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                                        .setTitle('Dcoin Transfer')
                                        .setDescription(`${row.Jmeno} přidal **${argsname2} Dcoinů** uživateli ${rows.Jmeno}`)
                                        .setThumbnail("https://i.imgur.com/y00EFzS.png")
                                        .setFooter('Transakce provedena')
                                        .setColor("Green")
                                        .setTimestamp()
                                    message.channel.send(embed2)
                                    client.channels.cache.find(channel => channel.name === rows.Discord).send(embed2)
                                    let embed3 = new MessageEmbed()
                                        .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                                        .setTitle('Log')
                                        .setDescription(`${row.Jmeno} přidal Uživateli: ${rows.Jmeno} počet: ${argsname2} :white_check_mark:`)
                                        .setColor(`RANDOM`)
                                        .setThumbnail("https://i.imgur.com/y00EFzS.png")
                                        .setFooter('Powered by chinese kid')
                                        .setTimestamp()
                                    client.channels.cache.get(LogBlackNetwork).send(embed3)
                                }
                            } else {
                                message.channel.send('Neposílej peníze sam sobě!');
                            }
                        })
                    });
                })
            });
        } else {
            message.author.send('Musíš se nejdřív přihlásit');
        }
    } else {
        message.channel.send('Zadej číslici!');
    }

}