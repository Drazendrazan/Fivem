resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script {
  'client/client.lua',
  'client/animation.lua',
  'config.lua'
}

server_script {
  'server/server.lua',
  'config.lua'
}

ui_page('html/ui.html')

files {
    'html/ui.html',
    'html/js/script.js',
    'html/css/style.css',
    'html/img/cursor.png',
    'html/img/radio.png'
}

exports {
  'JoinRadio',
  'LeaveRadio',
  'SetRadioState',
 }