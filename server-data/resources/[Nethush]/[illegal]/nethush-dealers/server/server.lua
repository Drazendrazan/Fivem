QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback("qb-dealers:server:get:config", function(source, cb)
    cb(Config.Dealers)
end)

RegisterServerEvent('qb-dealers:server:update:dealer:items')
AddEventHandler('qb-dealers:server:update:dealer:items', function(ItemData, Amount, Dealer)
    Config.Dealers[Dealer]["Products"][ItemData.slot].amount = Config.Dealers[Dealer]["Products"][ItemData.slot].amount - Amount
    TriggerClientEvent('qb-dealers:client:set:dealer:items', -1, ItemData, Amount, Dealer)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        Config.Dealers[2]['Products'][1].amount = Config.Dealers[2]['Products'][1].resetamount
        Config.Dealers[2]['Products'][2].amount = Config.Dealers[2]['Products'][2].resetamount
        Config.Dealers[3]['Products'][1].amount = Config.Dealers[3]['Products'][1].resetamount
        Config.Dealers[3]['Products'][2].amount = Config.Dealers[3]['Products'][2].resetamount
        --Config.Dealers[4]['Products'][1].amount = Config.Dealers[4]['Products'][1].resetamount
        --Config.Dealers[4]['Products'][2].amount = Config.Dealers[4]['Products'][2].resetamount
        TriggerClientEvent('qb-dealers:client:reset:items', -1)
        Citizen.Wait((1000 * 60) * 120)
    end
end)