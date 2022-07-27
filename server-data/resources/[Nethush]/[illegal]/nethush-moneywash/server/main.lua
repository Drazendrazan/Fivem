QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local ItemList = {
    ["markedbills"] = "markedbills"
}

RegisterServerEvent('nethush-moneywash:server:getmoney')
AddEventHandler('nethush-moneywash:server:getmoney', function()
    local src = source
	local total_worth = 0
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local markedbills = Player.Functions.GetItemByName('markedbills')
	for itemkey, item in pairs(Player.PlayerData.items) do
		if type(item.info) ~= 'string' and tonumber(item.info.worth) then
			total_worth = total_worth + tonumber(item.info.worth)
	if Player.PlayerData.items ~= nil then
        if markedbills ~= nil then
            if markedbills.amount >= 1 then
                Player.Functions.RemoveItem("markedbills", 1, false)
                TriggerClientEvent('nethush-inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "remove")
         
                Player.Functions.AddMoney("cash", total_worth)
				TriggerClientEvent('swt_notifications:Infos', src, "You washed "..total_worth.." Marked Money!")             
				break
                    else
                        TriggerClientEvent('swt_notifications:Infos', src, "You do not have marked money")     
                    end              
            else
                TriggerClientEvent('swt_notifications:Infos', src, "You do not have marked money")               
            end
        end
	end
end
end)


RegisterServerEvent('nethush-moneywash:server:checkmoney')
AddEventHandler('nethush-moneywash:server:checkmoney', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local markedbills = Player.Functions.GetItemByName('markedbills')

    if Player.PlayerData.items ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if markedbills ~= nil then
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    if Player.PlayerData.items[k].name == "markedbills" and Player.PlayerData.items[k].amount >= 1 then 
                        local amount = Player.PlayerData.items[k].amount
					    TriggerClientEvent("nethush-moneywash:client:WashProggress", src)
                        break
                    else
                        TriggerClientEvent('swt_notifications:Infos', src, "You do not have marked money")
                        break
                    end
                end
            else
                TriggerClientEvent('swt_notifications:Infos', src, "You do not have marked money")
                break

            end
        end
    end
end)

