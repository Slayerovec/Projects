const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
const mysql = require('mysql');
exports.run = (client, message, args, con, tools) => {
    let mChannel = message.mentions.channels.first()
    let moderator = message.author;
    var argsname = args.shift()
    var argsname2 = args.shift()
    var argsname3 = args.shift()
    let bmuser = message.author;
    message.delete()
    con.query('SELECT * FROM users WHERE Jmeno = ?', [argsname, argsname3], (err, result, fields) =>{
        if(err) throw err;
        if (result.length > 0)  {
            return message.author.send("⛔ | Už máš účet na BlackNetworku nebo Jméno účtu už je zabrané!");
        } else {
            const embed = new MessageEmbed()
                .setAuthor(`BlackNetwork`, client.user.displayAvatarURL)
                .setTitle('Powered by chinese kid')
                .setDescription(`/do Je číslo právé a tvoje?`)
                .setColor("Green")
                .setTimestamp("Máš 60s na odpověď")
                .setFooter('Requested By BlackNetwork')
            const ano = require('./1.json');
            const item = ano[Math.floor(Math.random() * ano.length)];
            const filter = response => {
                return item.answers.some(answer => answer.toLowerCase() === response.content.toLowerCase());
            };
            message.channel.send(embed).then(() => {
            message.channel.awaitMessages(filter, { maxMatches: 1, time: 60000, errors: ['time'] })
                .then(collected => {
                    console.log(con.query(`INSERT INTO users (Discord, Jmeno, PW, Tel, log, lastlog) VALUES ('${message.author.id}','${argsname}','${argsname2}','${argsname3}', "1", '${argsname3}')`))
                    console.log(con.query('UPDATE user SET Discord = ?, Tel = ? WHERE Discord = ?', [message.author.id, argsname3, message.author.id]));
                    message.author.send(`Discord: ${message.author} Jmeno: ${argsname} PW:${argsname2} Tel:${argsname3}`);
                    client.channels.cache.get(LogSpravce).send(`${message.author.id} si založil další učet na **BlackNetwork**. :white_check_mark:`)
                    client.channels.cache.get(SpravaPripojeni).send(`Byl udělen přístup pro Tel: ${argsname3}. :white_check_mark: (${message.author.id})`)
                })
                .catch(collected => {
                    message.author.send('Looks like nobody got the answer this time.');
                });
            });
        }
    })
}