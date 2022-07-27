QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)
local alertData = {
	title = "Attempted Yacht Heist",
	coords = {x = -2031.31, y =-1037.54 , z =2.56},
	description = "Yacht robbery attempt",
}
local PlayerData            = {}
local YachtHeist 			= {}
local Goons 				= {}
local drillRect 			= 0.0
local stealingRect 			= 0.0
local jobPlayer 			= false
local takingCashClient		= false
local drillingClient 		= false
local HeistComplete 		= false
local Robbing = false
local streetName
local trolleyNetObj
local emptyTrolleyNetObj
local requiredItemsShowed = false
local requiredItems = {}
local inRange

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:getSharedObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData =  QBCore.Functions.GetPlayerData()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

-- Outlaw message:
RegisterNetEvent('esx_YachtHeist:outlawNotify')
AddEventHandler('esx_YachtHeist:outlawNotify', function(alert)
		TriggerEvent('chat:addMessage', { args = { "^5 Dispatch: " .. alert }})

end)

RegisterNetEvent('esx_YachtHeist:load')
AddEventHandler('esx_YachtHeist:load', function(list)
    YachtHeist = list
end)

RegisterNetEvent('esx_YachtHeist:statusRecentlyRobbed')
AddEventHandler('esx_YachtHeist:statusRecentlyRobbed', function(id,status)
    if id ~= nil or status ~= nil then 
        YachtHeist[id].recentlyRobbed = status
    end
end)

RegisterNetEvent('esx_YachtHeist:statusSend')
AddEventHandler('esx_YachtHeist:statusSend', function(id,status)
    if id ~= nil or status ~= nil then 
        YachtHeist[id].started = status
    end
end)

RegisterNetEvent('esx_YachtHeist:statusGoonsSpawnedSend')
AddEventHandler('esx_YachtHeist:statusGoonsSpawnedSend', function(id,status)
    if id ~= nil or status ~= nil then 
        YachtHeist[id].GoonsSpawned = status
    end
end)

RegisterNetEvent('esx_YachtHeist:statusJobPlayerSend')
AddEventHandler('esx_YachtHeist:statusJobPlayerSend', function(id,status)
    if id ~= nil or status ~= nil then 
        YachtHeist[id].JobPlayer = status
    end
end)

RegisterNetEvent('esx_YachtHeist:statusHackSend')
AddEventHandler('esx_YachtHeist:statusHackSend', function(id,state)
    if id ~= nil or state ~= nil then  
        YachtHeist[id].keypadHacked = state
    end
end)

RegisterNetEvent('esx_YachtHeist:statusCurrentlyHackingSend')
AddEventHandler('esx_YachtHeist:statusCurrentlyHackingSend', function(id,state)
    if id ~= nil or state ~= nil then  
        YachtHeist[id].currentlyHacking = state
    end
end)

RegisterNetEvent('esx_YachtHeist:statusVaultSend')
AddEventHandler('esx_YachtHeist:statusVaultSend', function(id,state)
    if id ~= nil or state ~= nil then  
        YachtHeist[id].vaultLocked = state
    end
end)

RegisterNetEvent('esx_YachtHeist:statusDrillingSend')
AddEventHandler('esx_YachtHeist:statusDrillingSend', function(id,state)
    if id ~= nil or state ~= nil then  
        YachtHeist[id].drilling = state
    end
end)

RegisterNetEvent('esx_YachtHeist:statusSafeRobbedSend')
AddEventHandler('esx_YachtHeist:statusSafeRobbedSend', function(id,state)
    if id ~= nil or state ~= nil then  
        YachtHeist[id].safeRobbed = state
    end
end)

RegisterNetEvent('esx_YachtHeist:statusStealingSend')
AddEventHandler('esx_YachtHeist:statusStealingSend', function(id,state)
    if id ~= nil or state ~= nil then  
        YachtHeist[id].stealing = state
    end
end)

RegisterNetEvent('esx_YachtHeist:statusCashTakenSend')
AddEventHandler('esx_YachtHeist:statusCashTakenSend', function(id,state)
    if id ~= nil or state ~= nil then  
        YachtHeist[id].cashTaken = state
    end
end)

keyPressed = false
requiredItemsShowed = false
Citizen.CreateThread(function()
	Citizen.Wait(500)
	requiredItems = {
        [1] = {name = QBCore.Shared.Items["advancedlockpick"]["name"], image = QBCore.Shared.Items["advancedlockpick"]["image"]},
        [2] = {name = QBCore.Shared.Items["electronickit"]["name"], image = QBCore.Shared.Items["electronickit"]["image"]},
		[3] = {name = QBCore.Shared.Items["drill"]["name"], image = QBCore.Shared.Items["drill"]["image"]},
		[4] = {name = QBCore.Shared.Items["hak_kit"]["name"], image = QBCore.Shared.Items["hak_kit"]["image"]},
    }
    while true do
		inRange = false
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped,true)
        for k,v in pairs(YachtHeist) do
            v.startPos[1] = v.startPos[1]
            v.startPos[2] = v.startPos[2]
            v.startPos[3] = v.startPos[3]
			if not v.started then
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.startPos[1], v.startPos[2], v.startPos[3], true) <= 10.0 then
					DrawMarker(27, v.startPos[1], v.startPos[2], v.startPos[3]-0.97, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.25, 1.25, 1.25, 255, 255, 0, 100, false, true, 2, false, false, false, false)
				end  
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.startPos[1], v.startPos[2], v.startPos[3], true) <= 1.5 then
					DrawText3Ds(v.startPos[1], v.startPos[2], v.startPos[3], "Press ~g~[E]~s~ to start ~y~Yacht Heist~s~ ")
					inRange = true
				end
				if not requiredItemsShowed then
					requiredItemsShowed = true
					-- TriggerEvent('nethush-inventory:client:requiredItems', requiredItems, true)
				end
				if not inRange then
					if requiredItemsShowed then
						requiredItemsShowed = false
						--TriggerEvent('nethush-inventory:client:requiredItems', requiredItems, false)
					end
					Citizen.Wait(1000)
				end
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.startPos[1], v.startPos[2], v.startPos[3], true) <= 1.0 then
					if IsControlJustPressed(0,38) and not keyPressed then
						QBCore.Functions.TriggerCallback('esx_YachtHeist:getCooldownHeist', function(NoCooldown)
							if NoCooldown then
								keyPressed = true
								QBCore.Functions.TriggerCallback('esx_YachtHeist:GetPoliceOnline', function(PoliceCountOK)
											requiredItemsShowed = false
											--TriggerEvent('nethush-inventory:client:requiredItems', requiredItems, false)
									if PoliceCountOK then
										TriggerServerEvent("esx_YachtHeist:status", k, true)
										TriggerServerEvent("qb-phone:client:addPoliceAlert", -1, alertData)
										TriggerEvent('esx_YachtHeist:client:YachtHesitAlert')
										--TriggerServerEvent("esx_YachtHeist:success")	
										toggleHeistStart(k,v)
										TriggerEvent('swt_notifications:Infos','Find the room cointaining the vault')
									else
										TriggerEvent('swt_notifications:Infos','The vault is in lockdown due to lack of police in the city. Required Police '.. Config.RequiredPolice .."")
										TriggerEvent('swt_notifications:Infos','You dont have items')
										keyPressed = false
									end
								end)
							else
								keyPressed = false
							end
						end)
						break;
					end
				end
			end
        end
    end
end)
 
function toggleHeistStart(k,v)
    local ped = GetPlayerPed(-1)
    local x,y,z = table.unpack(GetEntityCoords(ped, true))
	-- exports['progressBars']:startUI(1000, "STARTING")
	QBCore.Functions.Progressbar("plant_weed_plant", "Starting the heist...", 8000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		RobbingATM = true
	})
	Citizen.Wait(8000)
	Yacht = "Yacht hest"
	TriggerEvent('esx_YachtHeist:client:YachtHesitAlert')
    TriggerServerEvent("qb-police:server:send:alert:yachtrob", GetEntityCoords(PlayerPedId()), QBCore.Functions.GetStreetLabel())

	TriggerEvent("esx_YachtHeist:HeistMainEvent",k,v)
	SpawnTrolleyEvent(k,v)
	PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
	
	--TriggerEvent("esx_YachtHeist:HeistMainEvent",k,v)
	--SpawnTrolleyEvent(k,v)
	--PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
	keyPressed = false
end

RegisterNetEvent('esx_YachtHeist:HeistMainEvent')
AddEventHandler('esx_YachtHeist:HeistMainEvent', function(k,v)
	local Goons = {}
	local ped = GetPlayerPed(-1)
	HeistComplete = false
	
	while not HeistComplete do
		Citizen.Wait(0)
		
		if v.started == true then
		
			local coords = GetEntityCoords(ped)
				-- Goons Spawn, not hostile:
			if (Vdist(coords.x, coords.y, coords.z, v.loc[1], v.loc[2], v.loc[3]) < 50) and not v.GoonsSpawned then
				v.GoonsSpawned = true
				TriggerServerEvent("esx_YachtHeist:goonsSpawned", k, true)
				Citizen.Wait(1500)
				ClearAreaOfPeds(v.loc[1], v.loc[2], v.loc[3], 50, 1)
				SetPedRelationshipGroupHash(ped, GetHashKey("PLAYER"))
				AddRelationshipGroup('HeistGuards')
				local i = 0
				for k,v in pairs(v.Goons) do
					RequestModel(GetHashKey(v.ped))
					while not HasModelLoaded(GetHashKey(v.ped)) do
						Wait(1)
					end
					Goons[i] = CreatePed(4, GetHashKey(v.ped), v.x, v.y, v.z, v.h, false, true)
					NetworkRegisterEntityAsNetworked(Goons[i])
					SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Goons[i]), true)
					SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(Goons[i]), true)
					SetPedCanSwitchWeapon(Goons[i], true)
					SetPedArmour(Goons[i], 100)
					SetPedAccuracy(Goons[i], 60)
					SetEntityInvincible(Goons[i], false)
					SetEntityVisible(Goons[i], true)
					SetEntityAsMissionEntity(Goons[i])
					RequestAnimDict(v.animDict) 
					while not HasAnimDictLoaded(v.animDict) do
						Citizen.Wait(0) 
					end 
					TaskPlayAnim(Goons[i], v.animDict, v.animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
					GiveWeaponToPed(Goons[i], GetHashKey(v.weapon), 255, false, false)
					SetPedDropsWeaponsWhenDead(Goons[i], false)
					SetPedFleeAttributes(Goons[i], 0, false)	
					SetPedRelationshipGroupHash(Goons[i], GetHashKey("HeistGuards"))	
					TaskGuardCurrentPosition(Goons[i], 3.0, 3.0, 1)
					i = i +1
				end
			end
			-- Gonns turning hostile:
			if (Vdist(coords.x, coords.y, coords.z, v.loc[1], v.loc[2], v.loc[3]) < 15) and not v.JobPlayer then
				v.JobPlayer = true
				TriggerServerEvent("esx_YachtHeist:JobPlayer", k, true)
				Citizen.Wait(1500)
				SetPedRelationshipGroupHash(ped, GetHashKey("PLAYER"))
				AddRelationshipGroup('HeistGuards')
				local i = 0
				for k,v in pairs(v.Goons) do
					ClearPedTasksImmediately(Goons[i])
					i = i +1
				end
				SetRelationshipBetweenGroups(0, GetHashKey("HeistGuards"), GetHashKey("HeistGuards"))
				SetRelationshipBetweenGroups(5, GetHashKey("HeistGuards"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("HeistGuards"))
			end
		end		
	end	
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped,true)
        for k,v in pairs(YachtHeist) do
            v.keypad[1] = v.keypad[1]
            v.keypad[2] = v.keypad[2]
            v.keypad[3] = v.keypad[3]
			if v.started == true then
				if v.keypadHacked == false and v.currentlyHacking == false then
					if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.keypad[1], v.keypad[2], v.keypad[3], true) <= 1.5 then
							DrawText3Ds(v.keypad[1], v.keypad[2], v.keypad[3], "Press ~g~[E]~s~ to ~y~Hack~s~")
					end
					if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.keypad[1], v.keypad[2], v.keypad[3], true) <= 1.0 then
						if IsControlJustPressed(0,38) then
							HackKeypadEvent(k,v)
							break;
						end
					end
				end
			end
        end
    end
end)


function SpawnTrolleyEvent(k,v)
	local trolley = GetHashKey("hei_prop_hei_cash_trolly_01")
	RequestModel(trolley)
	while not HasModelLoaded(trolley) do
		Citizen.Wait(100)
	end
	local trolleyObject = CreateObject(trolley, v.trolleyPos[1], v.trolleyPos[2], v.trolleyPos[3], true)
	SetEntityRotation(trolleyObject, 0.0, 0.0, v.trolleyPos[4]+180.0)
	PlaceObjectOnGroundProperly(trolleyObject)
	SetEntityAsMissionEntity(trolleyObject, true, true)
	trolleyNetObj = ObjToNet(trolleyObject)
	SetModelAsNoLongerNeeded(trolley)
end

function HackKeypadEvent(k,v)
    local ped = GetPlayerPed(-1)
    local x,y,z = table.unpack(GetEntityCoords(ped, true))
   QBCore.Functions.TriggerCallback("esx_YachtHeist:getHackerDevice", function(hackerDevice)
		if hackerDevice then
			if GetDistanceBetweenCoords(x,y,z, v.keypad[1], v.keypad[2], v.keypad[3],true) <= 1.0 then
				TriggerServerEvent("esx_YachtHeist:currentlyHacking", k, true)
				local animDict = "anim@heists@keypad@"
				local animLib = "idle_a"
			
				RequestAnimDict(animDict)
				while not HasAnimDictLoaded(animDict) do
					Citizen.Wait(50)
				end
				
				SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"),true)
				Citizen.Wait(500)
				
				FreezeEntityPosition(ped, true)
				-- exports['progressBars']:startUI(8500, "CONNECTING")
				QBCore.Functions.Progressbar("plant_weed_plant", "CONNECTING..", 8500, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				})
				TaskPlayAnim(ped, animDict, animLib, 2.0, -2.0, -1, 1, 0, 0, 0, 0 )
				Citizen.Wait(3500)
				TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_MOBILE', -1, true)
				Citizen.Wait(5000)
				TriggerEvent("mhacking:show")
				TriggerEvent("mhacking:start",7,25,HackingEvent)
			end
		end
	end)
end
---- haking ----
function HackingEvent(success)
	local ped = GetPlayerPed(-1)
	local coords = GetEntityCoords(ped)
	TriggerEvent('mhacking:hide')
	TriggerEvent("QBCore:Notify", "Find The Trolly and Safe Box in the Yath.s")
	for k,v in pairs(YachtHeist) do
		if success then			
			TriggerServerEvent("esx_YachtHeist:statusHack", k, true)
			PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
			PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
			TriggerEvent('esx_YachtHeist:client:YachtHesitAlert')
			TriggerServerEvent("qb-phone:client:addPoliceAlert", -1, alertData)
		--	TriggerEvent("QBCore:Notify", "Police: A Heist is in progress. The Yacht is temporarily shut down!")

			local peds = PlayerPedId()
            local playerPos = GetEntityCoords(peds)
			local gender = IsPedMale(PlayerPedId())
			local model = GetEntityModel(peds)
			if (model == GetHashKey("mp_f_freemode_01")) then
				gender = "Woman"
			end
			if (model == GetHashKey("mp_m_freemode_01")) then
				gender = "Man"
			end
			TriggerEvent("QBCore:Notify", "Police: A Heist is in progress. The Yacht is temporarily shut down!")

			TriggerServerEvent(
				"qb-phone:client:addPoliceAlert",
				"10-90",
				"Yath Robbery in progress",
				{{icon = "fa-venus-mars", info = gender}},
				{playerPos[1], playerPos[2], playerPos[3]},
				"police",
				5000,
				404,
				10
			)
			Citizen.Wait(1000)
		else
			TriggerServerEvent("esx_YachtHeist:statusHack", k, false)
			--TriggerEvent("QBCore:Notify", "Police: A Heist is in progress. The Yacht is temporarily shut down!")
			TriggerEvent('esx_YachtHeist:client:YachtHesitAlert')
			TriggerServerEvent("qb-phone:client:addPoliceAlert", -1, alertData)
			local peds = PlayerPedId()
            local playerPos = GetEntityCoords(peds)
			local gender = IsPedMale(PlayerPedId())
			local model = GetEntityModel(peds)
			if (model == GetHashKey("mp_f_freemode_01")) then
				gender = "Woman"
			end
			if (model == GetHashKey("mp_m_freemode_01")) then
				gender = "Man"
			end
			--TriggerEvent("QBCore:Notify", "Police: A Heist is in progress. The Yacht is temporarily shut down!")
			TriggerEvent('esx_YachtHeist:client:YachtHesitAlert')
			TriggerServerEvent(
				"qb-phone:client:addPoliceAlert",
				"10-90",
				"Yath Robbery in progress",
				{{icon = "fa-venus-mars", info = gender}},
				{playerPos[1], playerPos[2], playerPos[3]},
				"police",
				5000,
				156,
				10
			)
			Citizen.Wait(1000)
		end
		TriggerServerEvent("esx_YachtHeist:currentlyHacking", k, false)
		TriggerServerEvent('esx_YachtHeist:PoliceNotify',playerPos,streetName)
	end
	ClearPedTasks(ped)
	FreezeEntityPosition(ped, false)
end

RegisterNetEvent('esx_YachtHeist:client:YachtHesitAlert')
AddEventHandler('esx_YachtHeist:client:YachtHesitAlert', function()
    TriggerEvent('nethush-alerts:client:AddPoliceAlert', {
        timeOut = 10000,
        alertTitle = "Attempted Yacht Heist",
        details = {
            [1] = {
                icon = '<i class="fas fa-lock"></i>',
                detail = "The Yacht is temporarily shut down!",
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = "Pacific Ocean",
            },
        },
        callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
    })

end)

-- Poliec Alert:
RegisterNetEvent('esx_YachtHeist:OutlawBlipSettings')
AddEventHandler('esx_YachtHeist:OutlawBlipSettings', function(targetCoords)
	if Config.PoliceBlipShow then
		local alpha = Config.PoliceBlipAlpha
		local policeNotifyBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.PoliceBlipRadius)

		SetBlipHighDetail(policeNotifyBlip, true)
		SetBlipColour(policeNotifyBlip, Config.PoliceBlipColor)
		SetBlipAlpha(policeNotifyBlip, alpha)
		SetBlipAsShortRange(policeNotifyBlip, true)

		while alpha ~= 0 do
			Citizen.Wait(Config.PoliceBlipTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(policeNotifyBlip, alpha)

			if alpha == 0 then
				RemoveBlip(policeNotifyBlip)
				return
			end
		end
	end
end)

-- Thread for Police Notify
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
		PlayerJob = QBCore.Functions.GetPlayerData().job
        local coords = GetEntityCoords(ped,true)
        for k,v in pairs(YachtHeist) do
            v.vaultDoor[1] = v.vaultDoor[1]
            v.vaultDoor[2] = v.vaultDoor[2]
            v.vaultDoor[3] = v.vaultDoor[3]
			if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.vaultDoor[1], v.vaultDoor[2], v.vaultDoor[3], true) <= 1.5 then
				local doorVault = GetClosestObjectOfType(v.vaultDoor[1], v.vaultDoor[2], v.vaultDoor[3], 1.5, v.vaultModel, false, false, false)
				if doorVault ~= 0 then
					if v.vaultLocked then
                        if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.vaultDoor[1], v.vaultDoor[2], v.vaultDoor[3], true) <= 1.5 then
                            if v.keypadHacked == true then
								DrawText3Ds(v.vaultDoor[1], v.vaultDoor[2], v.vaultDoor[3], "Press ~g~[E]~s~ to ~y~Open Vault~s~")
							end
                        end
                        local vaultLocked, heading = GetStateOfClosestDoorOfType(v.vaultModel, v.vaultDoor[1], v.vaultDoor[2], v.vaultDoor[3], v.vaultLocked, 0)
                        if heading > -0.01 and heading < 0.01 then
                            FreezeEntityPosition(doorVault, v.vaultLocked)
                        end
					else
                        if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.vaultDoor[1], v.vaultDoor[2], v.vaultDoor[3], true) <= 2.0 then
                            if v.started == true and (PlayerJob.name == "police" or PlayerJob.name == "sheriff") then
								DrawText3Ds(v.keypad[1], v.keypad[2], v.keypad[3], "Press ~g~[E]~s~ to ~y~Secure Vault~s~")
							end	
                        end
                        FreezeEntityPosition(doorVault, v.vaultLocked)
					end
				end
			end
            if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.vaultDoor[1], v.vaultDoor[2], v.vaultDoor[3], true) <= 1.0 then
				if v.started == true and v.keypadHacked == true and v.vaultLocked == true then		
					if IsControlJustPressed(0,38) then
						VaultDoorEvent(k,v)
						break;
					end
				end
				if v.started == true then		
					if IsControlJustPressed(0,38) and v.vaultLocked == false then
						if (PlayerJob.name == "police") then
							PoliceSecureEvent(k,v)
						end
						break;
					end		
					if IsControlJustPressed(0,38) and v.vaultLocked == true then
						VaultDoorEvent(k,v)
						break;
					end
				end
            end
        end
    end
end)

function VaultDoorEvent(k,v)
    local ped = GetPlayerPed(-1)
    local x,y,z = table.unpack(GetEntityCoords(ped, true))
    if GetDistanceBetweenCoords(x,y,z, v.vaultDoor[1], v.vaultDoor[2], v.vaultDoor[3],true) <= 1.0 then
        TriggerServerEvent("esx_YachtHeist:statusVault", k, false)
		Citizen.Wait(100)
		PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
    end
end

function PoliceSecureEvent(k,v)
    local ped = GetPlayerPed(-1)
    local x,y,z = table.unpack(GetEntityCoords(ped, true))
    if GetDistanceBetweenCoords(x,y,z, v.keypad[1], v.keypad[2], v.keypad[3],true) <= 0.5 then
		FreezeEntityPosition(ped, true)
        TriggerServerEvent("esx_YachtHeist:HeistIsBeingReset", k)
		-- exports['progressBars']:startUI(1000, "SECURING")
		QBCore.Functions.Progressbar("plant_weed_plant", "SECURING...", 1000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		})
		Citizen.Wait(1000)
		PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
		TriggerEvent('QBCore:Notify', "Police: The Yacht has been secured by the Police and is now open again!")
		FreezeEntityPosition(ped, false)
		Citizen.Wait(1000)
		if NetworkDoesEntityExistWithNetworkId(trolleyNetObj) then
			local trolleyInactive = NetToObj(trolleyNetObj)
			Citizen.Wait(250) 
			while not NetworkHasControlOfEntity(trolleyInactive) do
				Citizen.Wait(0)
				NetworkRequestControlOfEntity(trolleyInactive)
			end
			Citizen.Wait(250) 
			DeleteObject(trolleyInactive)
		end 
		Citizen.Wait(1000) 
		if NetworkDoesEntityExistWithNetworkId(emptyTrolleyNetObj) then
			local emptyTrolleyInactive = NetToObj(emptyTrolleyNetObj)
			Citizen.Wait(250) 
			while not NetworkHasControlOfEntity(emptyTrolleyInactive) do
				Citizen.Wait(0)
				NetworkRequestControlOfEntity(emptyTrolleyInactive)
			end
			Citizen.Wait(250) 
			DeleteObject(emptyTrolleyInactive)
		end
    else
		-- ESX.ShowNotification("Get closer to the keypad")
		TriggerEvent('swt_notifications:Infos','Get closer to the keypad')
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped,true)
        for k,v in pairs(YachtHeist) do
            v.safe[1] = v.safe[1]
            v.safe[2] = v.safe[2]
            v.safe[3] = v.safe[3]
			local distAB = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.safe[1], v.safe[2], v.safe[3], true) 
			if v.started == true then
				if v.vaultLocked == false and v.keypadHacked == true and v.safeRobbed == false then
					if distAB <= 1.5 and v.drilling == false then
						DrawText3Ds(v.safe[1], v.safe[2], v.safe[3], "Press ~g~[E]~s~ to ~y~Drill~s~")
						if distAB <= 1.0 then
							if IsControlJustPressed(0,38) and v.drilling == false then
								Citizen.Wait(100)
								SafeDrillStartEvent(k,v)
								break;
							end
						end
					end
					if distAB <= 1.5 and v.drilling == true then
						DrawText3Ds(v.safe[1], v.safe[2], v.safe[3], "Press ~g~[E]~s~ to ~y~Stop Drill~s~")
						if distAB <= 1.0 then
							if IsControlJustPressed(0,38) and v.drilling == true then
								Citizen.Wait(100)
								SafeDrillStopEvent(k,v)
								break;
							end
						end
					end
				end
			end
        end
    end
end)

local attachedDrill
local effect
local drillSound
function SafeDrillStartEvent(k,v)
    local ped = GetPlayerPed(-1)
    local x,y,z = table.unpack(GetEntityCoords(ped, true))
    QBCore.Functions.TriggerCallback("esx_YachtHeist:getDrillItem", function(drillItem)
		if drillItem then
			if GetDistanceBetweenCoords(x,y,z, v.safe[1], v.safe[2], v.safe[3],true) <= 1.0 then
				TriggerServerEvent("esx_YachtHeist:drilling", k, true)
				drillingClient = true
				
				FreezeEntityPosition(ped, true)
				SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"),true)
				Citizen.Wait(500)
				local animDict = "anim@heists@fleeca_bank@drilling"
				local animLib = "drill_straight_idle"
				
				RequestAnimDict(animDict)
				while not HasAnimDictLoaded(animDict) do
					Citizen.Wait(50)
				end
				
				local drillProp = GetHashKey('hei_prop_heist_drill')
				local boneIndex = GetPedBoneIndex(ped, 28422)
				
				RequestModel(drillProp)
				while not HasModelLoaded(drillProp) do
					Citizen.Wait(100)
				end
				
				TaskPlayAnim(ped,animDict,animLib,1.0, -1.0, -1, 2, 0, 0, 0, 0)
				
				attachedDrill = CreateObject(drillProp, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(attachedDrill, ped, boneIndex, 0.0, 0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
				
				SetEntityAsMissionEntity(attachedDrill, true, true)
				
				RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
				RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
				RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
				drillSound = GetSoundId()
				
				Citizen.Wait(750)
						
				PlaySoundFromEntity(drillSound, "Drill", attachedDrill, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
				
				Citizen.Wait(200)
				
				local particleDictionary = "scr_fbi5a"
				local particleName = "scr_bio_grille_cutting"

				RequestNamedPtfxAsset(particleDictionary)
				while not HasNamedPtfxAssetLoaded(particleDictionary) do
				  Citizen.Wait(0)
				end

				SetPtfxAssetNextCall(particleDictionary)
				effect = StartParticleFxLoopedOnEntity(particleName, attachedDrill, 0.0, -0.6, 0.0, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
				ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 1.0)
			end
		end
	end)
end

function SafeDrillStopEvent(k,v)
    local ped = GetPlayerPed(-1)
    local x,y,z = table.unpack(GetEntityCoords(ped, true))
	TriggerServerEvent("esx_YachtHeist:drilling", k, false)
	drillingClient = false
	ClearPedTasksImmediately(ped)
	StopSound(drillSound)
	ReleaseSoundId(drillSound)
    DeleteEntity(attachedDrill)
    FreezeEntityPosition(ped, false)
    StopParticleFxLooped(effect, 0)
    StopGameplayCamShaking(true)
end

function drawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
		for k,v in pairs(YachtHeist) do
			if v.drilling and tonumber(drillRect) < 100.0 then
				drillRect = drillRect + 1
				Citizen.Wait(1000)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(0)
		for k,v in pairs(YachtHeist) do
			if v.drilling and drillingClient == true then
				-- background bar:
				drawRct(0.40, 0.95, 0.1430, 0.035, 0, 0, 0, 80)
				-- progress bar:
				drawRct(0.40, 0.95, (0.1429/100*drillRect) , 0.034, 0, 161, 255, 125)
				--text settings:
				SetTextScale(0.4, 0.4)
				SetTextFont(4)
				SetTextProportional(1)
				SetTextColour(255, 255, 255, 255)
				SetTextEdge(2, 0, 0, 0, 150)
				SetTextEntry("STRING")
				SetTextCentre(1)
				AddTextComponentString('DRILLING')
				DrawText(0.47,0.952)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped,true)
		for k,v in pairs(YachtHeist) do
			if drillRect == 100.0 then
				TriggerServerEvent("esx_YachtHeist:drilling", k, false)
				drillingClient = false
				TriggerServerEvent("esx_YachtHeist:safeRobbed", k, true)
				Citizen.Wait(200)
				drillRect = 0
				ClearPedTasksImmediately(ped)
				StopSound(drillSound)
				ReleaseSoundId(drillSound)
				DeleteEntity(attachedDrill)
				FreezeEntityPosition(ped, false)
				StopParticleFxLooped(effect, 0)
				StopGameplayCamShaking(true)
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped,true)
        for k,v in pairs(YachtHeist) do
            v.trolleyPos[1] = v.trolleyPos[1]
            v.trolleyPos[2] = v.trolleyPos[2]
            v.trolleyPos[3] = v.trolleyPos[3]
			local distAB = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.trolleyPos[1], v.trolleyPos[2], v.trolleyPos[3], true) 
			if v.started == true then
				if v.vaultLocked == false and v.keypadHacked == true and v.cashTaken == false then
					if NetworkDoesEntityExistWithNetworkId(trolleyNetObj) then
						if distAB <= 1.5 and v.stealing == false then
							DrawText3Ds(v.trolleyPos[1], v.trolleyPos[2], v.trolleyPos[3], "Press ~g~[E]~s~ to ~y~Take Cash~s~")
						end	
						if distAB <= 1.0 and v.stealing == false then
							if IsControlJustPressed(0,38) then
								Citizen.Wait(100)
								TakeCashEvent(k,v)
								break;
							end
						end
					end
				end
			end
        end
    end
end)

local totalCashTake = 0
local emptyTrolleyObject
function TakeCashEvent(k,v)
	local ped = PlayerPedId()
	TriggerServerEvent("esx_YachtHeist:stealing", k, true)
	takingCashClient = true
	local function GrabCashFromTrolley()
		local coords = GetEntityCoords(ped)
		local cashProp = GetHashKey("hei_prop_heist_cash_pile")
		RequestModel(cashProp)
		while not HasModelLoaded(cashProp) do
			Citizen.Wait(100)
		end
		local cashPile = CreateObject(cashProp, coords, true)
		FreezeEntityPosition(cashPile, true)
		SetEntityInvincible(cashPile, true)
		SetEntityNoCollisionEntity(cashPile, ped)
		SetEntityVisible(cashPile, false, false)
		AttachEntityToEntity(cashPile, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
		local takingCashTime = GetGameTimer()
		Citizen.CreateThread(function()
			while GetGameTimer() - takingCashTime < 37000 do
				Citizen.Wait(0)
									
				if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
					if not IsEntityVisible(cashPile) then
						SetEntityVisible(cashPile, true, false)
					end
				end		
				if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
					if IsEntityVisible(cashPile) then
						SetEntityVisible(cashPile, false, false)
						QBCore.Functions.TriggerCallback('esx_YachtHeist:updateCashTaken', function(cashTaken)
							totalCashTake = totalCashTake + cashTaken
						end)
					end
				end
			end
			DeleteObject(cashPile)
		end)
	end
	local trolleyObjectInUse
	local trolleyObject = NetToObj(trolleyNetObj)
	local emptyTrolleyProp = GetHashKey("hei_prop_hei_cash_trolly_03")
	if IsEntityPlayingAnim(trolleyObject, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return TriggerEvent('swt_notifications:Infos','A player is ~b~already~s~ taking cash.')
		-- ESX.ShowNotification("A player is ~b~already~s~ taking cash.") 
	end
	local animDict = "anim@heists@ornate_bank@grab_cash"
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(50)
	end
	RequestModel(emptyTrolleyProp)
	while not HasModelLoaded(emptyTrolleyProp) do
		Citizen.Wait(100)
	end
	RequestModel(GetHashKey("hei_p_m_bag_var22_arm_s"))
	while not HasModelLoaded(GetHashKey("hei_p_m_bag_var22_arm_s")) do
		Citizen.Wait(100)
	end
	while not NetworkHasControlOfEntity(trolleyObject) do
		Citizen.Wait(0)
		NetworkRequestControlOfEntity(trolleyObject)
	end
	bagProp = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
	SetPedComponentVariation(ped, 5, 0, 0, 0)
	-- First Scene:
	scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trolleyObject), GetEntityRotation(trolleyObject), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene1, animDict, "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bagProp, scene1, animDict, "bag_intro", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene1)
	Citizen.Wait(1500)
	GrabCashFromTrolley()
	-- Second Scene:
	scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trolleyObject), GetEntityRotation(trolleyObject), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene2, animDict, "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bagProp, scene2, animDict, "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trolleyObject, scene2, animDict, "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Citizen.Wait(37000)
	-- Third scene:
	scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trolleyObject), GetEntityRotation(trolleyObject), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene3, animDict, "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bagProp, scene3, animDict, "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)
	-- Scenes are done:
	local emptyTrolley = CreateObject(emptyTrolleyProp, GetEntityCoords(trolleyObject) + vector3(0.0, 0.0, - 0.985), true)
	SetEntityRotation(emptyTrolley, GetEntityRotation(trolleyObject))
	while not NetworkHasControlOfEntity(trolleyObject) do
		Citizen.Wait(0)
		NetworkRequestControlOfEntity(trolleyObject)
	end
	DeleteObject(trolleyObject)
	PlaceObjectOnGroundProperly(emptyTrolley)
	SetEntityAsMissionEntity(emptyTrolley, true, true)
	emptyTrolleyNetObj = ObjToNet(emptyTrolley)
	Citizen.Wait(1900) 
	DeleteObject(bagProp)
	if Config.EnablePlayerMoneyBag == true then
		SetPedComponentVariation(ped, 5, 45, 0, 2)
	end
	RemoveAnimDict(animDict)
	SetModelAsNoLongerNeeded(emptyTrolleyProp)
	SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
	Citizen.Wait(2000)
	TriggerServerEvent("esx_YachtHeist:cashTaken", k, true)
	TriggerServerEvent("esx_YachtHeist:stealing", k, false)
	takingCashClient = false
end

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(0)
		for k,v in pairs(YachtHeist) do
			if v.stealing and takingCashClient == true then
				-- background bar:
				drawRct(0.91, 0.95, 0.1430, 0.035, 0, 0, 0, 80)
				-- text settings:
				SetTextScale(0.4, 0.4)
				SetTextFont(4)
				SetTextProportional(1)
				SetTextColour(255, 255, 255, 255)
				SetTextEdge(2, 0, 0, 0, 150)
				SetTextEntry("STRING")
				SetTextCentre(1)
				AddTextComponentString("TAKE:")
				DrawText(0.925,0.9535)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(0)
		for k,v in pairs(YachtHeist) do
			if v.stealing and takingCashClient == true then
				SetTextScale(0.45, 0.45)
				SetTextFont(4)
				SetTextProportional(1)
				SetTextColour(255, 255, 255, 255)
				SetTextEdge(2, 0, 0, 0, 150)
				SetTextEntry("STRING")
				SetTextCentre(1)
				AddTextComponentString(comma_value("$"..totalCashTake..""))
				DrawText(0.97,0.9523)
			end
		end
	end
end)

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

-- Blip on Map for Heist:
-- Citizen.CreateThread(function()
--   for k,v in pairs(Config.Yacht) do
--     local blip = AddBlipForCoord(v.startPos[1], v.startPos[2], v.startPos[3])
--     SetBlipSprite (blip, v.blipSprite)
--     SetBlipDisplay(blip, 4)
--     SetBlipScale  (blip, v.blipScale)
--     SetBlipColour (blip, v.blipColor)
--     SetBlipAsShortRange(blip, true)
--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString(v.blipName)
--     EndTextCommandSetBlipName(blip)
--   end
-- end)

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

-- Refresh Heist State
Citizen.CreateThread(function()
    TriggerServerEvent("esx_YachtHeist:refreshHeist")
end)

