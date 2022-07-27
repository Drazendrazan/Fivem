Citizen.CreateThread(function()
    while true do
        --local players = GetAllPlayers()
        local playercount = GetNumPlayerIndices()
        TriggerClientEvent("rpc:sendCount", -1, playercount)
        Citizen.Wait(10000);
    end
end)