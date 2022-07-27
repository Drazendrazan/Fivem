Settings = {}

Settings.Locations = {
    ['stash'] = {
        ['help'] = "[E] - Stash",
        ['event'] = "gangs:openStash"
    },
    ['boss'] = {
        ['help'] = "[E] - Gang",
        ['event'] = "gangs:requestOpenBoss"
    },
    ['vehicles'] = {
        ['help'] = "[E] - Vehicles",
        ['event'] = "gangs:vehiclesMenu"
    },
}

Settings.Grades = {
    ['none'] = 0,
    ['soldier'] = 1,
    ['underboss'] = 2,
    ['boss'] = 3,
}

Settings.Gangs = {
    ['none'] = {},
    ['crips'] = {
        ['label'] = "Crips",
        ['color'] = {9,112,204},
        ['locations'] = {
            ['stash'] = vector3(0.0, 0.0, 0.0),
            ['boss'] = vector3(0.0, 0.0, 0.0),
            ['vehicles'] = vector3(0.0, 0.0, 21.0)
        },
        ['vehicles'] = {
            { ['model'] = "akuma", ['label'] = "Akuma", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "sultan", ['label'] = "Sultan", ['icon'] = "fas fa-car-alt" }
        }
    },
    ['ballas'] = {
        ['label'] = "Ballas",
        ['color'] = {76,0,108},
        ['locations'] = {
            ['stash'] = vector3(108.99762, -1982.302, 20.962623),
            ['boss'] = vector3(116.99819, -1961.8, 21.327606),
            ['vehicles'] = vector3(106.98784, -1941.618, 20.803724)
        },
        ['vehicles'] = {
            { ['model'] = "btype3", ['label'] = "btype3", ['icon'] = "fas fa-car-alt" },
            { ['model'] = "blazer", ['label'] = "blazer", ['icon'] = "fas fa-motorcycle" },

        }
    },
    ['bloods'] = {
        ['label'] = "Bloods",
        ['color'] = {158,0,0},
        ['locations'] = {
            ['stash'] = vector3(-1568.658, -405.2457, 48.260635),
            ['boss'] = vector3(-1566.144, -407.8743, 52.215026),
            ['vehicles'] = vector3(-1546.183, -402.6561, 41.987693)
        },
        ['vehicles'] = {
            { ['model'] = "XPERIA38", ['label'] = "boss", ['icon'] = "fas fa-car-alt" },
            { ['model'] = "blazer", ['label'] = "Blazer", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "gtr", ['label'] = "gtr", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "gronos6x6", ['label'] = "gronos6x6", ['icon'] = "fas fa-car-alt" },
            { ['model'] = "sultan", ['label'] = "sultan", ['icon'] = "fas fa-car-alt" }
        }
    },
    ['vagos'] = {
        ['label'] = "Vagos",
        ['color'] = {255,254,22},
        ['locations'] = {
            ['stash'] = vector3(338.54171, -2012.886, 22.39496),
            ['boss'] = vector3(340.29132, -2021.027, 22.394962),
            ['vehicles'] = vector3(332.67541, -2037.941, 21.048429)
        },
        ['vehicles'] = {
            { ['model'] = "btype3", ['label'] = "btype3", ['icon'] = "fas fa-car-alt" },
            { ['model'] = "blazer", ['label'] = "Blazer", ['icon'] = "fas fa-motorcycle" },
        }
    },
    ['themc'] = {
        ['label'] = "themc",
        ['color'] = {0,0,02},
        ['locations'] = {
            ['stash'] = vector3(987.08624, -92.82006, 74.845787),
            ['boss'] = vector3(977.36407, -103.9579, 74.845176),
            ['vehicles'] = vector3(957.55151, -127.2877, 74.353057)
        },
        ['vehicles'] = {
            { ['model'] = "blazer", ['label'] = "Blazer", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "manchez", ['label'] = "Manchez", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "sultan", ['label'] = "sultan", ['icon'] = "fas fa-car-alt" },
         
        }
    },
}
