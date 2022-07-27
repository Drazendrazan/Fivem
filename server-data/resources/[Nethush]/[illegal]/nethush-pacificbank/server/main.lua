QBCore = nil
local IsBankBeingRobbed = false
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local robberyBusy = false
local timeOut = false
local blackoutActive = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 10)
        if blackoutActive then
            TriggerEvent("qb-weathersync:server:toggleBlackout")
            TriggerClientEvent("police:client:EnableAllCameras", -1)
            TriggerClientEvent("nethush-pacific:client:enableAllBankSecurity", -1)
            blackoutActive = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 30)
        TriggerClientEvent("nethush-pacific:client:enableAllBankSecurity", -1)
        TriggerClientEvent("police:client:EnableAllCameras", -1)
    end
end)

RegisterServerEvent('nethush-pacific:server:set:trolly:state')
AddEventHandler('nethush-pacific:server:set:trolly:state', function(TrollyNumber, bool)
 Config.Trollys[TrollyNumber]['Open-State'] = bool
 TriggerClientEvent('nethush-pacific:client:set:trolly:state', -1, TrollyNumber, bool)
end)

QBCore.Functions.CreateCallback("nethush-pacific:server:get:status", function(source, cb)
    cb(IsBankBeingRobbed)
  end)

RegisterServerEvent('nethush-pacific:server:Klapdebank')
AddEventHandler('nethush-pacific:server:Klapdebank', function(state)
        if not robberyBusy then
			Config.PacificB["explosive"]["isOpened"] = state
            TriggerClientEvent('nethush-pacific:client:Klapdebank', state)
            IsBankBeingRobbed = true
            TriggerEvent('nethush-pacific:server:setTimeout')
        else
			Config.PacificB["explosive"]["isOpened"] = state
            IsBankBeingRobbed = false
            TriggerClientEvent('nethush-pacific:client:Klapdebank', state)
        end
    robberyBusy = true
end)

RegisterServerEvent('nethush-pacific:server:set:lights')
AddEventHandler('nethush-pacific:server:set:lights', function(bool)
 Config.PacificB['lights'] = bool
 TriggerClientEvent('nethush-pacific:client:set:lights:state', -1, bool)
end)


RegisterServerEvent('nethush-pacific:server:set:trollyz')
AddEventHandler('nethush-pacific:server:set:trollyz', function(bool)
    Config.PacificB["isOpened"] = bool
 TriggerClientEvent('nethush-pacific:client:set:trol:state', -1, bool)
end)


RegisterServerEvent('nethush-pacific:server:cabinetItem')
AddEventHandler('nethush-pacific:server:cabinetItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 25 then tier = 1 elseif tierChance >= 25 and tierChance < 50 then tier = 2 elseif tierChance >= 50 and tierChance < 75 then tier = 3 elseif tierChance >=75 and tierChance <85 then tier = 4 end
            if tier ~= 4 then
                local item = Config.CabinetRewards["tier"..tier][math.random(#Config.CabinetRewards["tier"..tier])]
                local itemAmount = math.random(item.maxAmount)

                ply.Functions.AddItem(item.item, itemAmount)
                TriggerClientEvent('nethush-inventory:client:ItemBox', ply.PlayerData.source, QBCore.Shared.Items[item.item], 'add')

            else
                ply.Functions.AddItem('pistol_ammo', 2)
                TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['pistol_ammo'], "add")
            end   
    end)

RegisterServerEvent('nethush-pacific:server:recieveItem')
AddEventHandler('nethush-pacific:server:recieveItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

        local itemType = math.random(#Config.RewardTypes)
        local WeaponChance = math.random(1, 100)
        local odd1 = math.random(1, 100)
        local odd2 = math.random(1, 100)
        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 10 then tier = 1 elseif tierChance >= 25 and tierChance < 50 then tier = 2 elseif tierChance >= 50 and tierChance < 95 then tier = 3 else tier = 4 end
        if WeaponChance ~= odd1 or WeaponChance ~= odd2 then
            if tier ~= 4 then
                if Config.RewardTypes[itemType].type == "item" then
                    local item = Config.LockerRewards["tier"..tier][math.random(#Config.LockerRewards["tier"..tier])]
                    local maxAmount = item.maxAmount
                    if tier == 3 then maxAmount = 7 elseif tier == 2 then maxAmount = 18 else maxAmount = 25 end
                    local itemAmount = math.random(maxAmount)

                    ply.Functions.AddItem(item.item, itemAmount)
                    
        TriggerClientEvent('nethush-inventory:client:ItemBox', ply.PlayerData.source, QBCore.Shared.Items[item.item], 'add')
                elseif Config.RewardTypes[itemType].type == "money" then
                    local moneyAmount = math.random(1200, 7000)
                    local info = {
                        worth = math.random(19000, 21000)
                    }
                    ply.Functions.AddItem('markedbills', 1, false, info)
                    TriggerClientEvent('nethush-inventory:client:ItemBox', ply.PlayerData.source, QBCore.Shared.Items['markedbills'], 'add')
                end
            else
                local info = {
                    worth = math.random(1, 3)
                }
                ply.Functions.AddItem("money-roll", 1, false, info)
                TriggerClientEvent('nethush-inventory:client:ItemBox', src, ply.PlayerData.source, QBCore.Shared.Items['money-roll'], "add")
            end
        else
            local chance = math.random(1, 2)
            local odd = math.random(1, 2)
           -- if chance == odd then
            --    ply.Functions.AddItem('weapon_microsmg', 1)
            --    TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['weapon_microsmg'], "add")
            --else
            --    ply.Functions.AddItem('weapon_minismg', 1)
            --    TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['weapon_minismg'], "add")
            --end
        end
end)

QBCore.Functions.CreateCallback('nethush-pacific:server:isRobberyActive', function(source, cb)
    cb(robberyBusy)
end)

QBCore.Functions.CreateCallback('nethush-pacific:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('nethush-pacific:server:setTimeout')
AddEventHandler('nethush-pacific:server:setTimeout', function()
    if not robberyBusy then
        if not timeOut then
            timeOut = true
            Citizen.CreateThread(function()
                Citizen.Wait(30 * (60 * 1000))
                timeOut = false
                robberyBusy = false
                TriggerEvent('qb-scoreboard:server:SetActivityBusy', "humanelabs", false)
                Config.PacificB["explosive"]["isOpened"] = false
                Config.PacificB["lights"] =false
                Config.PacificB["isOpened"] = false
                -- for k, v in pairs(Config.PacificBs["lockers"]) do
                --     Config.PacificBs["lockers"][k]["isBusy"] = false
                --     Config.PacificBs["lockers"][k]["isOpened"] = false
                --     Config.PacificBs["explosive"]["isOpened"] = false
                -- end

                TriggerClientEvent('nethush-pacific:client:ClearTimeoutDoors', -1)
            end)
        end
    end
end)

QBCore.Functions.CreateCallback('nethush-pacific:server:PoliceAlertMessage', function(source, cb, title, coords, blip)
	local src = source
    local alertData = {
        title = title,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Overval gestart op Human Lbas<br>Beschikbare camera's: Geen.",
    }

    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("qb-phone:client:addPoliceAlert", v, alertData)
                        TriggerClientEvent("nethush-pacific:client:PoliceAlertMessage", v, title, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("qb-phone:client:addPoliceAlert", v, alertData)
                    TriggerClientEvent("nethush-pacific:client:PoliceAlertMessage", v, title, coords, blip)
                end
            end
        end
    end
end)

RegisterServerEvent('nethush-pacific:server:SetStationStatus')
AddEventHandler('nethush-pacific:server:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
    TriggerClientEvent("nethush-pacific:client:SetStationStatus", -1, key, isHit)
    if AllStationsHit() then
        TriggerEvent("qb-weathersync:server:toggleBlackout")
        TriggerClientEvent("police:client:DisableAllCameras", -1)
        TriggerClientEvent("nethush-pacific:client:disableAllBankSecurity", -1)
        blackoutActive = true
    else
        CheckStationHits()
    end
end)

QBCore.Commands.Add("bankreset", "Bank reset", {}, false, function(source, args)
    local group = QBCore.Functions.GetPermission(source)
    if group == "god"  then
        TriggerEvent('nethush-pacific:server:setTimeout', source)
	end
end)

QBCore.Functions.CreateCallback('nethush-pacificbank:server:HasItem', function(source, cb, ItemName)
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

  
RegisterServerEvent('nethush-pacific:server:rob:pacific:money')
AddEventHandler('nethush-pacific:server:rob:pacific:money', function()
  local Player = QBCore.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 110)
  Player.Functions.AddMoney('cash', math.random(1500, 11000), "Bank Robbery")
if RandomValue > 15 and  RandomValue < 20 then
     Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(12500, 20000)})
     TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "add")
    else
    Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(1250, 20000)})
    TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "add")
  end

end)

RegisterServerEvent('nethush-pacific:maze:server:DoSmokePfx')
AddEventHandler('nethush-pacific:maze:server:DoSmokePfx', function()
    TriggerClientEvent('nethush-pacific:maze:client:DoSmokePfx', -1)
end)

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
        TriggerClientEvent('nethush-pacificbank:client:use:black-card', source, 'purple-card')
    end
end)

QBCore.Functions.CreateUseableItem("blue-card", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-bankrobbery:client:use:card', source, 'blue-card')
    end
end)