QBCore = nil
TriggerEvent(Config.CoreName..':GetObject', function(obj) QBCore = obj end)



RegisterServerEvent('qb-robparking:server:1I1i01I1')
AddEventHandler('qb-robparking:server:1I1i01I1', function(count)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    print("haha")
    local data = {
        worth = math.random(Config.MoneyMin,Config.MoneyMax)
    }

    xPlayer.Functions.AddItem('markedbills', 1, false, data)
    TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items["markedbills"], 'add')
    --TriggerClientEvent(Config.CoreName..':Notify', src, 'Recieved cash from the bank truck: $' ..data.worth)
    TriggerClientEvent("swt_notifications:Info",src,"Bank",'Recieved cash from the bank truck: $' ..data.worth,"top-right",3000,true)
    TriggerClientEvent("InteractSound_CL:PlayOnOne", "juntos", 0.25)

end)

