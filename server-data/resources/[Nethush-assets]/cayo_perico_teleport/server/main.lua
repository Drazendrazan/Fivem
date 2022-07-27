local function VerifyConfig()
  local invalid = false

  if not Config then
    invalid = true
  end

  if Config.Debug == nil or not Config.Marker or not Config.DrawDistance or not Config.ActivationDistanceScaler then
    invalid = true
  end

  if not Config.Control.Key or not Config.Control.Name then
    invalid = true
  end

  if not Config.TeleportLocations then
    invalid = true
  else
    for index, location in ipairs(Config.TeleportLocations) do
      if not location.LosSantosCoordinate or not location.IslandCoordinate then
        invalid = true
        break
      end

      if type(location.LosSantosCoordinate) ~= "vector3" or type(location.IslandCoordinate) ~= "vector3" then
        invalid = true
        break
      end

      if not location.LosSantosHeading or not location.IslandHeading then
        invalid = true
      end
    end
  end

  if invalid then
    local resource = GetCurrentResourceName()
    StopResource(GetCurrentResourceName())
  end
end

Citizen.CreateThread(
  function()
    VerifyConfig()
  end
)
