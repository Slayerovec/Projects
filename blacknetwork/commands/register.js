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

    var sql = `SELECT * FROM pd`;
    con.query(sql, (err, rr) =>{
        if (rr.length != 0)  {
            client.channels.cache.get(LogSpravce).send(`⛔ | BN.Jméno ='${argsname}', BN.Heslo ='${argsname2}', BN.Tel ='${argsname3}', BN.PD.Tel ='${row.Tel}', BN.PD.Jméno ='${row.Jméno}'  PD se snažilo přihlásit`)
            return message.author.send("⛔ | Táhni PDčko!");
        } else {
            con.query('SELECT * FROM users WHERE Jmeno = ? OR Tel = ?', [argsname, argsname3], (err, result, fields) =>{
                if(err) throw err;
                if (result.length > 0)  {
                    return message.author.send("⛔ | Už máš účet na BlackNetworku nebo Jméno účtu už je zabrané!");
                } else {
                    var embed = new MessageEmbed()
                        .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                        .setTitle('Powered by chinese kid')
                        .setDescription(`/do Je číslo pravé a tvoje? Pokud je odepiš jenom ano`)
                        .setThumbnail("https://i.imgur.com/TmQFbxy.png")
                        .setColor("Green")
                        .setTimestamp("Máš 60s na odpověď")
                        .setFooter('Requested By BlackNetwork')
                    const ano = require('./1.json');
                    const item = ano[Math.floor(Math.random() * ano.length)];
                    const filter = response => {
                            return item.answers.some(answer => answer.toLowerCase() === response.content.toLowerCase());
                    };
                    message.channel.send(embed).then(() => {
                    message.channel.awaitMessages(filter, { max: 1, time: 60000, errors: ['time'] })
                        .then(collected => {
                            message.member.roles.add(Logged)
                            message.member.roles.add(Registered)
                            message.member.roles.add(Agreed)
                            message.member.roles.remove(Checked)
                            message.member.roles.remove(NewBie)
                            con.query(`INSERT INTO users(Discord, Jmeno, PW, Tel, log, lastlog) VALUES ('${message.author.id}','${argsname}','${argsname2}','${argsname3}', "1", '${argsname3}')`)
                            roles = [ Agreed, Registered ]
                            json = JSON.stringify(roles)
                            console.log(con.query('UPDATE user SET roles = ? WHERE discord_id = ?', [bmuser.id, json]))
                            message.author.send(`Registrace úspěšná Discord: ${message.author} Jmeno: ${argsname} PW:${argsname2} Tel:${argsname3}`);
                            client.channels.get(LogBlackNetwork).send(`${message.author.id} si založil učet na **BlackNetwork**. :white_check_mark:`)
                            var embed2 = new MessageEmbed()
                                .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                                .setTitle('Log')
                                .setDescription(`Byl udělen přístup pro Tel: ${argsname3}. :white_check_mark: (${message.author.id})`)
                                .setThumbnail("https://i.imgur.com/MVcTYFE.png")
                                .setColor(`GREEN`)
                                .setFooter('Powered by chinese kid')
                                .setTimestamp()
                            client.channels.cache.get(SpravaPripojeni).send(embed2)
                        })
                        .catch(collected => {
                            message.author.send('Nestihl jsi napsat Ano v daný čas.');
                        });
                    });
                }
            })
        }
    })
   function ID() {
        if (!cID){
            var number = []
            var sql = `SELECT * FROM contract WHERE contract_id = ?`;
            contractID(5)
            var IDs = number[0]+number[1]+number[2]+number[3]+number[4]
                con.query(sql,[IDs], (err, rr) =>{
                    if (err) {throw err}
                    if (rr.length != 0){
                        number = []
                        contractID(5)
                        IDs = number[0]+number[1]+number[2]+number[3]+number[4]
                        ID()
                    } else {
                        cID = IDs
                        sendingEmbed(cID)
                    }
                })

                function contractID(length) {
                count = Math.random() * 10;
                    if (length > 0) {
                        number[number.length] = count.toFixed(0)
                        contractID(length - 1)
                    }
                }
        }
    }
}

