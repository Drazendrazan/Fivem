QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback('qb-banktruck:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('qb-banktruck:server:OpenTruck')
AddEventHandler('qb-banktruck:server:OpenTruck', function(Veh) 
    TriggerClientEvent('qb-banktruck:client:OpenTruck', source, Veh)
end)

RegisterServerEvent('qb-banktruck:server:updateplates')
AddEventHandler('qb-banktruck:server:updateplates', function(Plate)
 Config.RobbedPlates[Plate] = true
 TriggerClientEvent('qb-banktruck:plate:table', -1, Plate)
end)

RegisterServerEvent('qb-banktruck:sever:send:cop:alert')
AddEventHandler('qb-banktruck:sever:send:cop:alert', function(coords, veh, plate)
    local msg = "A bank truck is being robbed.<br>"..plate
    local alertData = {
        title = "Bank truck Alarm",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("qb-banktruck:client:send:cop:alert", -1, coords, veh, plate)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('qb-bankrob:server:remove:card')
AddEventHandler('qb-bankrob:server:remove:card', function()
local Player = QBCore.Functions.GetPlayer(source)
 Player.Functions.RemoveItem('green-card', 1)
 TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['green-card'], "remove")
end)

RegisterServerEvent('blijf:uit:mijn:scripts:rewards')
AddEventHandler('blijf:uit:mijn:scripts:rewards', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local RandomWaarde = math.random(1,100)
    if RandomWaarde >= 1 and RandomWaarde <= 30 then
    local info = {worth = math.random(7500, 12500)}
    Player.Functions.AddItem('markedbills', 1, false, info)
    TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
    TriggerEvent("qb-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Recieved: **Marked Bills\n**Waarde: **"..info.worth)
    elseif RandomWaarde >= 31 and RandomWaarde <= 50 then
        local AmountGoldStuff = math.random(6,19)
        Player.Functions.AddItem('rolex', AmountGoldStuff)
        TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['rolex'], "add")
    elseif RandomWaarde >= 51 and RandomWaarde <= 80 then 
        local AmountGoldStuff = math.random(6,19)
        Player.Functions.AddItem('goldchain', AmountGoldStuff)
        TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['goldchain'], "add")
        TriggerEvent("qb-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Recieved: **Golden Chain\n**Amount: **"..AmountGoldStuff)
    elseif RandomWaarde == 91 or RandomWaarde == 98 or RandomWaarde == 85 or RandomWaarde == 65 then
        local RandomAmount = math.random(2,6)
        Player.Functions.AddItem('goldbar', RandomAmount)
        TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], "add") 
        TriggerEvent("qb-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Recieved: **Gold Bar\n**Amount: **"..RandomAmount)
    elseif RandomWaarde == 26 or RandomWaarde == 52 then 
        Player.Functions.AddItem('security_card_01', 1)
        TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['security_card_01'], "add") 
        TriggerEvent("qb-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Recieved: **Yellow Card\n**Amount:** 1x")
    end
end)

QBCore.Functions.CreateUseableItem("green-card", function(source, item)
    TriggerClientEvent("qb-truckrob:client:UseCard", source)
end)