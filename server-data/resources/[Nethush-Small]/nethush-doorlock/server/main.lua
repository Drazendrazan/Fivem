QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback("nethush-doorlock:server:get:config", function(source, cb)
    cb(Config)
  end)

RegisterServerEvent('nethush-doorlock:server:updateState')
AddEventHandler('nethush-doorlock:server:updateState', function(doorID, state)
 Config.Doors[doorID]['Locked'] = state
 TriggerClientEvent('nethush-doorlock:client:setState', -1, doorID, state)
end)