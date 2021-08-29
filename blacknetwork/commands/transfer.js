const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');
const mysql = require('mysql');
exports.run = (client, message, args, con, tools) => {
    var argsname = args.shift()
    var argsname2 = args.shift()
    let mChannel = message.mentions.channels.first()
    var bmuser = message.author.id;
    var sql = `SELECT * FROM users WHERE Jmeno = ?`;
    var sql2 = `SELECT * FROM user WHERE Discord = ?`;
    var s = `SELECT * FROM users WHERE Discord = ?`;
    var sq2 = `SELECT * FROM user WHERE Tel = ?`;
    message.delete()
if(isNaN(argsname2)){
    let em1 = new Discord.RichEmbed()
    .setAuthor(`BlackNetwork`, client.user.displayAvatarURL)
    .setDescription('Máš špatne posloupnost. (/transfer Jmeno Číslo)')
    .setColor(`RANDOM`)
    .setTimestamp()
    message.channel.send(em1);
}else{
if(message.member.roles.cache.some(r=>["Přihlášený/á"].includes(r.name)) ) {
con.query('SELECT * FROM user WHERE Discord = ?', [bmuser], (err, result, fields) =>{ 
     Object.keys(result).forEach(function(key) {
                var r = result[key];
  if(err) throw err;
  if (r.token < argsname2)  { 
    message.channel.send("⛔ | Máš málo ");
    }
    else {
        con.query(sql2,[bmuser], (err, results) =>{  /// ten co to používá vše
            Object.keys(results).forEach(function(key) {
                var rows = results[key];
        con.query(s,[bmuser], (err, results) =>{  /// ten co to používá vše
                    Object.keys(results).forEach(function(key) {
                        var row3 = results[key];  
        con.query(sql,[argsname], (err, result) =>{ ///// Podle jmena najdem uživatele
            argsresult = args.join(` `)
            Object.keys(result).forEach(function(key) {
                var row = result[key];
        con.query(sq2,[row.Tel], (err, result) =>{ //// tomu komu posílam tokeny získam info
                    Object.keys(result).forEach(function(key) {
                        argsresult = args.join(` `)
                        var row2 = result[key];
if (row2.Discord == bmuser)  { 
    message.channel.send("⛔ | Neposílej sám sobě! ");
                            }
                            else {
                                console.log(row2.Discord)
                                console.log(bmuser)
                let token = parseInt(argsname2) - parseInt(rows.token);
                console.log(token)
                let token2 = parseInt(argsname2) + parseInt(row2.token);
                console.log(token2)
                console.log(con.query('UPDATE user SET token = ? WHERE Tel = ?', [token2, argsname]));// on
                console.log(con.query('UPDATE user SET token = ? WHERE Discord = ?', [token, bmuser]));// já
            let emb = new MessageEmbed()
            .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
            .setDescription(`${row3.Jmeno} Transfernul si: ${argsname2}, uživately: ${argsname}`)
            .setColor("RANDOM")
            .setThumbnail("https://i.imgur.com/UpV69DT.png")
            .setTimestamp()       
            message.channel.send(emb)
            let embed3 = new MessageEmbed()
            .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
            .setTitle('22')
            .setDescription(`${row3.Jmeno} transfernul tokeny uživately: ${argsname} :white_check_mark:`)
            .setThumbnail("https://i.imgur.com/UpV69DT.png")
            .setColor(`RANDOM`)
            .setTimestamp()   
            client.channels.cache.get(LogBlackNetwork).send(embed3)
        }
        })
});  
})
});        
        })
       
    });
    })
 
    });

}
}) 
})    
    } else {
        message.author.send('Musíš se nejdřív přihlásit');
    }   
}
}