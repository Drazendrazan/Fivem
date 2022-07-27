fx_version 'cerulean'
game 'gta5'

version '1.0.0'
 
lua54 'yes' -- Add in case you want to use lua 5.4 (https://www.lua.org/manual/5.4/manual.html)

 
client_scripts {
    'client/*.lua', -- Globbing method for multiple files
    'config.lua'
}
 
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua' -- Globbing method for multiple files
}
 
