const { Client, MessageEmbed } = require('discord.js');
const mysql = require('mysql');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie, Spravce} = require ('./cfg.json');

exports.run = (client, message, args, con, tools) => {
    let bmuser = message.author.id;
    var ID = args.shift()
    var status = args.shift()
    if (status == 'done') {
        var img = args.shift()
    } else if (status == ' payout') {
        var stars = args.shift()
    }
    var sql = `SELECT * FROM contract WHERE contract_id = ?`;
    var sql2 = `SELECT * FROM users WHERE Discord = ?`;
    var example = ID / 10
    let argsresult = args.join(` `);
    message.delete()
    if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
        if (example) {
            con.query(sql,[ID], (err, data) =>{
                Object.keys(data).forEach(function(key, value) {
                    var dat = data[key];
                    if (dat.contract_done == 0){
                        if (dat.contract_AID == bmuser && dat.contract_author != bmuser){
                            var json = JSON.parse(dat.contract_json)
                            let embed = new MessageEmbed()
                                .setAuthor(`Blacknetwork`, client.user.displayAvatarURL())
                                .setTitle('Kontrakt Info')
                                .setDescription(dat.Taker + 'dokončil Váš kontrakt č.: ' + json[0] + ' na osobu ' + json[1])
                                .setThumbnail("https://i.imgur.com/T9G2apN.png")
                                .setURL(img)
                                .setColor("Green")
                                .setFooter('Powered by chinese kid')
                                .setTimestamp()
                            client.channels.cache.find(channel => channel.name === dat.contract_author).send(embed)
                            message.channel.send('Zpráva byla odeslána!');
                            con.query('UPDATE contract SET contract_info = ? WHERE contract_id = ?', ['${img}', '${json[0]}']);
                        } else {
                            if (dat.contract_AID != bmuser && dat.contract_author == bmuser) {
                                con.query(sql,[bmuser], (err, results) =>{  /// ten co to používá vše
                                    Object.keys(results).forEach(function(key, value) {
                                        var rows = results[key];
                                        if (rows.token >= json[5]){
                                            var price = rows.token - json[5]
                                            let embed = new MessageEmbed()
                                                .setAuthor(`Blacknetwork`, client.user.displayAvatarURL())
                                                .setTitle('Kontrakt Info')
                                                .setDescription('bylo Vám zaplaceno za kontrakt č.: ' + json[0] + ' na osobu ' + json[1] + '. Bylo Vám vyplaceno ' + json[5])
                                                .addField('Stars: ' + + '/10', ,true)
                                                .setThumbnail("https://i.imgur.com/T9G2apN.png")
                                                .setURL(img)
                                                .setColor("Green")
                                                .setFooter('Powered by chinese kid')
                                                .setTimestamp()
                                            message.channel.send('Zaplatil jste za Váš kontrakt. Děkujeme za feedback na' + dat.Taker);
                                            con.query('UPDATE users SET token = ? WHERE Discord = ?', ['${price}', '${bmuser}']);
                                            con.query('UPDATE contract SET contract_done = ? WHERE contract_author = ?', ['1', '${bmuser}']);
                                            con.query(`INSERT INTO feedback (cID, killer, author, feedback, stars) VALUES (${json[0]}, ${dat.contract_taker}, ${dat.contract_author}, ${dat.argsresult}, ${stars})`);
                                            client.channels.cache.find(channel => channel.name === dat.contract_author).send(embed)
                                        }
                                    })
                                });

                            } else {
                                message.channel.send('Tak nějak nevím o co ti jde.');
                            }
                        }
                    })
                });
            });
       } else {
            message.channel.send('Tohle tak není úplně číslo.');
       }
    } else {
        message.author.send('Musíš se nejdřív přihlásit');
    }
}