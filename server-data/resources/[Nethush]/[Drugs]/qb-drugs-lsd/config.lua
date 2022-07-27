Config = {}

Config.Locale = 'en'

Config.Delays = {
	WeedProcessing = 1000 * 1
}

Config.Pricesell = 1350

Config.MinPiecesWed = 1



Config.DrugDealerItems = {
	empty_weed_bag = 91
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. 



Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	WeedField = {coords = vector3(2774.2026, 1406.9382, 24.513031), name = 'blip_weedfield', color = 25, sprite = 496, radius = 30.0},
	WeedProcessing = {coords = vector3(1982.6214, -2611.304, 3.5522441), name = 'blip_weedprocessing', color = 25, sprite = 496, radius = 100.0},
	DrugDealer = {coords = vector3(609.09289, -3059.065, 6.0692901), name = 'blip_drugdealer', color = 6, sprite = 378, radius = 25.0},
}