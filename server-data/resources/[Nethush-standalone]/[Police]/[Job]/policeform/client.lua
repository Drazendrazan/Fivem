--colors
fullColor = 255
halfColor = 123
lowColor = 10

--scales
pointTwo = 0.2
pointoneSeven = 0.17
pointoneFive = 0.15
pointOne = 0.1
pointzeroSeven = 0.07
halfpointOne = 0.05
pointzeroThree = 0.03


local display = false


RegisterCommand("nui", function(source, args)
    SetDisplay(not display)
end)

--very important cb 
RegisterNUICallback("exit", function(data)

    SetDisplay(false)
end)


RegisterNUICallback("main", function(data)
    SetDisplay(false)
end)


function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)

        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end



function DrawText2(text)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.45)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.40, 0.10)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        displayText( -246.65, -921.2, 32.31  -0.700, "Job Applications", Config.r, Config.g, Config.b, pointOne, pointoneSeven)
        displayText( -244.77, -915.81, 32.31  -0.700, "Police Applications", Config.r, Config.g, Config.b, pointTwo, pointoneSeven) 
        if (GetDistanceBetweenCoords(pos, -246.85 , -911.75 , 32.34, true) < 3) then
            DrawMarker(2,-246.85 , -911.75 , 32.34 , 0.0, 0.0, 0.0, 300.0, 0.0, 0.0, 0.25, 0.25, 0.05, 0, 100, 255, 255, false, true, 2, false, false, false, false)
            DrawText3D(-246.85 , -911.75 , 32.31 + 0.2, "~b~[E]~w~ To Open A Form")
            if IsControlJustReleased(1, 38) then        
                SetDisplay(not display)
            end
		end
	end
end)


RegisterNUICallback('name', function(data, cb)
    TriggerServerEvent("log" , data)

end)

function displayText(x,y,z,textin3D,r,g,b,sizeonX,sizeonY)
    local playerx,playery,playerz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(playerx,playery,playerz, x,y,z, 1)    
    local size = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local size = size*fov   
          SetTextFont(Config.font)
          SetTextScale(sizeonX * size, sizeonY * size)
          SetTextProportional(1)
          SetTextCentre(1)
          SetTextColour(r, g, b, 255)
          SetTextDropshadow(10, Config.r, Config.g, Config.b, 255)
          SetTextEdge(5, 0, 0, 0, 255)
          SetTextOutline()
          SetTextEntry("STRING")
          AddTextComponentString(textin3D)
          SetDrawOrigin(x,y,z+2, 0)
          DrawText(0.0, 0.0)
          ClearDrawOrigin()
 end