QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback('nethush-houserobbery:server:get:config', function(source, cb)
  cb(Config)
end)

-- Code

RegisterServerEvent('nethush-houserobbery:server:set:door:status')
AddEventHandler('nethush-houserobbery:server:set:door:status', function(RobHouseId, bool)
 Config.HouseLocations[RobHouseId]['Opened'] = bool
 TriggerClientEvent('nethush-houserobbery:client:set:door:status', -1, RobHouseId, bool)
 ResetHouse(RobHouseId)
end)

RegisterServerEvent('nethush-houserobbery:server:set:locker:state')
AddEventHandler('nethush-houserobbery:server:set:locker:state', function(RobHouseId, LockerId, Type, bool)
 Config.HouseLocations[RobHouseId]['Lockers'][LockerId][Type] = bool
 TriggerClientEvent('nethush-houserobbery:client:set:locker:state', -1, RobHouseId, LockerId, Type, bool)
end)

RegisterServerEvent('nethush-houserobbery:server:locker:reward')
AddEventHandler('nethush-houserobbery:server:locker:reward', function()
  local Player = QBCore.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 100)
  if RandomValue <= 30 then
    Player.Functions.AddMoney('cash', math.random(250, 350), "House Robbery")
  elseif RandomValue >= 45 and RandomValue <= 58 then
    Player.Functions.AddItem('diamond_ring', math.random(1,5))
    TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['diamond_ring'], "add")
  elseif RandomValue >= 76 and RandomValue <= 82 then
    Player.Functions.AddItem('10kgoldchain', math.random(1,5))
    TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['10kgoldchain'], "add") 
  elseif RandomValue >= 83 and RandomValue <= 98 then
    Player.Functions.AddItem('rolex', math.random(1,3))
    TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['rolex'], "add")
  elseif RandomValue == 32 or RandomValue == 34 or RandomValue == 40 then
    local SubValue = math.random(1,2)
    if SubValue == 1 then
      Player.Functions.AddItem('rifle-trigger', 1)
      TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['rifle-trigger'], "add")
    else
      Player.Functions.AddItem('rifle-body', 1)
      TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['rifle-body'], "add")
    end
  else
    TriggerClientEvent('swt_notifications:Infos', source, "You found nothing of interest..")
  end 
end)

RegisterServerEvent('nethush-houserobbery:server:recieve:extra')
AddEventHandler('nethush-houserobbery:server:recieve:extra', function(CurrentHouse, Id)
  local Player = QBCore.Functions.GetPlayer(source)
  Player.Functions.AddItem(Config.HouseLocations[CurrentHouse]['Extras'][Id]['Item'], 1)
  TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items[Config.HouseLocations[CurrentHouse]['Extras'][Id]['Item']], "add")
  Config.HouseLocations[CurrentHouse]['Extras'][Id]['Stolen'] = true
  TriggerClientEvent('nethush-houserobbery:client:set:extra:state', -1, CurrentHouse, Id, true)
end)

function ResetHouse(HouseId)
  Citizen.SetTimeout((1000 * 60) * 15, function()
      Config.HouseLocations[HouseId]["Opened"] = false
      for k, v in pairs(Config.HouseLocations[HouseId]["Lockers"]) do
          v["Opened"] = false
          v["Busy"] = false
      end
      if Config.HouseLocations[HouseId]["Extras"] ~= nil then
        for k, v in pairs(Config.HouseLocations[HouseId]["Extras"]) do
          v['Stolen'] = false
        end
      end
      TriggerClientEvent('nethush-houserobbery:server:reset:state', -1, HouseId)
  end)
end