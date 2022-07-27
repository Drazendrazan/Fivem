local CurrentDivingArea = math.random(1, #QBDiving.Locations)

QBCore.Functions.CreateCallback('cash-divingjob:server:GetDivingConfig', function(source, cb)
    cb(QBDiving.Locations, CurrentDivingArea)
end)

RegisterServerEvent('cash-divingjob:server:TakeCoral')
AddEventHandler('cash-divingjob:server:TakeCoral', function(Area, Coral, Bool)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CoralType = math.random(1, #QBDiving.CoralTypes)
    local Amount = math.random(1, QBDiving.CoralTypes[CoralType].maxAmount)
    local ItemData = QBCore.Shared.Items[QBDiving.CoralTypes[CoralType].item]

    if Amount > 1 then
        for i = 1, Amount, 1 do
            Player.Functions.AddItem(ItemData["name"], 1)
            TriggerClientEvent('nethush-inventory:client:ItemBox', src, ItemData, "add")
            Citizen.Wait(250)
        end
    else
        Player.Functions.AddItem(ItemData["name"], Amount)
        TriggerClientEvent('nethush-inventory:client:ItemBox', src, ItemData, "add")
    end

    if (QBDiving.Locations[Area].TotalCoral - 1) == 0 then
        for k, v in pairs(QBDiving.Locations[CurrentDivingArea].coords.Coral) do
            v.PickedUp = false
        end
        QBDiving.Locations[CurrentDivingArea].TotalCoral = QBDiving.Locations[CurrentDivingArea].DefaultCoral

        local newLocation = math.random(1, #QBDiving.Locations)
        while (newLocation == CurrentDivingArea) do
            Citizen.Wait(3)
            newLocation = math.random(1, #QBDiving.Locations)
        end
        CurrentDivingArea = newLocation
        
        TriggerClientEvent('cash-divingjob:client:NewLocations', -1)
    else
        QBDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
        QBDiving.Locations[Area].TotalCoral = QBDiving.Locations[Area].TotalCoral - 1
    end

    TriggerClientEvent('cash-divingjob:server:UpdateCoral', -1, Area, Coral, Bool)
end)

RegisterServerEvent('cash-divingjob:server:RemoveGear')
AddEventHandler('cash-divingjob:server:RemoveGear', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("diving_gear", 1)
    TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items["diving_gear"], "remove")
end)

RegisterServerEvent('cash-divingjob:server:GiveBackGear')
AddEventHandler('cash-divingjob:server:GiveBackGear', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    Player.Functions.AddItem("diving_gear", 1)
    TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items["diving_gear"], "add")
end)