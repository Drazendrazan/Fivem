QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback('nethush-stores:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('nethush-stores:server:update:store:items')
AddEventHandler('nethush-stores:server:update:store:items', function(Shop, ItemData, Amount)
    Config.Shops[Shop]["Product"][ItemData.slot].amount = Config.Shops[Shop]["Product"][ItemData.slot].amount - Amount
    TriggerClientEvent('nethush-stores:client:set:store:items', -1, ItemData, Amount, Shop)
end)