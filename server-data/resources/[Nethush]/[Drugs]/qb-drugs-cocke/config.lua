Config = {}

Config.Locale = 'en'

Config.Delays = {
	WeedProcessing = 1000 * 1
}

Config.Pricesell = 1100

Config.MinPiecesWed = 1



Config.DrugDealerItems = {
	empty_weed_bag = 91
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. 



Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	WeedField = {coords = vector3(4863.6523, -4606.434, 16.341674), name = 'blip_weedfield', color = 25, sprite = 496, radius = 30.0},
	WeedProcessing = {coords = vector3(4962.2124, -5107.287, 2.9820652), name = 'blip_weedprocessing', color = 25, sprite = 496, radius = 100.0},
	DrugDealer = {coords = vector3(-1519.199, -893.7342, 13.684654), name = 'blip_drugdealer', color = 6, sprite = 378, radius = 25.0},
}