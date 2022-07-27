resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
 'config.lua',
 'client/client.lua',
}


files {
    'stream/HouseExtra/v_int_20.ytyp',
    'stream/HouseExtra/v_int_shop.ytyp',
}
   
data_file 'DLC_ITYP_REQUEST' 'stream/HouseExtra/v_int_20.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/HouseExtra/v_int_shop.ytyp'

exports {
 'DespawnInterior',
 'CreateMidAppartement',
 'CreateMidHotel',
 'HouseTierOne',
 'HouseTierTwo',
 'HouseTierThree',
 'HouseTierFour',
 'HouseTierFive',
 'HouseTierSix',
 'HouseTierSeven',
 'HouseTierEight',
 'HouseTierNine',
 'HouseTierTen',
 'GarageTierOne',
 'GarageTierTwo',
 'HouseRobTierOne',
 'HouseRobTierThree',
 'TrapHouse',
}