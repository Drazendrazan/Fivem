-- AFK Kick Time Limit (in seconds)
secondsUntilKick = 1800

-- Load QBCore
QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local group = "user"
local isLoggedIn = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('qb-afkkick:server:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPermissionUpdate')
AddEventHandler('QBCore:Client:OnPermissionUpdate', function(UserGroup)
    group = UserGroup
end)

-- Code
Citizen.CreateThread(function()
	while true do
		Wait(1000)
        playerPed = GetPlayerPed(-1)
        if isLoggedIn then
            if group == "user" then
                currentPos = GetEntityCoords(playerPed, true)
                if prevPos ~= nil then
                    if currentPos == prevPos then
                        if time ~= nil then
                            if time > 0 then
                                if time == (900) then
                                    TriggerEvent('swt_notifications:Infos','You are AFK and will be kicked in ' .. math.ceil(time / 60) .. ' minutes!')
                                elseif time == (600) then
                                    TriggerEvent('swt_notifications:Infos','You are AFK and will be kicked in ' .. math.ceil(time / 60) .. ' minutes!')
                                elseif time == (300) then
                                    TriggerEvent('swt_notifications:Infos','You are AFK and will be kicked in ' .. math.ceil(time / 60) .. ' minutes!')
                                elseif time == (150) then
                                    TriggerEvent('swt_notifications:Infos','You are AFK and will be kicked in ' .. math.ceil(time / 60) .. ' minutes!')   
                                elseif time == (60) then
                                    TriggerEvent('swt_notifications:Infos','You are AFK and will be kicked in ' .. math.ceil(time / 60) .. ' minute!') 
                                elseif time == (30) then
                                    TriggerEvent('swt_notifications:Infos','You are AFK and will be kicked in ' .. time .. ' seconds!')  
                                elseif time == (20) then
                                    TriggerEvent('swt_notifications:Infos','You are AFK and will be kicked in ' .. time .. ' seconds!')    
                                elseif time == (10) then
                                    TriggerEvent('swt_notifications:Infos','You are AFK and will be kicked in ' .. time .. ' seconds!')                                                                                                            
                                end
                                time = time - 1
                            else
                                TriggerServerEvent("KickForAFK")
                            end
                        else
                            time = secondsUntilKick
                        end
                    else
                        time = secondsUntilKick
                    end
                end
                prevPos = currentPos
            end
        end
    end
end)