QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local photo = nil


QBCore.Commands.Add("addphoto", "Add Photo To ID", {{name="playerid", help="Player ID"},{name="url", help="URL"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	local playerid = tonumber(args[1])
	local url = tostring(args[2])

	local target = QBCore.Functions.GetPlayer(playerid)
	local fetchcitizen = target.PlayerData.citizenid

	if Player.PlayerData.job.name == "police" then  -- you can add your job name here and grade as well


		QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `photo` = '"..url.."' WHERE `citizenid` = '"..fetchcitizen.."'")

	else
		TriggerClientEvent('swt_notifications:Infos', source, "You don't have Permission!")
	end
end)


RegisterServerEvent('virus-idcard:server:fetchPhoto')
AddEventHandler('virus-idcard:server:fetchPhoto', function()
	local src     		= source
	local Virus 		= QBCore.Functions.GetPlayer(src)

	QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..Virus.PlayerData.citizenid.."'", function(results)
		-- Looping through results:
		for k,v in pairs(results) do

				photo = v.photo

			--TriggerClientEvent('virus-idcard:client:fetchPhoto', src, photo)
			print(photo)

		end
	end)	
end)




