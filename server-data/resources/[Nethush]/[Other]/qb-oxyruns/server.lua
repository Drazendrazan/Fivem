QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Oxy Run
RegisterServerEvent('oxydelivery:server')
AddEventHandler('oxydelivery:server', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	
	if Player.Functions.RemoveMoney('cash', Config.StartOxyPayment, "pay-job") then
		TriggerClientEvent("oxydelivery:startDealing", source)
		TriggerClientEvent('chatMessage', source, "Dealer", "normal", "There is a car outside for you. Your pager will be updated with locations shortly")
		TriggerClientEvent('swt_notifications:Infos', src, 'You paid 1500, -')
	else
		TriggerClientEvent('swt_notifications:Infos', src, "You don't have enough cash in your pocket!")   
    end
end)

-- RegisterServerEvent('oxydelivery:receiveBigRewarditem')
-- AddEventHandler('oxydelivery:receiveBigRewarditem', function()
-- end)

RegisterServerEvent('oxydelivery:receiveoxy')
AddEventHandler('oxydelivery:receiveoxy', function()
end)

RegisterServerEvent('oxydelivery:receivemoneyyy')
AddEventHandler('oxydelivery:receivemoneyyy', function()
end)

-- QBCore.Functions.CreateCallback('oxydelivery:server:receiveBigRewarditem', function(source, cb)
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
 
-- 	Player.Functions.AddItem('security_card_03', 1)
--     TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['security_card_03'], "add")
-- end)
 
QBCore.Functions.CreateCallback('oxydelivery:server:receiveOxey', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PurpleCardOxy = math.random(1, 1000)
 
    local price = math.random(250, 300)
	Player.Functions.AddMoney("cash", price, "oxy-money")

    Player.Functions.AddItem('painkillers', 1)
    TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['painkillers'], "add")

    if PurpleCardOxy == 1 then
        Player.Functions.AddItem('security_card_03', 1)
        TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['security_card_03'], "add")
    end
end)
 
QBCore.Functions.CreateCallback('oxydelivery:server:receiveMoney', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PurpleCardMoney = math.random(1, 1000)
    
    local price = math.random(300, 350)
    Player.Functions.AddMoney("cash", price, "oxy-money")

    if PurpleCardMoney == 1 then
        Player.Functions.AddItem('security_card_03', 1)
        TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items['security_card_03'], "add")
    end
end)

RegisterServerEvent('qb-oxyruns:server:callCops')
AddEventHandler('qb-oxyruns:server:callCops', function(streetLabel, coords)
    local msg = "There is a suspicious situation on it "..streetLabel..", possible Oxy trade."
    local alertData = {
        title = "Oxy Runs",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg
    }
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("qb-oxyruns:client:robberyCall", Player.PlayerData.source, msg, streetLabel, coords)
                TriggerClientEvent("qb-phone:client:addPoliceAlert", Player.PlayerData.source, alertData)
            end
        end
	end
end)