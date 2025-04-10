Citizen.CreateThread(function()
    ShutdownLoadingScreen()
    Citizen.Wait(0)

    ShutdownLoadingScreenNui()
    Citizen.Wait(0)

    local playerPed = PlayerPedId()

    local spawnCoords = vector3(0, 0, 70)
    local spawnHeading = 0

    RequestCollisionAtCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z)

    SetEntityCoordsNoOffset(playerPed, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false)
    NetworkResurrectLocalPlayer(spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnHeading, 0, true)

    ClearPedTasksImmediately(playerPed)

    while not HasCollisionLoadedAroundEntity(playerPed) do
        Citizen.Wait(0)
    end

    FreezeEntityPosition(playerPed, false)
end)
