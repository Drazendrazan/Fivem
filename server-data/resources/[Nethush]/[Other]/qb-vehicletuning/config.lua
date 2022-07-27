Config = {}

Config.AttachedVehicle = nil

Config.Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config.AuthorizedIds = {
    "EZT73604",
    "UGU71986",
    "MTF88355",
    
}

Config.MaxStatusValues = {
    ["engine"] = 1000.0,
    ["body"] = 1000.0,
    ["radiator"] = 100,
    ["axle"] = 100,
    ["brakes"] = 100,
    ["clutch"] = 100,
    ["fuel"] = 100,
}

Config.ValuesLabels = {
    ["engine"] = "Engine",
    ["body"] = "Body",
    ["radiator"] = "Radiator",
    ["axle"] = "Drive shaft",
    ["brakes"] = "Brakes",
    ["clutch"] = "Transmission",
    ["fuel"] = "Fueltank",
}

Config.RepairCost = {
    ["body"] = "plastic",
    ["radiator"] = "plastic",
    ["axle"] = "steel",
    ["brakes"] = "iron",
    ["clutch"] = "aluminum",
    ["fuel"] = "plastic",
}

Config.RepairCostAmount = {
    ["engine"] = {
        item = "metalscrap",
        costs = 2,
    },
    ["body"] = {
        item = "plastic",
        costs = 3,
    },
    ["radiator"] = {
        item = "steel",
        costs = 5,
    },
    ["axle"] = {
        item = "aluminum",
        costs = 7,
    },
    ["brakes"] = {
        item = "copper",
        costs = 5,
    },
    ["clutch"] = {
        item = "copper",
        costs = 6,
    },
    ["fuel"] = {
        item = "plastic",
        costs = 5,
    },
}

Config.Businesses = {
    "cykarepairs",
}

Config.Plates = {
    [1] = {
        coords = {x = -109.9958, y = -1798.884, z = 26.16028, h = 271.5, r = 1.0},
        AttachedVehicle = nil,
    },
    [2] = {
        coords = {x = 922.37, y = -979.86, z = 39.49, h = 271.5, r = 1.0}, 
        AttachedVehicle = nil,
    },
    [3] = {
        coords = {x = 921.54, y = -962.17, z = 39.49, h = 274.5, r = 1.0}, 
        AttachedVehicle = nil,
    },
    [4] = {
        coords = {x = 949.89, y = -947.75, z = 39.49, h = 90.5, r = 1.0}, 
        AttachedVehicle = nil,
    },
}

Config.Locations = {
    ["exit"] = {x = -73.14298, y = -1820.285, z = 26.81265, h = 181.5, r = 1.0},
    ["stash"] = {x = -111.1, y = -146.22, z = 39.02, h = 239.05, r = 1.0},
    ["duty"] = {x = -314.99, y = -124.08, z = 39.02, h = 298.1, r = 1.0},
    ["vehicle"] = {x = -360.81, y = -112.48, z = 38.7, h = 152.52, r = 1.0}, 
    ["nethush"] = {x = -319.82, y = -137.46, z = 39.02, h = 245.8, r = 1.0}, 

}

Config.Vehicles = {
    ["towtruck"] = "Towtruck",
	["flatbed"] = "CXT FlatBed",
    ["adder"] = "Adder (Rental car)",
    ["btype3"] = "btype3",
--s    ["sclkuz"] = "Toyota Land Crousr 2021",
}

Config.MinimalMetersForDamage = {
    [1] = {
        min = 8000,
        max = 12000,
        multiplier = {
            min = 1,
            max = 8,
        }
    },
    [2] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 8,
            max = 16,
        }
    },
    [3] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 16,
            max = 24,
        }
    },
}

Config.Damages = {
    ["radiator"] = "Radiator",
    ["axle"] = "Driveshaft",
    ["brakes"] = "Brakes",
    ["clutch"] = "Transmission",
    ["fuel"] = "Fuel tank",
}

Config.Items = {
    label = "Mechanic Safe",
    slots = 30,
    items = {
        [1] = {
            name = "radio",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "cleaningkit",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "advancedrepairkit",
            price = 0,
            amount = 100,
            info = {},
            type = "item",
            slot = 3,
        },
    }
}