const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
const mysql = require('mysql');

exports.run = (client, message, args, con, tools) => {
    let mChannel = message.mentions.channels.first()
    let moderator = message.author;
    let bmuser = message.author.id;
    var name = args.shift().trim().split(',')
    var ar = message.content.slice(args.length).trim().split(', ');
    name = name[0]
    var text = ar[1]
    var img = ar[2]
    var assign = ar[3]
    var price = ar[4]
    var AID = con.query('SELECT * FROM users WHERE Discord = ?', [bmuser])
    var cID
    ID()
    message.delete()

    function sendingEmbed(ID){
        var sql = `SELECT * FROM contract WHERE contract_id = ?`;
        const embed = new MessageEmbed()
            .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
            .setTitle('Jmeno: ' + name + ' /Za ' + assign + ' ' +'Nabízí'+ ' ' + price + 'x Dc')
            .setDescription('Podrobnosti:' + text )
            .setThumbnail('https://i.imgur.com/T9G2apN.png')
            .setImage(img)
            .setColor("Black")
            .setTimestamp(Date.now())
            .setFooter(ID)

            const ano = require('./1.json');
            const item = ano[Math.floor(Math.random() * ano.length)];
            const filter = response => {
                    return item.answers.some(answer => answer.toLowerCase() === response.content.toLowerCase());
            };
            message.channel.send(embed).then(() => {
            message.channel.send('Zkontroluj si to pokud je všechno ok, napiš ano a odešle se to.');
            message.channel.awaitMessages(filter, { max: 1, time: 60000, errors: ['time'] })
                .then(collected => {
                    client.channels.cache.get(Chat).send(embed).then((msg) => {
                        var msgID = msg.channel.lastMessageID
                        js = [ ID, name, text, img, assign, price, msgID]
                        json = JSON.stringify(js)
                        message.channel.send(embed)
                        UpdateDB(json, msgID)
                    })
                })
                .catch(collected => {
                    message.channel.send(message);
                });
            });
    }
    //message.guild.members.cache.get('426528628403339276').send('Čusan Legine!')
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

    function UpdateDB(json, msgID){
        var sql = `INSERT INTO contract (contract_id, contract_author, contract_AID, contract_text, contract_price, contract_done, contract_json, contract_msgID) VALUES ('${cID}', '${bmuser}', '${AID}', '${text}', '${price}', 0, '${json}', '${msgID}')`;
        con.query(sql)
    }
}

