


local QBCore 				= nil

local HeistTimer = {}

TriggerEvent('QBCore:getSharedObject', function(obj) QBCore = obj end)

local QBCore 				= nil


TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local YachtHeist = Config.Yacht

AddEventHandler('QBCore:Client:OnPlayerLoaded', function(source)
    TriggerClientEvent('esx_YachtHeist:load', source, YachtHeist)
end)

RegisterServerEvent('esx_YachtHeist:refreshHeist')
AddEventHandler('esx_YachtHeist:refreshHeist', function()
    TriggerClientEvent('esx_YachtHeist:load', -1, YachtHeist)
end)

RegisterServerEvent('esx_YachtHeist:goonsSpawned')
AddEventHandler('esx_YachtHeist:goonsSpawned', function(id, status)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if YachtHeist[id].pairs ~= nil then
        YachtHeist[YachtHeist[id].pairs].GoonsSpawned=status
        TriggerClientEvent('esx_YachtHeist:statusGoonsSpawnedSend', -1, YachtHeist[id].pairs, status)
    end
    YachtHeist[id].GoonsSpawned=status
    TriggerClientEvent('esx_YachtHeist:statusGoonsSpawnedSend', -1, id, status)
end)

RegisterServerEvent('esx_YachtHeist:JobPlayer')
AddEventHandler('esx_YachtHeist:JobPlayer', function(id, status)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if YachtHeist[id].pairs ~= nil then
        YachtHeist[YachtHeist[id].pairs].JobPlayer=status
        TriggerClientEvent('esx_YachtHeist:statusJobPlayerSend', -1, YachtHeist[id].pairs, status)
    end
    YachtHeist[id].JobPlayer=status
    TriggerClientEvent('esx_YachtHeist:statusJobPlayerSend', -1, id, status)
end)

RegisterServerEvent('esx_YachtHeist:status')
AddEventHandler('esx_YachtHeist:status', function(id, status)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if YachtHeist[id].pairs ~= nil then
        YachtHeist[YachtHeist[id].pairs].started=status
        TriggerClientEvent('esx_YachtHeist:statusSend', -1, YachtHeist[id].pairs, status)
    end
    YachtHeist[id].started=status
    TriggerClientEvent('esx_YachtHeist:statusSend', -1, id, status)
end)

RegisterServerEvent("esx_YachtHeist:success")
AddEventHandler("esx_YachtHeist:success",function()
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	xPlayer.Functions.RemoveItem('advancedlockpick', 1)----change this
	TriggerClientEvent("nethush-inventory:client:ItemBox", src, QBCore.Shared.Items['advancedlockpick'], "remove")
	xPlayer.Functions.RemoveItem('electronickit', 1)----change this
	TriggerClientEvent("nethush-inventory:client:ItemBox", src, QBCore.Shared.Items['electronickit'], "remove")


end)

--QBCore.Functions.CreateCallback("esx_YachtHeist:getRitems",function(source,cb)
--	local src = source
--	local xPlayer = QBCore.Functions.GetPlayer(src)
--	local Items = xPlayer.Functions.GetItemByName("electronickit")
--	if Items == nil then
		
----		cb(false)
		
--		TriggerClientEvent('swt_notifications:Infos', source, 'You dont have items to Hack Yacht!') 
--	else
--		if Items.amount >= 1 then
---			cb(true)
--		else
--			cb(false)
			
--			TriggerClientEvent('swt_notifications:Infos', source, 'You dont have items to Hack Yacht!') 
--		end



--	end

--end)

local policeOnline

QBCore.Functions.CreateCallback("esx_YachtHeist:GetPoliceOnline",function(source,cb)
	local Players = QBCore.Functions.GetPlayers()
	policeOnline = 0
	for i = 1, #Players do
		local xPlayer = QBCore.Functions.GetPlayer(Players[i])
		if xPlayer.PlayerData.job.name == Config.PoliceDBname then
			policeOnline = policeOnline + 1
		end
	end
	if policeOnline >= Config.RequiredPolice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_YachtHeist:statusHack')
AddEventHandler('esx_YachtHeist:statusHack', function(id, state)
    local xPlayer = QBCore.Functions.GetPlayer(source)
	local itemInfo = QBCore.Shared.Items["lockpick"]
    if YachtHeist[id].pairs ~= nil then
        YachtHeist[YachtHeist[id].pairs].keypadHacked=state
        TriggerClientEvent('esx_YachtHeist:statusHackSend', -1, YachtHeist[id].pairs, state)
    end
    YachtHeist[id].keypadHacked=state
    TriggerClientEvent('esx_YachtHeist:statusHackSend', -1, id, state)
end)

RegisterServerEvent('esx_YachtHeist:currentlyHacking')
AddEventHandler('esx_YachtHeist:currentlyHacking', function(id, state)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if YachtHeist[id].pairs ~= nil then
        YachtHeist[YachtHeist[id].pairs].currentlyHacking=state
        TriggerClientEvent('esx_YachtHeist:statusCurrentlyHackingSend', -1, YachtHeist[id].pairs, state)
    end
    YachtHeist[id].currentlyHacking=state
    TriggerClientEvent('esx_YachtHeist:statusCurrentlyHackingSend', -1, id, state)
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local Player = QBCore.Functions.GetPlayer(v)
		if Player ~= nil then 
			if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
				TriggerClientEvent("esx_YachtHeist:client:YachtHesitAlert", v)
			end
		end
	end
end)

-- Trigger message and blip for Police:
RegisterServerEvent('esx_YachtHeist:PoliceNotify')
AddEventHandler('esx_YachtHeist:PoliceNotify', function(targetCoords, streetName)
	TriggerClientEvent('esx_YachtHeist:outlawNotify', -1,string.format(Config.DispatchMessage,streetName))
	TriggerClientEvent('esx_YachtHeist:OutlawBlipSettings', -1, targetCoords)
end)

RegisterServerEvent('esx_YachtHeist:statusVault')
AddEventHandler('esx_YachtHeist:statusVault', function(id, state)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if YachtHeist[id].pairs ~= nil then
        YachtHeist[YachtHeist[id].pairs].vaultLocked=state
        TriggerClientEvent('esx_YachtHeist:statusVaultSend', -1, YachtHeist[id].pairs, state)
    end
    YachtHeist[id].vaultLocked=state
    TriggerClientEvent('esx_YachtHeist:statusVaultSend', -1, id, state)
end)

RegisterServerEvent('esx_YachtHeist:HeistIsBeingReset')
AddEventHandler('esx_YachtHeist:HeistIsBeingReset', function(id)
    local xPlayer = QBCore.Functions.GetPlayer(source)
	-- started:
	YachtHeist[id].started=false
    TriggerClientEvent('esx_YachtHeist:statusSend', -1, id, false)
	Citizen.Wait(1000)
	-- recently robbed:
	TriggerEvent("esx_YachtHeist:heistCooldown")
	YachtHeist[id].recentlyRobbed=true
    TriggerClientEvent('esx_YachtHeist:statusRecentlyRobbed', -1, id, true)
	-- hacked:
    YachtHeist[id].keypadHacked=false
    TriggerClientEvent('esx_YachtHeist:statusHackSend', -1, id, false)
	-- currently hacking:
    YachtHeist[id].currentlyHacking=false
    TriggerClientEvent('esx_YachtHeist:statusCurrentlyHackingSend', -1, id, false)
	-- vault:
    YachtHeist[id].vaultLocked=true
    TriggerClientEvent('esx_YachtHeist:statusVaultSend', -1, id, true)
	-- safe:
    YachtHeist[id].safeRobbed=false
    TriggerClientEvent('esx_YachtHeist:statusSafeRobbedSend', -1, id, false)
	-- drilling:
    YachtHeist[id].drilling=false
    TriggerClientEvent('esx_YachtHeist:statusDrillingSend', -1, id, false)
	-- cashTaken:
    YachtHeist[id].cashTaken=false
    TriggerClientEvent('esx_YachtHeist:statusCashTakenSend', -1, id, false)
	-- stealing:
    YachtHeist[id].stealing=false
    TriggerClientEvent('esx_YachtHeist:statusStealingSend', -1, id, false)
	-- GoonsSpawned:
    YachtHeist[id].GoonsSpawned=false
    TriggerClientEvent('esx_YachtHeist:statusGoonsSpawnedSend', -1, id, false)
	-- JobPlayer:
    YachtHeist[id].JobPlayer=status
    TriggerClientEvent('esx_YachtHeist:statusJobPlayerSend', -1, id, status)
end)

RegisterServerEvent('esx_YachtHeist:drilling')
AddEventHandler('esx_YachtHeist:drilling', function(id, state)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if YachtHeist[id].pairs ~= nil then
        YachtHeist[YachtHeist[id].pairs].drilling=state
        TriggerClientEvent('esx_YachtHeist:statusDrillingSend', -1, YachtHeist[id].pairs, state)
    end
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local Player = QBCore.Functions.GetPlayer(v)
		if Player ~= nil then 
			if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
				TriggerClientEvent("esx_YachtHeist:client:YachtHesitAlert", v)
			end
		end
	end
    YachtHeist[id].drilling=state
    TriggerClientEvent('esx_YachtHeist:statusDrillingSend', -1, id, state)
end)

RegisterServerEvent('esx_YachtHeist:stealing')
AddEventHandler('esx_YachtHeist:stealing', function(id, state)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if YachtHeist[id].pairs ~= nil then
        YachtHeist[YachtHeist[id].pairs].stealing=state
        TriggerClientEvent('esx_YachtHeist:statusStealingSend', -1, YachtHeist[id].pairs, state)
    end
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local Player = QBCore.Functions.GetPlayer(v)
		if Player ~= nil then 
			if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
				TriggerClientEvent("esx_YachtHeist:client:YachtHesitAlert", v)
			end
		end
	end
    YachtHeist[id].stealing=state
    TriggerClientEvent('esx_YachtHeist:statusStealingSend', -1, id, state)
end)

RegisterServerEvent('esx_YachtHeist:cashTaken')
AddEventHandler('esx_YachtHeist:cashTaken', function(id, state)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if YachtHeist[id].pairs ~= nil then
        YachtHeist[YachtHeist[id].pairs].cashTaken=state
        TriggerClientEvent('esx_YachtHeist:statusCashTakenSend', -1, YachtHeist[id].pairs, state)
    end
    YachtHeist[id].cashTaken=state
    TriggerClientEvent('esx_YachtHeist:statusCashTakenSend', -1, id, state)
end)

RegisterServerEvent('esx_YachtHeist:safeRobbed')
AddEventHandler('esx_YachtHeist:safeRobbed', function(id, state)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if YachtHeist[id].pairs ~= nil then
        YachtHeist[YachtHeist[id].pairs].safeRobbed=state
        TriggerClientEvent('esx_YachtHeist:statusSafeRobbedSend', -1, YachtHeist[id].pairs, state)
    end
    YachtHeist[id].safeRobbed=state
    TriggerClientEvent('esx_YachtHeist:statusSafeRobbedSend', -1, id, state)
	
	if policeOnline > 5 then
		policeReward = 5
	else
		policeReward = policeOnline
	end
	local cashReward = 0
	local itemReward = 0
	if Config.RewardBasedOnCops then
		cashReward = ((math.random(Config.SafeMinCash,Config.SafeMaxCash) * 1000) * policeReward)
		itemReward = ((math.random(Config.SafeMinItem,Config.SafeMaxItem) * 10) * policeReward)
	else
		cashReward = (math.random(Config.SafeMinCash,Config.SafeMaxCash) * 1000)
		itemReward = (math.random(Config.SafeMinItem,Config.SafeMaxItem) * 10)
	end
	local amounts = math.random(1, 10)
	local black_item = math.random(100, 200)
	xPlayer.Functions.AddItem(Config.SafeBoxItem, amounts)
	xPlayer.Functions.AddItem('markedbills', black_item)
        xPlayer.Functions.AddItem('hackerphone', 1)
	-- TriggerClientEvent('nethush-inventory:client:ItemBox', Config.SafeBoxItem, "add")
	-- xPlayer.Functions.AddMoney("cash", cashReward, "banknerv")
	-- TriggerClientEvent("esx:showNotification",source,"You received: ~r~$"..cashReward.."~s~ money and ~b~"..itemReward.."x~s~ ~y~Gold Watches~s~")
	TriggerClientEvent('swt_notifications:Infos', source,"You received: "..black_item.." black money and "..itemReward.." Hacker Phone")
end)

QBCore.Functions.CreateCallback("esx_YachtHeist:updateCashTaken",function(source,cb)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if policeOnline > 5 then
		policeReward = 5
	else
		policeReward = policeOnline
	end
	if xPlayer then
		local randomMoney = 0
		if Config.RewardBasedOnCops then
			randomMoney = ((math.random(Config.MinCashTake, Config.MaxCashTake) * 100) * policeReward)
		else
			randomMoney = (math.random(Config.MinCashTake, Config.MaxCashTake) * 100)
		end
		xPlayer.Functions.AddMoney("cash", randomMoney, "banknerv")
		cb(randomMoney)
	end
end)

-- Server Callback to get inventory hackerDevice:
QBCore.Functions.CreateCallback("esx_YachtHeist:getHackerDevice",function(source,cb)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if xPlayer.Functions.GetItemByName(Config.HackerDevice) then
		cb(true)
	else
		cb(false)
		-- TriggerClientEvent("esx:showNotification",source,"You need a ~y~Hacker Device~s~ to hack the terminal!")
		TriggerClientEvent('swt_notifications:Infos', source,"You need a ~y~Hacker Device~s~ to hack the terminal!")
	end
end)

-- Server Callback to get inventory drill:
QBCore.Functions.CreateCallback("esx_YachtHeist:getDrillItem",function(source,cb)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if xPlayer.Functions.GetItemByName(Config.DrillItem) then
		cb(true)
	else
		cb(false)
		-- TriggerClientEvent("esx:showNotification",source,"You need a ~y~Drill~s~ to drill the safe!")
		TriggerClientEvent('swt_notifications:Infos', source,"You need a ~y~Drill~s~ to drill the safe!")
	end
end)

QBCore.Functions.CreateCallback("esx_YachtHeist:getCooldownHeist",function(source,cb)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if YachtHeist[1].recentlyRobbed == false then
		cb(true)
	else
		cb(false)
		-- TriggerClientEvent("esx:showNotification",source,string.format("New heist available in: ~b~%s minutes~s~",GetCooldownTimer()))
		TriggerClientEvent('swt_notifications:Infos', source, string.format("New heist available in: ~b~%s minutes~s~",GetCooldownTimer()))
	end
end)

-- server side for cooldown timer
RegisterServerEvent("esx_YachtHeist:heistCooldown")
AddEventHandler("esx_YachtHeist:heistCooldown",function()
	table.insert(HeistTimer,{time = (Config.CooldownTimer * 60000)}) -- cooldown timer for doing missions
end)

-- thread for syncing the cooldown timer
Citizen.CreateThread(function() -- do not touch this thread function!
	while true do
	Citizen.Wait(1000)
		for k,v in pairs(HeistTimer) do
			if v.time <= 0 then
				YachtHeist[1].recentlyRobbed=false
				TriggerClientEvent('esx_YachtHeist:statusRecentlyRobbed', -1, 1, false)
			else
				v.time = v.time - 1000
			end
		end
	end
end)

function GetCooldownTimer()
	for k,v in pairs(HeistTimer) do
		if v.time > 0 then
			return math.ceil(v.time/60000)
		end
	end
end
