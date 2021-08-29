fx_version 'cerulean'
games { 'gta5' }

author 'Slayer'
description 'Export / Import Jobs'
version '0.1.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    "html/listener.js",
    "html/styles.css",
    "html/img/*.png",
    "cfg.json"
}

shared_scripts {
    'config.lua',
    'modules/utils.lua',
    'modules/vector3.lua'
}


client_scripts {
    'client/main.lua',
    'client/menu.lua',
    'client/work.lua'
}

server_script {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/function.lua',
    'server/main.lua'
}

dependencies {
    'es_extended',
    'esx_billing'
}

exports {
}