fx_version 'cerulean'
game 'gta5'
lua54 'yes'

dependencies {
    'esx_core',
    'ox_lib',
    'ox_inventory',
    'pma-voice'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/app.js'
}

client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}

server_scripts {
    '@ox_lib/init.lua',
    'server.lua'
}
