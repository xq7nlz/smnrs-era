--- @class TouchUtils
TouchUtils = {}

local touchStack = {}

local currentValue = 0

local co
local pool = List()

--- @return void
--- @param object TouchObject
local function RecordWaiting(object)
    if co ~= nil or type(object.key) ~= 'number' then
        return
    end

    co = Coroutine.start(function()
        --XDebug.Log("RecordWaiting before")
        coroutine.waitforseconds(1.5)
        --XDebug.Log("RecordWaiting after")
        PopupMgr.ShowPopup(UIPopupName.UIPopupWaiting, object.key)
    end)
end

--- @return void
local function RemoveWaiting()
    if co ~= nil then
        Coroutine.stop(co)
        co = nil
    end
    if PopupUtils.IsWaitingShowing() then
        --XDebug.Log("Hide popup waiting")
        PopupMgr.HidePopup(UIPopupName.UIPopupWaiting)
    end
end

--- @return TouchObject
--- @param key string
TouchUtils.Spawn = function(key)
    assert(key)
    --- @type TouchObject
    local obj
    if pool:Count() == 0 then
        obj = TouchObject()
    else
        --XDebug.Log("Pool count: " .. tostring(pool:Count()))
        obj = pool:Get(1)
        pool:RemoveByIndex(1)
    end
    obj:SetKey(key)
    obj:Disable()
    return obj
end

TouchUtils.Reset = function()
    --- @param v TouchObject
    for _, v in pairs(touchStack) do
        v:Enable()
    end
    currentValue = 0
    uiCanvas.config.eventSystem.enabled = true
end

--- @param object TouchObject
TouchUtils.Enable = function(object)
    currentValue = currentValue - 1
    if currentValue <= 0 then
        uiCanvas.config.eventSystem.enabled = true
        RemoveWaiting()
        if currentValue < 0 then
            currentValue = 0
            XDebug.Warning("it's already enabled")
        end
    end
    touchStack[object] = nil
    pool:Add(object)
end

--- @param object TouchObject
TouchUtils.Disable = function(object)
    touchStack[object] = object
    if currentValue == 0 then
        uiCanvas.config.eventSystem.enabled = false
    end

    currentValue = currentValue + 1
    RecordWaiting(object)
end

--- @return number
TouchUtils.GetNumberWaiting = function()
    return currentValue
end

TouchUtils.CatchError = function()
    --local str = "Waiting"
    ----- @param v TouchObject
    --for _, v in pairs(touchStack) do
    --    str = str .. " => " .. v.key
    --end
    --if serverLog ~= nil then
    --    serverLog:OnReceiveLog(str, "", U_LogType.Error)
    --end
end