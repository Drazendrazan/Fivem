-------------------------------------
------- Created by CODERC-SLO -------
-----------Money Loundry---------------
------------------------------------- 
local CoolDownTimerATM = {}
QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
---######################################################---


---------------------------------------------PROCESS MONEY CLEANING-----------------------
local itname1 = 'black_money'
RegisterServerEvent('pulisci:moneblak')
AddEventHandler('pulisci:moneblak', function()
   
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    local Item = xPlayer.Functions.GetItemByName(itname1)
    
   
    if Item == nil then
        TriggerClientEvent('swt_notifications:Infos', source, 'You have no dirty money!') 
    else
        if Item.amount >= Item.amount then

           ----------------elimino dal mio inventario---------------------------------------------------------
           xPlayer.Functions.RemoveItem(itname1, Item.amount)
           TriggerClientEvent("nethush-inventory:client:ItemBox", source, QBCore.Shared.Items[itname1], "remove")
		   xPlayer.Functions.AddMoney("cash", Item.amount, "sold-pawn-items")
       
           
        else
            TriggerClientEvent('swt_notifications:Infos', _source, 'You have no dirty money!')  
           
        end
    end

end)
---------------------------------clean end---------------------------------------------------------------