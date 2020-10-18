--[[################################################
    #       Creat by : Rotcher & Milad_nx          #
    #                  Discord                     #
    #          https://discord.gg/QMvsJap          #
    ################################################]]
fx_version "adamant"
game "gta5"

version '1.0.0'

server_scripts {
    '@essentialmode/locale.lua',
	'config.lua',
	'server/main.lua',
	'locales/en.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'config.lua',
	'client/main.lua',
	'locales/en.lua'
}

dependency 'essentialmode'
