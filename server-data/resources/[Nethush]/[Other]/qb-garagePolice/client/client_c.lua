-------------------------
--Written by CODERC-SLO-
--------Slo#0669---------

----TEXT-----------------
local textgar = '~g~[E]~w~ Get car '
local textDel = '~g~[E]~w~ Park your car'
local textCarP = '~g~[G]~w~ Pay Parking Card'
-------------------------
local ClosestBerth = 1
------------------------

------------------CONFIG-----------------------------
local delX = 213.38  --del auto 
local delY = -796.2
local delZ = 30.96
----------------------------------------------------

----------garage Noleggio central park----------------------------
--Auto standard------------------
local sellX = 223.01  
local sellY = -798.85
local sellZ = 30.67
local model1 = 'btype3' --model
--4x4------------------
local sellX2 = 224.95  
local sellY2 = -793.81
local sellZ2 = 30.67
local model2 = 'btype3' --model
--moto------------------
local sellX3 = 226.73  
local sellY3 = -788.87
local sellZ3 = 30.67
local model3 = 'btype3' --model
--blindato------------------
local sellX4 = 228.42  
local sellY4 = -783.99
local sellZ4 = 30.71
local model4 = 'btype3' --model
--auto 5------------------
local sellX5 = 230.33  
local sellY5 = -778.55
local sellZ5 = 30.72
local model5 = 'btype3' --model
----------------------------------------------------
--Pay parking card------------------
local sellX6 = 215.3  
local sellY6 = -809.77
local sellZ6 = 30.74
local model6 = 'btype3' --model
----------------------------------------------------
----------------------------------------------------
---timer rent car-----------------------------------
local secondi = 0
local minuti = 0
local hore = 0
local vistimer = false
local coordsVisible = false
local bonus = 0

----------------------------------------------------
--------------
local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

QBCore = nil 

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
	
	while QBCore.Functions.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
    PlayerData = QBCore.Functions.GetPlayerData()
    Citizen.Wait(10)
end)

--onload player
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        PlayerData = QBCore.Functions.GetPlayerData()
    end)
    
end)

--setjob
RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)
---
------------------------------------TEXT DRAW3D------------------------
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3D2(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end

--del veicolo scadenza tempo noleggio
function delve()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    vehicle = QBCore.Functions.GetClosestVehicle()
    QBCore.Functions.DeleteVehicle(vehicle)
    TriggerEvent('swt_notifications:Infos','RENT CAR TIME OUT')
end


-----------------------------timer rentcar
Citizen.CreateThread(function()
    while true do
        
         
		local sleepThread2 = 1000
		if coordsVisible then
			sleepThread2 = 1000
			secondi = secondi +1
			if secondi == 59 then
              secondi = 0
              
             delve()

               minuti = minuti + 1
               ----
               coordsVisible = false 
						vistimer = false
						secondi = 0
						minuti = 0
						hore = 0
                        bonus = 0
                      --  TriggerEvent('swt_notifications:Infos','RENT CART TIME OUT', 'success',10000)
			    if minuti == 59 then
				    minuti = 0
				    hore = hore + 1
				    if hore == 1 then
						coordsVisible = false 
						vistimer = false
						secondi = 0
						minuti = 0
						hore = 0
						bonus = 0
						
				    end
			    end
	  		end
		end
		Citizen.Wait(sleepThread2)
	end
end)
-----------------on text
Citizen.CreateThread(function()
    while true do
		local sleepThread = 250
		
		if coordsVisible then
			sleepThread = 5
			
			--DrawGenericText('Hai un ora di temp- '..'Hour: '.. hore .. ' minut:' .. minuti .. ' second:'.. secondi ..'')
			DrawGenericText(("~r~Hour~w~: %s ~b~Minut~w~: %s ~y~Second~w~: %s"):format(hore, minuti, secondi))
		end

		Citizen.Wait(sleepThread)
	end
end)
function DrawGenericText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(7)
	SetTextScale(0.300, 0.300)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString('CAR RENTAL 1 HOUR: '..text..'')
	DrawText(0.40, 0.00)
end

--------------------------------------------------------------------
----parcheggia auto-------------------------------------------------
Citizen.CreateThread(function()
    while true do
	Citizen.Wait(10)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, delX, delY, delZ)
        local ped = GetPlayerPed(-1)
        local vehicled = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        local veh2 = GetVehiclePedIsIn(ped)

		if dist <= 10.0 then
        DrawMarker(20, delX, delY, delZ, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0.2, 255, 0, 0, 255, false, false, false, true, false, false, false)
        DrawMarker(25, delX, delY, delZ-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 0, 0, 200, 0, 0, 0, 0)
		else
		Citizen.Wait(1500)
		end
		
		if dist <= 2.5 then
				
            if GetPedInVehicleSeat(vehicled, -1) == GetPlayerPed(-1) then
                DrawText3D2(delX, delY, delZ, ''..textDel..'')
                           
                if IsControlJustPressed(0, Keys['E']) then 
                     
                    QBCore.Functions.DeleteVehicle(veh2)
                    coordsVisible = false 
                    vistimer = false
                    secondi = 0
                    minuti = 0
                    hore = 0
                    bonus = 0
                end	

            else
        
		    end		
		end
	end
end)
-------------------------------------fine cancella auto---------------------------------------------------------------

-----########################################################################################################---------

------------------------------------marker prendi auto ---------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        -----------------------------------------------LOCAL------------------------------------------------------

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        ---local distanza marker 1----------------------
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX, sellY, sellZ)
        

        ---end local distanza marker 1------------------
       
        local vehicled = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        local playerPeds = PlayerPedId()

        -------------------------------------------primo marker pavimento----------------------------------------

		if dist <= 3.0 then
			DrawMarker(25, sellX, sellY, sellZ-0.96, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
		
        end
                         

       
        -------------------------------------------fine marker pavimento-----------------------------------------
        --####################################################################################################---
        -------------------------------------------ingresso in marker 1--------------------------------------------
        if dist <= 1.0 then

            ---------------------------------------eseguo il controllo se sono in macchina----------------------
		    if GetPedInVehicleSeat(vehicled, -1) == GetPlayerPed(-1) then
              ----se sono in macchina non esegue nessuna funzione
            else
                ----se sono a piedi eseguo il codice---------------------------------------

                -------------creo il testo-------------------------------------------------
                DrawText3D2(sellX, sellY, sellZ+0.1,''..textgar..' Model: '..model1..'')
                ---------------------------------------------------------------------------
                -------------creo il marker------------------------------------------------
                DrawMarker(20, CashoutPolicega.SpawnVehicle.x, CashoutPolicega.SpawnVehicle.y, CashoutPolicega.SpawnVehicle.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.1, 0.2, 15, 255, 55, 255, true, false, false, true, false, false, false)
                ---------------------------------------------------------------------------

                -----------pressione tasto E-----------------------------------------------
                if IsControlJustPressed(0, Keys['E']) then 

                -----------locali di controllo---------------------------------------------
                local hasBag4g = false
				local s1 = false
				-----------eseguo il controllo se ho la carta parking----------------------
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag4g = result
					s1 = true
                end, 'carking')
                while(not s1) do
					Citizen.Wait(100)
				end
                if (hasBag4g) then
                    ----notifica preparazione auto e benzina-------------------------------------------
                    TriggerEvent('swt_notifications:Infos','I\'m preparing your car, 100% fuel.')
                    -----------------------------------------------------------------------------------

                    ----creo animazione---------------------------------------------------------------
                    TaskStartScenarioInPlace(playerPeds, "PROP_HUMAN_PARKING_METER", 0, true)
                    SetEntityHeading(PlayerPedId(), 65.45)
                    ----------------------------------------------------------------------------------

                    ----creo la progress Bar----------------------------------------------------------
                    QBCore.Functions.Progressbar("search_register", "Insert code card..", 8000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()
                                    
                        local timeLeft = 1000 * 1 / 1000
                
                        while timeLeft > 0 do
                            Citizen.Wait(1000)
                            timeLeft = timeLeft - 1
                            ClearPedTasks(GetPlayerPed(-1))
                            ----cancello animazione
                            Citizen.Wait(500)

                            -------------------------------terminato il timer creo l'auto------------------------------------------
                                TriggerServerEvent('qb-diving:server:generateAuto', model1, ClosestBerth)
                            ------------------------------------------------------------------------------------------------------
                            coordsVisible = true
                        end
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
                    end, function()
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
               
                    end)
                    ----------------fine progress Bar-----------------------------------------------------------------------------

                 
                else
                    TriggerEvent('swt_notifications:Infos','You dont have enough Parking Card.')
                    
                end
                ---------------------------------------------fine controllo card parking-------------------------------------------

                end	
                -----------------------------------------------fine pressione tasto-----------------------------------------------
              
                
            end
            -----------------------------------------------fine controllo se sono in  macchina---------------------------------------
		
		end	
        ---------------------------------------------------fine ingresso marker 1-------------------------------------------------------


    end
    -------fine while-------------------------------------------------------------------------------------------------
end)
-----------------------------------------------------------fine creazione prendi auto-------------------------------------------------

--2

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        ---local distanza marker 1----------------------
        
        local dist2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX2, sellY2, sellZ2)
        
        ---end local distanza marker 1------------------
        local ped = GetPlayerPed(-1)
        local vehicled = GetVehiclePedIsIn(GetPlayerPed(-1), true)
      
        local playerPeds = PlayerPedId()
        --------------------------------------------------
         -------------------------------------------secondo marker pavimento----------------------------------------
         if dist2 <= 3.0 then
			DrawMarker(25, sellX2, sellY2, sellZ2-0.96, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
		
        end
         ---#############################################################################################################################
         -------------------------------------------ingresso in marker 2--------------------------------------------
         if dist2 <= 1.0 then

            ---------------------------------------eseguo il controllo se sono in macchina----------------------
		    if GetPedInVehicleSeat(vehicled, -1) == GetPlayerPed(-1) then
              ----se sono in macchina non esegue nessuna funzione
            else
                ----se sono a piedi eseguo il codice---------------------------------------

                -------------creo il testo-------------------------------------------------
                DrawText3D2(sellX2, sellY2, sellZ2+0.1,''..textgar..' Model: '..model2..'')
                ---------------------------------------------------------------------------
                -------------creo il marker------------------------------------------------
                DrawMarker(20, CashoutPolicega.SpawnVehicle.x, CashoutPolicega.SpawnVehicle.y, CashoutPolicega.SpawnVehicle.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.1, 0.2, 15, 255, 55, 255, true, false, false, true, false, false, false)
                ---------------------------------------------------------------------------

                -----------pressione tasto E-----------------------------------------------
                if IsControlJustPressed(0, Keys['E']) then 

                -----------locali di controllo---------------------------------------------
                local hasBag4g = false
				local s1 = false
				-----------eseguo il controllo se ho la carta parking----------------------
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag4g = result
					s1 = true
                end, 'carking')
                while(not s1) do
					Citizen.Wait(100)
				end
                if (hasBag4g) then
                    ----notifica preparazione auto e benzina-------------------------------------------
                    TriggerEvent('swt_notifications:Infos','I\'m preparing your car, 100% fuel.', 'success',10000)
                    -----------------------------------------------------------------------------------

                    ----creo animazione---------------------------------------------------------------
                    TaskStartScenarioInPlace(playerPeds, "PROP_HUMAN_PARKING_METER", 0, true)
                    SetEntityHeading(PlayerPedId(), 65.45)
                    ----------------------------------------------------------------------------------

                    ----creo la progress Bar----------------------------------------------------------
                    QBCore.Functions.Progressbar("search_register", "Insert code card..", 8000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()
                                    
                        local timeLeft = 1000 * 1 / 1000
                
                        while timeLeft > 0 do
                            Citizen.Wait(1000)
                            timeLeft = timeLeft - 1
                            ClearPedTasks(GetPlayerPed(-1))
                            ----cancello animazione
                            Citizen.Wait(500)

                            -------------------------------terminato il timer creo l'auto------------------------------------------
                                TriggerServerEvent('qb-diving:server:generateAuto', model2, ClosestBerth)
                            ------------------------------------------------------------------------------------------------------
                            
                        end
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
                    end, function()
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
               
                    end)
                    ----------------fine progress Bar-----------------------------------------------------------------------------

                 
                else
                    TriggerEvent('swt_notifications:Infos','You dont have enough Parking Card.')
                end
                ---------------------------------------------fine controllo card parking-------------------------------------------

                end	
                -----------------------------------------------fine pressione tasto-----------------------------------------------
              
                
            end
            -----------------------------------------------fine controllo se sono in  macchina---------------------------------------
		
		end	
        ---------------------------------------------------fine ingresso marker 2-------------------------------------------------------


    end
end)

--3
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        ---local distanza marker 1----------------------
        
        local dist3 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX3, sellY3, sellZ3)
        
        ---end local distanza marker 1------------------
        local ped = GetPlayerPed(-1)
        local vehicled = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        
        local playerPeds = PlayerPedId()
        --------------------------------------------------
         -------------------------------------------secondo marker pavimento----------------------------------------
         if dist3 <= 3.0 then
			DrawMarker(25, sellX3, sellY3, sellZ3-0.96, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
		
        end
         ---#############################################################################################################################
         -------------------------------------------ingresso in marker 2--------------------------------------------
         if dist3 <= 1.0 then

            ---------------------------------------eseguo il controllo se sono in macchina----------------------
		    if GetPedInVehicleSeat(vehicled, -1) == GetPlayerPed(-1) then
              ----se sono in macchina non esegue nessuna funzione
            else
                ----se sono a piedi eseguo il codice---------------------------------------

                -------------creo il testo-------------------------------------------------
                DrawText3D2(sellX3, sellY3, sellZ3+0.1,''..textgar..' Model: '..model3..'')
                ---------------------------------------------------------------------------
                -------------creo il marker------------------------------------------------
                DrawMarker(20, CashoutPolicega.SpawnVehicle.x, CashoutPolicega.SpawnVehicle.y, CashoutPolicega.SpawnVehicle.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.1, 0.2, 15, 255, 55, 255, true, false, false, true, false, false, false)
                ---------------------------------------------------------------------------

                -----------pressione tasto E-----------------------------------------------
                if IsControlJustPressed(0, Keys['E']) then 

                -----------locali di controllo---------------------------------------------
                local hasBag4g = false
				local s1 = false
				-----------eseguo il controllo se ho la carta parking----------------------
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag4g = result
					s1 = true
                end, 'carking')
                while(not s1) do
					Citizen.Wait(100)
				end
                if (hasBag4g) then
                    ----notifica preparazione auto e benzina-------------------------------------------
                    TriggerEvent('swt_notifications:Infos','I\'m preparing your car, 100% fuel.')
                    -----------------------------------------------------------------------------------

                    ----creo animazione---------------------------------------------------------------
                    TaskStartScenarioInPlace(playerPeds, "PROP_HUMAN_PARKING_METER", 0, true)
                    SetEntityHeading(PlayerPedId(), 65.45)
                    ----------------------------------------------------------------------------------

                    ----creo la progress Bar----------------------------------------------------------
                    QBCore.Functions.Progressbar("search_register", "Insert code card..", 8000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()
                                    
                        local timeLeft = 1000 * 1 / 1000
                
                        while timeLeft > 0 do
                            Citizen.Wait(1000)
                            timeLeft = timeLeft - 1
                            ClearPedTasks(GetPlayerPed(-1))
                            ----cancello animazione
                            Citizen.Wait(500)

                            -------------------------------terminato il timer creo l'auto------------------------------------------
                                TriggerServerEvent('qb-diving:server:generateAuto', model3, ClosestBerth)
                            ------------------------------------------------------------------------------------------------------
                            
                        end
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
                    end, function()
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
               
                    end)
                    ----------------fine progress Bar-----------------------------------------------------------------------------

                 
                else
                    TriggerEvent('swt_notifications:Infos','You dont have enough Parking Card.')
                end
                ---------------------------------------------fine controllo card parking-------------------------------------------

                end	
                -----------------------------------------------fine pressione tasto-----------------------------------------------
              
                
            end
            -----------------------------------------------fine controllo se sono in  macchina---------------------------------------
		
		end	
        ---------------------------------------------------fine ingresso marker 2-------------------------------------------------------


    end
end)

--4
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        ---local distanza marker 1----------------------
        
        local dist4 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX4, sellY4, sellZ4)
        
        ---end local distanza marker 1------------------
        local ped = GetPlayerPed(-1)
        local vehicled = GetVehiclePedIsIn(GetPlayerPed(-1), true)
       
        local playerPeds = PlayerPedId()
        --------------------------------------------------
         -------------------------------------------secondo marker pavimento----------------------------------------
         if dist4 <= 3.0 then
			DrawMarker(25, sellX4, sellY4, sellZ4-0.96, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
		
        end
         ---#############################################################################################################################
         -------------------------------------------ingresso in marker 2--------------------------------------------
         if dist4 <= 1.0 then

            ---------------------------------------eseguo il controllo se sono in macchina----------------------
		    if GetPedInVehicleSeat(vehicled, -1) == GetPlayerPed(-1) then
              ----se sono in macchina non esegue nessuna funzione
            else
                ----se sono a piedi eseguo il codice---------------------------------------

                -------------creo il testo-------------------------------------------------
                DrawText3D2(sellX4, sellY4, sellZ4+0.1,''..textgar..' Model: '..model4..'')
                ---------------------------------------------------------------------------
                -------------creo il marker------------------------------------------------
                DrawMarker(20, CashoutPolicega.SpawnVehicle.x, CashoutPolicega.SpawnVehicle.y, CashoutPolicega.SpawnVehicle.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.1, 0.2, 15, 255, 55, 255, true, false, false, true, false, false, false)
                ---------------------------------------------------------------------------

                -----------pressione tasto E-----------------------------------------------
                if IsControlJustPressed(0, Keys['E']) then 

                -----------locali di controllo---------------------------------------------
                local hasBag4g = false
				local s1 = false
				-----------eseguo il controllo se ho la carta parking----------------------
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag4g = result
					s1 = true
                end, 'carking')
                while(not s1) do
					Citizen.Wait(100)
				end
                if (hasBag4g) then
                    ----notifica preparazione auto e benzina-------------------------------------------
                    TriggerEvent('swt_notifications:Infos','I\'m preparing your car, 100% fuel.', 'success',10000)
                    -----------------------------------------------------------------------------------

                    ----creo animazione---------------------------------------------------------------
                    TaskStartScenarioInPlace(playerPeds, "PROP_HUMAN_PARKING_METER", 0, true)
                    SetEntityHeading(PlayerPedId(), 65.45)
                    ----------------------------------------------------------------------------------

                    ----creo la progress Bar----------------------------------------------------------
                    QBCore.Functions.Progressbar("search_register", "Insert code card..", 8000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()
                                    
                        local timeLeft = 1000 * 1 / 1000
                
                        while timeLeft > 0 do
                            Citizen.Wait(1000)
                            timeLeft = timeLeft - 1
                            ClearPedTasks(GetPlayerPed(-1))
                            ----cancello animazione
                            Citizen.Wait(500)

                            -------------------------------terminato il timer creo l'auto------------------------------------------
                                TriggerServerEvent('qb-diving:server:generateAuto', model4, ClosestBerth)
                            ------------------------------------------------------------------------------------------------------
                            
                        end
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
                    end, function()
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
               
                    end)
                    ----------------fine progress Bar-----------------------------------------------------------------------------

                 
                else
                    TriggerEvent('swt_notifications:Infos','You dont have enough Parking Card.')
                end
                ---------------------------------------------fine controllo card parking-------------------------------------------

                end	
                -----------------------------------------------fine pressione tasto-----------------------------------------------
              
                
            end
            -----------------------------------------------fine controllo se sono in  macchina---------------------------------------
		
		end	
        ---------------------------------------------------fine ingresso marker 2-------------------------------------------------------


    end
end)

--5
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        ---local distanza marker 1----------------------
        
        local dist5 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX5, sellY5, sellZ5)
        
        ---end local distanza marker 1------------------
        local ped = GetPlayerPed(-1)
        local vehicled = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        
        local playerPeds = PlayerPedId()
        --------------------------------------------------
         -------------------------------------------secondo marker pavimento----------------------------------------
         if dist5 <= 3.0 then
			DrawMarker(25, sellX5, sellY5, sellZ5-0.96, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
		
        end
         ---#############################################################################################################################
         -------------------------------------------ingresso in marker 2--------------------------------------------
         if dist5 <= 1.0 then

            ---------------------------------------eseguo il controllo se sono in macchina----------------------
		    if GetPedInVehicleSeat(vehicled, -1) == GetPlayerPed(-1) then
              ----se sono in macchina non esegue nessuna funzione
            else
                ----se sono a piedi eseguo il codice---------------------------------------

                -------------creo il testo-------------------------------------------------
                DrawText3D2(sellX5, sellY5, sellZ5+0.1,''..textgar..' Model: '..model5..'')
                ---------------------------------------------------------------------------
                -------------creo il marker------------------------------------------------
                DrawMarker(20, CashoutPolicega.SpawnVehicle.x, CashoutPolicega.SpawnVehicle.y, CashoutPolicega.SpawnVehicle.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.1, 0.2, 15, 255, 55, 255, true, false, false, true, false, false, false)
                ---------------------------------------------------------------------------

                -----------pressione tasto E-----------------------------------------------
                if IsControlJustPressed(0, Keys['E']) then 

                -----------locali di controllo---------------------------------------------
                local hasBag4g = false
				local s1 = false
				-----------eseguo il controllo se ho la carta parking----------------------
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag4g = result
					s1 = true
                end, 'carking')
                while(not s1) do
					Citizen.Wait(100)
				end
                if (hasBag4g) then
                    ----notifica preparazione auto e benzina-------------------------------------------
                    TriggerEvent('swt_notifications:Infos','I\'m preparing your car, 100% fuel.')
                    -----------------------------------------------------------------------------------

                    ----creo animazione---------------------------------------------------------------
                    TaskStartScenarioInPlace(playerPeds, "PROP_HUMAN_PARKING_METER", 0, true)
                    SetEntityHeading(PlayerPedId(), 65.45)
                    ----------------------------------------------------------------------------------

                    ----creo la progress Bar----------------------------------------------------------
                    QBCore.Functions.Progressbar("search_register", "Insert code card..", 8000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()
                                    
                        local timeLeft = 1000 * 1 / 1000
                
                        while timeLeft > 0 do
                            Citizen.Wait(1000)
                            timeLeft = timeLeft - 1
                            ClearPedTasks(GetPlayerPed(-1))
                            ----cancello animazione
                            Citizen.Wait(500)

                            -------------------------------terminato il timer creo l'auto------------------------------------------
                                TriggerServerEvent('qb-diving:server:generateAuto', model5, ClosestBerth)
                            ------------------------------------------------------------------------------------------------------
                            
                        end
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
                    end, function()
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
               
                    end)
                    ----------------fine progress Bar-----------------------------------------------------------------------------

                 
                else
                    TriggerEvent('swt_notifications:Infos','You dont have enough Parking Card.')
                end
                ---------------------------------------------fine controllo card parking-------------------------------------------

                end	
                -----------------------------------------------fine pressione tasto-----------------------------------------------
              
                
            end
            -----------------------------------------------fine controllo se sono in  macchina---------------------------------------
		
		end	
        ---------------------------------------------------fine ingresso marker 2-------------------------------------------------------


    end
end)

--6
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        ---local distanza marker 1----------------------
        
        local dist6 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX6, sellY6, sellZ6)
        
        ---end local distanza marker 1------------------
       
        local vehicled = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        
        local playerPeds = PlayerPedId()
        --------------------------------------------------
         -------------------------------------------secondo marker pavimento----------------------------------------
         if dist6 <= 10.0 then
			DrawMarker(22, sellX6, sellY6, sellZ6,0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.1, 0.2, 15, 255, 55, 255, true, false, false, true, false, false, false)
		
        end
  ---#############################################################################################################################
         -------------------------------------------ingresso in marker 6--------------------------------------------
         if dist6 <= 2.0 then

            ---------------------------------------eseguo il controllo se sono in macchina----------------------
		    if GetPedInVehicleSeat(vehicled, -1) == GetPlayerPed(-1) then
              ----se sono in macchina non esegue nessuna funzione
            else
                ----se sono a piedi eseguo il codice---------------------------------------

                -------------creo il testo-------------------------------------------------
                DrawText3D2(sellX6, sellY6, sellZ6+0.1,''..textCarP..'')
                ---------------------------------------------------------------------------
                -------------creo il marker------------------------------------------------
                --DrawMarker(20, CashoutPolicega.SpawnVehicle.x, CashoutPolicega.SpawnVehicle.y, CashoutPolicega.SpawnVehicle.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.1, 0.2, 15, 255, 55, 255, true, false, false, true, false, false, false)
                ---------------------------------------------------------------------------

                -----------pressione tasto E-----------------------------------------------
                if IsControlJustPressed(0, Keys['E']) then 

                 
                    ----notifica preparazione auto e benzina-------------------------------------------
                    --TriggerEvent('swt_notifications:Infos','I\'m preparing your car, 100% fuel.', 'success',10000)
                    -----------------------------------------------------------------------------------

                    ----creo animazione---------------------------------------------------------------
                    TaskStartScenarioInPlace(playerPeds, "PROP_HUMAN_PARKING_METER", 0, true)
                    SetEntityHeading(PlayerPedId(), 65.45)
                    ----------------------------------------------------------------------------------

                    ----creo la progress Bar----------------------------------------------------------
                    QBCore.Functions.Progressbar("search_register", "Insert code card..", 8000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()
                                    
                        local timeLeft = 1000 * 1 / 1000
                
                        while timeLeft > 0 do
                            Citizen.Wait(1000)
                            timeLeft = timeLeft - 1
                            ClearPedTasks(GetPlayerPed(-1))
                            ----cancello animazione
                            Citizen.Wait(500)

                            -------------------------------terminato il timer creo l'auto------------------------------------------
                                TriggerServerEvent('qb-diving:server:parkinCard')
                            ------------------------------------------------------------------------------------------------------
                            
                        end
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
                    end, function()
                        ----cancello animazione
                        ClearPedTasks(GetPlayerPed(-1))
               
                    end)
                    ----------------fine progress Bar-----------------------------------------------------------------------------

                 
                
                ---------------------------------------------fine controllo card parking-------------------------------------------

                end	
                -----------------------------------------------fine pressione tasto-----------------------------------------------
              
                
            end
            -----------------------------------------------fine controllo se sono in  macchina---------------------------------------
		
		end	
        ---------------------------------------------------fine ingresso marker 6-------------------------------------------------------

    end
end)
 

--------------------------------------------------GENERATE AUTO AND PLATE-------------------------------------------------------------
RegisterNetEvent('qb-diving:client:Auto')
AddEventHandler('qb-diving:client:Auto', function(boatModel, plate)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    QBCore.Functions.SpawnVehicle(boatModel, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['esx_fuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, CashoutPolicega.SpawnVehicle.h)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        SetVehicleEngineOn(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        -------------------------INSERT ITEM CAR --------------------------------------------------
       -- TriggerServerEvent("nethush-inventory:server:addTrunkItems", GetVehicleNumberPlateText(veh), Config.CarItems)
    end, CashoutPolicega.SpawnVehicle, true)
   SetTimeout(1000, function()
        DoScreenFadeIn(250)
    end)
end)

-------------------------------------------------------------------------------------------------------------