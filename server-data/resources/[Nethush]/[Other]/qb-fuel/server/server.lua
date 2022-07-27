QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateCallback("qb-fuel:server:get:fuel:config", function(source, cb)
    cb(Config)
end)

QBCore.Functions.CreateCallback('qb-fuel:server:can:fuel', function(source, cb, price)
    local CanFuel = false
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "car-wash") then
        CanFuel = true
    else 
        CanFuel = false
    end
    cb(CanFuel)
end)

RegisterServerEvent('qb-fuel:server:register:fuel')
AddEventHandler('qb-fuel:server:register:fuel', function(Plate, Vehicle, Amount)
    Config.VehicleFuel[Plate] = Amount
    TriggerClientEvent('qb-fuel:client:register:vehicle:fuel', -1, Plate, Vehicle, Amount)
end)

RegisterServerEvent('qb-fuel:server:update:fuel')
AddEventHandler('qb-fuel:server:update:fuel', function(Plate, Vehicle, Amount)
    Config.VehicleFuel[Plate] = Amount
    TriggerClientEvent('qb-fuel:client:update:vehicle:fuel', -1, Plate, Vehicle, Amount)
end)