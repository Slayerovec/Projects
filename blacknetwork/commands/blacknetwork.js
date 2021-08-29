const { Client, MessageEmbed } = require('discord.js');
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie} = require ('./cfg.json');

exports.run = (client, message, args, tools) => {
    let argsresult = args.join(` `);
    message.delete()
    if(message.member.roles.cache.some(r=>["Velký Bratr", "Big Brother", "Správce"].includes(r.name)) ) {
        let embed2 = new MessageEmbed()
        .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
        .setTitle('Oznámení BlackNetwork')
        .setDescription(`${argsresult}`)
        .setColor('RANDOM')
        .setFooter('Powered by chinese kid')
        .setTimestamp()
        client.channels.cache.get(Chat).send(embed2)
        client.channels.cache.get(LogSpravce).send(`<@${bmuser.id}> použil/a blackmarket. :white_check_mark: *(${argsresult})*`)
    } else {
        message.author.send('Nemáš na to práva');
    }  
}