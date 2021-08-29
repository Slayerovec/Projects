const { Client, MessageEmbed } = require('discord.js');
const mysql = require('mysql');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
exports.run = (client, message, args, con, tools) => {
    var argsname = args.shift()
    var argsname2 = args.shift()
    let mChannel = message.mentions.channels.first()
    var bmuser = message.author.id;
    var sql = `SELECT * FROM pd WHERE Tel = ?`;
    message.delete()
    if (argsname == null) { message.channel.send('HAHA ZMRDE!') }
    if(message.member.roles.cache.some(r=>["Správce"].includes(r.name)) ) {
        con.query(sql,[argsname2], (err, results) =>{
            Object.keys(results).forEach(function(key, value) {
                var rows = results[key];
                if (rows.length == 0){
                    console.log(con.query(`INSERT INTO pd(Jmeno, Tel) VALUES ('${argsname}','${argsname2}')`))
                        let embed3 = new MessageEmbed()
                        .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
                        .setTitle('Ban')
                        .setDescription(`Správce zamezil přístup na server Tel:'${argsname2}' Jméno:${argsname}  :x:`)
                        .setColor(`RED`)
                        .setThumbnail("https://i.imgur.com/BMXP8sb.png")
                        .setFooter('Powered by chinese kid')
                        .setTimestamp()
                       client.channels.cache.get(SpravaPripojeni).send(embed3)
               } else {
                       message.channel.send('Tohle číslo už je zablokováno.');
               }
           })
       });
    } else {
        message.channel.send('Nejsi Správce');
    }   

}