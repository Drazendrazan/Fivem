resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script {
	"config.lua",
	'client.lua'
 }

 server_scripts {
	"config.lua",
	--"money.lua",
	"main.lua",
}

ui_page('html/index.html')

files({
	"html/script.js",
	"html/jquery.min.js",
	"html/jquery-ui.min.js",
	"html/styles.css",
	"html/img/*.svg",
	"html/index.html",
})
