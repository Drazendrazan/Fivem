local NearScrapYard = false
local CurrentScrapYard = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
         local PlayerCoords = GetEntityCoords(PlayerPedId())
         NearScrapYard = false
         for k, v in pairs(Config.ScrapyardLocations) do 
             local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
             if Area < 7.5 then
                CurrentScrapYard = k
                NearScrapYard = true
             end
         end
         if not NearScrapYard then
            Citizen.Wait(2500)
            CurrentScrapYard = false
         end
        end
    end
end)

RegisterNetEvent('nethush-materials:client:scrap:vehicle')
AddEventHandler('nethush-materials:client:scrap:vehicle', function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    --local veh = GetVehiclePedIsIn(PlayerPedId(),false)
    local driver = GetPedInVehicleSeat(Vehicle, -1)
    if Config.CanScrap then
        Config.CanScrap = false
	    QBCore.Functions.TriggerCallback('nethush-materials:server:is:vehicle:owned', function(IsOwned)
        if not IsOwned then
			if driver == PlayerPedId() then
            -- start scrap
            local Time = math.random(30000, 40000)
	        ScrapVehicleAnim(Time)
	    	QBCore.Functions.Progressbar("scrap-vehicle", "Scrapping the vehicle..", Time, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
               
                QBCore.Functions.DeleteVehicle(Vehicle)
                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                QBCore.Functions.TriggerCallback('nethush-materials:server:scrap:reward', function() end)
                Citizen.SetTimeout((1000 * 60) * 10, function()
                   Config.CanScrap = true
                end)
            end, function() -- Cancel
                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                TriggerEvent("swt_notifications:Infos","Canceled..")
            end)
            else
                TriggerEvent("swt_notifications:Infos","You are not in the drivers seat..")
            end

	    else
	    	TriggerEvent("swt_notifications:Infos","This vehicle is not scrapable..")									end
        end, GetVehicleNumberPlateText(Vehicle))
    else
      TriggerEvent("swt_notifications:Infos","You have to wait a little longer..")	
    end								
end)

function IsNearScrapYard()
  if IsPedSittingInAnyVehicle(PlayerPedId()) then
      return NearScrapYard
  else
      return false
  end
end

function ScrapVehicleAnim(time)
    time = (time / 1000)
    exports['nethush-assets']:RequestAnimationDict("mp_car_bomb")
    TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    Scrapping = true
    Citizen.CreateThread(function()
        while Scrapping do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
			time = time - 2
            if time <= 0 then
                Scrapping = false
                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end