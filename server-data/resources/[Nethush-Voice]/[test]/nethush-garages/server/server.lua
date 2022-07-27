QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateCallback("nethush-garage:server:is:vehicle:owner", function(source, cb, plate)
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..PlateEscapeSqli(plate).."'", function(result)
        local Player = QBCore.Functions.GetPlayer(source)
        if result[1] ~= nil then
            if result[1].citizenid == Player.PlayerData.citizenid then
              cb(true)
            else
              cb(false)
            end
        else
            cb(false)
        end
    end)
end)

QBCore.Functions.CreateCallback("nethush-garage:server:GetHouseVehicles", function(source, cb, HouseId)
  QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `garage` = '"..HouseId.."'", function(result)
    if result ~= nil then
      cb(result)
    end 
  end)
end)

QBCore.Functions.CreateCallback("nethush-garage:server:GetUserVehicles", function(source, cb, garagename)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND garage = '"..garagename.."'", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              cb(result)
          end
      end
      cb(nil)
  end)
end)

QBCore.Functions.CreateCallback("nethush-garage:server:GetDepotVehicles", function(source, cb)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              cb(result)
          end
      end
      cb(nil)
  end)
end)

QBCore.Functions.CreateCallback("nethush-garage:server:pay:depot", function(source, cb, price)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  if Player.Functions.RemoveMoney("cash", price, "Depot Paid") then
    cb(true)
  else
    TriggerClientEvent('swt_notifications:Infos', src, "You do not have enough cash..")
    cb(false)
  end
end)

QBCore.Functions.CreateCallback("nethush-garage:server:get:vehicle:mods", function(source, cb, plate)
  local src = source
  local properties = {}
  QBCore.Functions.ExecuteSql(false, "SELECT `mods` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
      if result[1] ~= nil then
          properties = json.decode(result[1].mods)
      end
      cb(properties)
  end)
end)

RegisterServerEvent('nethush-garages:server:set:in:garage')
AddEventHandler('nethush-garages:server:set:in:garage', function(Plate, GarageData, Status, MetaData)
 TriggerEvent('nethush-garages:server:set:garage:stater', Plate, 'in')
 QBCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET garage = '" ..GarageData.. "', stater = '"..Status.."', metadata = '" ..json.encode(MetaData).. "' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

RegisterServerEvent('nethush-garages:server:set:in:impound')
AddEventHandler('nethush-garages:server:set:in:impound', function(Plate)
 TriggerEvent('nethush-garages:server:set:garage:stater', Plate, 'in')
 local MetaData = '{"Engine":1000.0,"Fuel":100.0,"Body":1000.0}'
 QBCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET garage = 'Police', stater = 'in', metadata = '" ..json.encode(MetaData).. "' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

RegisterServerEvent('nethush-garages:server:set:garage:stater')
AddEventHandler('nethush-garages:server:set:garage:stater', function(Plate, Status)
  QBCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET stater = '"..Status.."' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

RegisterServerEvent('nethush-garages:server:set:depot:price')
AddEventHandler('nethush-garages:server:set:depot:price', function(Plate, Price)
  QBCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET depotprice = '"..Price.."' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

-- // Server Function \\ --

function PlateEscapeSqli(str)
	if str:len() <= 8 then 
	 local replacements = { ['"'] = '\\"', ["'"] = "\\'"}
	 return str:gsub( "['\"]", replacements)
	end
end