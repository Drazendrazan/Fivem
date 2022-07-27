local recoils = {
	[453432689] = 3.3, -- PISTOL
	[3219281620] = 3.5, -- PISTOL MK2
	[1593441988] = 7.2, -- COMBAT PISTOL
	[584646201] = 4.3, -- AP PISTOL
	[2578377531] = 3.6, -- PISTOL .50
	[324215364] = 3.5, -- MICRO SMG
	[736523883] = 5.4, -- SMG
	[2024373456] = 5.1, -- SMG MK2
	[4024951519] = 6.1, -- ASSAULT SMG
	[3220176749] = 10.5, -- ASSAULT RIFLE
	[961495388] = 6.2, -- ASSAULT RIFLE MK2
	[2210333304] = 15.3, -- CARBINE RIFLE
	[4208062921] = 15.1, -- CARBINE RIFLE MK2
	[2937143193] = 5.1, -- ADVANCED RIFLE
	[2634544996] = 1.1, -- MG
	[2144741730] = 1.1, -- COMBAT MG
	[3686625920] = 1.1, -- COMBAT MG MK2
	[487013001] = 1.4, -- PUMP SHOTGUN
	[1432025498] = 1.35, -- PUMP SHOTGUN MK2
	[2017895192] = 1.7, -- SAWNOFF SHOTGUN
	[3800352039] = 1.4, -- ASSAULT SHOTGUN
	[2640438543] = 1.2, -- BULLPUP SHOTGUN
	[911657153] = 1.1, -- STUN GUN
	[100416529] = 1.5, -- SNIPER RIFLE
	[205991906] = 1.7, -- HEAVY SNIPER
	[177293209] = 1.6, -- HEAVY SNIPER MK2
	[856002082] = 1.2, -- REMOTE SNIPER
	[2726580491] = 1.0, -- GRENADE LAUNCHER
	[1305664598] = 1.0, -- GRENADE LAUNCHER SMOKE
	[2982836145] = 1.0, -- RPG
	[1752584910] = 1.0, -- STINGER
	[1119849093] = 1.01, -- MINIGUN
	[3218215474] = 1.2, -- SNS PISTOL
	[1627465347] = 1.1, -- GUSENBERG
	[3231910285] = 1.2, -- SPECIAL CARBINE
	[-1768145561] = 1.15, -- SPECIAL CARBINE MK2
	[3523564046] = 1.5, -- HEAVY PISTOL
	[2132975508] = 1.2, -- BULLPUP RIFLE
	[-2066285827] = 1.15, -- BULLPUP RIFLE MK2
	[137902532] = 1.4, -- VINTAGE PISTOL
	[2828843422] = 1.7, -- MUSKET
	[984333226] = 1.2, -- HEAVY SHOTGUN
	[3342088282] = 1.3, -- MARKSMAN RIFLE
	[1785463520] = 1.25, -- MARKSMAN RIFLE MK2
	[1672152130] = 1, -- HOMING LAUNCHER
	[1198879012] = 1.9, -- FLARE GUN
	[171789620] = 1.2, -- COMBAT PDW
	[3696079510] = 1.9, -- MARKSMAN PISTOL
	[1834241177] = 2.4, -- RAILGUN
	[3675956304] = 1.3, -- MACHINE PISTOL
	[3249783761] = 1.6, -- REVOLVER
	[-879347409] = 1.6, -- REVOLVER MK2
	[4019527611] = 1.7, -- DOUBLE BARREL SHOTGUN
	[1649403952] = 1.3, -- COMPACT RIFLE
	[317205821] = 1.2, -- AUTO SHOTGUN
	[125959754] = 1.5, -- COMPACT LAUNCHER
	[3173288789] = 1.1, -- MINI SMG		
}



Citizen.CreateThread(function()
	while true do
		if IsPedShooting(PlayerPedId()) and not IsPedDoingDriveby(PlayerPedId()) then
			local _,wep = GetCurrentPedWeapon(PlayerPedId())
			_,cAmmo = GetAmmoInClip(PlayerPedId(), wep)
			if recoils[wep] and recoils[wep] ~= 0 then
				tv = 0
				if GetFollowPedCamViewMode() ~= 4 then
					repeat 
						Wait(0)
						p = GetGameplayCamRelativePitch()
						SetGameplayCamRelativePitch(p+0.1, 0.2)
						tv = tv+0.1
					until tv >= recoils[wep]
				else
					repeat 
						Wait(0)
						p = GetGameplayCamRelativePitch()
						if recoils[wep] > 0.1 then
							SetGameplayCamRelativePitch(p+0.6, 1.2)
							tv = tv+0.6
						else
							SetGameplayCamRelativePitch(p+0.016, 0.333)
							tv = tv+0.1
						end
					until tv >= recoils[wep]
				end
			end
		end

		Citizen.Wait(0)
	end
end)
