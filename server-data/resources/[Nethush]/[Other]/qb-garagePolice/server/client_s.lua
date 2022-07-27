-------------------------
--Written by CODERC-SLO
-------------------------
 --- Edited By Kingofnethush
QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local prezzo = 10


RegisterServerEvent('qb-diving:server:generateAuto')
AddEventHandler('qb-diving:server:generateAuto', function(boatModel, BerthId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local plate = "RENT"..math.random(1111, 9999)
    Player.Functions.RemoveItem('carking', 1)----change this
    TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['carking'], "remove")
	TriggerClientEvent('qb-diving:client:Auto', src, boatModel, plate)
end)

RegisterServerEvent('qb-diving:server:parkinCard')
AddEventHandler('qb-diving:server:parkinCard', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerMoney = {
        cash = Player.PlayerData.money.cash,
        bank = Player.PlayerData.money.bank,
    }
    local missingMoney = 0
  
    if PlayerMoney.cash >= prezzo then
        Player.Functions.RemoveMoney('cash', prezzo, "carking")
        Player.Functions.AddItem('carking', 1)-----change this
        TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['carking'], "add")
       
    elseif PlayerMoney.bank >= prezzo then
        Player.Functions.RemoveMoney('bank', prezzo, "carking")
        Player.Functions.AddItem('carking', 1)-----change this
        TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['carking'], "add")
    else
        if PlayerMoney.bank > PlayerMoney.cash then
            missingMoney = (prezzo - PlayerMoney.bank)
        else
            missingMoney = (prezzo - PlayerMoney.cash)
        end
        TriggerClientEvent('swt_notifications:Infos', src, 'You do not have enough money, you are missing $'..missingMoney)
    end
end)

