const { Client, MessageEmbed } = require('discord.js');

exports.run = (client, message, args, tools) => {
    message.delete()        
    var embed = new MessageEmbed()
        .setAuthor(`BlackNetwork`, client.user.displayAvatarURL())
        .setTitle("Příkazy")
        .setThumbnail('https://i.imgur.com/z7BOUc3.png')
        .setDescription('Příkazy, které můžete použít např:./commands (ukáže ti přesně tohle). Dodržujte přesně tak jak je to napsané pokud je tam čárka tak využijte tu čarku pokud stačí jen mezera dejte mezeru.')
        .addField("/register Jmeno Heslo Tel", '(slouží pro registraci, každý muže mít 1 účet)')
        .addField("/login Jmeno Heslo", '(slouží k přihlášení)', true)
        .addField("/logout", '(slouží k odhlášení)', true)
        .addField("/pocet", '(ukáže ti kolik máš Dcoinů)', true)
        .addField("/account", '(ukáže ti tvůj blacknetwork account)', true)
        .addField("/dm JehoJmeno Text", '(Pošlete DMku)', true)
        .addField("/pay Jmeno Pocet", 'Převod Dcoinu', true)
        .addField("/bm Text", 'Pošlete zprávu do BlackMarketu', true)
        .addField("/review Jmeno", 'Ziskate historii aka review', true)
        .addField("/contract Jmeno, Text, IMG(nejlepe imgur), Co se mu ma stat, cena", 'Vytvoříte kontrakt pro všechny, dodržujte čárky.', true)
        .addField("/accept ID", 'Příjmete kontrakt ID = číslo kontraktu', true)
        .addField("/done ID done/payout img/stars (pokud payout) FeedbackText ", 'Dokončování kontraktu. Pokud jste vykonavatel kontraktu píšete done img. Pokud jste zadavatel kontraktu pišete payout stars(třeba 5) a nějaký text ohledně toho borca', true)
        .addField("/zmena NovéJmeno", '(Zmená na nový nickname, ale bude tě to stát 1x Dcoin)', true)
        .setColor("WHITE")
        .setFooter('Powered by chinese kid')
        .setTimestamp()
    message.channel.send(embed)
}