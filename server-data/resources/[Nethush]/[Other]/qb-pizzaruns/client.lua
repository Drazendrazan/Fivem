------------
-- CONFIG --
------------

Config              = {}

Config.Zones = {

	Vehicle = {
		Pos   = {x = 538.17, y = 101.61, z = 95.63}
	},

	Spawn = {
        Pos   = {x = 548.39, y = 125.23, z = 96.47, h = 70.0},
        Heading = 70.0
	},

}

---------
-- QBUS --
---------

QBCore = nil
PlayerData = {}
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
end)
-------------
-- Variables --
-------------

local InService = false
local Hired = true
local BlipSell = nil
local BlipEnd = nil
local BlipCancel = nil
local TargetPos = nil
local HasPizza = false
local NearVan = false
local LastGoal = 0
local DeliveriesCount = 0
local Delivered = false
local xxx = nil
local yyy = nil
local zzz = nil
local Blipy = {}
local JuzBlip = false
local PizzaDelivered = false
local ownsVan = false

---------------
-- Functions --
---------------

-- Create Job Blip
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not JuzBlip then
            Blipy['praca'] = AddBlipForCoord(538.17, 101.61, 96.53)
            SetBlipSprite(Blipy['praca'], 488)
            SetBlipDisplay(Blipy['praca'], 4)
            SetBlipScale(Blipy['praca'], 0.8)
            SetBlipAsShortRange(Blipy['praca'], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Pizza Wala Dhanda')
            EndTextCommandSetBlipName(Blipy['praca'])
						JuzBlip = true
        end
    end
end)
-- LUND BHENCHO GAADI AAYEGI GHANTA
--Spawn Van
function PullOutVehicle()
    if ownsVan == true then
        TriggerEvent("swt_notifications:Infos","You already have a van! Go and collect it.")
    elseif ownsVan == false then
        coords = Config.Zones.Spawn.Pos
        QBCore.Functions.SpawnVehicle('btype3', function(veh)
            SetVehicleNumberPlateText(veh, "PIZZA"..tostring(math.random(1200, 9999)))
            SetEntityHeading(veh, coords.h)
            exports['esx_fuel']:SetFuel(veh, 100.0)
            SetVehicleEngineOn(veh, true, true)
            plaquevehicule = GetVehicleNumberPlateText(veh)
	    TriggerEvent("vehiclekeys:client:SetOwner", plaquevehicule)
	    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        end, coords, true)
        InService = true
        DrawTarget()
        AddCancelBlip()
        ownsVan = true
        TriggerServerEvent("RoutePizza:TakeDeposit")
    end
end

-- Garaz
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Hired then
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local dist = GetDistanceBetweenCoords(pos, Config.Zones.Vehicle.Pos.x, Config.Zones.Vehicle.Pos.y, Config.Zones.Vehicle.Pos.z, true)
            if dist <= 2.5 then
                local GaragePos = {
                    ["x"] = Config.Zones.Vehicle.Pos.x,
                    ["y"] = Config.Zones.Vehicle.Pos.y,
                    ["z"] = Config.Zones.Vehicle.Pos.z + 1
                }
                DrawText3Ds(GaragePos["x"],GaragePos["y"],GaragePos["z"], "Press [~g~G~s~] to start work as a Pizza Boy")
                if dist <= 3.0 then
                    if IsControlJustReleased(0, 47) then
                        PullOutVehicle()
                    end
                end
            end
        end
    end
end)

-------------------
-- Target Search --
-------------------
-- MA CHOD DIYE PIZZA GAAND ME DAAL LO
function DrawTarget()
    local RandomPoint = math.random(1, 21)
    if DeliveriesCount == 4 then
        TriggerEvent("swt_notifications:Infos","All Pizzas have been delivered")
        RemoveCancelBlip()
        SetBlipRoute(BlipSell, false)
        AddFinnishBlip()
        Delivered = true
				xxx = nil
				yyy = nil
				zzz = nil
    else
      local pizza = 4 - DeliveriesCount
      if pizza == 1 then
        TriggerEvent("swt_notifications:Infos","You have 1 pizza")
      else
        if pizza == 4 then
          pizza = 'Four'
        elseif pizza == 3 then
          pizza = 'Three'
        elseif pizza == 2 then
          pizza = 'Two'
        end
        TriggerEvent("swt_notifications:Infos","You have "..pizza.." pizzas")
      end
        if LastGoal == RandomPoint then
            DrawTarget()
        else
            if RandomPoint == 1 then
								xxx =3.45
								yyy =36.74
								zzz =71.53
                LastGoal = 1
            elseif RandomPoint == 2 then
								xxx =-273.58
								yyy =28.33
								zzz =54.75
                LastGoal = 2
            elseif RandomPoint == 3 then
								xxx =-336.49
								yyy =30.87
								zzz =47.34
                LastGoal = 3
            elseif RandomPoint == 4 then
								xxx =-384.25
								yyy =152.84
								zzz =65.46
                LastGoal = 4
            elseif RandomPoint == 5 then
								xxx =-842.22
								yyy =-25.07
								zzz =40.39
                LastGoal = 5
            elseif RandomPoint == 6 then
								xxx =-902.37
								yyy =191.56
								zzz =69.44
                LastGoal = 6
            elseif RandomPoint == 7 then
								xxx =-1116.81
								yyy =304.54
								zzz =66.52
                LastGoal = 7
            elseif RandomPoint == 8 then
								xxx =-583.49
								yyy =195.21
								zzz =71.22
                LastGoal = 8
            elseif RandomPoint == 9 then
								xxx =-1905.66
								yyy =252.95
								zzz =86.45
                LastGoal = 9
            elseif RandomPoint == 10 then
								xxx =-1961.23
								yyy =212.01
								zzz =86.8
                LastGoal = 10
            elseif RandomPoint == 11 then -- zrobione
								xxx =-1899.38
								yyy =-710.93
								zzz =8.76
                LastGoal = 11
            elseif RandomPoint == 12 then
								xxx =56.93
								yyy =-1922.44
								zzz =21.55
                LastGoal = 12
            elseif RandomPoint == 13 then
								xxx =-5.0513
								yyy =-1872.062
								zzz =24.151
                LastGoal = 13
            elseif RandomPoint == 14 then
								xxx =-80.66     
								yyy =-1608.31
								zzz =31.56
                LastGoal = 14
            elseif RandomPoint == 15 then
								xxx =-38.14
								yyy =-1071.58
								zzz =27.26
                LastGoal = 15
            elseif RandomPoint == 16 then
								xxx =344.731
								yyy =-205.027
								zzz =58.019
                LastGoal = 16
            elseif RandomPoint == 17 then
								xxx =340.956
								yyy =-214.876
								zzz =58.019
                LastGoal = 17
            elseif RandomPoint == 18 then
								xxx =337.132
								yyy =-224.712
								zzz =58.019
                LastGoal = 18
            elseif RandomPoint == 19 then
								xxx =331.373
								yyy =-225.865
								zzz =58.019
                LastGoal = 19
            elseif RandomPoint == 20 then
								xxx =337.158
								yyy =-224.729
								zzz =54.221
                LastGoal = 20
            elseif RandomPoint == 21 then
								xxx =-386.907
								yyy =504.108
								zzz =120.412
                LastGoal = 21
            end
		    AddObjBlip(TargetPos)
		    TriggerEvent("swt_notifications:Infos","Take the Pizza to the customer")
        end
    end
end

--------------------
-- Creating Blips --
--------------------

-- Blip celu podrózy
function AddObjBlip(TargetPos)
    Blipy['obj'] = AddBlipForCoord(xxx, yyy, zzz)
    SetBlipRoute(Blipy['obj'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Customer')
	EndTextCommandSetBlipName(Blipy['obj'])
end

-- Blip anulowania pracy
function AddCancelBlip()
    Blipy['cancel'] = AddBlipForCoord(558.52, 121.27, 97.37)
		SetBlipColour(Blipy['cancel'], 59)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('cancel orders')
	EndTextCommandSetBlipName(Blipy['cancel'])
end

-- Blip zakonczenia pracy
function AddFinnishBlip()
    Blipy['end'] = AddBlipForCoord(571.25, 116.78, 97.36)
		SetBlipColour(Blipy['end'], 2)
    SetBlipRoute(Blipy['end'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('finnish job')
	EndTextCommandSetBlipName(Blipy['end'])
end

------------------
-- Delete Blips --
------------------

function RemoveBlipObj()
    RemoveBlip(Blipy['obj'])
end

function RemoveCancelBlip()
    RemoveBlip(Blipy['cancel'])
end

function RemoveAllBlips()
    RemoveBlip(Blipy['obj'])
    RemoveBlip(Blipy['cancel'])
    RemoveBlip(Blipy['end'])
end

-------------------
-- DELIVERY AREA --
-------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dist = GetDistanceBetweenCoords(pos, xxx, yyy, zzz, true)
        if dist <= 20.0 and Hired and (not HasPizza) then
            local DeliveryPoint = {
                ["x"] = xxx,
                ["y"] = yyy,
                ["z"] = zzz
            }
            DrawText3Ds(DeliveryPoint["x"],DeliveryPoint["y"],DeliveryPoint["z"], "Take ~y~Pizza~s~ from ~b~btype3~s~!")
            local Vehicle = GetClosestVehicle(pos, 6.0, 0, 70)
            if IsVehicleModel(Vehicle, GetHashKey('btype3')) then
                local VehPos = GetEntityCoords(Vehicle)
								local distance = GetDistanceBetweenCoords(pos, VehPos, true)
                DrawText3Ds(VehPos.x,VehPos.y,VehPos.z, "Press [~g~G~s~] to pull out ~y~Pizza")
								if dist >= 4 and distance <= 5 then
                	                NearVan = true
								end
            end
        elseif dist <= 25 and HasPizza and Hired then
            local DeliveryPoint = {
                ["x"] = xxx,
                ["y"] = yyy,
                ["z"] = zzz
            }
            DrawText3Ds(DeliveryPoint["x"],DeliveryPoint["y"],DeliveryPoint["z"], "Press [~g~G~s~] to deliver ~y~Pizza")
            if dist <= 3 then
                if IsControlJustReleased(0, 47) then
                    TakePizza()
                    DeliverPizza()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if (not HasPizza) and NearVan then
			if IsControlJustReleased(0, 47) then
                TakePizza()
                NearVan = false
			end
		end
	end
end)

-------------------
-- DELIVER PIZZA --
-------------------

function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

function TakePizza()
    local player = GetPlayerPed(-1)
    if not IsPedInAnyVehicle(player, false) then
        local ad = "anim@heists@box_carry@"
        local prop_name = 'prop_pizza_box_01'
        if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
            loadAnimDict( ad )
            if HasPizza then
                TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0 )
                DetachEntity(prop, 1, 1)
                DeleteObject(prop)
                Wait(1000)
                ClearPedSecondaryTask(PlayerPedId())
                HasPizza = false
            else
                local x,y,z = table.unpack(GetEntityCoords(player))
                prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
                AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 60309), 0.2, 0.08, 0.2, -45.0, 290.0, 0.0, true, true, false, true, 1, true)
                TaskPlayAnim( player, ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                HasPizza = true
            end
        end
    end
end

function DeliverPizza()
    if not PizzaDelivered then
        PizzaDelivered = true
        DeliveriesCount = DeliveriesCount + 1
        RemoveBlipObj()
        SetBlipRoute(BlipSell, false)
        HasPizza = false    
        NextDelivery()
        Citizen.Wait(2500)
        PizzaDelivered = false
    end
end

function NextDelivery()
    TriggerServerEvent('RoutePizza:Payment')
    Citizen.Wait(300)
    DrawTarget()
end
-----------------
-- END OF WORK --
-----------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local DistanceFromEndZone = GetDistanceBetweenCoords(pos, 571.25, 116.78, 97.36, true)
        local DistanceFromCancelZone = GetDistanceBetweenCoords(pos, 558.52, 121.27, 97.37, true)
        if InService then
            if Delivered then
                if DistanceFromEndZone <= 2.5 then
                    local endPoint = { --x = 571.25, y = 116.78, z = 97.36
                        ["x"] = 571.25,
                        ["y"] = 116.78,
                        ["z"] = 97.36
                    }
                    DrawText3Ds(endPoint["x"],endPoint["y"],endPoint["z"], "Press [~g~G~s~] to ~r~complete~s~ work")
                    if DistanceFromEndZone <= 7 then
                        if IsControlJustReleased(0, 47) then
                            TriggerEvent("swt_notifications:Infos","The work is finished! Rest a while, the next orders are already waiting!")
                            EndOfWork()
                        end
                    end
                end
            else
                if DistanceFromCancelZone <= 2.5 then
                    local cancel = { --x = 558.52, y = 121.27, z = 97.37
                        ["x"] = 558.52,
                        ["y"] = 121.27,
                        ["z"] = 97.37
                    }
                    DrawText3Ds(cancel["x"],cancel["y"],cancel["z"], "Press [~g~G~s~] to ~r~cancel~s~ orders")
                    if DistanceFromCancelZone <= 7 then
                        if IsControlJustReleased(0, 47) then
                            TriggerEvent("swt_notifications:Infos","orders Canceled!")
							EndOfWork()
                        end
                    end
                end
            end
        end
    end
end)

function EndOfWork()
    RemoveAllBlips()
    local ped = GetPlayerPed(-1)
    if IsPedInAnyVehicle(ped, false) then
        local Van = GetVehiclePedIsIn(ped, false)
        if IsVehicleModel(Van, GetHashKey('btype3')) then
            QBCore.Functions.DeleteVehicle(Van)
            if Delivered == true then
                TriggerServerEvent("RoutePizza:ReturnDeposit", 'end')
            end
            InService = false
            BlipSell = nil
            BlipEnd = nil
            BlipCancel = nil
            TargetPos = nil
            HasPizza = false
            LastGoal = nil
            DeliveriesCount = 0
            xxx = nil
            yyy = nil
            zzz = nil
            ownsVan = false
            Delivered = false
        else
            TriggerEvent("swt_notifications:Infos","You must return to pizza btype3!")
            TriggerEvent("swt_notifications:Infos","If you lost the btype3 cancel the job on foot")
        end
    else
        InService = false
        BlipSell = nil
        BlipEnd = nil
        BlipCancel = nil
        TargetPos = nil
        HasPizza = false
        LastGoal = nil
        DeliveriesCount = 0
        xxx = nil
        yyy = nil
        zzz = nil
        ownsVan = false
        Delivered = false
    end
end

----------------------
-- 3D text function --
----------------------
DrawText3Ds = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end