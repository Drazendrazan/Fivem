resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

files {

	'data/**/carcols.meta',
	'data/**/carvariations.meta',
	'data/**/handling.meta',
	'data/**/vehiclelayouts.meta',
	'data/**/vehicles.meta',

 

	
	'audioconfig/r35sound_game.dat151.rel',
	'audioconfig/r35sound_sounds.dat54.rel',
	
	'sfx/dlc_r35sound/r35sound.awc',
	'sfx/dlc_r35sound/r35sound_npc.awc',
	


}

	data_file 'VEHICLE_LAYOUTS_FILE'	'data/**/vehiclelayouts.meta'
	data_file 'HANDLING_FILE'			'data/**/handling.meta'
	data_file 'VEHICLE_METADATA_FILE'	'data/**/vehicles.meta'
	data_file 'CARCOLS_FILE'			'data/**/carcols.meta'
	data_file 'VEHICLE_VARIATION_FILE'	'data/**/carvariations.meta'


	
	data_file 'AUDIO_GAMEDATA' 'audioconfig/r35sound_game.dat151'
	data_file 'AUDIO_SOUNDDATA' 'audioconfig/r35sound_sounds.dat54'
	data_file 'AUDIO_WAVEPACK' 'sfx/dlc_r35sound'
	


	client_script 'veh_label.lua'
