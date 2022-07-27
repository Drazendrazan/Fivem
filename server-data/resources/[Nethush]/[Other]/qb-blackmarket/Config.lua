---------SYSTEM REPAIR CAR CODERC-SLO--------------


Config = {}

--------------------------SET USE GANG
Config.UseGang = false --- sets true if only the gang can use it

---------------------------------------------------------------------------------------------

-------------------COORDS MARKER 1 ------------------1
Config.riparaX = 973.95 
Config.riparaY = -101.32
Config.riparaZ = 75.07
Config.textput = '~g~[E]~r~ Black Market ~y~(knocks) ~w~'

------------------------------------------------------------
-------------------COORDS ARMORY GANG ------------------1
Config.armoryX = 973.95  
Config.armoryY = -101.32
Config.armoryZ = 75.07
Config.textarm = '~g~[E]~r~ Armory ~y~(Gang) ~w~'

------------------------------------------------------------
local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

---ITEM NON GANG
Config.Itemspistol = {
	label = "Ammo Pistol",
    slots = 10000,
	items = {
	[1] = {
            name = "weapon_pistol",
            price = 1000,
            amount = 1,
            info = {
                serie = "",    
                attachments = {
                    {component = "COMPONENT_AT_PI_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "pistol_ammo",
            price = 40,
            amount = 5,
            info = {},
            type = "item",
            slot = 2,
        },
		[3] = {
            name = "weapon_appistol",
            price = 10000,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 3,
        },
		[4] = {
            name = "weapon_heavypistol",
            price = 8000,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 4,
        },
        [5] = {
            name = "weapon_minismg",
            price = 19000,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 5,
        },
        [6] = {
            name = "smg_ammo",
            price = 200,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 6,
        },
        [7] = {
            name = "pistol_suppressor",
            price = 4000,
            amount = 5,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "pistol_extendedclip",
            price = 4000,
            amount = 5,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "smg_extendedclip",
            price = 4000,
            amount = 5,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "smg_flashlight",
            price = 4000,
            amount = 5,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "smg_scope",
            price = 4000,
            amount = 5,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "smg_suppressor",
            price = 4000,
            amount = 5,
            info = {},
            type = "item",
            slot = 12,
        },
        [13] = {
            name = "rifle_extendedclip",
            price = 4000,
            amount = 5,
            info = {},
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "rifle_drummag",
            price = 4000,
            amount = 5,
            info = {},
            type = "item",
            slot = 14,
        },
        [15] = {
            name = "rifle_suppressor",
            price = 4000,
            amount = 5,
            info = {},
            type = "item",
            slot = 15,
        },
	}
}

----ITEM GANG
Config.Items = {
    label = "Ammo craft",
    slots = 30,
    items = {
        [1] = {
            name = "weapon_heavypistol",
            price = 1000000,
            amount = 1,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_AT_PI_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "weapon_stungun",
            price = 1000000,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "weapon_pumpshotgun",
            price = 1000000,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 3,
        },
        [4] = {
            name = "weapon_smg",
            price = 1000000,
            amount = 1,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_AT_SCOPE_MACRO_02", label = "1x Scope"},
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 4,
        },
        [5] = {
            name = "weapon_carbinerifle",
            price = 1000000,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_AT_SCOPE_MEDIUM", label = "3x Scope"},
                }
            },
            type = "weapon",
            slot = 5,
        },
        [6] = {
            name = "weapon_nightstick",
            price = 1000000,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 6,
        },
        [7] = {
            name = "pistol_ammo",
            price = 1000,
            amount = 5,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "smg_ammo",
            price = 1000,
            amount = 5,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "shotgun_ammo",
            price = 1000,
            amount = 5,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "rifle_ammo",
            price = 1000,
            amount = 5,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "handcuffs",
            price = 500,
            amount = 5,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "weapon_flashlight",
            price = 2500,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 12,
        },
        
        [13] = {
            name = "armor",
            price = 5000,
            amount = 5,
            info = {},
            type = "item",
            slot = 15,
        },
        
        [14] = {
            name = "heavyarmor",
            price = 50000,
            amount = 5,
            info = {},
            type = "item",
            slot = 17,
        },
    }
}

