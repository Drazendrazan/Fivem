QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('nethush-mine:getItem')
AddEventHandler('nethush-mine:getItem', function()
	local xPlayer, randomItem = QBCore.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
	
	if math.random(0, 100) <= Config.ChanceToGetItem then
		local Item = xPlayer.Functions.GetItemByName(randomItem)
		if Item == nil then
			xPlayer.Functions.AddItem(randomItem, 1)
            TriggerClientEvent('nethush-inventory:client:ItemBox', xPlayer.PlayerData.source, QBCore.Shared.Items[randomItem], 'add')
		else	
		if Item.amount < 35 then
        
        xPlayer.Functions.AddItem(randomItem, 1)
        TriggerClientEvent('nethush-inventory:client:ItemBox', xPlayer.PlayerData.source, QBCore.Shared.Items[randomItem], 'add')
		else
			TriggerClientEvent('swt_notifications:Infos', source, 'Inventory full')  
		end
	    end
    end
end)



RegisterServerEvent('nethush-mine:sell')
AddEventHandler('nethush-mine:sell', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
if Player ~= nil then

    if Player.Functions.RemoveItem("steel", 1) then
        TriggerClientEvent("swt_notifications:Infos", src, "You sold 1x Steel")
        Player.Functions.AddMoney("cash", Config.pricexd.steel)
        Citizen.Wait(200)
        TriggerClientEvent('nethush-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['steel'], 'remove')
    else
        TriggerClientEvent("swt_notifications:Infos", src, "You have nothing to offer.")
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("iron", 1) then
        TriggerClientEvent("swt_notifications:Infos", src, "You sold 1x Iron")
        Player.Functions.AddMoney("cash", Config.pricexd.iron)
        Citizen.Wait(200)
        TriggerClientEvent('nethush-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['iron'], 'remove')
    else
        TriggerClientEvent("swt_notifications:Infos", src, "You have nothing to offer.")
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("copper", 1) then
        TriggerClientEvent("swt_notifications:Infos", src, "You sold 1x Copper")
        Player.Functions.AddMoney("cash", Config.pricexd.copper)
        Citizen.Wait(200)
        TriggerClientEvent('nethush-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['copper'], 'remove')
    else
        TriggerClientEvent("swt_notifications:Infos", src, "You have nothing to offer.")
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("diamond", 1) then
        TriggerClientEvent("swt_notifications:Infos", src, "You sold 1x Diamond")
        Player.Functions.AddMoney("cash", Config.pricexd.diamond)
        Citizen.Wait(200)
        TriggerClientEvent('nethush-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['diamond'], 'remove')
    else
        TriggerClientEvent("swt_notifications:Infos", src, "You have nothing to offer.")
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("emerald", 1) then
        TriggerClientEvent("swt_notifications:Infos", src, "You sold 1x Emerald")
        Player.Functions.AddMoney("cash", Config.pricexd.emerald)
        Citizen.Wait(200)
        TriggerClientEvent('nethush-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['emerald'], 'remove')
    else
        TriggerClientEvent("swt_notifications:Infos", src, "You have nothing to offer.")
    end
end
end)
