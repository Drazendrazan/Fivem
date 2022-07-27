QBCore = nil

local isInJob = false
local isFull = false
local lockPlayerControls = false
local haspackage = false
local hasTrailer = false

local spawnId = 0
local truck	                    = 0
local trailer                   = 0



local randomVehicle 
local customersName 
local customersType
local customersPrice


local lasttype

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer) 
  vehiclehash = GetHashKey("hauler")
  RequestModel(vehiclehash)

  trailerHash = GetHashKey("tr4")
    RequestModel(trailerHash)
end)

RegisterNUICallback("exit", function(data) -- index.js ruft diesen Callback auf und dan passiert das was dadrin passiert
    SetDisplay(false, lasttype) -- Deaktviert die UI
    isMenuOpen = false
end)

function SetDisplay(bool, type)
    local countCar = 0
    QBCore.Functions.TriggerCallback('nethush_carDelivery:getCount', function(count)
        Citizen.Wait(200)
        countCar = count
    end)


    QBCore.Functions.TriggerCallback('nethush_carDelivery:getStorage', function(itemsToSale) 
        Citizen.Wait(500)
        display = bool
        SetNuiFocus(bool, bool)
        SendNUIMessage({
            type = "ui",
            status = bool,
            itemsToSale = itemsToSale,
            countCar = countCar,
            customersPrice = customersPrice,
            customersType = customersType,
            customersName = customersName
        })                
       
    end)

    
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)




Citizen.CreateThread(function()
    local markerPosition = Config.Locations[1]["pos"]


    while true do   
    Citizen.Wait(5)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)



    if not DoesBlipExist(blipBank) then
            blipBank= AddBlipForCoord(markerPosition["x"], markerPosition["y"], markerPosition["z"])
            SetBlipSprite(blipBank, Config.blipId)
            SetBlipDisplay(blipBank, 4)
            SetBlipScale(blipBank, 0.7)
            SetBlipColour(blipBank, Config.blipColor)
            SetBlipAsShortRange(blipBank, true)
    
            BeginTextCommandSetBlipName("rmzBankBlip")
            AddTextEntry("rmzBankBlip", "Car Delivery Service")
            EndTextCommandSetBlipName(blipBank)
    end

    
    if(GetDistanceBetweenCoords(coords, markerPosition["x"], markerPosition["y"], markerPosition["z"], true) < 8.0) then

            DrawMarker(25, markerPosition["x"], markerPosition["y"], markerPosition["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.2, 1.2, 1.0, 0, 174, 255, 100, false, true, 2, false, false, false, false)
            DrawMarker(29, markerPosition["x"], markerPosition["y"], markerPosition["z"]+0.90, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 195, 255, 100, false, true, 2, true, false, false, false)
            

        if(GetDistanceBetweenCoords(coords, markerPosition["x"], markerPosition["y"], markerPosition["z"], true) < 1.2) then
           
            if isInJob == false then
                DrawText3Ds(markerPosition["x"], markerPosition["y"], markerPosition["z"]+1.5, 'Press [E] to open the Delivery Panel.')

                if IsControlJustReleased(0, Keys['E']) then

                    SetDisplay(not display)
                    lasttype = "ui"
                end
            else
                DrawText3Ds(markerPosition["x"], markerPosition["y"], markerPosition["z"]+1.5, 'Please finish your job bevore start a new job.')

            end

                
        end

    end

    

    end


end)



 -- TRUNK  FUNCTION
 Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
        local Vehicle = GetVehiclePedIsIn(ped, true)
        local namecar = GetDisplayNameFromVehicleModel(GetEntityModel(Vehicle))
				if namecar == 'STOCKADE' then
					local trunkpos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -3.8, 0)
						if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunkpos.x, trunkpos.y, trunkpos.z, true) < 1.5 and isFull then
							if not haspackage then
								DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.15, "Press [E] to take a mail from trunk")
							end
							if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunkpos.x, trunkpos.y, trunkpos.z, true) < 1.5 then
								if IsControlJustReleased(0, 38) and not haspackage then
									haspackage = true

                                    TriggerEvent('rc_bankDelivery:SetOntoPlayer')

                                    TriggerEvent("pNotify:SendNotification", {
                                        text = "<b style='color:white'>Mail Delivery</b><br />   <br /> You take a mail from the trunk.",
                                        type = "success",
                                        timeout = 1400,
                                        layout = "centerRight",
                                        queue = "left",
                                        sounds = {
                                        sources = {"notificationSFX.wav"}, -- For sounds to work, you place your sound in the html folder and then add it to the files array in the __resource.lua file.
                                        volume = 0.2,
                                        conditions = {"docVisible"} -- This means it will play the sound when the notification becomes visible.
                                        }
                                    })
									
								end
							end
						end
        end
		Citizen.Wait(5)
	end
end)



RegisterNUICallback(
    "startDeliveryVehicle",
    function(data)

    
    TriggerServerEvent("nethush_carDelivery:startDeliveryJob", data.idItemBuy)
    

    TriggerEvent("pNotify:SendNotification", {
        text = "<b style='color:white'>Car Delivery Service</b><br />   <br /> Go outside and go in the car and drive this car to the customer.",
        type = "success",
        timeout = 5400,
        layout = "centerRight",
        queue = "left",
        sounds = {
        sources = {"notificationSFX.wav"}, -- For sounds to work, you place your sound in the html folder and then add it to the files array in the __resource.lua file.
        volume = 0.2,
        conditions = {"docVisible"} -- This means it will play the sound when the notification becomes visible.
        }
    })

    
    

end
)

RegisterNetEvent("nethush_carDelivery:startJobDeliverySpawn")
AddEventHandler("nethush_carDelivery:startJobDeliverySpawn", function(name,type,price)

    isInJob = true

    local vehSpawnPoint = Config.Locations[1]["spawnCustomersCars"]


    if not DoesBlipExist(blipDeliveryCar) then
        blipDeliveryCar= AddBlipForCoord(vehSpawnPoint["x"], vehSpawnPoint["y"], vehSpawnPoint["z"])
        SetBlipSprite(blipDeliveryCar, 128)
        SetBlipDisplay(blipDeliveryCar, 4)
        SetBlipScale(blipDeliveryCar, 1.0)
        SetBlipColour(blipDeliveryCar, Config.blipColor)
        SetBlipAsShortRange(blipDeliveryCar, true)
        SetBlipRoute(blipDeliveryCar, true)
        BeginTextCommandSetBlipName("blipDeliveryCar")
        AddTextEntry("blipDeliveryCar", "Customer Car")
        EndTextCommandSetBlipName(blipDeliveryCar)
        
    end

    local randomeVehNumber = math.random(1,5)

    customersName = name
    customersPrice = price
    customersType = type

    if Config.vehType[1] == type then
        if randomeVehNumber == 1 then
            randomVehicle = Config.compactsVehOne
        end
        if randomeVehNumber == 2 then
            randomVehicle = Config.compactsVehTwo
        end
        if randomeVehNumber == 3 then
            randomVehicle = Config.compactsVehThree
        end
        if randomeVehNumber == 4 then
            randomVehicle = Config.compactsVehFour
        end
        if randomeVehNumber == 5 then
            randomVehicle = Config.compactsVehFive
        end

    end

    if Config.vehType[2] == type then
        if randomeVehNumber == 1 then
            randomVehicle = Config.coupesVehOne
        end
        if randomeVehNumber == 2 then
            randomVehicle = Config.coupesVehTwo
        end
        if randomeVehNumber == 3 then
            randomVehicle = Config.coupesVehThree
        end
        if randomeVehNumber == 4 then
            randomVehicle = Config.coupesVehFour
        end
        if randomeVehNumber == 5 then
            randomVehicle = Config.coupesVehFive
        end

    end

    
    if Config.vehType[3] == type then
        if randomeVehNumber == 1 then
            randomVehicle = Config.suvVehOne
        end
        if randomeVehNumber == 2 then
            randomVehicle = Config.suvVehTwo
        end
        if randomeVehNumber == 3 then
            randomVehicle = Config.suvVehThree
        end
        if randomeVehNumber == 4 then
            randomVehicle = Config.suvVehFour
        end
        if randomeVehNumber == 5 then
            randomVehicle = Config.suvVehFive
        end

    end

    if Config.vehType[4] == type then
        if randomeVehNumber == 1 then
            randomVehicle = Config.superVehOne
        end
        if randomeVehNumber == 2 then
            randomVehicle = Config.superVehTwo
        end
        if randomeVehNumber == 3 then
            randomVehicle = Config.superVehThree
        end
        if randomeVehNumber == 4 then
            randomVehicle = Config.superVehFour
        end
        if randomeVehNumber == 5 then
            randomVehicle = Config.superVehFive
        end

    end


    if Config.vehType[5] == type then
        if randomeVehNumber == 1 then
            randomVehicle = Config.sportVehOne
        end
        if randomeVehNumber == 2 then
            randomVehicle = Config.sportVehTwo
        end
        if randomeVehNumber == 3 then
            randomVehicle = Config.sportVehThree
        end
        if randomeVehNumber == 4 then
            randomVehicle = Config.sportVehFour
        end
        if randomeVehNumber == 5 then
            randomVehicle = Config.sportVehFive
        end

    end









    QBCore.Game.SpawnVehicle(randomVehicle,  {x = vehSpawnPoint['x'], y = vehSpawnPoint['y'], z = vehSpawnPoint['z']}, vehSpawnPoint['h'], function(vehicle) 


        while true do
            Citizen.Wait(500)
            if IsPedInVehicle(PlayerPedId(), vehicle, true) then
                RemoveBlip(blipDeliveryCar)

                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))

                TriggerEvent("pNotify:SendNotification", {
                    text = "<b style='color:white'>Car Delivery Service</b><br />   <br /> Fine, now drive to customer and bring he the car.",
                    type = "success",
                    timeout = 5400,
                    layout = "centerRight",
                    queue = "left",
                    sounds = {
                    sources = {"notificationSFX.wav"}, -- For sounds to work, you place your sound in the html folder and then add it to the files array in the __resource.lua file.
                    volume = 0.2,
                    conditions = {"docVisible"} -- This means it will play the sound when the notification becomes visible.
                    }
                })

                haspackage = true

                startDeliver()

                break
            end


        end


    end)

end)


function startDeliver()

    local randomCustomer = math.random(1, Config.maxCustomersNumber)

    local customerPoint = Config.Customers[randomCustomer]["pos"]

    if not DoesBlipExist(blipCustomer) then
    blipCustomer= AddBlipForCoord(customerPoint["x"], customerPoint["y"], customerPoint["z"])
    SetBlipSprite(blipCustomer, 128)
    SetBlipDisplay(blipCustomer, 4)
    SetBlipScale(blipCustomer, 1.0)
    SetBlipColour(blipCustomer, Config.blipColor)
    SetBlipAsShortRange(blipCustomer, true)
    SetBlipRoute(blipCustomer, true)
    BeginTextCommandSetBlipName("blipCustomer")
    AddTextEntry("blipCustomer", "Customer Delivery Point")
    EndTextCommandSetBlipName(blipCustomer)
    
    end

    while haspackage do
    Citizen.Wait(5)

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)


    if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, customerPoint["x"], customerPoint["y"], customerPoint["z"], true) < 33 then

        DrawMarker(25, customerPoint["x"], customerPoint["y"], customerPoint["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.2,3.2,3.0, 0, 174, 255, 100, false, true, 2, false, falsed, false, false)
        DrawMarker(24, customerPoint["x"], customerPoint["y"], customerPoint["z"]+1.90, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 195, 255, 100, false, true, 2, false, false, false, false)

        local lastVehicle = GetVehiclePedIsIn(ped, false)
        
        if IsPedInVehicle(ped, lastVehicle, true) then
            if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, customerPoint["x"], customerPoint["y"], customerPoint["z"], true) < 3 then
                DrawText3Ds(customerPoint["x"], customerPoint["y"], customerPoint["z"]+1.5, 'Press [E] to finish your delivery.')

                if IsControlJustReleased(0, Keys['E']) then

                    display = true
                    SetNuiFocus(true, true)

                    lasttype = "protokol"
                    
                    SendNUIMessage({
                        type = "protokol",
                        status = true,
                        itemsToSale = itemsToSale,
                        countCar = countCar,
                        customersPrice = customersPrice,
                        customersType = customersType,
                        customersName = customersName
                    }) 

                    

                end
            end

        end


    end
    end


end

RegisterNUICallback(
    "finishDelivery",
    function(data)

    TriggerEvent("pNotify:SendNotification", {
            text = "<b style='color:white'>Car Delivery Service</b><br />   <br /> Thanks for delivery. Here is your payout $"..Config.payoutDeliverer.." ",
            type = "success",
            timeout = 5400,
            layout = "centerRight",
            queue = "left",
            sounds = {
            sources = {"notificationSFX.wav"}, -- For sounds to work, you place your sound in the html folder and then add it to the files array in the __resource.lua file.
            volume = 0.2,
            conditions = {"docVisible"} -- This means it will play the sound when the notification becomes visible.
            }
    })
    
    isInJob = false

    haspackage = false
    
    local curVeh = GetVehiclePedIsIn(PlayerPedId(), false)

    QBCore.Functions.DeleteVehicle(curVeh)

    TriggerServerEvent("nethush_carDelivery:payout", Config.payoutDeliverer)
    RemoveBlip(blipCustomer)

end
)





RegisterNUICallback(
    "startPickup",
    function(data)
      --  local checkPos = IsSpawnPointClear(Config.CarClearPos, 10)
   -- if checkPos then

        local markerPositionTruckSpawn = Config.Locations[1]["spawnPointTruck"]

    
        if not DoesBlipExist(blipSpawnTruck) then
            blipSpawnTruck= AddBlipForCoord(markerPositionTruckSpawn["x"], markerPositionTruckSpawn["y"], markerPositionTruckSpawn["z"])
            SetBlipSprite(blipSpawnTruck, 128)
            SetBlipDisplay(blipSpawnTruck, 4)
            SetBlipScale(blipSpawnTruck, 1.0)
            SetBlipColour(blipSpawnTruck, Config.blipColor)
            SetBlipAsShortRange(blipSpawnTruck, true)
            SetBlipRoute(blipSpawnTruck, true)
            BeginTextCommandSetBlipName("blipSpawnTruck")
            AddTextEntry("blipSpawnTruck", "Truck | Pick up Service")
            EndTextCommandSetBlipName(blipSpawnTruck)
            
        end
        
        isInJob = true
        
        spawnTruck(1)

        TriggerEvent("pNotify:SendNotification", {
            text = "<b style='color:white'>Car Pickup Service</b><br />   <br /> Drive to the port and pick up the truck and then drive to the dealer and charge vehicles.",
            type = "success",
            timeout = 5400,
            layout = "centerRight",
            queue = "left",
            sounds = {
            sources = {"notificationSFX.wav"}, -- For sounds to work, you place your sound in the html folder and then add it to the files array in the __resource.lua file.
            volume = 0.2,
            conditions = {"docVisible"} -- This means it will play the sound when the notification becomes visible.
            }
        })

end
)



function spawnTruck(spawn)


    spawnId = 1
    
    local markerPositionSpawn1 = Config.Locations[1]["spawnPointTruck"]
    local markerPositionSpawn2 = Config.Locations[1]["spawnPointTruck2"]
    local spawnPointTrailer  = Config.Locations[1]["spawnPointTrailer"]

    local currentTruck

    QBCore.Functions.TriggerCallback('nethush_carDelivery:spawnVehicle', function() 
        Citizen.Wait(500)

        if spawnId == 1 then
             
                vehiclehash = GetHashKey("hauler")
                RequestModel(vehiclehash)
                vehicle = CreateVehicle(vehiclehash, markerPositionSpawn1["x"],markerPositionSpawn1["y"], markerPositionSpawn1["z"], markerPositionSpawn1["h"], 1, 0)
               
                local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(vehicle,  0.0, 8.0, 0.5))

                trailerHash = GetHashKey("tr2")
                RequestModel(trailerHash)

                trailer = CreateVehicle(trailerHash, x,y,z, markerPositionSpawn1['h'], 1, 0)
                AttachVehicleToTrailer(vehicle, trailer, 15)

                local isInVehicle = false


                while not isInVehicle do
                    Citizen.Wait(5)
                    local ped = PlayerPedId()
                    local coords = GetEntityCoords(ped)

                    

                    if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, markerPositionSpawn1["x"], markerPositionSpawn1["y"], markerPositionSpawn1["z"], true) < 3 then

                        RemoveBlip(blipSpawnTruck)

                        if IsPedInVehicle(ped, vehicle, true) then
                            isInVehicle = true
                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))

                            TriggerEvent("pNotify:SendNotification", {
                                text = "<b style='color:white'>Car Pickup Service</b><br />   <br /> Drive to the point and connect the trailer.",
                                type = "success",
                                timeout = 5400,
                                layout = "centerRight",
                                queue = "left",
                                sounds = {
                                sources = {"notificationSFX.wav"}, -- For sounds to work, you place your sound in the html folder and then add it to the files array in the __resource.lua file.
                                volume = 0.2,
                                conditions = {"docVisible"} -- This means it will play the sound when the notification becomes visible.
                                }
                            })

                            

                            


                            test()

                        


                        end

                    end


                end


        end        
        
                
           
       
        
       
    end)



end


RegisterCommand("TEST1", function()

    spawnFullTrailer()



end)


function spawnFullTrailer()
    local truck = GetVehiclePedIsIn(PlayerPedId(), false)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
     QBCore.Functions.TriggerCallback('nethush_carDelivery:spawnVehicle', function() 
        QBCore.Functions.DeleteVehicle(truck)
        vehiclehash = GetHashKey("hauler")
        RequestModel(vehiclehash)
        truck = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId()), 1, 0)
        TaskWarpPedIntoVehicle(PlayerPedId(), truck, -1)
        trailerHash = GetHashKey("tr4")
        RequestModel(trailerHash)
        trailer = CreateVehicle(trailerHash, x, y, z, GetEntityHeading(PlayerPedId()), 1, 0)
        AttachVehicleToTrailer(truck, trailer, 15)
        
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(truck))
    end)
end

function test2()

    DoScreenFadeOut(200)
    Citizen.Wait(300)
    spawnFullTrailer()

    lockPlayerControls = true
    disableControls()

    TriggerEvent("pNotify:SendNotification", {
        text = "<b style='color:white'>Car Pickup Service</b><br />   <br /> Trailer is filled with vehicles. Please wait...",
        type = "success",
        timeout = 20000,
        layout = "centerRight",
        queue = "left",
        sounds = {
        sources = {"notificationSFX.wav"}, 
        volume = 0.2,
        conditions = {"docVisible"} 
        }
    })

    Citizen.Wait(20000)

    DoScreenFadeIn(200)
    isFull = true
    
    lockPlayerControls = false
    RemoveBlip(blipFillTrailer)

    TriggerEvent("pNotify:SendNotification", {
        text = "<b style='color:white'>Car Pickup Service</b><br />   <br />Trailer is full. Drive back to vehicle shop and load out the vehicles.",
        type = "success",
        timeout = 5000,
        layout = "centerRight",
        queue = "left",
        sounds = {
        sources = {"notificationSFX.wav"}, 
        volume = 0.2,
        conditions = {"docVisible"} 
        }
    })

   createLoadoutPoint()

end


function test()
        local markerPosition = Config.Locations[1]["pointFillTrailer"]
        local ped = PlayerPedId()



        if not DoesBlipExist(blipFillTrailer) then
            blipFillTrailer= AddBlipForCoord(markerPosition["x"], markerPosition["y"], markerPosition["z"])
            SetBlipSprite(blipFillTrailer, 128)
            SetBlipDisplay(blipFillTrailer, 4)
            SetBlipScale(blipFillTrailer, 1.0)
            SetBlipColour(blipFillTrailer, Config.blipColor)
            SetBlipAsShortRange(blipFillTrailer, true)
            SetBlipRoute(blipFillTrailer, true)
            BeginTextCommandSetBlipName("blipFillTrailer")
            AddTextEntry("blipFillTrailer", "Fill Trailer")
            EndTextCommandSetBlipName(blipFillTrailer)
            
        end



    
    
        while not isFull do
        Citizen.Wait(5)
        local coords = GetEntityCoords(ped)
        local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local namecar = GetDisplayNameFromVehicleModel(GetEntityModel(Vehicle))
    
        if isInJob and namecar == 'HAULER' then
            DrawMarker(25, markerPosition["x"], markerPosition["y"], markerPosition["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.2,3.2,3.0, 0, 174, 255, 100, false, true, 2, false, falsed, false, false)
            DrawMarker(24, markerPosition["x"], markerPosition["y"], markerPosition["z"]+1.90, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 195, 255, 100, false, true, 2, false, false, false, false)
            
            if(GetDistanceBetweenCoords(coords, markerPosition["x"], markerPosition["y"], markerPosition["z"], true) < 3) then
                DrawText3Ds(markerPosition["x"], markerPosition["y"], markerPosition["z"]+3.5, 'Press [E] to fill the trailer with vehicles.')
    
                if IsControlJustReleased(0, Keys['E']) then
                    test2()
                    break

                    
                   
                end
    
            end
            
        end
              
    
    
    end
    
    
    

end





function createLoadoutPoint()
    local markerPosition = Config.Locations[1]["loadoutVehicles"]
    local ped = PlayerPedId()


    if not DoesBlipExist(blipLoadout) then
        blipLoadout= AddBlipForCoord(markerPosition["x"], markerPosition["y"], markerPosition["z"])
        SetBlipSprite(blipLoadout, 128)
        SetBlipDisplay(blipLoadout, 4)
        SetBlipScale(blipLoadout, 1.0)
        SetBlipColour(blipLoadout, Config.blipColor)
        SetBlipAsShortRange(blipLoadout, true)
        SetBlipRoute(blipLoadout, true)
        BeginTextCommandSetBlipName("blipLoadout")
        AddTextEntry("blipLoadout", "Unloading point")
        EndTextCommandSetBlipName(blipLoadout)
        
    end


    while isFull do
        Citizen.Wait(5)
        local coords = GetEntityCoords(ped)
        local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local namecar = GetDisplayNameFromVehicleModel(GetEntityModel(Vehicle))
    
        if isInJob and namecar == 'HAULER' then
            DrawMarker(25, markerPosition["x"], markerPosition["y"], markerPosition["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.2,3.2,3.0, 0, 174, 255, 100, false, true, 2, false, falsed, false, false)
            DrawMarker(24, markerPosition["x"], markerPosition["y"], markerPosition["z"]+1.90, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 195, 255, 100, false, true, 2, false, false, false, false)

            if(GetDistanceBetweenCoords(coords, markerPosition["x"], markerPosition["y"], markerPosition["z"], true) < 4) then
                DrawText3Ds(markerPosition["x"], markerPosition["y"], markerPosition["z"]+3.5, 'Press [E] to unload the trailer.')

                if IsControlJustReleased(0, Keys['E']) then

                    QBCore.Functions.DeleteVehicle(Vehicle)

                    TriggerEvent("pNotify:SendNotification", {
                        text = "<b style='color:white'>Car Pickup Service</b><br />   <br />Thanks for deliver. You become $"..Config.payoutTrucker.."",
                        type = "success",
                        timeout = 5000,
                        layout = "centerRight",
                        queue = "left",
                        sounds = {
                        sources = {"notificationSFX.wav"}, 
                        volume = 0.2,
                        conditions = {"docVisible"} 
                        }
                    })

                    RemoveBlip(blipLoadout)

                    isInJob = false
                    isFull = false
                    hasTrailer = false
                    spawnId = 0

                    TriggerServerEvent("nethush_carDelivery:addVehicles")
                    TriggerServerEvent("nethush_carDelivery:payout", Config.payoutTrucker)
                end
                

            end
            
        end
    end


end



function disableControls()
	Citizen.CreateThread(function()
		while lockPlayerControls do
			Citizen.Wait(1)

			DisableControlAction(0, 1, true) 				-- Disable pan
			DisableControlAction(0, 2, true) 				-- Disable tilt
			DisableControlAction(0, 24, true) 				-- Attack
			DisableControlAction(0, 257, true) 				-- Attack 2
			DisableControlAction(0, 25, true) 				-- Aim
			DisableControlAction(0, 263, true) 				-- Melee Attack 1

			DisableControlAction(0, Keys['R'], true) 		-- Reload
			DisableControlAction(0, Keys['SPACE'], true) 	-- Jump
			DisableControlAction(0, Keys['TAB'], true) 		-- Select Weapon
			DisableControlAction(0, Keys['F'], true) 		-- Also 'enter'?

			DisableControlAction(0, Keys['F2'], true) 		-- Inventory
			DisableControlAction(0, Keys['F3'], true) 		-- Animations
			DisableControlAction(0, Keys['F5'], true) 		-- Bag
			DisableControlAction(0, Keys['F6'], true) 		-- Job & Panicbutton
			DisableControlAction(0, Keys['F7'], true) 		-- Billing
			DisableControlAction(0, Keys['F9'], true) 		-- Job

			DisableControlAction(0, Keys['V'], true) 		-- Disable changing view
			DisableControlAction(0, Keys['C'], true) 		-- Disable looking behind
			DisableControlAction(2, Keys['P'], true)		-- Disable pause screen

			DisableControlAction(0, 59, true) 				-- Disable steering in vehicle
			DisableControlAction(0, 71, true) 				-- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) 				-- Disable reversing in vehicle

			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

			DisableControlAction(0, 47, true)  				-- Disable weapon
			DisableControlAction(0, 264, true) 				-- Disable melee
			DisableControlAction(0, 257, true) 				-- Disable melee
			DisableControlAction(0, 140, true) 				-- Disable melee
			DisableControlAction(0, 141, true) 				-- Disable melee
			DisableControlAction(0, 142, true) 				-- Disable melee
			DisableControlAction(0, 143, true) 				-- Disable melee
			DisableControlAction(0, 75, true)  				-- Disable exit vehicle
			DisableControlAction(27, 75, true) 				-- Disable exit vehicle
		end
	end)
end











function DrawText3Ds(x, y, z, text)
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