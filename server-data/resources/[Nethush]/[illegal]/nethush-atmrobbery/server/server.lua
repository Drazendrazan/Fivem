local QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Callback to get hacker device count:
QBCore.Functions.CreateCallback("osm-atmrobbery:getHackerDevice",function(source,cb)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if xPlayer.Functions.GetItemByName("advancedscrewdriver") and xPlayer.Functions.GetItemByName("drill") then
		cb(true)
	else
		cb(false)
	--	TriggerClientEvent('swt_notifications:Infos', source, "You need an Advancedscrewdriver and a Drill to proceed.")
		TriggerClientEvent("swt_notifications:Info",source,"SLMC System","You need an Advancedscrewdriver and a Drill to proceed.","right",2000,true)

	end
end)

RegisterServerEvent('itemsil')
AddEventHandler('itemsil', function()
local xPlayer = QBCore.Functions.GetPlayer(source)
	xPlayer.Functions.RemoveItem('drill', 1)
end)

QBCore.Functions.CreateUseableItem('advancedscrewdriver', function(source)
	TriggerClientEvent('atm:item', source)
end)


-- Event to reward after successfull robbery

RegisterServerEvent("osm-atmrobbery:success")
AddEventHandler("osm-atmrobbery:success",function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
    local reward = math.random(Config.MinReward,Config.MaxReward)
		xPlayer.Functions.AddMoney(Config.RewardAccount, tonumber(reward))
		TriggerClientEvent("Drilling:Stop")
--TriggerClientEvent("swt_notifications:Infos",source,"Succesful Robbery | You earn't $"..reward.. " !")
		TriggerClientEvent("swt_notifications:Info",source,"Bank","Succesful Robbery | You earn't $"..reward.. " !","top-right",3000,true)

end)

---

cooldowntime = Config.Cooldown 

undercd = false

RegisterServerEvent('osm:CooldownServer')
AddEventHandler('osm:CooldownServer', function(bool)
    undercd = bool
	if bool then 
		cooldown()
	end	 
end)

RegisterServerEvent('osm:CooldownNotify')
AddEventHandler('osm:CooldownNotify', function()
	TriggerClientEvent("swt_notifications:Infos",source,"An ATM Robbery has happened Recently. Please Wait "..cooldowntime.." Minutes!")
end)

function cooldown()

	while true do 
	Citizen.Wait(60000)

	cooldowntime = cooldowntime - 1 

	if cooldowntime <= 0 then
		undercd = false
		break
	end

end
end

QBCore.Functions.CreateCallback("osm:GetCooldown",function(source,cb)
	cb(undercd)
end)
