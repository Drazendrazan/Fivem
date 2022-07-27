QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local VehicleNitrous = {}

RegisterServerEvent('tackle:server:TacklePlayer')
AddEventHandler('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent("tackle:client:GetTackled", playerId)
end)

QBCore.Functions.CreateCallback('nos:GetNosLoadedVehs', function(source, cb)
    cb(VehicleNitrous)
end)

QBCore.Commands.Add("id", "What is my id?", {}, false, function(source, args)
    TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "ID: "..source)
end)

QBCore.Functions.CreateUseableItem("harness", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
end)

RegisterServerEvent('equip:harness')
AddEventHandler('equip:harness', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.items[item.slot].info.uses - 1 == 0 then
        TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['harness'], "remove")
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses = Player.PlayerData.items[item.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterServerEvent('seatbelt:DoHarnessDamage')
AddEventHandler('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses = Player.PlayerData.items[data.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)



QBCore.Functions.CreateCallback("Kingofnethush:armor",function(source,cb)
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local Item = xPlayer.Functions.GetItemByName("armor")
	if Item == nil then
		
		cb(false)
		
		--TriggerClientEvent('swt_notifications:Infos', source, 'Nice Try Bro') 
        TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'Nice Try Bro',"right",8000,true)
        TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'You Have Been Reported',"right",8000,true)


	else
		if Item.amount >= 1 then
			cb(true)
		else
			cb(false)
			
            TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'Nice Try Bro',"right",8000,true)
            TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'You Have Been Reported',"right",8000,true)

		end



	end

end)

QBCore.Functions.CreateCallback("Kingofnethush:harmor",function(source,cb)
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local Item = xPlayer.Functions.GetItemByName("heavyarmor")
	if Item == nil then
		
		cb(false)
		
		--TriggerClientEvent('swt_notifications:Infos', source, 'Nice Try Bro') 
        TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'Nice Try Bro',"right",8000,true)
        TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'You Have Been Reported',"right",8000,true)


	else
		if Item.amount >= 1 then
			cb(true)
		else
			cb(false)
			
            TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'Nice Try Bro',"right",8000,true)
            TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'You Have Been Reported',"right",8000,true)

		end



	end

end)