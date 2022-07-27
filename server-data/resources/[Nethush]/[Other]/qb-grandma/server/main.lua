QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('osm-grandma:server:Charge')
AddEventHandler('osm-grandma:server:Charge', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if TriggerClientEvent("swt_notifications:Infos", src, "God Bless You!") then
        Player.Functions.RemoveMoney('cash', 2000)
    end
end)