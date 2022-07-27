RegisterServerEvent('json:dataStructure')
AddEventHandler('json:dataStructure', function(data)
    print(json.encode(data))
end)

RegisterServerEvent('nethush-radialmenu:trunk:server:Door')
AddEventHandler('nethush-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('nethush-radialmenu:trunk:client:Door', -1, plate, door, open)
end)