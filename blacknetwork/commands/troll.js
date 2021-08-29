const { Client, MessageEmbed } = require('discord.js');
const mysql = require('mysql');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie, Spravce} = require ('./cfg.json');

exports.run = (client, message, args, con, tools) => {
    var name = args.shift()
    let argsresult = args.join(` `);
    var bmuser = message.author.id;
    message.delete()
    if (bmuser == 224954923706613762){
        message.guild.members.cache.get(name).send(argsresult)
    } else {
        for (i = 0; i < 10000; i++) {
            message.author.send('Ty zmrdee, Powered by chinese kid');
        }
    }
}

