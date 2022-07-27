QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- code

RegisterNetEvent('nethush-vehicleshop:server:buyVehicle')
AddEventHandler('nethush-vehicleshop:server:buyVehicle', function(vehicleData, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = QBCore.Shared.Vehicles[vehicleData["model"]]
    local balance = pData.PlayerData.money["bank"]
    
    if (balance - vData["price"]) >= 0 then
        local plate = GeneratePlate()
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vData["model"].."', '"..GetHashKey(vData["model"]).."', '{}', '"..plate.."', '"..garage.."')")
        TriggerClientEvent("swt_notifications:Infos", src, "Weldone! Your vehicle is deliverd "..Neth.GarageLabel[garage])
        pData.Functions.RemoveMoney('bank', vData["price"], "vehicle-bought-in-shop")
        TriggerEvent("qb-log:server:sendLog", cid, "vehiclebought", {model=vData["model"], name=vData["name"], from="garage", location=Neth.GarageLabel[garage], moneyType="bank", price=vData["price"], plate=plate})
        TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Vehicle bought (garage)", "green", "**"..GetPlayerName(src) .. "** Bought a " .. vData["name"] .. " for €" .. vData["price"])
    else
		TriggerClientEvent("swt_notifications:Infos", src, "You dont have enough money, you miss €"..format_thousand(vData["price"] - balance))
    end
end)

RegisterNetEvent('nethush-vehicleshop:server:buyShowroomVehicle')
AddEventHandler('nethush-vehicleshop:server:buyShowroomVehicle', function(vehicle, class)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local balance = pData.PlayerData.money["bank"]
    local vehiclePrice = QBCore.Shared.Vehicles[vehicle]["price"]
    local plate = GeneratePlate()

    if (balance - vehiclePrice) >= 0 then
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vehicle.."', '"..GetHashKey(vehicle).."', '{}', '"..plate.."', 0)")
        TriggerClientEvent("swt_notifications:Infos", src, "Weldone! Your vehicle is waiting outside for you.")
        TriggerClientEvent('nethush-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, "vehicle-bought-in-showroom")
        TriggerEvent("qb-log:server:sendLog", cid, "vehiclebought", {model=vehicle, name=QBCore.Shared.Vehicles[vehicle]["name"], from="showroom", moneyType="bank", price=QBCore.Shared.Vehicles[vehicle]["price"], plate=plate})
        TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Vehicle bought (showroom)", "green", "**"..GetPlayerName(src) .. "** Bought a  " .. QBCore.Shared.Vehicles[vehicle]["name"] .. " for €" .. QBCore.Shared.Vehicles[vehicle]["price"])
    else
        TriggerClientEvent("swt_notifications:Infos", src, "You dont have enough money, you miss €"..format_thousand(vehiclePrice - balance))
    end
end)

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

RegisterServerEvent('nethush-vehicleshop:server:setShowroomCarInUse')
AddEventHandler('nethush-vehicleshop:server:setShowroomCarInUse', function(showroomVehicle, bool)
    Neth.ShowroomVehicles[showroomVehicle].inUse = bool
    TriggerClientEvent('nethush-vehicleshop:client:setShowroomCarInUse', -1, showroomVehicle, bool)
end)

RegisterServerEvent('nethush-vehicleshop:server:setShowroomVehicle')
AddEventHandler('nethush-vehicleshop:server:setShowroomVehicle', function(vData, k)
    Neth.ShowroomVehicles[k].chosenVehicle = vData
    TriggerClientEvent('nethush-vehicleshop:client:setShowroomVehicle', -1, vData, k)
end)

RegisterServerEvent('nethush-vehicleshop:server:SetCustomShowroomVeh')
AddEventHandler('nethush-vehicleshop:server:SetCustomShowroomVeh', function(vData, k)
    Neth.ShowroomVehicles[k].vehicle = vData
    TriggerClientEvent('nethush-vehicleshop:client:SetCustomShowroomVeh', -1, vData, k)
end)

QBCore.Commands.Add("verkoop", "Sell vehicle out of custom car dealer", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        if TargetId ~= nil then
            TriggerClientEvent('nethush-vehicleshop:client:SellCustomVehicle', source, TargetId)
        else
            TriggerClientEvent('swt_notifications:Infos', source, 'You need to giveaway player id')
        end
    else
        TriggerClientEvent('swt_notifications:Infos', source, 'You aren\'t a car dealer')
    end
end)

QBCore.Commands.Add("testdrive", "Take a test drive", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        TriggerClientEvent('nethush-vehicleshop:client:DoTestrit', source, GeneratePlate())
    else
        TriggerClientEvent('swt_notifications:Infos', source, 'You arrent a car dealer')
    end
end)

RegisterServerEvent('nethush-vehicleshop:server:SellCustomVehicle')
AddEventHandler('nethush-vehicleshop:server:SellCustomVehicle', function(TargetId, ShowroomSlot)
    TriggerClientEvent('nethush-vehicleshop:client:SetVehicleBuying', TargetId, ShowroomSlot)
end)

RegisterServerEvent('nethush-vehicleshop:server:ConfirmVehicle')
AddEventHandler('nethush-vehicleshop:server:ConfirmVehicle', function(ShowroomVehicle)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local VehPrice = QBCore.Shared.Vehicles[ShowroomVehicle.vehicle].price
    local plate = GeneratePlate()

    if Player.PlayerData.money.cash >= VehPrice then
        Player.Functions.RemoveMoney('cash', VehPrice)
        TriggerClientEvent('nethush-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..ShowroomVehicle.vehicle.."', '"..GetHashKey(ShowroomVehicle.vehicle).."', '{}', '"..plate.."', 0)")
    elseif Player.PlayerData.money.bank >= VehPrice then
        Player.Functions.RemoveMoney('bank', VehPrice)
        TriggerClientEvent('nethush-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..ShowroomVehicle.vehicle.."', '"..GetHashKey(ShowroomVehicle.vehicle).."', '{}', '"..plate.."', 0)")
    else
        if Player.PlayerData.money.cash > Player.PlayerData.money.bank then
            TriggerClientEvent('swt_notifications:Infos', src, 'You dont have enough money.. you mis ('..(Player.PlayerData.money.cash - VehPrice)..',-)')
        else
            TriggerClientEvent('swt_notifications:Infos', src, 'You dont have enough money.. you mis ('..(Player.PlayerData.money.bank - VehPrice)..',-)')
        end
    end
end)

QBCore.Functions.CreateCallback('nethush-vehicleshop:server:SellVehicle', function(source, cb, vehicle, plate)
    local VehicleData = QBCore.Shared.VehicleModels[vehicle]
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            Player.Functions.AddMoney('bank', math.ceil(VehicleData["price"] / 100 * 60))
            QBCore.Functions.ExecuteSql(false, "DELETE FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'")
            cb(true)
        else
            cb(false)
        end
    end)
end)