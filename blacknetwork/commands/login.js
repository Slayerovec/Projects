const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
const { Client, MessageEmbed } = require('discord.js');
const mysql = require('mysql');
const fs = require('fs');

exports.run = (client, message, args, con, tools) => {
    let mChannel = message.mentions.channels.first()
    let moderator = message.author;
    var argsname = args.shift()
    var argsname2 = args.shift()
    let argsresult = args.join(` `);
    let bmuser = message.author
    let user = message.author.id
    var sql = `SELECT * FROM users WHERE Discord = ?`;
    message.delete() 
    con.query('SELECT * FROM users WHERE Jmeno = ? AND PW = ? AND log = 0', [argsname, argsname2], (err, result) =>{
        if (result.length > 0){
            Object.keys(result).forEach(function(key, value) {
                var rows = result[key];
                var embed2 = new MessageEmbed()
                    .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                    .setTitle('Login')
                    .setDescription(`<${rows.Tel}> se přihlásil/a na **BlackNetwork**. :white_check_mark:`)
                    .setThumbnail("https://i.imgur.com/pLcRypU.png")
                    .setColor("Red")
                    .setFooter('Powered by chinese kid')
                    .setTimestamp()
                    con.query('UPDATE users SET Log = ?, lastlog = ? WHERE Jmeno = ? AND PW = ? AND Log = ?', ["1", rows.Tel, argsname, argsname2, "0"]);
                    client.channels.cache.get(Log).send(embed2)
                    message.member.roles.add(Logged)
                    message.member.roles.remove(Logout)
                    let emb = new MessageEmbed()
                        .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                        .setTitle('Log')
                        .setDescription(`Úspěšně si se příhlásil/a na blacknetwork pane ${argsname}.`)
                        .addField("Zůstatek", `Váš zůstatek činí: ${rows.token}x Dcoin`)
                        .setColor("RANDOM")
                        .setThumbnail("https://i.imgur.com/pLcRypU.png")
                        .setFooter('Powered by chinese kid')
                        .setTimestamp()
                    message.channel.send(emb)
            })
        } else {
            return message.author.send("⛔ | Špatné přihlašovácí údaje, nebo účet je příhlášen!");
        }
    });
}


function addUserRole(roleName,message){
    var role = message.guild.roles.find(`name`, `roleName`)
     message.member.addRole(role.id)
}