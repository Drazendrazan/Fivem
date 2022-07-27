QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterNetEvent("hell_mushroomfarmer:sell")
AddEventHandler("hell_mushroomfarmer:sell", function()
    local _source = source
    local xPlayer  = QBCore.Functions.GetPlayer(_source)
    local money = math.random(80,500)
    xPlayer.Functions.AddMoney("cash", money)
      xPlayer.addMoney(money)
      TriggerClientEvent("swt_notifications:Icon",_source,"' ..money.. '$ Dollers Made.","top-right",5500,"blue-10","white",true,"mdi-earth")

end)