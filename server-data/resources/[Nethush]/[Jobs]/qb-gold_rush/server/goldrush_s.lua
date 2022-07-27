----------------CODERC-SLO--------------------------
-----------------GOLD RUSH---------------------------
QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


-------------------------------------------------CREO IL SECCHIO E PRENDO LA SABBIA----------------------------------------
RegisterServerEvent('smerfikcraft:zlomiarzzbier2fpg')
AddEventHandler('smerfikcraft:zlomiarzzbier2fpg', function()
   
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    --local Item = xPlayer.Functions.GetItemByName('orangea')

    --if Item == nil then
  
        TriggerClientEvent('wiadro:postawfpg', _source)
        TriggerClientEvent('smerfik:zamrozcrft222fpg', _source)
        TriggerClientEvent('zacznijtekst22fpg', _source)
        TriggerClientEvent('smerfik:craftanimacja222fpg', _source)
        TriggerClientEvent('smerfik:tekstjab22fpg', _source)
        Citizen.Wait(10000)
        ---------------------------------------
        local ilosc = math.random(1,1)
        xPlayer.Functions.AddItem('gravel', ilosc)
        -----------------------------------------

		TriggerClientEvent("nethush-inventory:client:ItemBox", _source, QBCore.Shared.Items['gravel'], "add")
        TriggerClientEvent('smerfik:odmrozcrft222fpg', _source)
        --TriggerClientEvent("swt_notifications:Infos", _source, 'Collected'.. ilosc .. ' milk')
        TriggerClientEvent('smerfik:resetg', _source)
         TriggerClientEvent('smerfik:zdejmijznaczek22fpg', _source)
  -- else
  --[[
        if Item.amount < 50 then
          TriggerClientEvent('wiadro:postawfpg', _source)
          TriggerClientEvent('smerfik:zamrozcrft222fp', _source)
          TriggerClientEvent('zacznijtekst22fp', _source)
          TriggerClientEvent('smerfik:craftanimacja222fp', _source)
          TriggerClientEvent('smerfik:tekstjab22fp', _source)
          Citizen.Wait(10000)
          ----------------------------------------
         -- local ilosc = math.random(10,10)
         -- xPlayer.Functions.AddItem('milk', ilosc)
          ----------------------------------------

		  --TriggerClientEvent("nethush-inventory:client:ItemBox", _source, QBCore.Shared.Items['milk'], "add")
          TriggerClientEvent('smerfik:odmrozcrft222fp', _source)
          -- TriggerClientEvent("swt_notifications:Infos", _source, 'Collected'.. ilosc .. ' milk')
          TriggerClientEvent('smerfik:reset', _source)
        else 

        TriggerClientEvent('smerfik:zdejmijznaczek22fpg', _source)
        TriggerClientEvent("swt_notifications:Infos", _source, 'You dont have orangea!')
       
         end]]--

   -- end

end)
--------------------------------------------------END CREO SECCHIO E SABBIA-------------------------------------------------------------

-----------------------------------------------------------------AD GOLD---------------------------------------------------------------
RegisterServerEvent('tost:addgold')
AddEventHandler('tost:addgold', function()

    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    local Item = xPlayer.Functions.GetItemByName('gravel')

    if Item == nil then
  
       -- TriggerClientEvent('wiadro:postaw', _source)
       
        ---------------------------------------
        local ilosc = math.random(1,6)
        xPlayer.Functions.AddItem('rawgold', ilosc)
        -----------------------------------------
        TriggerClientEvent("nethush-inventory:client:ItemBox", _source, QBCore.Shared.Items['rawgold'], "add")

        xPlayer.Functions.RemoveItem('gravel', 1)----
        TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['gravel'], "remove")
		
   else
        if Item.amount < 50 then
        
          ----------------------------------------
          local ilosc = math.random(1,6)
          xPlayer.Functions.AddItem('rawgold', ilosc)
          ----------------------------------------

		  TriggerClientEvent("nethush-inventory:client:ItemBox", _source, QBCore.Shared.Items['rawgold'], "add")
           xPlayer.Functions.RemoveItem('gravel', 1)----
          TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['gravel'], "remove")
          
        else 

        TriggerClientEvent('smerfik:zdejmijznaczek22fp', _source)
        TriggerClientEvent("swt_notifications:Infos", _source, 'Non hai pi� spazio nel tuo inventario carica nel tuo furgone!')
       
         end

    end

end)
--------------------------------------------------------------END ADD GOLD-------------------------------------------------

------------------------------------NOT USE
RegisterServerEvent('smerfik:pobierzjablka22fp') 
AddEventHandler('smerfik:pobierzjablka22fp', function()
	local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
        xPlayer.removeMoney(3000)
end)

RegisterServerEvent('smerfik:pobierzjablka222fp') 
AddEventHandler('smerfik:pobierzjablka222fp', function()
	local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    xPlayer.addMoney(3000)
        TriggerClientEvent('esx:deleteVehicle', source)
end)
-------------------------------------------------------------

-----------------------------------------------Processa rawgold-----------------------------------------------------------------------
RegisterServerEvent('smerfikcraft:skup22fpg')
AddEventHandler('smerfikcraft:skup22fpg', function()
   
    --local jabka = xPlayer.getInventoryItem('milk').count

    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    local Item = xPlayer.Functions.GetItemByName('rawgold')
    


    --if Item.amount >= 1 then
    if Item == nil then
        TriggerClientEvent('swt_notifications:Infos', source, 'No rawgold')  
    else
        if Item.amount >= 1 then
           -- for i = 1, 2 do
          
        TriggerClientEvent('tp:milkingfpg', _source)
        TriggerClientEvent('odlacz:propa3fpg', _source)
      
       -- local price =  math.random(50, 200) 
        
             xPlayer.Functions.RemoveItem('rawgold', 1)----change this milkbotle
             TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['rawgold'], "remove")
       
             TriggerClientEvent('sprzedawanie:jablekanim22fpg', _source)
             
       
           

             TriggerClientEvent('odlacz:propa2fpg', _source)
             TriggerClientEvent('tp:misc-jobs:unlockControlsfpg', _source)
             
          --  end
        else
            TriggerClientEvent('swt_notifications:Infos', _source, 'You have no raw gold.')  
            TriggerClientEvent('tp:misc-jobs:unlockControlsfpg', _source)
        end
     end
end)
RegisterServerEvent('smerfikcraft:lingotto')
AddEventHandler('smerfikcraft:lingotto', function()
   
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    xPlayer.Functions.AddItem('refinedgold', 1)
    TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['refinedgold'], "add")


end)
--------------------------------------------------------------------------------------------------------------------------------

--------------VENDITA LINGOTTI ORO--------------------------------------------------------------------------------------------
RegisterServerEvent('gold:lingotti')
AddEventHandler('gold:lingotti', function()

    local xPlayer = QBCore.Functions.GetPlayer(source)
	local Item = xPlayer.Functions.GetItemByName('refinedgold')
   
	
	if Item == nil then
       TriggerClientEvent('swt_notifications:Infos', source, 'you have no gold bars')  
	else
	 
        
		
		if Item.amount > 0 then
			--for i = 1, Item.amount do
            local reward = 0
            for i = 1, Item.amount do
                reward = 1850
            end
			xPlayer.Functions.RemoveItem('refinedgold', 1)----change this
			TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items['refinedgold'], "remove")
			xPlayer.Functions.AddMoney("cash", reward, "sold-pawn-items")
			TriggerClientEvent('swt_notifications:Infos', source, 'You have sold 1 bar of 1KG')  
			--end
        end
		
		
     
	end

end)
-----------------------------END VENDITA LINGOTTI---------------------------------------------------------------------------------

---------------------------PRENDI AUTO ---------------------------------------------------------

-----RITIRA CAMMION LAVORO----------------------------------------
local prezzo = 10
---------PARKING CAR--------------------------------------
RegisterServerEvent('qb-gold_rush:server:truck')
AddEventHandler('qb-gold_rush:server:truck', function(boatModel, BerthId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local plate = "GOLD"..math.random(1111, 9999)
    
	TriggerClientEvent('qb-gold_rush:Auto', src, boatModel, plate)
end)



---------------------------CONSEGNA AUTO-------------------------------------------------------
