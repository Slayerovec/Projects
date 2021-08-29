const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
const mysql = require('mysql');
exports.run = (client, message, args, con, tools) => {
    var argsname = args.shift()
    var sql2 = `SELECT * FROM users WHERE Discord = ?`;
    message.delete()
    if(message.member.roles.cache.some(r=>["Správce"].includes(r.name)) ) {
        con.query(sql2,[argsname], (err, results) =>{
        Object.keys(results).forEach(function(key) {
            var rows = results[key];
            addToDB(rows.Discord)
            console.log(con.query(`DELETE FROM users WHERE Discord = ${rows.Discord}`))             
            let embed3 = new MessageEmbed()
            .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
            .setTitle('Ban')
            .setDescription(`Správce zamezil přístup na server Tel:'${rows.Tel}' Jméno:${rows.Jmeno}  :x:`)
            .setColor(`RED`)
            .setThumbnail("https://i.imgur.com/BMXP8sb.png")
            .setFooter('Powered by chinese kid')
            .setTimestamp()   
           client.channels.get(SpravaPripojeni).send(embed3)
           message.member.roles.remove(Logged)
           message.member.roles.remove(Registered)
           message.member.roles.remove(Agreed)
           message.member.roles.remove(Logout)
           message.member.roles.add(Banned)
        })
    });

    function addToDB(author){
          roles = [ Banned ]
          json = JSON.stringify(roles)
          console.log(con.query('UPDATE user SET roles = ? WHERE discord_id = ?', [author, json]))
    }

    } else {
        let embed4 = new MessageEmbed()
        message.channel.send('Nejsi Správce');
    }   

}