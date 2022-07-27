QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('nethush-assets:server:tackle:player')
AddEventHandler('nethush-assets:server:tackle:player', function(playerId)
    TriggerClientEvent("nethush-assets:client:get:tackeled", playerId)
end)

RegisterServerEvent('nethush-assets:server:display:text')
AddEventHandler('nethush-assets:server:display:text', function(Text)
	TriggerClientEvent('nethush-assets:client:me:show', -1, Text, source)
end)

RegisterServerEvent('nethush-assets:server:drop')
AddEventHandler('nethush-assets:server:drop', function()
	if not QBCore.Functions.HasPermission(source, 'admin') then
		TriggerEvent("qb-log:server:SendLog", "anticheat", "Nui Devtools", "red", "**".. GetPlayerName(source).. "** Tried opening devtools.")
		DropPlayer(source, 'Do not open DevTools.')
	end
end)
