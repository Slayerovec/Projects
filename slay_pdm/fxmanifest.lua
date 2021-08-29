fx_version 'cerulean'
games { 'gta5' }

author 'Slayer'
description 'CarShop/SPZ/ExtMenu'
version '0.4.0'

shared_scripts {
	'config.lua'
}


client_scripts {
    'client/main.lua',
    'client/functions.lua',
    'client/menu.lua',
    'client/plates.lua',
    'client/btrailer.lua',
}

ui_page {
	'html/ui.html',
}

files {
	'html/ui.html',
}

server_script {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
}

dependencies {
	'es_extended',
	'esx_billing'
}

exports {
	'GeneratePlate',
	'GenerateVIN',
	'GenerateUUID',
	'GetDecor',
	'GetVIN',
}