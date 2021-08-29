const { Client, MessageEmbed } = require('discord.js');

exports.run = (client, message, args, tools) => {
    let channel = message.mentions.channels.first();
    let messageID = args[1];
    let icon = args[2];
    let role = message.mentions.roles.first();
    
    if(!channel.fetchMessage(messageID)) return message.reply("could not find the specified message. Please check the channel and message ID again.");
    channel.fetchMessage(messageID).then(msg => {
        msg.react(icon);
        info[role.name] = {
            roleID: role.id,
            channelID: channel.id,
            icon: icon,
        };
        fs.writeFile("./configs/info.json", JSON.stringify(info), (err)=>{
            if(err) console.log(err);
        });
    }); 

}