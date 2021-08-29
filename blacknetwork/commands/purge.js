const Discord = require('discord.js');

exports.run = (client, message, args, tools) => {
    if(message.member.roles.cache.some(r=>["Správce"].includes(r.name)) ) {
        if (isNaN(args[0])) return message.channel.send('**Debyle špatne číslo**');
        if (args[0] > 100) return message.channel.send('**Debylku**');

        message.channel.bulkDelete(args[0])
            .then( messages => message.channel.send('**Deleted**').then (msg => msg.delete({ timeout: 100})))
            .catch( error => console.log(error));
	}
}