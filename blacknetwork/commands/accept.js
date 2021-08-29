const { Client, MessageEmbed } = require('discord.js');
const mysql = require('mysql');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie, Spravce} = require ('./cfg.json');

exports.run = (client, message, args, con, tools) => {
    let bmuser = message.author.id;
    var ID = args.shift()
    var sql = `SELECT * FROM contract WHERE contract_id = ?`;
    var sql2 = `SELECT * FROM users WHERE Discord = ?`;
    var example = ID / 10
    message.delete()
    if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
        if (example) {
            con.query(sql,[ID], (err, data) =>{  /// ten co to používá vše
                Object.keys(data).forEach(function(key, value) {
                    var dat = data[key];
                    if (dat.length > 0){
                        var json = JSON.parse(dat.contract_json)
                        con.query(sql,[bmuser], (err, results) =>{  /// ten co to používá vše
                            Object.keys(results).forEach(function(key, value) {
                                var rows = results[key];
                                var embed = new MessageEmbed()
                                    .setAuthor(`Blacknetwork`, client.user.displayAvatarURL())
                                    .setTitle('Kontrakt Info')
                                    .setDescription(rows.Jmeno + 'přijmul Váš kontrakt č.: ' + json[0] + ' na osobu ' + json[1])
                                    .setThumbnail('https://i.imgur.com/T9G2apN.png')
                                    .setImage(json[3])
                                    .setColor("Green")
                                    .setFooter('Powered by chinese kid')
                                    .setTimestamp()
                                client.channels.cache.find(channel => channel.name === dat.contract_author).send(embed)
                                 var embed2 = new MessageEmbed()
                                    .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                                    .setTitle('Jmeno: ' + json[1] + ' /Za ' + json[4] + ' ' +'Nabízí'+ ' ' + json[5] + '$')
                                    .setDescription('Podrobnosti:' + json[2] )
                                    .setThumbnail('https://i.imgur.com/T9G2apN.png')
                                    .setImage(json[3])
                                    .setColor("Green")
                                    .setTimestamp()
                                    .setFooter(json[0] + 'Taken by:' + rows.Jmeno)
                                 con.query('UPDATE contract SET contract_AID = ? AND contract_taker = ? WHERE contract_id = ?', ['${rows.Discord}', '${rows.Jmeno}', '${ID}']);
                                 message.channel.send('Příjmul si kontrakt č.' + json[0]);
                                 client.channels.cache.get(Chat).messages.fetch(json[6]).then(msg => msg.edit(embed))
                            })
                        });
                    }
                })
            });
       } else {
            message.channel.send('Tohle tak není úplně číslo.');
       }
    } else {
        message.author.send('Musíš se nejdřív přihlásit');
    }

}