fx_version 'cerulean'
game 'gta5'

author 'Slayer'
description 'KKRP.cz | Jobs'
lua54 'yes'
version '0.1'

client_scripts {
	"@menu/menu.lua",
	"@key_mapping/mapping.lua",
	"config.lua",
	"client/main.lua",
	"client/menu.lua"
}

shared_scripts {
	'@modules/utils.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"config.lua",
	"server/main.lua"
}

export "GetJobSpec"