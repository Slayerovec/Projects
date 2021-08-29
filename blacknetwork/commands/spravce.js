const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
const mysql = require('mysql');

exports.run = (client, message, args, con, tools) => {
    var mChannel = message.mentions.channels.first()
    var moderator = message.author;
    var bmuser = message.author.id
    var sql = `SELECT * FROM users WHERE Jmeno = ? AND log = ?`;
    var sql2 = `SELECT * FROM users WHERE Spravce = ?`;
    var argsname = args.shift();
    var name
    message.delete()
    if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
        if(message.member.roles.cache.some(r=>["Správce"].includes(r.name)) ) {
            con.query(sql,[argsname, '1'], (err, results) =>{
                Object.keys(results).forEach(function(key, value) {
                    var rows = results[key];
                    if (rows.length != 0){
                        name = rows.Jmeno
                        var embed2 = new MessageEmbed()
                            .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                            .setTitle('Byl jsi povýšen!')
                            .setDescription('Uživateli ' + rows.Jmeno + ' byl jsi povýšen na správce BlackNetworku, užívej svou moc moudře!')
                            .setThumbnail("https://i.imgur.com/IOTjgg1.png")
                            .setColor("GREEN")
                            .setFooter('From: ' + 'BlackNetwork' + ' ' + 'To: ' + rows.Jmeno)
                            .setTimestamp()
                        client.channels.cache.find(channel => channel.name === rows.Discord).send(embed2)
                        console.log(client.users)
                        //client.users.cache.find(user => user.id === rows.Discord)
                        con.query('UPDATE users SET Spravce = ? WHERE Jmeno = ?', ["1", rows.Discord]);
                        con.query(sql2,['1'], (err, dat) =>{
                            Object.keys(dat).forEach(function(key, value) {
                                var data = dat[key];
                                var embed3 = new MessageEmbed()
                                    .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                                    .setTitle('Log')
                                    .setDescription(`${name} byl povýšen/a na Správce!. :white_check_mark:`)
                                    .setThumbnail("https://i.imgur.com/IOTjgg1.png")
                                    .setColor(`RANDOM`)
                                    .setFooter('Powered by chinese kid')
                                    .setTimestamp()
                                client.channels.cache.find(channel => channel.name === data.Discord).send(embed3)
                                client.channels.cache.get(LogBlackNetwork).send(embed3)
                            })
                        });
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