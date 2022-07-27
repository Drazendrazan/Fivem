description "Simple Notification Script using https://notifyjs.com/"
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
ui_page "html/index.html"

client_script "cl_notify.lua"

export "SetQueueMax"
export "SendNotification"

files {
    "html/index.html",
    "html/notificationSFX.wav",
    "html/pNotify.js",
    "html/noty.js",
    "html/noty.css",
    "html/themes.css",
    "html/sound-example.wav"
}