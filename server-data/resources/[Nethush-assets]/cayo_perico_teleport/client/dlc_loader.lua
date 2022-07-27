function EnableIsland(enabled)
  Citizen.InvokeNative(0x9A9D1BA639675CF1, "HeistIsland", enabled)
  Citizen.InvokeNative(0x5E1460624D194A38, enabled)
end

function ToggleIslandPathNodes(enabled)
  Citizen.InvokeNative(0xF74B1FFA4A15FBEA, enabled)
end