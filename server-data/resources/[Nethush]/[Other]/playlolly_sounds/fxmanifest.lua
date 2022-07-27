-- FXVersion Version
fx_version 'adamant'
games { 'gta5' }

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page "client/html/index.html"

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files {
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .oggß
    'client/html/sounds/tesla-autopilot-start.ogg',
    'client/html/sounds/tesla-autopilot-stop.ogg',
    'client/html/sounds/tesla-crash-avoidance-detect.ogg',
    'client/html/sounds/tesla-crash-avoidance-cancel.ogg',
    'client/html/sounds/tesla-mark.ogg',
    'client/html/sounds/tesla-dance.ogg'
}
