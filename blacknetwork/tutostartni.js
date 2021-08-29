//Req packages
const Discord = require('discord.js');
const client = new Discord.Client();

const {prefix, token, Name } = require ('./config.json');
const config = require('./config.json')
const { SpravaPripojeni, Logged, Registered, Agreed, Logout, Log, Banned, Chat, LogBlackNetwork, LogSpravce, Checked, NewBie, Spravce} = require ('./commands/cfg.json');
const active = new Map();
var userTickets = new Map();


client.on('ready', function(){
    console.log(Name + " je Online!")
    client.user.setUsername(Name)
    client.user.setPresence({
        activity: { name: 'KKRP.CZ // Powered by chinese kid' },
        status: 'Online',
        url: "https://www.twitch.tv/spajkk"
    })
	handleDisconnect();
});

client.on('guildMemberAdd', (guildMember) => {
    var sql = `SELECT * FROM user WHERE discord_id = ?`;

   con.query(sql,[guildMember.id], (err, data) =>{
        if (data.length == 0) {
            guildMember.roles.add(NewBie);
              roles = [ NewBie ]
              json = JSON.stringify(roles)
              con.query(`INSERT INTO user (discord_id, roles) VALUES ('${guildMember.id}', '${json}')`)
        } else {
          Object.keys(data).forEach(function(key, value) {
              var row = data[key];
              json = JSON.parse(row.roles)
              for (i = 0; i < json.length; i++) {
                guildMember.roles.add(json[i]);
              }
          })
        }
    })
});

const mysql = require('mysql');
var dbconfig = {
    host     : 'localhost',
    port     : '3306',
    user     : 'root',
    password : '',
    database : 'blacknetwork',
    charset : 'utf8mb4_czech_ci'
};
  
var con;
function handleDisconnect() {
      con = mysql.createConnection(dbconfig);
      con.connect( function onConnect(err) {
          if (err) {
              if (err.code == 'ECONNREFUSED' || err.code == 'PROTOCOL_CONNECTION_LOST'){
                setTimeout(handleDisconnect, 1000);
              }
              throw err;
          } else {
               console.log("Connected to database");
          }
      });

      con.on('error', function onError(err) {
          if (err.code == 'PROTOCOL_CONNECTION_LOST') {
              setTimeout(handleDisconnect, 1000);
          } else if (err.code == 'ECONNREFUSED') {
                setTimeout(handleDisconnect, 1000);
          } else {
              throw err;
          }
      });
}
//Listener Events
client.on('message', message => {
    if (message.channel.type === 'dm'){
        var slayer = '659534798682849305';
        client.channels.cache.find(channel => channel.name === slayer).send('Od uživatele: '+ message.channel.recipient.username + '/// zprava: ' +  message.channel.messages.cache.get(message.channel.lastMessageID).content)
    }
    let msg = message.content.toUpperCase();
    let sender = message.author;
    let args = message.content.slice(prefix.length).trim().split(' ');
    let cmd = args.shift().toLowerCase();
    if (sender.id != 653280961089372170){
        // Return statements
        if (!msg.startsWith(prefix)) return;
        if (message.author.bot) return;
        if (cmd == 'do') return;
        try {
            let commandFile = require(`./commands/${cmd}.js`);
            commandFile.run(client, message, args, con);

        } catch (e) {
            console.log(e.message);

        } finally {
            console.log(`${message.author.tag} použil příkaz /${cmd}`);

        }
    }
})


client.on('raw', payload => {
    if(payload.t === 'MESSAGE_REACTION_ADD') {
        if(payload.d.emoji.id === '659891112890335252') {
            if(payload.d.message_id === '661936260352442418') {
                let channel = client.channels.cache.get(payload.d.channel_id)
                if(channel.messages.cache.has(payload.d.message_id)) {
                    return;
                } else {
                    channel.messages.fetch(payload.d.message_id)
                    .then(msg => {
                        let reaction = msg.reactions.cache.get('659891112890335252');
                        let user = client.users.cache.get(payload.d.user_id);
                        client.emit('messageReactionAdd', reaction, user);
                    })
                    .catch(err => console.log(err))
                }
            }
        }       
    }
});

client.on('messageReactionAdd', (reaction, user) => {
    if(reaction.emoji.name === 'checked') { 
        var roleName = reaction.emoji.name;
        var role = reaction.message.guild.roles.cache.find(role => role.name.toLowerCase() === roleName.toLowerCase());
        var member = reaction.message.guild.members.cache.find(member => member.id === user.id);
        if(member.roles.cache.has(role.id)){
            member.roles.remove(role.id).then(member =>{
            console.log(" Removed " + member.user.username + " from the " + role.name + " role");
        }).catch(error => console.error);
        } else {
            member.roles.add(role.id).then(member =>{
            console.log("Added " + member.user.username + " to the " + role.name + " role");
            }).catch(error => console.error);
        }
        if(userTickets.has(user.id) || reaction.message.guild.channels.cache.some(channel => channel.name.toLowerCase() === user.id )) {
            client.channels.cache.find(channel => channel.name === user.id).send(`⛔ | Už máš Roomku vytvořenou <@${user.id}>`)
        } else {
            let guild = reaction.message.guild;
            guild.channels
            .create(user.id, { type: 'text'})
            .then(r => {
                r.setParent('653205634778660904', { lockPermissions: false })
                r.overwritePermissions([
                  {
                      id: user.id,
                      allow: ['VIEW_CHANNEL','READ_MESSAGE_HISTORY', 'SEND_MESSAGES'],

                  },
                  {
                      id: '653205108082999316',
                      deny: 'VIEW_CHANNEL',
                  },
                ]);
            })
            .catch(console.error);
        }
    }   
});

client.on('error', console.error)
client.on('warn', console.warn)
process.on('unhandledRejection', (error) => {
    console.error(`Uncaught Promise Error: \n${error.stack}`)
})

process.on('uncaughtException', (err) => {
    let errmsg = (err ? err.stack || err : '').toString().replace(new RegExp(`${__dirname}/`, 'g'), './')
    console.error(errmsg)
})


function addUserRole(roleName,message){
    var role = message.guild.roles.find(`name`, `roleName`)
     message.member.roles.add(role.id)
}

// Login
client.login(token);