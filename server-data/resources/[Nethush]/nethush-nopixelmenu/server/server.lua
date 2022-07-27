QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback('nethush-nopixelmenu:server:HasItem', function(source, cb, itemName)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
      local Item = Player.Functions.GetItemByName(itemName)
        if Item ~= nil then
			cb(true)
        else
			cb(false)
        end
	end
end)