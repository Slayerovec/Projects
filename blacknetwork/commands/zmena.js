const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, Cena} = require ('./cfg.json');
const mysql = require('mysql');
exports.run = (client, message, args, con, tools) => {
    var argsname = args.shift()
    var bmuser = message.author.id;
    var sql = `SELECT * FROM users WHERE Discord = ? AND log = ?`;
    var sql2 = `SELECT * FROM users WHERE Jmeno = ?`;
    message.delete()
    if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
        con.query(sql,[bmuser, "1"], (err, results) =>{
            Object.keys(results).forEach(function(key) {
                var rows = results[key];
                var name = rows.Jmeno
                con.query(sql2,[argsname], (err, result) =>{
                    if (result.length > 0)  {
                        message.channel.send("⛔ | Jméno je už zabrané! ");
                    } else {
                        if (rows.token >= Cena)  {
                            var token = parseInt(rows.token) - parseInt(Cena)
                            let embed2 = new MessageEmbed()
                                .setAuthor(`BlackNetwork`, client.user.displayAvatarURL)
                                .setTitle('Nickname change')
                                .setDescription(`${name} změnil si jméno na ${argsname} za ${Cena} Dcoin`)
                                .setThumbnail("https://i.imgur.com/RVKYnVZ.png")
                                .setColor("RANDOM")
                                .setFooter('Powered by chinese kid')
                                .setTimestamp()
                            message.channel.send(embed2)
                            let embed3 = new MessageEmbed()
                                .setAuthor(`BlackNetwork`, client.user.displayAvatarURL)
                                .setTitle('Log')
                                .setDescription(`${name} si změnil jméno na ${argsname} za ${Cena} Dcoin. :white_check_mark:`)
                                .setThumbnail("https://i.imgur.com/RVKYnVZ.png")
                                .setColor(`RANDOM`)
                                .setFooter('Powered by chinese kid')
                                .setTimestamp()
                            client.channels.cache.get(LogBlackNetwork).send(embed3)
                            console.log(con.query(`UPDATE users SET Jmeno = '${argsname}', token = ${token} WHERE Discord = '${bmuser}'`))
                            con.query('UPDATE feedback SET author = ? WHERE author = ?', [argsname, name])
                            con.query('UPDATE feedback SET killer = ? WHERE killer = ?', [argsname, name])
                        } else {
                            message.channel.send("⛔ | Máš málo Dcoinů");
                        }
                    }
                })
            })
        });
    } else {
        message.author.send('Musíš se nejdřív přihlásit');
    }   

}