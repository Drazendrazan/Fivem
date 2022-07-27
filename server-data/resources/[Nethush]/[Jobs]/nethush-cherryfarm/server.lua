QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


RegisterNetEvent("hell_cherryfarmer:sell")
AddEventHandler("hell_cherryfarmer:sell", function()
    local _source = source
    local xPlayer  = QBCore.Functions.GetPlayer(_source)
    local money = 1000
    xPlayer.Functions.AddMoney("cash", money)
    TriggerClientEvent("swt_notifications:Icon",_source,"You got 1000$","top-right",5500,"blue-10","white",true,"mdi-earth")
end)