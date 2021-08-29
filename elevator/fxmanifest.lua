fx_version 'bodacious'
games {'gta5'}

author 'Slayer'
description 'Elevator'
version '1.0.0'

client_scripts {
    'config.lua',
    'client/main.lua'
}

server_script {
    'config.lua',
    'server/main.lua'
}

ui_page(
        'client/html/index.html'
)

files({
    'client/html/index.html',
    'client/html/sounds/elevator.ogg',
    "client/html/styles.css"
})
