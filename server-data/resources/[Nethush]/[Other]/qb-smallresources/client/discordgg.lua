Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(899292240172707890)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('larges')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('https://discord.gg/sWZdTqGSU6')
        
        --Here you will have to put the image name for the "small" icon.
        --SetDiscordRichPresenceAssetSmall('logo-mk3')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('https://discord.gg/sWZdTqGSU6')


        SetDiscordRichPresenceAction(0, "Discord!", "https://discord.gg/sWZdTqGSU6")
        SetDiscordRichPresenceAction(1, "Connect Sever!", "https://cfx.re/join/34e99o")

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)