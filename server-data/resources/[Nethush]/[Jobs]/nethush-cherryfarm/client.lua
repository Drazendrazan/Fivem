QBCore = nil

Citizen.CreateThread(function()
	while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
    end
end)

local hasJob = false
local aajuns = true
local culege = false
local cursaf = false
local cutie = 0

function DrawText3D(x,y,z, text, scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function CreateCar(x,y,z,heading) -- spawn vehicle
	local hash = GetHashKey("kalahari")
    local n = 0
    while not HasModelLoaded(hash) and n < 500 do
        RequestModel(hash)
        Citizen.Wait(10)
        n = n+1
    end
    if HasModelLoaded(hash) then
        veh = CreateVehicle(hash,x,y,z,heading,true,false)
        SetEntityHeading(veh,heading)
        SetEntityInvincible(veh,false)
        SetModelAsNoLongerNeeded(hash)
        SetVehicleLights(veh,2)
        SetVehicleColours(veh,147,41)
        SetVehicleNumberPlateTextIndex(veh,2)
		SetVehicleNumberPlateText(veh,"CHERRYFARM")
		SetPedIntoVehicle(GetPlayerPed(-1),veh,-1)
		SetEntityAsMissionEntity(veh, true, true)
        for i = 0,24 do
            SetVehicleModKit(veh,0)
            RemoveVehicleMod(veh,i)
        end
    end    
end


local coordonate = {
    {376.74,6506.03,28.04},
    {369.99,6506.59,28.44},
    {363.18,6506.63,28.53},
    {355.2,6506.04,28.5},
    {347.63,6506.1,28.82},
    {339.82,6506.54,28.69},
    {330.91,6506.53,28.58},
    {321.62,6506.36,29.22},
    {321.88,6516.89,29.13},
    {330.51,6516.48,28.96},
    {338.59,6516.33,28.94},
    {347.66,6516.87,28.78},
    {355.04,6516.81,28.22},
    {362.6,6517.04,28.26},
    {369.81,6516.99,28.37},
    {377.89,6516.59,28.37},
    {369.43,6530.64,28.43},
    {361.66,6530.53,28.39},
    {353.68,6529.97,28.44},
    {346.18,6530.48,28.73},
    {338.55,6530.27,28.56},
    {329.79,6530.33,28.6},
    {322.19,6530.15,29.17},
    {2330.2463378906,5036.1245117188,44.325420379639},
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local metrii2 = math.floor(GetDistanceBetweenCoords(352.22,6512.19,28.52, GetEntityCoords(GetPlayerPed(-1))))
        local carPos = GetEntityCoords(veh, false)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        if cutie == 6 then      
            DrawText3D(carPos.x,carPos.y,carPos.z+2, "~r~Go sell the cherries", 1.2)
        end
        if not DoesEntityExist(veh) and hasJob then
            hasJob = false
            aajuns = false
            culege = false
            cutie = 0
        end
        if culege then
            if (Vdist(pos.x, pos.y, pos.z, carPos.x , carPos.y, carPos.z) <= 7.0) and DoesEntityExist(veh) then
                DrawText3D(carPos.x,carPos.y,carPos.z, "Press ~y~[E]~w~ to put the box in car", 1.2)
                DrawText3D(carPos.x,carPos.y,carPos.z+2, "~r~"..cutie.."~w~/~g~6", 1.2)
                if IsControlJustPressed(1,51) then
                    DeleteEntity(myObject)
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    culege = false
                    cutie = cutie + 1
                    if cutie == 1 then
                        local objectModel1 = GetHashKey("v_ind_cf_chckbox1")
                        myObject1 = CreateObject(objectModel1, carPos.x, carPos.y, carPos.z, true, true, false)
                        AttachEntityToEntity(myObject1, veh, veh, 0.23, -0.8,4, -0.5, 5.0, 0.0, 0.0, true, true, false, true, 1, true)
                    elseif cutie == 3 then  
                        local objectModel2 = GetHashKey("v_ind_cf_chckbox1")
                        myObject2 = CreateObject(objectModel2, carPos.x, carPos.y, carPos.z, true, true, false)
                        AttachEntityToEntity(myObject2, veh, veh, 0.13, -1.3,4, -0.9, 5.0, 0.0, 0.0, true, true, false, true, 1, true)
                    elseif cutie == 6 then  
                        local objectModel3 = GetHashKey("v_ind_cf_chckbox1")
                        myObject3 = CreateObject(objectModel3, carPos.x, carPos.y, carPos.z, true, true, false)
                        AttachEntityToEntity(myObject3, veh, veh, -0.23, -0.8,4, -0.9, 5.0, 0.0, 0.0, true, true, false, true, 1, true)
                        aajuns = false
                        cursaf = true
                        if cursaf then
                            SetNewWaypoint(2553.9436035156,4668.5922851563)
                            for i,v in pairs(coordonate) do
                                table.remove(coordonate,i)
                            end
                        end
                    end
                end 
            end
        end  
        if aajuns == true and hasJob == true then
            for i,v in pairs(coordonate) do
                if metrii2 <= 50 then
                    DrawMarker(2, v[1], v[2], v[3], 0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.4, 35, 170, 25, 165, 0, 0, 2, 1, 0, 1, 0,1)
                    local metrii3 = math.floor(GetDistanceBetweenCoords(v[1],v[2],v[3], GetEntityCoords(GetPlayerPed(-1))))
                    if metrii3 <= 2 then
                        DrawText3D(pos.x,pos.y,pos.z, "Press ~y~[E]~w~ to start picking cherries", 1.2)
                        if IsControlJustPressed(1,51) then
                            if (Vdist(pos.x, pos.y, pos.z, carPos.x , carPos.y, carPos.z) <= 50.0) and hasJob and aajuns and DoesEntityExist(veh) then
                                if culege == false then
                                    table.remove(coordonate,i)
                                    local playerPed = PlayerPedId()
                                    TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_PARKING_METER', 0, false)
                                    SetTimeout(10000, function()
                                        ClearPedTasks(playerPed)
                                        RequestAnimDict("anim@heists@box_carry@")
                                        TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
                                        local objectModel = GetHashKey("v_ind_cf_chckbox1")
                                        local pos = GetEntityCoords(GetPlayerPed(-1), true)
                                        local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
                                        RequestModel(objectModel)
                                        myObject = CreateObject(objectModel, pos.x, pos.y, pos.z, true, true, false)
                                        AttachEntityToEntity(myObject, PlayerPedId(), bone, 0.0, 0,4, -0.1, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                                        FreezeEntityPosition(myObject, true)
                                        SetEntityInvincible(myObject, true)
                                        SetEntityCollision(myObject,0,1)
                                        culege = true
            
                                        exports['swt_notifications']:Negative("SLMC System","Go to put the box with cherries in car","top-right",6000,true)

                                    end)
                                else
                                    exports['swt_notifications']:Negative("SLMC System","You are picking allready","top-right",6000,true)
                                end
                            else
                                exports['swt_notifications']:Negative("SLMC System","The car is not near","top-right",6000,true)
                            end
                        end
                    end
                end
            end
        end
        local metrii = math.floor(GetDistanceBetweenCoords(416.77,6520.83,27.71, GetEntityCoords(GetPlayerPed(-1))))
        if metrii <= 3 then
            DrawText3D(pos.x,pos.y,pos.z+0.6, "Press ~y~[E]~w~ to be an Cherries Farmer \n Press ~y~[Y]~w~ to sell the cherries", 1.2)
            if IsControlJustPressed(1,51) then
                if hasJob == false then
                    aajuns = true
                    hasJob = true
                    exports['swt_notifications']:Success("SLMC System","You have been hired","top-right",6000,true)
                    CreateCar(422.75,6523.09,27.28,100)
                    if hasJob then
                        SetNewWaypoint(351.84,6512.19)
                    end
                else
                    exports['swt_notifications']:Negative("SLMC System","You are already hired","top-right",6000,true)
                end
            elseif IsControlJustPressed(1,246) then
                if cursaf then
                    if DoesEntityExist(veh) then
                        DeleteEntity(veh)
                        DeleteEntity(myObject1)
                        DeleteEntity(myObject2)
                        DeleteEntity(myObject3)
                        hasJob = false
                        culege = false
                        cursaf = false
                        cutie = 0
                        table.insert(coordonate,{376.74,6506.03,28.04})
                        table.insert(coordonate,{369.99,6506.59,28.44})
                        table.insert(coordonate,{363.18,6506.63,28.53})
                        table.insert(coordonate,{355.2,6506.04,28.5})
                        table.insert(coordonate,{347.63,6506.1,28.82})
                        table.insert(coordonate,{339.82,6506.54,28.69})
                        table.insert(coordonate,{330.91,6506.53,28.58})
                        table.insert(coordonate,{321.62,6506.36,29.22})
                        table.insert(coordonate,{321.88,6516.89,29.13})
                        table.insert(coordonate,{330.51,6516.48,28.96})
                        table.insert(coordonate,{338.59,6516.33,28.94})
                        table.insert(coordonate,{347.66,6516.87,28.78})
                        table.insert(coordonate,{355.04,6516.81,28.22})
                        table.insert(coordonate,{362.6,6517.04,28.26})
                        table.insert(coordonate,{369.81,6516.99,28.37})
                        table.insert(coordonate,{377.89,6516.59,28.37})
                        table.insert(coordonate,{369.43,6530.64,28.43})
                        table.insert(coordonate,{361.66,6530.53,28.39})
                        table.insert(coordonate,{353.68,6529.97,28.44})
                        table.insert(coordonate,{346.18,6530.48,28.73})
                        table.insert(coordonate,{338.55,6530.27,28.56})
                        table.insert(coordonate,{329.79,6530.33,28.6})
                        table.insert(coordonate,{322.19,6530.15,29.17})
                        table.insert(coordonate,{2330.2463378906,5036.1245117188,44.325420379639})
                        TriggerServerEvent("hell_cherryfarmer:sell")
                    else
            
                        exports['swt_notifications']:Negative("SLMC System","You dont have a car","top-right",6000,true)

                    end
                else
                    exports['swt_notifications']:Negative("SLMC System","You have not finished","top-right",6000,true)
                end
            end
        end      
    end
end)
