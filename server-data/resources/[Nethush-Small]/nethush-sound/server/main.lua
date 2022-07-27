RegisterServerEvent('nethush-sound:server:play')
AddEventHandler('nethush-sound:server:play', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('nethush-sound:client:play', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('nethush-sound:server:play:source')
AddEventHandler('nethush-sound:server:play:source', function(soundFile, soundVolume)
    TriggerClientEvent('nethush-sound:client:play', source, soundFile, soundVolume)
end)

RegisterServerEvent('nethush-sound:server:play:distance')
AddEventHandler('nethush-sound:server:play:distance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('nethush-sound:client:play:distance', -1, source, maxDistance, soundFile, soundVolume)
end)