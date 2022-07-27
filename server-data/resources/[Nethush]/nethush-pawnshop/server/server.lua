local TotalGoldBars = 0

QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateCallback('nethush-pawnshop:server:has:gold', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.GetItemByName("goldchain") ~= nil or Player.Functions.GetItemByName("rolex") or Player.Functions.GetItemByName("10kgoldchain") or Player.Functions.GetItemByName("diamond_ring") ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('nethush-pawnshop:server:sell:gold:items')
AddEventHandler('nethush-pawnshop:server:sell:gold:items', function()
  local Player = QBCore.Functions.GetPlayer(source)
  local Price = 0
  if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
     for k, v in pairs(Player.PlayerData.items) do
         if Config.ItemPrices[Player.PlayerData.items[k].name] ~= nil then
            Price = Price + (Config.ItemPrices[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
            Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
         end
     end
     if Price > 0 then
       Player.Functions.AddMoney("cash", Price, "sold-pawn-items")
       TriggerClientEvent('swt_notifications:Infos', source, "You sold your gold")
     end
  end
end)

RegisterServerEvent('nethush-pawnshop:server:sell:gold:bars')
AddEventHandler('nethush-pawnshop:server:sell:gold:bars', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local GoldItem = Player.Functions.GetItemByName("goldbar")
    Player.Functions.RemoveItem('goldbar', GoldItem.amount)
    TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['goldbar'], "remove")
    Player.Functions.AddMoney("cash", math.random(3500, 5000) * GoldItem.amount, "sold-pawn-items")
end)

RegisterServerEvent('nethush-pawnshop:server:smelt:gold')
AddEventHandler('nethush-pawnshop:server:smelt:gold', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Config.SmeltItems[Player.PlayerData.items[k].name] ~= nil then
               local ItemAmount = (Player.PlayerData.items[k].amount / Config.SmeltItems[Player.PlayerData.items[k].name])
                if ItemAmount >= 1 then
                    ItemAmount = math.ceil(Player.PlayerData.items[k].amount / Config.SmeltItems[Player.PlayerData.items[k].name])
                    if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
                        TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items[Player.PlayerData.items[k].name], "remove")
                        TotalGoldBars = TotalGoldBars + ItemAmount
                        if TotalGoldBars > 0 then
                          TriggerClientEvent('nethush-pawnshop:client:start:process', -1)
                        end
                    end
                end
            end
        end
     end
end)

 RegisterServerEvent('nethush-pawnshop:server:redeem:gold:bars')
 AddEventHandler('nethush-pawnshop:server:redeem:gold:bars', function()
     local Player = QBCore.Functions.GetPlayer(source)
     Player.Functions.AddItem("goldbar", TotalGoldBars)
     TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items["goldbar"], "add")
     TriggerClientEvent('nethush-pawnshop:server:reset:smelter', -1)
 end)

--[[RegisterServerEvent('nethush-pawnshop:server:redeem:gold:bars')
AddEventHandler('nethush-pawnshop:server:redeem:gold:bars', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if TotalGoldBars > 0 then
        if Player.Functions.AddItem("goldbar", TotalGoldBars) then
            TotalGoldBars = 0
            TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items["goldbar"], "add")
            TriggerClientEvent('nethush-pawnshop:server:reset:smelter', -1)
        end
    end
end)]]