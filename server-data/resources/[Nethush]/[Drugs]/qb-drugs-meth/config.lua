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
	WeedField = {coords = vector3(28.096691, 6858.0883, 13.472906), name = 'blip_weedfield', color = 25, sprite = 496, radius = 30.0},
	WeedField2 = {coords = vector3(1536.4251, 6616.6723, 2.3468446), name = 'blip_weedfield', color = 25, sprite = 496, radius = 30.0},
	WeedProcessing = {coords = vector3(-552.7081, 5348.4775, 74.742973), name = 'blip_weedprocessing', color = 25, sprite = 496, radius = 100.0},
	DrugDealer = {coords = vector3(3726.5932, 4539.3188, 22.252056), name = 'blip_drugdealer', color = 6, sprite = 378, radius = 25.0},
}