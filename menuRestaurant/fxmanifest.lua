fx_version 'cerulean'
games { 'gta5' }

author 'Slayer'
description 'Menu pro restarace'
version '0.0.1'

ui_page 'nui/index.html'

files {
    'nui/index.html',
    "nui/listener.js",
    "nui/styles.css",
    "nui/img/*.png",
}

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_script {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

exports {
}