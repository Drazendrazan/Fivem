QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

RegisterServerEvent('nethush-alerts:server:send:alert')
AddEventHandler('nethush-alerts:server:send:alert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('nethush-alerts:client:send:alert', -1, data, forBoth)
end)