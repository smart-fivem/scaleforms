MultiplayerChat = setmetatable({}, {})
MultiplayerChat.__index = MultiplayerChat

MultiplayerChat.MODE_LOBBY = 0
MultiplayerChat.MODE_GAME = 1

function MultiplayerChat.New(options)
    options = options or {}

    local data = {
        _sfName = options.sfName or "MULTIPLAYER_CHAT",
        _sfHandle = nil,
        _sfLoaded = false,
        _open = false,
        _openTime = 0,
        _typing = false,
        _typingTime = 0,

        hideAfter = options.hideAfter or 10000,

        playerName = options.playerName or 'Unknown',
        playerColor = options.playerColor or 0
    }

    return setmetatable(data, MultiplayerChat)
end

function MultiplayerChat:IsLoaded()
    return self._sfLoaded
end

function MultiplayerChat:Load()
    if self._sfHandle ~= nil then
        return
    end

    self._sfHandle = RequestScaleformMovie(self._sfName)
    while not HasScaleformMovieLoaded(self._sfHandle) do Citizen.Wait(0) end

    self._sfLoaded = true
    self:Reset()
end

function MultiplayerChat:Reset()
    if not self:IsLoaded() then return end

    BeginScaleformMovieMethod(self._sfHandle, "RESET")
    EndScaleformMovieMethod()
end

function MultiplayerChat:IsShowing()
    return self._open
end

function MultiplayerChat:Show()
    self._open = true
    self._openTime = GetGameTimer()

    BeginScaleformMovieMethod(self._sfHandle, "SET_FOCUS")
    ScaleformMovieMethodAddParamInt(1)
    EndScaleformMovieMethod()
end

function MultiplayerChat:Hide()
    self._open = false
    self._openTime = 0

    self._typing = false
    self._typingTime = 0

    BeginScaleformMovieMethod(self._sfHandle, "SET_FOCUS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()
end

function MultiplayerChat:IsTyping()
    return self._typing
end

function MultiplayerChat:StartTyping(scopeText)
    local timer = GetGameTimer()

    if not self._open then
        self._open = true
        self._openTime = timer
    end

    self._typing = true
    self._typingTime = timer

    BeginScaleformMovieMethod(self._sfHandle, "SET_FOCUS")
    ScaleformMovieMethodAddParamInt(2)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamTextureNameString(scopeText)
    ScaleformMovieMethodAddParamTextureNameString(self.playerName)
    ScaleformMovieMethodAddParamInt(self.playerColor)
    EndScaleformMovieMethod()
end

function MultiplayerChat:EndTyping(send)
    if not self:IsLoaded() then return end

    self._typing = false
    self._typingTime = 0

    if send then
        BeginScaleformMovieMethod(self._sfHandle, "COMPLETE_TEXT")
        EndScaleformMovieMethod()
    else
        BeginScaleformMovieMethod(self._sfHandle, "ABORT_TEXT")
        EndScaleformMovieMethod()
    end

    self:Show()
end

function MultiplayerChat:AddText(text)
    if not self:IsLoaded() then return end

    BeginScaleformMovieMethod(self._sfHandle, "ADD_TEXT")
    ScaleformMovieMethodAddParamTextureNameString(text)
    EndScaleformMovieMethod()
end

function MultiplayerChat:DeleteText()
    if not self:IsLoaded() then return end

    BeginScaleformMovieMethod(self._sfHandle, "DELETE_TEXT")
    EndScaleformMovieMethod()
end

function MultiplayerChat:ClearText()
    if not self:IsLoaded() then return end

    BeginScaleformMovieMethod(self._sfHandle, "ABORT_TEXT")
    EndScaleformMovieMethod()
end

function MultiplayerChat:AddMessage(playerName, message, scopeText, playerColor)
    if not self:IsLoaded() then return end

    if not self._open then
        self:Show()
    end

    self._openTime = GetGameTimer()

    BeginScaleformMovieMethod(self._sfHandle, "ADD_MESSAGE")
    ScaleformMovieMethodAddParamTextureNameString(playerName)
    ScaleformMovieMethodAddParamTextureNameString(message)
    ScaleformMovieMethodAddParamTextureNameString(scopeText)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(playerColor)
    EndScaleformMovieMethod()
end

function MultiplayerChat:PageUp()
    if not self:IsLoaded() then return end

    BeginScaleformMovieMethod(self._sfHandle, "PAGE_UP")
    EndScaleformMovieMethod()
end

function MultiplayerChat:PageDown()
    if not self:IsLoaded() then return end

    BeginScaleformMovieMethod(self._sfHandle, "PAGE_DOWN")
    EndScaleformMovieMethod()
end

function MultiplayerChat:SetMode(mode)
    BeginScaleformMovieMethod(self._sfHandle, "SET_FOCUS_MODE")
    ScaleformMovieMethodAddParamInt(mode)
    EndScaleformMovieMethod()
end

function MultiplayerChat:Update()
    if not self:IsLoaded() then return end

    if not self:IsShowing() then return end

    if self.hideAfter > 0 and not self._typing then
        local timeDiff = GetGameTimer() - self._openTime
        if timeDiff > self.hideAfter then
            self:Hide()
            return
        end
    end

    DrawScaleformMovieFullscreen(self._sfHandle, 255, 255, 255, 255, 0)
end

function MultiplayerChat:Dispose()
    if self == nil then return end

    self._sf:Dispose()
    self._sf = nil
    self = nil
end
