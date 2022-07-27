--- CODEM STORE  https://discord.gg/YZMZsv4yCy ---- 
--- CODEM STORE  https://discord.gg/YZMZsv4yCy ---- 
--- CODEM STORE  https://discord.gg/YZMZsv4yCy ---- 
--- CODEM STORE  https://discord.gg/YZMZsv4yCy ---- 
--- CODEM STORE  https://discord.gg/YZMZsv4yCy ---- 


QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(1321.95, -742.47, 65.9190)
    SetBlipSprite (blip, 126)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.5)
    SetBlipColour (blip, 46)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('House Creater Job Finish')
    EndTextCommandSetBlipName(blip)

    local blip3 = AddBlipForCoord(1323.20, -744.27, 65.8939)
        SetBlipSprite (blip3, 642)
        SetBlipDisplay(blip3, 4)
        SetBlipScale  (blip3, 0.5)
        SetBlipColour (blip3, 25)
        SetBlipAsShortRange(blip3, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('House Creater Job')
        EndTextCommandSetBlipName(blip3)
    end)


function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end




local nexLocation = 1
local nextspawnlocation = 1


local work, collected = false, false

 
function createped()
    for k, v in pairs(Config['house']['peds']) do
        loadModel(v['model'])
        NPC = CreatePed(26, GetHashKey(v['model']), v['coords'], v['heading'], true, true)
        TaskStartScenarioInPlace(NPC,v['anim'], 0, true)
        print(NPC)
    end
end   

say = {}
local busy = false
local blip = true
RegisterNetEvent('mission:start')
AddEventHandler('mission:start', function()
    TriggerEvent("swt_notifications:Success","SLMC System",Strings['go_blip'],"top-right",8000,true)


    while true do
        local time = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local prp = `prop_fncwood_02b`
        while not HasModelLoaded(prp) do
            Wait(0)
            RequestModel(prp)
        end
    --    if ESX then
            if #(playerCoords - Config['house']['housecoords']['missionstart']) < 20 and not work and  blip then
                time = 1
                DrawMarker(2, Config['house']['housecoords']['missionstart'].x,Config['house']['housecoords']['missionstart'].y,Config['house']['housecoords']['missionstart'].z - 0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5,100, 253, 7, 100, false, true, 2, false, false,false, false)
                if #(playerCoords -
                    Config['house']['housecoords']['missionstart']) < 2 then
                    ShowHelpNotification(Strings['jobstart'])
                    if IsControlJustReleased(0, 38) then
                        work = true
                        createped()

                    end
                end
            end

           

                if #(playerCoords - Config['house']['location'][nexLocation].coords) < 20 and not busy and work and not collected then
                    time = 1
                    DrawMarker(2, Config['house']['location'][nexLocation].coords.x, Config['house']['location'][nexLocation].coords.y,Config['house']['location'][nexLocation].coords.z - 0.2, 0.0, 0.0, 0.0, 0,0.0, 0.0, 0.5, 0.5, 0.5, 100, 253, 7, 100, false,true, 2, false, false, false, false)
                    if #(playerCoords - Config['house']['location'][nexLocation].coords) < 2.3 then
                        if IsControlJustReleased(0, 38) then
                        
                            wall = CreateObject(prp, Config['house']['location'][nexLocation].objecoords.x, Config['house']['location'][nexLocation].objecoords.y,Config['house']['location'][nexLocation].objecoords.z, 1, 0, 0)
                            SetEntityHeading(wall , Config['house']['location'][nexLocation].heading)
                            busy = true
                            TaskStartScenarioInPlace(playerPed,'WORLD_HUMAN_HAMMERING', 2.0, true)
                            Citizen.Wait(2000)
                            ClearPedProp(ped, 0)
                            ClearPedTasks(ped)
                            ClearPedTasksImmediately(playerPed)
                            busy = false
                            nexLocation = nexLocation + 1
                            nextspawnlocation = nextspawnlocation + 1
                            
                            table.insert(say , nexLocation)
                             if #say >= 39 then
                                print('geldi')
                                    TriggerEvent('mission:finish')
                                    work = false
                                    blip = false
                        
                                 
                             else
                            
                                ShowHelpNotification(Strings['jobstart2'])
                                print('yuh')
                            end

                        end
                   
                end
                

            end
        Citizen.Wait(time)
    end
end)

RegisterNetEvent('mission:finish')
AddEventHandler('mission:finish', function()
    TriggerEvent("swt_notifications:Success","SLMC System","Go to Finish Blip and Press [E]","top-right",8000,true)
    TriggerServerEvent('nethush-house:Pay')
    while true do
        local time = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local homeprp = `lf_house_11_`
        while not HasModelLoaded(homeprp) do
            Wait(0)
            RequestModel(homeprp)
         
        end
      --  if ESX then
            if #(playerCoords - Config['house']['housecoords']['missionfinish']) < 20 and not blip then
                time = 1
                DrawMarker(2, Config['house']['housecoords']['missionfinish'].x,Config['house']['housecoords']['missionfinish'].y,Config['house']['housecoords']['missionfinish'].z - 0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5,100, 253, 7, 100, false, true, 2, false, false,false, false)
                if #(playerCoords -Config['house']['housecoords']['missionfinish']) < 2 then
                    ShowHelpNotification(Strings['rappel_start'])
                    
                    if IsControlJustReleased(0, 38) then
                        DoScreenFadeOut(1000)
                        Citizen.Wait(1000)
                        home = CreateObject(homeprp, 1319.40, -758.03, 64.11, 1, 0, 0)
                        FreezeEntityPosition(home, true)
                        SetEntityHeading(home , 165.78)
                        Citizen.Wait(1000)
                        DoScreenFadeIn(1000)
                        cams()
                        Citizen.Wait(86400000) --- 1 DAYS
                        blip = true 
                        work = false
                        
                    end
                end
            end

                

        
       -- end
        Citizen.Wait(time)
    end
end)


function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end








function cams()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", vector3(1327.93, -723.94, 65.8564), 10.00, 0.0, 180.00, 50.00, false, 0)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",vector3(1319.73, -740.40, 65.8645) , 10.00,0.0, 180.00, 50.00, false, 0)
    SetCamRot(cam, -10.0, 10.0, 5.0 ,2)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 2000, true, true)
    SetCamActiveWithInterp(cam2, cam, 6000, true, true)   
    Citizen.Wait(8000)  
    cam3 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", vector3(1310.97, -742.94, 66.3282), 10.00, 0.0, 250.00, 50.00, false, 0)
    cam4 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",vector3(1304.76, -763.63, 67.6669) , 10.00,0.0, 250.00, 50.00, false, 0)
    SetCamActive(cam3, true)
    RenderScriptCams(true, false, 2000, true, true)
    SetCamActiveWithInterp(cam4, cam3, 6000, true, true)   
    Citizen.Wait(8000)  

    cam5 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", vector3(1304.93, -768.60, 66.9481), 10.00, 0.0, 360.00, 50.00, false, 0)
    cam6 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",vector3(1326.52, -773.77, 67.4292) , 10.00,0.0, 360.00, 50.00, false, 0)
    SetCamActive(cam5, true)
    RenderScriptCams(true, false, 2000, true, true)
    SetCamActiveWithInterp(cam6, cam5, 6000, true, true)   
    Citizen.Wait(8000)  

    cam7 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", vector3(1328.09, -772.21, 67.4707), 10.00, 0.0, -250.0, 50.00, false, 0)
    cam8 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",vector3(1333.71, -751.56, 66.9230) , 10.00,0.0, -250.00, 50.00, false, 0)
    SetCamActive(cam7, true)
    RenderScriptCams(true, false, 2000, true, true)
    SetCamActiveWithInterp(cam8, cam7, 6000, true, true)   
    Citizen.Wait(8000) 

    RenderScriptCams(false, false, 200, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)

    RenderScriptCams(false, false, 2000, true, true)
    SetCamActive(cam3, false)
    DestroyCam(cam3, true)
    SetCamActive(cam4, false)
    DestroyCam(cam4, true)
end