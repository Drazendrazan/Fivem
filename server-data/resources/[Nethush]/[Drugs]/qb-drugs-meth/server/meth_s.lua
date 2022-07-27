QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('xd_drugs:metacid') --hero
AddEventHandler('xd_drugs:metacid', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	    if 	TriggerClientEvent("QBCore:Notify", src, "Picked up hydrochloric acid!!", "Success", 8000) then
		  Player.Functions.AddItem('hydrochloric', 1) ---- 
		  Player.Functions.RemoveItem('hydrochloric_bottle', 1)----
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['hydrochloric'], "add")
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['hydrochloric_bottle'], "remove")
	    end
end)
-- pikup sulfuric
RegisterServerEvent('xd_drugs:metasodium') --hero
AddEventHandler('xd_drugs:metasodium', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	    if 	TriggerClientEvent("QBCore:Notify", src, "Picked up sulfuricacid!!", "Success", 8000) then
		  Player.Functions.AddItem('sulfuricacid', 1) ---- 
		  Player.Functions.RemoveItem('sulfuricacid_bottle', 1)----
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['sulfuricacid'], "add")
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['sulfuricacid_bottle'], "remove")
	    end
end)

--pikup sodium
local itname1 = 'empty_plastic_bag'
local itnamecraft = 'sodiumhydroxide'


RegisterServerEvent('craft:sodium')
AddEventHandler('craft:sodium', function()
   
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    local Item = xPlayer.Functions.GetItemByName(itname1)
    --local Item2 = xPlayer.Functions.GetItemByName(itnamecraft)
    
   
    if Item == nil then
        TriggerClientEvent('QBCore:Notify', source, 'No empty plastic bag', "error", 8000)  
    else
        if Item.amount >= 1 then

           ----------------elimino dal mio inventario---------------------------------------------------------
           xPlayer.Functions.RemoveItem(itname1, 1)
           TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[itname1], "remove")
           
           
        
            ----------------aggiungo al mio inventario-------------------------------------------------------       
           xPlayer.Functions.AddItem(itnamecraft, 1)
	       TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[itnamecraft], "add")
           
        else
            TriggerClientEvent('QBCore:Notify', _source, 'No empty plastic bag', "error", 10000)  
           
        end
    end

end)

RegisterServerEvent('xd_drugs_weed:metprocess')
AddEventHandler('xd_drugs_weed:metprocess', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Item = Player.Functions.GetItemByName('sulfuricacid')
	local Item2 = Player.Functions.GetItemByName('hydrochloric')
	local Item3 = Player.Functions.GetItemByName('sodiumhydroxide')

	if Item.amount >= 1 and Item2.amount >= 1 and Item3.amount >= 1 then
		Player.Functions.RemoveItem('sulfuricacid', 1)---
		Player.Functions.RemoveItem('hydrochloric', 1)---
		Player.Functions.RemoveItem('sodiumhydroxide', 1)--
		Player.Functions.AddItem('blue_meth', 1)--
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['sulfuricacid'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['hydrochloric'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['sodiumhydroxide'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['blue_meth'], "add")
	else
		TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
	end


end)

--selldrug ok

RegisterServerEvent('xd_drugs_weed:sellmeth')
AddEventHandler('xd_drugs_weed:sellmeth', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Item = Player.Functions.GetItemByName('blue_meth')
	
		
	
	
		for i = 1, Item.amount do
		if Item.amount > 0 then
	    if Player.Functions.GetItemByName('blue_meth') then
		local chance2 = math.random(1, 8)
		if chance2 == 1 or chance2 == 2 or chance2 == 3 or chance2 == 4 or chance2 == 5 or chance2 == 6 or chance2 == 7 or chance2 == 8 then
			Player.Functions.RemoveItem('blue_meth', 1)----change this
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['blue_meth'], "remove")
			Player.Functions.AddMoney("cash", Config.Pricesell, "sold-pawn-items")

			TriggerClientEvent('QBCore:Notify', src, 'you sold to the pusher', "success")  
		else
			
		end 
	    else
		TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
	    end
	
       else
	   TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
	
	   end
	end
 
end)



function CancelProcessing(playerId)
	if playersProcessingCannabis[playerId] then
		ClearTimeout(playersProcessingCannabis[playerId])
		playersProcessingCannabis[playerId] = nil
	end
end

RegisterServerEvent('xd_drugs_weed:cancelProcmet')
AddEventHandler('xd_drugs_weed:cancelProcmet', function()
	CancelProcessing(source)
end)

AddEventHandler('QBCore_:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('xd_drugs_weed:onPlayerDeath2d')
AddEventHandler('xd_drugs_weed:onPlayerDeath2d', function(data)
	local src = source
	CancelProcessing(src)
end)

QBCore.Functions.CreateCallback('poppy:process', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	 
	if Player.PlayerData.item ~= nil and next(Player.PlayerData.items) ~= nil then
		for k, v in pairs(Player.PlayerData.items) do
		    if Player.Playerdata.items[k] ~= nil then
				if Player.Playerdata.items[k].name == "lsd" then
					cb(true)
			    else
					TriggerClientEvent("QBCore:Notify", src, "You do not have any lsd process", "error", 10000)
					cb(false)
				end
	        end
		end	
	end
end)