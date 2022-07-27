Config = {}

Config.Locale = 'en'

Config.Delays = {
	WeedProcessing = 1000 * 1
}

Config.Pricesell = 975

Config.MinPiecesWed = 1



Config.DrugDealerItems = {
	empty_weed_bag = 91
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. 



Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	WeedField = {coords = vector3(2220.0773, 5576.7836, 53.7957), name = 'blip_weedfield', color = 25, sprite = 496, radius = 100.0},
	WeedProcessing = {coords = vector3(32.573436, 3672.1057, 40.440586), name = 'blip_weedprocessing', color = 25, sprite = 496, radius = 100.0},
	DrugDealer = {coords = vector3(-1168.915, -1572.513, 4.6636223), name = 'blip_drugdealer', color = 6, sprite = 378, radius = 25.0},
}