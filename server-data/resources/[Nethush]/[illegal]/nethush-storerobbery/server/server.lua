QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback('nethush-storerobbery:server:get:config', function(source, cb)
    cb(Config)
end)

QBCore.Commands.Add("resetsafes", "Reset store safes", {}, false, function(source, args)
    for k, v in pairs(Config.Safes) do
        Config.Safes[k]['Busy'] = false
        TriggerClientEvent('nethush-storerobbery:client:safe:busy', -1, k, false)
    end
end, "user")

QBCore.Functions.CreateCallback('nethush-storerobbery:server:HasItem', function(source, cb, itemName)
    local Player = QBCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName(itemName)
	if Player ~= nil then
        if Item ~= nil then
			cb(true)
        else
			cb(false)
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(Config.Registers) do
            if Config.Registers[k]['Time'] > 0 and (Config.Registers[k]['Time'] - Config.Inverval) >= 0 then
                Config.Registers[k]['Time'] = Config.Registers[k]['Time'] - Config.Inverval
            else
                Config.Registers[k]['Time'] = 0
                Config.Registers[k]['Robbed'] = false
                TriggerClientEvent('nethush-storerobbery:client:set:register:robbed', -1, k, false)
            end
        end
        Citizen.Wait(Config.Inverval)
    end
end)

RegisterServerEvent('nethush-storerobbery:server:set:register:robbed')
AddEventHandler('nethush-storerobbery:server:set:register:robbed', function(RegisterId, bool)
    Config.Registers[RegisterId]['Robbed'] = bool
    Config.Registers[RegisterId]['Time'] = Config.ResetTime
    TriggerClientEvent('nethush-storerobbery:client:set:register:robbed', -1, RegisterId, bool)
end)

RegisterServerEvent('nethush-storerobbery:server:set:register:busy')
AddEventHandler('nethush-storerobbery:server:set:register:busy', function(RegisterId, bool)
    Config.Registers[RegisterId]['Busy'] = bool
    TriggerClientEvent('nethush-storerobbery:client:set:register:busy', -1, RegisterId, bool)
end)

RegisterServerEvent('nethush-storerobbery:server:safe:busy')
AddEventHandler('nethush-storerobbery:server:safe:busy', function(SafeId, bool)
    Config.Safes[SafeId]['Busy'] = bool
    TriggerClientEvent('nethush-storerobbery:client:safe:busy', -1, SafeId, bool)
end)

RegisterServerEvent('nethush-storerobbery:server:safe:robbed')
AddEventHandler('nethush-storerobbery:server:safe:robbed', function(SafeId, bool)
    Config.Safes[SafeId]['Robbed'] = bool
    TriggerClientEvent('nethush-storerobbery:client:safe:robbed', -1, SafeId, bool)
    SetTimeout((1000 * 60) * 25, function()
        TriggerClientEvent('nethush-storerobbery:client:safe:robbed', -1, SafeId, false)
        Config.Safes[SafeId]['Robbed'] = false
    end)
end)

RegisterServerEvent('nethush-storerobbery:server:rob:register')
AddEventHandler('nethush-storerobbery:server:rob:register', function(RegisterId, IsDone)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', math.random(900, 3120), "Store Robbery")
    if IsDone then
        local RandomItem = Config.SpecialItems[math.random(#Config.SpecialItems)]
        local RandomValue = math.random(1, 100)
        if RandomValue <= 16 then
            Player.Functions.AddItem(RandomItem, 1)
            TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items[RandomItem], "add")
        end
        Player.Functions.AddItem('money-roll', math.random(25, 150))
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['money-roll'], "add")
    end
end)

RegisterServerEvent('nethush-storerobbery:server:safe:reward')
AddEventHandler('nethush-storerobbery:server:safe:reward', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local RandomItem = Config.SpecialItems[math.random(#Config.SpecialItems)]
    Player.Functions.AddMoney('cash', math.random(1000, 3000), "Safe Robbery")
    Player.Functions.AddItem('money-roll', math.random(40, 95))
    TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['money-roll'], "add")
    local RandomValue = math.random(1,100)
    if RandomValue <= 25 then
        Player.Functions.AddItem("money-roll", math.random(2,4))
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items["rolex"], "add") 
    elseif RandomValue >= 35 and RandomValue <= 55 then
        Player.Functions.AddItem(RandomItem, 1)
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items[RandomItem], "add")
    elseif RandomValue >= 65 and RandomValue <= 75 then
        Player.Functions.AddItem("money-roll", math.random(1,2))
        TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items["goldbar"], "add") 
    end
end)

RegisterServerEvent('qb-storerobbery:server:callCops')
AddEventHandler('qb-storerobbery:server:callCops', function(type, safe, streetLabel, coords)
    local cameraId = 4
    if type == "safe" then
        cameraId = Config.Safes[safe].camId
    else
        cameraId = Config.Registers[safe].camId
    end
    local alertData = {
        title = "Shop robbery",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Someone is trying to raid a store at "..streetLabel.." (CAMERA ID: "..cameraId..")"
    }
    TriggerClientEvent("qb-storerobbery:client:robberyCall", -1, type, safe, streetLabel, coords)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
end)