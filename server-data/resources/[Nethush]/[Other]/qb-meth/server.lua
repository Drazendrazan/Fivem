print("Meth car got loaded, Modified by NethushaGuru")
	
--ESX = nil
QBCore = nil
--TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('qb-methcar:start')
AddEventHandler('qb-methcar:start', function()
	-- local _source = source
	-- local xPlayer = ESX.GetPlayerFromId(_source)
	local src   = source
    local Player = QBCore.Functions.GetPlayer(src)
	
	-- if xPlayer.getInventoryItem('acetone').count >= 5 and xPlayer.getInventoryItem('lithium').count >= 2 and xPlayer.getInventoryItem('methlab').count >= 1 then
	-- 	if xPlayer.getInventoryItem('meth').count >= 30 then
	-- 			TriggerClientEvent('qb-methcar:notify', _source, "~r~~h~You cant hold more meth")
	-- 	else
	-- 		TriggerClientEvent('qb-methcar:startprod', _source)
	-- 		xPlayer.removeInventoryItem('acetone', 5)
	-- 		xPlayer.removeInventoryItem('lithium', 2)
	-- 	end	
	-- else
	-- 	--TriggerClientEvent('qb-methcar:notify', _source, "~r~~h~Not enough supplies to start producing Meth")
	-- end	

	if Player.Functions.GetItemByName('acetone') and Player.Functions.GetItemByName('lithium') and Player.Functions.GetItemByName('methlab') and Player.Functions.GetItemByName('lsd') then
		TriggerClientEvent('qb-methcar:startprod', src)
		Player.Functions.RemoveItem('acetone', 1)----change this
	    Player.Functions.RemoveItem('lsd', 1)-----change this
	    Player.Functions.RemoveItem('lithium', 1)-----change this
	   TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['lsd'], "remove")
	   TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['acetone'], "remove")
	   TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['lithium'], "remove")
	   TriggerClientEvent("swt_notifications:Infos", src, "Meth production started sucessfully")
	else
		TriggerClientEvent("swt_notifications:Infos", src, "You\'re either missing Lsd, Acetone, Lithium Battries or Methlab.")
	end
end)


RegisterServerEvent('qb-methcar:stopf')
AddEventHandler('qb-methcar:stopf', function(id)
--local _source = source
    local src   = source
	-- local xPlayers = ESX.GetPlayers()
	-- local xPlayer = ESX.GetPlayerFromId(_source)
    local Player = QBCore.Functions.GetPlayer(src)
    local xPlayers   = QBCore.Functions.GetPlayers()
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('qb-methcar:stopfreeze', xPlayers[i], id)
	end	
end)

RegisterServerEvent('qb-methcar:make')
AddEventHandler('qb-methcar:make', function(posx,posy,posz)
	-- local _source = source
	-- local xPlayer = ESX.GetPlayerFromId(_source)
	local src   = source
    local Player = QBCore.Functions.GetPlayer(src)
	local xPlayers   = QBCore.Functions.GetPlayers()
	
	-- if xPlayer.getInventoryItem('methlab').count >= 1 then
	-- local xPlayers   = QBCore.Functions.GetPlayers()
	
		-- local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			TriggerClientEvent('qb-methcar:smoke',xPlayers[i],posx,posy,posz, 'a') 
		end
		
	-- else
		-- TriggerClientEvent('qb-methcar:stop', _source)
		-- TriggerClientEvent('qb-methcar:stop', src)
	-- end
end)

RegisterServerEvent('qb-methcar:finish')
AddEventHandler('qb-methcar:finish', function(qualtiy)
	-- local _source = source
	-- local xPlayer = ESX.GetPlayerFromId(_source)
	local src   = source
    local Player = QBCore.Functions.GetPlayer(src)
	print(qualtiy)
	local rnd = math.random(-5, 5)
	--TriggerEvent('KLevels:addXP', _source, 20)
	TriggerEvent('KLevels:addXP', src, 20)
	--xPlayer.addInventoryItem('meth', math.floor(qualtiy / 2) + rnd)
	Player.Functions.AddItem('meth', math.floor(qualtiy / 2) + rnd)
	TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['meth'], "add")
	
end)

RegisterServerEvent('qb-methcar:blow')
AddEventHandler('qb-methcar:blow', function(posx, posy, posz)
	-- local _source = source
	-- local xPlayers = ESX.GetPlayers()
	-- local xPlayer = ESX.GetPlayerFromId(_source)
	local src   = source
    local Player = QBCore.Functions.GetPlayer(src)
    local xPlayers   = QBCore.Functions.GetPlayers()
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('qb-methcar:blowup', xPlayers[i],posx, posy, posz)
	end
	--xPlayer.removeInventoryItem('methlab', 1)
	Player.Functions.RemoveItem('methlab', 1)
	TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['methlab'], "remove")
end)

