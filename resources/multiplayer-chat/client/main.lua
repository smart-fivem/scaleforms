local chat = MultiplayerChat.New({
    -- sfName = 'MULTIPLAYER_CHAT'
    -- hideAfter = 10000
    -- playerName = 'Unknown'
    -- playerColor = 0
})

local SCOPE_ALL = "All"
local SCOPE_TEAM = "Team"
local SCOPE_FRIENDS = "Friends"
local SCOPE_CREW = "Crew"

-- Actions

-- Opens chat (if not open already)
-- Shows input box with the given scope
local function startTyping(scope)
    chat:StartTyping(scope)

    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'RESET' })
end

-- NUI callbacks
-- Handles typing
-- Handles scrolling while input is open

RegisterNUICallback('onInputKeydown', function(data, cb)
    cb({})

    if not chat:IsLoaded() then
        return
    end

    if data.key == "Backspace" then
        chat:DeleteText()
        return
    end
end)

RegisterNUICallback('onInputInput', function(data, cb)
    cb({})

    if not chat:IsLoaded() then
        return
    end

    -- The player can easily control the NUI page and input characters that are not allowed
    -- it's a good idea to also filter those characters here before adding them to the scaleform
    -- and again on the server so other players don't receive those characters

    chat:AddText(data.data)
end)

RegisterNUICallback('onInputKeyup', function(data, cb)
    cb({})

    if not chat:IsLoaded() then
        return
    end

    if data.key == "PageDown" then
        chat:PageDown()
        return
    end

    if data.key == "PageUp" then
        chat:PageUp()
        return
    end

    if data.key == "Escape" then
        SetNuiFocus(false, false)
        chat:EndTyping(false)
        return
    end

    if data.key == "Enter" then
        SetNuiFocus(false, false)
        chat:EndTyping(true)
        return
    end
end)

-- Main thread
-- Handles opening chat
-- Handles scrolling
-- Keeps the chat visible
Citizen.CreateThread(function()
    chat:Load()

    -- These can be changed at any time
    -- chat.hideAfter = 10000
    -- chat.playerName = 'Player Name'
    -- chat.playerColor = 0

    -- Mode can be changed at any time
    -- chat:SetMode(MultiplayerChat.MODE_LOBBY)

    while true do
        Citizen.Wait(0)

        if not chat:IsTyping() then
            if IsControlJustPressed(0, 245) then -- INPUT_MP_TEXT_CHAT_ALL
                startTyping(SCOPE_ALL)
            end
            if IsControlJustPressed(0, 246) then -- INPUT_MP_TEXT_CHAT_TEAM
                startTyping(SCOPE_TEAM)
            end
            if IsControlJustPressed(0, 247) then -- INPUT_MP_TEXT_CHAT_FRIENDS
                startTyping(SCOPE_FRIENDS)
            end
            if IsControlJustPressed(0, 248) then -- INPUT_MP_TEXT_CHAT_CREW
                startTyping(SCOPE_CREW)
            end
        end

        if chat:IsShowing() then
            if IsControlJustPressed(0, 207) then -- INPUT_FRONTEND_LT
                chat:PageDown()
            end
            if IsControlJustPressed(0, 208) then -- INPUT_FRONTEND_RT
                chat:PageUp()
            end
        end

        chat:Update()
    end
end)

-- Simulates other users sending messages
Citizen.CreateThread(function()
    local interval = 5000
    local prevTime = GetGameTimer()

    local count = 0

    while true do
        Citizen.Wait(0)

        if chat:IsLoaded() then
            local curTime = GetGameTimer()
            local diff = curTime - prevTime

            if diff > interval then
                interval = math.random(1, 19) * 1000
                prevTime = curTime
                count = count + 1

                chat:AddMessage('Random', 'example message ' .. count, SCOPE_ALL, 0)
            end
        end
    end
end)
