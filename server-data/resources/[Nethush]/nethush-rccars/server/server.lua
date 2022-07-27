--------CODERC-SLO---------
--##RC CAR CONTROL RACE##--
---------------------------

--------------------CORE---------------------------------------------------
QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
----------------------------------------------------------------------------

---------------REGISTRABLE ITEM---------------------------------------------
QBCore.Functions.CreateUseableItem("rc", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent('coderc_rc:RonEat', source)
end)
----------------------------------------------------------------------------