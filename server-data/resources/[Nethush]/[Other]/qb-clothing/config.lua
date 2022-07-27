Config = Config or {}

Config.WomanPlayerModels = {
    'mp_f_freemode_01',
}
    
Config.ManPlayerModels = {
    'mp_m_freemode_01',
}


Config.LoadedManModels = {}
Config.LoadedWomanModels = {}

Config.Stores = {
    [1] =   {shopType = "clothing", x = 1693.32,      y = 4823.48,     z = 41.06},
	[2] =   {shopType = "clothing", x = -712.215881,  y = -155.352982, z = 37.4151268},
	[3] =   {shopType = "clothing", x = -1192.94495,  y = -772.688965, z = 17.3255997},
	[4] =   {shopType = "clothing", x =  425.236,     y = -806.008,    z = 28.491},
	[5] =   {shopType = "clothing", x = -162.658,     y = -303.397,    z = 38.733},
	[6] =   {shopType = "clothing", x = 75.950,       y = -1392.891,   z = 28.376},
	[7] =   {shopType = "clothing", x = -822.194,     y = -1074.134,   z = 10.328},
	[8] =   {shopType = "clothing", x = -1450.711,    y = -236.83,     z = 48.809},
	[9] =   {shopType = "clothing", x = 4.254,        y = 6512.813,    z = 30.877},
	[10] =  {shopType = "clothing", x = 615.180,      y = 2762.933,    z = 41.088},
	[11] =  {shopType = "clothing", x = 1196.785,     y = 2709.558,    z = 37.222},
	[12] =  {shopType = "clothing", x = -3171.453,    y = 1043.857,    z = 19.863},
	[13] =  {shopType = "clothing", x = -1100.959,    y = 2710.211,    z = 18.107},
	[14] =  {shopType = "clothing", x = -1207.65,     y = -1456.88,    z = 4.3784737586975},
    [15] =  {shopType = "clothing", x = 121.76,       y = -224.6,      z = 53.56},
	[16] =  {shopType = "barber",   x = -814.3,       y = -183.8,      z = 36.6},
	[17] =  {shopType = "barber",   x = 136.8,        y = -1708.4,     z = 28.3},
	[18] =  {shopType = "barber",   x = -1282.6,      y = -1116.8,     z = 6.0},
	[19] =  {shopType = "barber",   x = 1931.5,       y = 3729.7,      z = 31.8},
	[20] =  {shopType = "barber",   x = 1212.8,       y = -472.9,      z = 65.2},
	[21] =  {shopType = "barber",   x = -32.9,        y = -152.3,      z = 56.1},
	[22] =  {shopType = "barber",   x = -278.1,       y = 6228.5,      z = 30.7}
}

Config.ClothingRooms = {
    [1] = {requiredJob = "police", x = 460.13, y = -996.52, z = 30.68, cameraLocation = {x = 462.15, y = -996.45, z = 30.68, h = 3.5}},
    [2] = {requiredJob = "doctor", x = -825.0802, y = -1237.8810, z = 7.3350, cameraLocation = {x = -825.0802, y = -1237.8810, z = 7.3350, h = 44.4955}},
    [3] = {requiredJob = "ambulance", x = 300.0796, y = -597.2629, z = 43.2840, cameraLocation = {x = 300.0796, y = -597.2629, z = 43.2840, h = 44.4955}},
    [4] = {requiredJob = "police", x = -453.613446, y = 6013.8896, z = 31.71643, cameraLocation = {x = -455.613446, y = 6013.8896, z = 31.71643}},
    [5] = {requiredJob = "ambulance", x = -250.5, y = 6323.98, z = 32.32, cameraLocation = {x = -250.5, y = 6323.98, z = 32.32, h = 315.5}},    
    [6] = {requiredJob = "doctor", x = -250.5, y = 6323.98, z = 32.32, cameraLocation = {x = -250.5, y = 6323.98, z = 32.32, h = 315.5}},
    [7] = {requiredJob = "police", x = 1849.7069, y = 3695.5263, z = 34.267074, cameraLocation = {x = 1850.7069, y = 3695.5263, z = 34.267074}}, 
}
Config.Outfits = {
    ["police"] = {
        ["male"] = {
            [1] = {
                outfitLabel = "Police",
                outfitData = {
                    ["pants"]       = { item = 35, texture = 0},  -- Broek
                    ["arms"]        = { item = 19, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 129, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 16, texture = 2},  -- Body Vest
                    ["torso2"]      = { item = 55, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 10, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 7, texture = 0},  -- Decals
                    ["accessory"]   = { item = 8, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 46, texture = 0},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
            [2] = {
                outfitLabel = "S.W.A.T.",
                outfitData = {
                    ["pants"]       = { item = 31, texture = 0},  -- Broek
                    ["arms"]        = { item = 31, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 56, texture = 1},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 220, texture = 20},  -- Jas / Vesten
                    ["shoes"]       = { item = 60, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 7, texture = 0},  -- Decals
                    ["accessory"]   = { item = 8, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 115, texture = 0},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
            [3] = {
                outfitLabel = "Pilot",
                outfitData = {
                    ["pants"]       = { item = 33, texture = 0},  -- Broek
                    ["arms"]        = { item = 31, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 54, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 62, texture = 4},  -- Schoenen
                    ["decals"]      = { item = 7, texture = 0},  -- Decals
                    ["accessory"]   = { item = 8, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 47, texture = 0},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
        },
        ["female"] = {
            [1] = {
                outfitLabel = "Police",
                outfitData = {
                    ["pants"]       = { item = 100, texture = 0},  -- Broek
                    ["arms"]        = { item = 3, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 14, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 3, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 24, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 1, texture = 0},  -- Decals
                    ["accessory"]   = { item = 8, texture = 0},  -- Nek / Das
            --      ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
            [2] = {
                outfitLabel = "S.W.A.T.",
                outfitData = {
                    ["pants"]       = { item = 100, texture = 0},  -- Broek
                    ["arms"]        = { item = 14, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 14, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 6, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 85, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 24, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 1, texture = 0},  -- Decals
                    ["accessory"]   = { item = 8, texture = 0},  -- Nek / Das
            --      ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
            [3] = {
                outfitLabel = "Pilot",
                outfitData = {
                    ["pants"]       = { item = 33, texture = 0},  -- Broek
                    ["arms"]        = { item = 31, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 54, texture = 20},  -- Jas / Vesten
                    ["shoes"]       = { item = 62, texture = 4},  -- Schoenen
                    ["decals"]      = { item = 7, texture = 0},  -- Decals
                    ["accessory"]   = { item = 8, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 47, texture = 0},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
        }
    },
    ["ambulance"] = {
        ["male"] = {
            [1] = {
                outfitLabel = "Ambulance 1",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 85, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 88, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 18, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 93, texture = 2},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker
                },
            },
        },
        ["female"] = {},
    },
    ["doctor"] = {
        ["male"] = {
            [1] = {
                outfitLabel = "Jas Voor Artsen",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 88, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 118, texture = 7},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker
				},
			},
			[2] = {
                outfitLabel = "T-Shirt Zwaar Vest",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 85, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 88, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 18, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 32, texture = 6},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker
				},
			},			
			[3] = {
                outfitLabel = "OVD-G",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 4},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 51, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 151, texture = 2},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker
				},
			},
			[4] = {
                outfitLabel = "MMT Piloot",
                outfitData = {
                    ["pants"]       = { item = 59,texture = 5},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 151, texture = 3},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 79, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker	
				},
			},
			[5] = {
                outfitLabel = "MMT Arts",
                outfitData = {
                    ["pants"]       = { item = 59,texture = 5},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 151, texture = 5},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 79, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker	
				},
			},
			[6] = {
                outfitLabel = "MMT Verpleegkundige",
                outfitData = {
                    ["pants"]       = { item = 59,texture = 5},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 151, texture = 4},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 79, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker	
				},
			},		
		},		
        ["female"] = {
            [1] = {
                outfitLabel = "Vrouwelijke Outfit",
                outfitData = {
                    ["pants"]       = { item = 3,texture = 1},  -- Broek
                    ["arms"]        = { item = 14, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 3, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 14, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker
				},
            },
        },
    },
}