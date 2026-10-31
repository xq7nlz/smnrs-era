local SilentRequestData = require("lua.client.core.network.SilentRequestData")

local silentRequestDict = {}

local pool = List()

local GetHashKey = function(opCode, outBound)
    local hash = {}
    hash.opCode = opCode
    hash.outBound = outBound
    return json.encode(hash)
end

--- @return SilentRequestData
local SpawnSilentRequestData = function(hashKey)
    --- @type SilentRequestData
    local data
    if pool:Count() == 0 then
        data = SilentRequestData()
    else
        data = pool:Get(1)
        pool:RemoveByIndex(1)
    end
    data:SetHash(hashKey)
    return data
end

--- @return SilentRequestData
local GetSilentRequestData = function(hashKey)
    local data = silentRequestDict[hashKey]
    if data == nil then
        data = SpawnSilentRequestData(hashKey)
        silentRequestDict[hashKey] = data
    end
    return data
end

--- @param opCode OpCode
--- @param outBound OutBound
--- @param inBoundClass table
--- @param onSuccess function
--- @param onFailed function
--- @param cacheTime number
function NetworkUtils.SilentRequest(opCode, outBound, inBoundClass, onSuccess, onSuccessAfter, onFailed, cacheTime)
    --- @type string
    local hashKey = GetHashKey(opCode, outBound)
    ---@type SilentRequestData
    local data = GetSilentRequestData(hashKey)

    if data:CanRequest() == false then
        return
    end

    local co
    local stopCoroutine = function()
        if co ~= nil then
            Coroutine.stop(co)
            co = nil
        end
    end

    if cacheTime ~= nil and data:CanGetCache(cacheTime) then
        onSuccess(data:GetCache(), false)
        return
    end

    ---@type boolean
    local canShow = onSuccess ~= nil
    --- @type TouchObject
    local touchObject
    if canShow then
        touchObject = TouchUtils.Spawn(opCode)
    end

    if data:HasCache() and onSuccess ~= nil then
        co = Coroutine.start(function()
            coroutine.waitforseconds(1)
            onSuccess(data:GetCache(), false)
            stopCoroutine()
            if canShow then
                touchObject:Enable()
            end
        end)
    end

    data:SetCanRequest(false)
    NetworkUtils.Request(opCode, outBound, function(result)
        if canShow and (co ~= nil or data:HasCache() == false) then
            touchObject:Enable()
        end
        data:SetCanRequest(true)

        local obj
        NetworkUtils.ExecuteResult(result, function(buffer)
            --- @type InBound
            obj = inBoundClass()
            obj:Deserialize(buffer)
        end, function()
            if onSuccessAfter ~= nil then
                onSuccessAfter(obj)
            end
            if onSuccess ~= nil and (co ~= nil or data:HasCache() == false) then
                onSuccess(obj, true)
            end
            data:SetCache(obj)
        end, function(logicCode)
            if onFailed ~= nil and data:HasCache() == false then
                onFailed(logicCode)
            end
        end)

        stopCoroutine()
    end, false)
end

function NetworkUtils.Reset()
    --- @param v SilentRequestData
    for _, v in pairs(silentRequestDict) do
        v:Reset()
        pool:Add(v)
    end
    silentRequestDict = {}
end