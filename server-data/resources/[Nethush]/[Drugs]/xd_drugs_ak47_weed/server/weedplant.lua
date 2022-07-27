QBCore = nil
local itemcraft = 'black_money'
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('xd_drugs_weed:pickedUpweed_ak47_seed') --hero
AddEventHandler('xd_drugs_weed:pickedUpweed_ak47_seed', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	    if 	TriggerClientEvent("swt_notifications:Infos", src, "Picked up some weed_ak47_seed!!") then
		  Player.Functions.AddItem('weed_ak47_seed', 1) ---- change this shit 
		  TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['weed_ak47_seed'], "add")
	    end
end)

RegisterServerEvent('xd_drugs_weed:processweed')
AddEventHandler('xd_drugs_weed:processweed', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if Player.Functions.GetItemByName('weed_ak47_seed') and Player.Functions.GetItemByName('empty_weed_bag') then
		local chance = math.random(1, 10)
		if chance == 1 or chance == 2 or chance == 9 or chance == 4 or chance == 10 or chance == 6 or chance == 7 or chance == 8 then
			Player.Functions.RemoveItem('weed_ak47_seed', 1)----change this
			Player.Functions.RemoveItem('empty_weed_bag', 1)----change this
			Player.Functions.AddItem('weed_ak47', 1)-----change this
			TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['weed_ak47_seed'], "remove")
			TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['empty_weed_bag'], "remove")
			TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['weed_ak47'], "add")
			TriggerClientEvent('swt_notifications:Infos', src, 'weed_ak47_seed Processed successfully')  
		else
			Player.Functions.RemoveItem('weed_ak47_seed', 1)----change this
			Player.Functions.RemoveItem('empty_weed_bag', 1)----change this
			TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['weed_ak47_seed'], "remove")
			TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['empty_weed_bag'], "remove")
			TriggerClientEvent('swt_notifications:Infos', src, 'You messed up and got nothing') 
		end 
	else
		TriggerClientEvent('swt_notifications:Infos', src, 'You don\'t have the right items') 
	end
end)

--selldrug ok

RegisterServerEvent('xd_drugs_weed:selld')
AddEventHandler('xd_drugs_weed:selld', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Item = Player.Functions.GetItemByName('weed_ak47')
   
	
      
	
	if Item.amount >= 1 then
	if Player.Functions.GetItemByName('weed_ak47') then
		local chance2 = math.random(1, 8)
		if chance2 == 1 or chance2 == 2 or chance2 == 9 or chance2 == 4 or chance2 == 10 or chance2 == 6 or chance2 == 7 or chance2 == 8 then
			Player.Functions.RemoveItem('weed_ak47', 1)----change this
			TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['weed_ak47'], "remove")
			Player.Functions.AddMoney("cash", Config.Pricesell, "sold-pawn-items")
			TriggerClientEvent('swt_notifications:Infos', src, 'you sold to the pusher')  
			--Player.Functions.AddItem(itemcraft, Config.Pricesell)
			--TriggerClientEvent("nethush-inventory:client:ItemBox", src, QBCore.Shared.Items[itemcraft], "add")

		else
			--Player.Functions.RemoveItem('weed_ak47_seed', 1)----change this
			--Player.Functions.RemoveItem('empty_weed_bag', 1)----change this
			--TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['weed_ak47_seed'], "remove")
			--TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['empty_weed_bag'], "remove")
			--TriggerClientEvent('swt_notifications:Infos', src, 'You messed up and got nothing') 
		end 
	else
		TriggerClientEvent('swt_notifications:Infos', src, 'You don\'t have the right items') 
	end
else
	TriggerClientEvent('swt_notifications:Infos', src, 'You don\'t have the right items') 
	
end
end)



function CancelProcessing(playerId)
	if playersProcessingweed_ak47_seed[playerId] then
		ClearTimeout(playersProcessingweed_ak47_seed[playerId])
		playersProcessingweed_ak47_seed[playerId] = nil
	end
end

RegisterServerEvent('xd_drugs_weed:cancelProcessing')
AddEventHandler('xd_drugs_weed:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('QBCore_:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('xd_drugs_weed:onPlayerDeath')
AddEventHandler('xd_drugs_weed:onPlayerDeath', function(data)
	local src = source
	CancelProcessing(src)
end)

QBCore.Functions.CreateCallback('poppy:process', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	 
	if Player.PlayerData.item ~= nil and next(Player.PlayerData.items) ~= nil then
		for k, v in pairs(Player.PlayerData.items) do
		    if Player.Playerdata.items[k] ~= nil then
				if Player.Playerdata.items[k].name == "weed_ak47_seed" then
					cb(true)
			    else
					TriggerClientEvent("swt_notifications:Infos", src, "You do not have any weed_ak47_seed")
					cb(false)
				end
	        end
		end	
	end
end)
