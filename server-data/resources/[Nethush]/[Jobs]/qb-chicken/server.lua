QBCore= nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore= obj end)

RegisterServerEvent('og-chickenjob:getNewChicken')
AddEventHandler('og-chickenjob:getNewChicken', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent("swt_notifications:Infos", src, "You Received 3 Alive chicken!") then
          Player.Functions.AddItem('alivechicken', 3)
          TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['alivechicken'], "add")
      end
end)

RegisterServerEvent('og-chickenjob:startChicken')
AddEventHandler('og-chickenjob:startChicken', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

      if TriggerClientEvent("swt_notifications:Infos", src, "Lets Catch The Chicken Dumbass!") then
        -- Player.Functions.RemoveMoney('cash', 500)
          
      end
end)

RegisterServerEvent('og-chickenjob:getcutChicken')
AddEventHandler('og-chickenjob:getcutChicken', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent("swt_notifications:Infos", src, "Well! You slaughtered chicken.") then
          Player.Functions.RemoveItem('alivechicken', 1)
          Player.Functions.AddItem('slaughteredchicken', 1)
          TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['alivechicken'], "remove")
          TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['slaughteredchicken'], "add")
      end
end)

RegisterServerEvent('og-chickenjob:getpackedChicken')
AddEventHandler('og-chickenjob:getpackedChicken', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent("swt_notifications:Infos", src, "You Packed Slaughtered chicken .") then
          Player.Functions.RemoveItem('slaughteredchicken', 1)
          Player.Functions.AddItem('packedchicken', 1)
          TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['slaughteredchicken'], "remove")
          TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['packedchicken'], "add")
      end
end)


local ItemList = {
    ["packedchicken"] = math.random(450, 650),
}

RegisterServerEvent('og-chickenjob:sell')
AddEventHandler('og-chickenjob:sell', function()
    local src = source
    local price = 0
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-items")
        TriggerClientEvent('swt_notifications:Infos', src, "You have sold your items")
    else
        TriggerClientEvent('swt_notifications:Infos', src, "You don't have items")
    end
end)


