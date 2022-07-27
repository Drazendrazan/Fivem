QBCore = nil

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
            TriggerClientEvent("nethush-humanlabs:client:enableAllBankSecurity", -1)
            blackoutActive = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 30)
        TriggerClientEvent("nethush-humanlabs:client:enableAllBankSecurity", -1)
        TriggerClientEvent("police:client:EnableAllCameras", -1)
    end
end)

RegisterServerEvent('nethush-humanlabs:server:setLabState')
AddEventHandler('nethush-humanlabs:server:setLabState', function(bankId, state)
        if not robberyBusy then
            Config.Lab["isOpened"] = state
			Config.Lab["explosive"]["isOpened"] = state
            TriggerClientEvent('nethush-humanlabs:client:setLabState', -1, bankId, state)
            TriggerEvent('qb-scoreboard:server:SetActivityBusy', "humanelabs", true)
            TriggerEvent('nethush-humanlabs:server:setTimeout')
        else
            Config.Lab["isOpened"] = state
			Config.Lab["explosive"]["isOpened"] = state
            TriggerClientEvent('nethush-humanlabs:client:setLabState', -1, bankId, state)
        end
    robberyBusy = true
end)


RegisterServerEvent('nethush-humanlabs:server:Openkluisjes')
AddEventHandler('nethush-humanlabs:server:Openkluisjes', function(bool)

    Config.Lab["isOpened"] = bool

    TriggerClientEvent('nethush-humanlabs:client:setLabState', -1, bool)
end)

RegisterServerEvent('nethush-humanlabs:server:setLockerState')
AddEventHandler('nethush-humanlabs:server:setLockerState', function(lockerId, state, bool)

        Config.Lab["lockers"][lockerId][state] = bool

    TriggerClientEvent('nethush-humanlabs:client:setLockerState', -1, lockerId, state, bool)
end)

RegisterServerEvent('nethush-humanlabs:server:setCabinetState')
AddEventHandler('nethush-humanlabs:server:setCabinetState', function(cabinetId, state, bool)

        Config.Lab["lockers"][lockerId][state] = bool

    TriggerClientEvent('nethush-humanlabs:client:setCabinetState', -1, cabinetId, state, bool)
end)

RegisterServerEvent('nethush-humanlabs:server:cabinetItem')
AddEventHandler('nethush-humanlabs:server:cabinetItem', function(type)
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
                ply.Functions.AddItem('weapon_minismg', 2)
                TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['pistol-ammo'], "add")
            end   
    end)

RegisterServerEvent('nethush-humanlabs:server:recieveItem')
AddEventHandler('nethush-humanlabs:server:recieveItem', function(type)
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
                    local info = {worth = math.random(3500, 12500)}
                    ply.Functions.AddItem('markedbills', 1, false, info)
                    TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
                end
            else
                --local info = {
                --    crypto = math.random(1, 3)
                --}
                --ply.Functions.AddItem("cryptostick", 1, false, info)
                --TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['cryptostick'], "add")
            end
        else
            local chance = math.random(1, 2)
            local odd = math.random(1, 2)
           if chance == odd then
               ply.Functions.AddItem('weapon_minismg', 1)
               TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['pistol-ammo'], "add")
            --else
            --    ply.Functions.AddItem('weapon_minismg', 1)
            --    TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['weapon_minismg'], "add")
            end
        end
end)

QBCore.Functions.CreateCallback('nethush-humanlabs:server:isRobberyActive', function(source, cb)
    cb(robberyBusy)
end)

QBCore.Functions.CreateCallback('nethush-humanlabs:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('nethush-humanlabs:server:setTimeout')
AddEventHandler('nethush-humanlabs:server:setTimeout', function()
    if not robberyBusy then
        if not timeOut then
            timeOut = true
            Citizen.CreateThread(function()
                Citizen.Wait(30 * (60 * 1000))
                timeOut = false
                robberyBusy = false
                TriggerEvent('qb-scoreboard:server:SetActivityBusy', "humanelabs", false)

                for k, v in pairs(Config.Labs["lockers"]) do
                    Config.Labs["lockers"][k]["isBusy"] = false
                    Config.Labs["lockers"][k]["isOpened"] = false
                    Config.Labs["explosive"]["isOpened"] = false
                end

                TriggerClientEvent('nethush-humanlabs:client:ClearTimeoutDoors', -1)
                Config.Labs["isOpened"] = false
            end)
        end
    end
end)

QBCore.Functions.CreateCallback('nethush-humanlabs:server:PoliceAlertMessage', function(source, cb, title, coords, blip)
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
                        TriggerClientEvent("nethush-humanlabs:client:PoliceAlertMessage", v, title, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("qb-phone:client:addPoliceAlert", v, alertData)
                    TriggerClientEvent("nethush-humanlabs:client:PoliceAlertMessage", v, title, coords, blip)
                end
            end
        end
    end
end)

RegisterServerEvent('nethush-humanlabs:server:SetStationStatus')
AddEventHandler('nethush-humanlabs:server:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
    TriggerClientEvent("qb-bankrobbery:client:SetStationStatus", -1, key, isHit)
    if AllStationsHit() then
        TriggerEvent("qb-weathersync:server:toggleBlackout")
        TriggerClientEvent("police:client:DisableAllCameras", -1)
        TriggerClientEvent("qb-bankrobbery:client:disableAllBankSecurity", -1)
        blackoutActive = true
    else
        CheckStationHits()
    end
end)

QBCore.Functions.CreateUseableItem("explosive", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('lighter') ~= nil then
        TriggerClientEvent("explosive:UseExplosive", source)
        
        TriggerEvent('qb-scoreboard:server:SetActivityBusy', "humanelabs", true)
    else
        TriggerClientEvent('swt_notifications:Infos', source, "You Dont Have lighter..")
    end
end)


QBCore.Functions.CreateUseableItem("electronickit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName('electronickit') ~= nil then
        TriggerClientEvent("electronickit:UseElectronickit", source)
    else
        TriggerClientEvent('swt_notifications:Infos', source, "You dont have any electronic kit")
    end
end)

RegisterServerEvent('qb-bankrobbery:maze:server:DoSmokePfx')
AddEventHandler('qb-bankrobbery:maze:server:DoSmokePfx', function()
    TriggerClientEvent('qb-bankrobbery:maze:client:DoSmokePfx', -1)
end)