local IsBankBeingRobbed = false
cooldowntime = Config.Cooldown 
atmcooldown = false

QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateCallback("nethush-bankrobbery:server:get:status", function(source, cb)
  cb(IsBankBeingRobbed)
end)

QBCore.Functions.CreateCallback("nethush-bankrobbery:server:get:key:config", function(source, cb)
  cb(Config)
end)

QBCore.Functions.CreateCallback("nethush-atmrobbery:getHackerDevice",function(source,cb)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if xPlayer.Functions.GetItemByName("electronickit") and xPlayer.Functions.GetItemByName("drill") then
		cb(true)
	else
		cb(false)
		TriggerClientEvent('swt_notifications:Infos', source, _U("needdrill"))
	end
end)

QBCore.Functions.CreateCallback('nethush-bankrobbery:server:HasItem', function(source, cb, ItemName)
  local Player = QBCore.Functions.GetPlayer(source)
  local Item = Player.Functions.GetItemByName(ItemName)
  if Player ~= nil then
     if Item ~= nil then
       cb(true)
     else
       cb(false)
     end
  end
end)

QBCore.Functions.CreateCallback('nethush-bankrobbery:server:HasLockpickItems', function(source, cb)
  local Player = QBCore.Functions.GetPlayer(source)
  local LockpickItem = Player.Functions.GetItemByName('lockpick')
  local ToolkitItem = Player.Functions.GetItemByName('toolkit')
  local AdvancedLockpick = Player.Functions.GetItemByName('advancedlockpick')
  if Player ~= nil then
    if LockpickItem ~= nil and ToolkitItem ~= nil or AdvancedLockpick ~= nil then
      cb(true)
    else
      cb(false)
    end
  end
end)

RegisterServerEvent('nethush-atm:rem:drill')
AddEventHandler('nethush-atm:rem:drill', function()
local xPlayer = QBCore.Functions.GetPlayer(source)
	xPlayer.Functions.RemoveItem('drill', 1)
end)

QBCore.Functions.CreateUseableItem('electronickit', function(source)
	TriggerClientEvent('nethush-atm:item', source)
end)


RegisterServerEvent("nethush-atmrobbery:success")
AddEventHandler("nethush-atmrobbery:success",function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
    local reward = math.random(Config.MinReward,Config.MaxReward)
		xPlayer.Functions.AddMoney(Config.RewardAccount, tonumber(reward))

		TriggerClientEvent("swt_notifications:Infos",source,_U("success") ..""..reward.. " !")
end)

RegisterServerEvent('nethush-atm:CooldownServer')
AddEventHandler('nethush-atm:CooldownServer', function(bool)
    atmcooldown = bool
	if bool then 
		cooldown()
	end	 
end)

RegisterServerEvent('nethush-atm:CooldownNotify')
AddEventHandler('nethush-atm:CooldownNotify', function()
	TriggerClientEvent("swt_notifications:Infos",source,_U("atmrob") ..""..cooldowntime.." Minutes!")
end)

function cooldown()

	while true do 
	Citizen.Wait(60000)

	cooldowntime = cooldowntime - 1 

	if cooldowntime <= 0 then
		atmcooldown = false
		break
	end

end
end

QBCore.Functions.CreateCallback("nethush-atm:GetCooldown",function(source,cb)
	cb(atmcooldown)
end)


RegisterServerEvent('nethush-bankrobbery:server:set:state')
AddEventHandler('nethush-bankrobbery:server:set:state', function(BankId, LockerId, Type, bool)
 Config.BankLocations[BankId]['Lockers'][LockerId][Type] = bool
 TriggerClientEvent('nethush-bankrobbery:client:set:state', -1, BankId, LockerId, Type, bool)
end)

RegisterServerEvent('nethush-bankrobbery:server:set:open')
AddEventHandler('nethush-bankrobbery:server:set:open', function(BankId, bool)
 IsBankBeingRobbed = bool
 Config.BankLocations[BankId]['IsOpened'] = bool
 TriggerClientEvent('nethush-bankrobbery:client:set:open', -1, BankId, bool)
 StartRestart(BankId)
end)

RegisterServerEvent('nethush-bankrobbery:server:random:reward')
AddEventHandler('nethush-bankrobbery:server:random:reward', function(Tier, BankId)
  local Player = QBCore.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 110)
  if BankId ~= 6 then
      if RandomValue >= 1 and RandomValue <= 18 then
        if Tier == 2 then
          Player.Functions.AddItem('yellow-card', 1)
          TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['yellow-card'], "add")
        elseif Tier == 3 then
          Player.Functions.AddItem('bank-black', 1)
          TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['bank-black'], "add")
        end
        Player.Functions.AddMoney('cash', math.random(1000, 2500), "Bank Robbery")
      elseif RandomValue >= 22 and RandomValue <= 35 then
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(3500, 5000)})
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "add")
      elseif RandomValue >= 40 and RandomValue <= 52 then
        Player.Functions.AddItem('goldbar', math.random(1,4))
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['goldbar'], "add") 
      elseif RandomValue >= 55 and RandomValue <= 75 then
        Player.Functions.AddItem('10kgoldchain', math.random(4,8))
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['10kgoldchain'], "add") 
      elseif RandomValue >= 76 and RandomValue <= 96 then
        Player.Functions.AddItem('rolex', math.random(4,8))
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['rolex'], "add")
      elseif RandomValue == 110 or RandomValue == 97 or RandomValue == 98 or RandomValue == 105 then
        -- local Info = {quality = 100.0, ammo = 10}
        -- if Tier == 1 then
        --   Player.Functions.AddItem('weapon_heavypistol', 1, false, Info)
        --   TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['weapon_heavypistol'], "add")
        -- elseif Tier == 2 then
        --   Player.Functions.AddItem('weapon_snspistol_mk2', 1, false, Info)
        --   TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['weapon_snspistol_mk2'], "add")
        -- elseif Tier == 3 then
        --   Player.Functions.AddItem('pistol_ammo', math.random(2,6))
        --   TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['pistol_ammo'], "add")
        -- -- end
        -- local curRep = Player.PlayerData.metadata["alcoholaddiction"]
        -- Player.Functions.SetMetaData('alcoholaddiction', (curRep + 3))
      else
        TriggerClientEvent('swt_notifications:Infos', source, _U("nopes"))
      end
  else
      if RandomValue >= 1 and RandomValue <= 18 then
        if Tier == 2 then
          Player.Functions.AddItem('yellow-card', 1)
          TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['yellow-card'], "add")
        elseif Tier == 3 then
          Player.Functions.AddItem('bank-black', 1)
          TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['bank-black'], "add")
        end
        Player.Functions.AddMoney('cash', math.random(2500, 3500), "Bank Robbery")
      elseif RandomValue >= 22 and RandomValue <= 36 then
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(7500, 8000)})
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "add")
      elseif RandomValue >= 40 and RandomValue <= 55 then
        Player.Functions.AddItem('goldbar', math.random(1,4))
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['goldbar'], "add") 
      elseif RandomValue >= 62 and RandomValue <= 96 then
        Player.Functions.AddItem('rolex', math.random(4,8))
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['rolex'], "add")
      elseif RandomValue == 110 or RandomValue == 97 or RandomValue == 98 or RandomValue == 105 then
        local Info = {quality = 100.0, ammo = 10}
        if Tier == 1 then
          Player.Functions.AddItem('weapon_heavypistol', 1, false, Info)
          TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['weapon_heavypistol'], "add")
        elseif Tier == 2 then
          Player.Functions.AddItem('weapon_vintagepistol', 1, false, Info)
          TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['weapon_vintagepistol'], "add")
        elseif Tier == 3 then
          Player.Functions.AddItem('pistol_ammo', math.random(2,6))
          TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['pistol_ammo'], "add")
        end
      else
        TriggerClientEvent('swt_notifications:Infos', source, _U("nopes"))
      end
  end
end)

RegisterServerEvent('nethush-bankrobbery:server:rob:pacific:money')
AddEventHandler('nethush-bankrobbery:server:rob:pacific:money', function()
  local Player = QBCore.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 110)
  Player.Functions.AddMoney('cash', math.random(1500, 2000), "Bank Robbery")
  if RandomValue > 15 and  RandomValue < 20 then
     Player.Functions.AddItem('money-roll', 1, false, {worth = math.random(12500, 20000)})
     TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['money-roll'], "add")
  end
end)

RegisterServerEvent('nethush-bankrobbery:server:pacific:start')
AddEventHandler('nethush-bankrobbery:server:pacific:start', function()
  Config.SpecialBanks[1]['Open'] = true
  IsBankBeingRobbed = true
  TriggerClientEvent('nethush-bankrobbery:client:pacific:start', -1)
  Citizen.SetTimeout((1000 * 60) * math.random(20,30), function()
    TriggerClientEvent('nethush-bankrobbery:client:clear:trollys', -1)
    TriggerClientEvent('nethush-doorlock:server:reset:door:looks', -1)
    IsBankBeingRobbed = false
    for k,v in pairs(Config.Trollys) do 
      v['Open-State'] = false
    end
  end)
end)

RegisterServerEvent('nethush-bankrobbery:server:set:trolly:state')
AddEventHandler('nethush-bankrobbery:server:set:trolly:state', function(TrollyNumber, bool)
 Config.Trollys[TrollyNumber]['Open-State'] = bool
 TriggerClientEvent('nethush-bankrobbery:client:set:trolly:state', -1, TrollyNumber, bool)
end)

function StartRestart(BankId)
  Citizen.SetTimeout((1000 * 60) * math.random(20,30), function()
    IsBankBeingRobbed = false
    Config.BankLocations[BankId]['IsOpened'] = false
    TriggerClientEvent('nethush-bankrobbery:client:set:open', -1, BankId, false)
    --DOORS reset
    for k, v in pairs(Config.BankLocations[BankId]['DoorId']) do
      TriggerEvent('nethush-doorlock:server:updateState', v, true)
    end
    -- Lockers
    for k,v in pairs(Config.BankLocations[BankId]['Lockers']) do
     v['IsBusy'] = false
     v['IsOpend'] = false
    TriggerClientEvent('nethush-bankrobbery:client:set:state', -1, BankId, k, 'IsBusy', false)
    TriggerClientEvent('nethush-bankrobbery:client:set:state', -1, BankId, k, 'IsOpend', false)
    end
  end)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(4)
    for k, v in pairs(Config.BankLocations) do
      local RandomCard = Config.CardType[math.random(1, #Config.CardType)]
      Config.BankLocations[k]['card-type'] = RandomCard
      TriggerClientEvent('nethush-bankrobbery:client:set:cards', -1, k, Config.BankLocations[k]['card-type'])
    end
    Citizen.Wait((1000 * 60) * 60)
  end
end)
-- // Card Types \\ --

QBCore.Functions.CreateUseableItem("red-card", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-bankrobbery:client:use:card', source, 'red-card')
    end
end)

QBCore.Functions.CreateUseableItem("purple-card", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-bankrobbery:client:use:card', source, 'purple-card')
    end
end)

QBCore.Functions.CreateUseableItem("black-card", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-bankrobbery:client:use:card', source, 'purple-card')
    end
end)

QBCore.Functions.CreateUseableItem("blue-card", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-bankrobbery:client:use:card', source, 'blue-card')
    end
end)