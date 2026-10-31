require "lua.client.core.event.EventDispatcherListener"
require "lua.client.core.event.RequestData"

local listenerDict = Dictionary()

local exceptionDict = { OpCode.DISCONNECT, OpCode.SERVER_NOTICE , OpCode.CHAT_SERVER_SEND}

--- @param opCode OpCode
local function CanRemoveEvent(opCode)
    for _, v in ipairs(exceptionDict) do
        if v == opCode then
            return false
        end
    end
    return true
end

--- @class NetDispatcherMgr
NetDispatcherMgr = Class(NetDispatcherMgr)

function NetDispatcherMgr:Ctor()
    --- do something
end

--- @param opCode OpCode
--- @param eventListener EventDispatcherListener
function NetDispatcherMgr:AddListener(opCode, eventListener)
    --- @type List
    local listener = listenerDict:Get(opCode)
    if listener == nil then
        listener = List()
        listenerDict:Add(opCode, listener)
    end

    if CanRemoveEvent(opCode) then
        listener:Add(eventListener)
        if listener:Count() > 1 then
            --XDebug.Log(string.format("event dispatcher: %s => %d", opCode, listener:Count()))
        end
    else
        if listener:Count() == 0 then
            listener:Add(eventListener)
        else
            XDebug.Warning(string.format("Add more than 1 can't remove: %s => %d", opCode, listener:Count()))
        end
    end

end

--- @param eventId OpCode
function NetDispatcherMgr:RemoveListener(eventId)
    listenerDict:RemoveByKey(eventId)
end

--- @return void
--- @param opCode OpCode
--- @param eventData table
function NetDispatcherMgr:TriggerEvent(opCode, eventData)
    --- @type List
    local list = listenerDict:Get(opCode)
    if list ~= nil and list:Count() > 0 then
        --- @type EventDispatcherListener
        local listener = list:Get(1)
        if CanRemoveEvent(opCode) then
            list:RemoveByIndex(1)
        end
        listener:Trigger(eventData)
    else
        if opCode ~= OpCode.TUTORIAL_NEW_STEP_SET then
            XDebug.Log(string.format("None event listener at moment: %s", tostring(opCode)))
        end
    end
end

--- don't clean opcode in exception
function NetDispatcherMgr:Reset()
    for key, _ in pairs(listenerDict:GetItems()) do
        if CanRemoveEvent(key) then
            listenerDict:RemoveByKey(key)
        end
    end
end

--- @return boolean
--- @param opCode OpCode
function NetDispatcherMgr:ExistEvent(opCode)
    local list = listenerDict:Get(opCode)
    if list ~= nil and list:Count() > 0 then
        return true
    end
    return false
end