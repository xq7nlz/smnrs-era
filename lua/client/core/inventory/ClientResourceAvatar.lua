--- @class ClientResourceAvatar : BaseJsonInBound
ClientResourceAvatar = Class(ClientResourceAvatar, BaseJsonInBound)

--- @return void
--- @param type ResourceType
function ClientResourceAvatar:Ctor(type)
    self.type = type
    --- @type Dictionary -- <number, ClientAvatar> -- id, expiredTime
    self._avatarResourceDict = Dictionary()
end

--- @return void
--- @param data table
function ClientResourceAvatar:InitDatabase(data)
    if data ~= nil then
        -- XDebug.Log("data is " .. #data)
        self._avatarResourceDict:Clear()
        for k, v in pairs(data) do
            --XDebug.Log("add id" .. k .. " value " .. v)
            self:Add(tonumber(k), v, false)
        end

        self:RemoveLegacyAvatarTier()
    end
end

--- @return number
--- @param resourceId number
function ClientResourceAvatar:Get(resourceId)
    if resourceId == nil then
        assert(false, string.format("resourceId[%s]", resourceId))
    end
    return self._avatarResourceDict:IsContainValue(resourceId) and 1 or 0
end

--- @return table
function ClientResourceAvatar:GetItems()
    return self._avatarResourceDict:GetItems()
end

--- @return table
function ClientResourceAvatar:GetResourceDict()
    return self._avatarResourceDict
end

--- @return void
--- @param resourceId number
--- @param expiredTime number
function ClientResourceAvatar:InitResource(resourceId, expiredTime)
    if not self._avatarResourceDict:IsContainValue(resourceId) then
        self._avatarResourceDict:Add(resourceId, expiredTime)
    end
end

--- @return void
--- @param resourceId number
--- @param expiredTime number
function ClientResourceAvatar:Add(resourceId, expiredTime, fireEvent)
    if not self._avatarResourceDict:IsContainValue(resourceId) then
        self._avatarResourceDict:Add(resourceId, expiredTime)
        if fireEvent ~= false then
            RxMgr.changeResource:Next(
                    { ['resourceType'] = self.type, ['resourceId'] = resourceId })
        end
    end
end

function ClientResourceAvatar:AddByClaim(...)
    local args = { ... }
    local resourceId = args[1]

    local expiredTime = self._avatarResourceDict:Get(resourceId)
    expiredTime = expiredTime or -1

    local avatarConfig = ResourceMgr.GetAvatarConfig()
    local avatarItemConfig = avatarConfig:GetAvatarItemConfig(resourceId)
    local configDuration = avatarItemConfig.timeDuration * TimeUtils.SecondADay
    --expiredTime = expiredTime + configDuration + zg.timeMgr:GetServerTime()
    local currentTime = zg.timeMgr:GetServerTime()
    if (configDuration < 0) then
        expiredTime = -1
    else
        if (expiredTime < currentTime) then
            expiredTime = configDuration + zg.timeMgr:GetServerTime()
        else
            expiredTime = expiredTime + configDuration
        end
    end
    self._avatarResourceDict:Add(resourceId, expiredTime)

    RxMgr.changeResource:Next(
            { ['resourceType'] = self.type, ['resourceId'] = resourceId })
end

--- @return void
--- @param resourceId number
function ClientResourceAvatar:Sub(resourceId)
    if self._avatarResourceDict:IsContainKey(resourceId) then
        self._avatarResourceDict:RemoveByKey(resourceId)
        RxMgr.changeResource:Next(
                { ['resourceType'] = self.type, ['resourceId'] = resourceId })
    end
end

--- @return boolean
--- @param resourceId number
function ClientResourceAvatar:IsValid(resourceId)
    return self._avatarResourceDict:IsContainValue(resourceId)
end

--- @return void
function ClientResourceAvatar:Clear()
    self._avatarResourceDict:Clear()
end

function ClientResourceAvatar:ToString()
    local content = "Resource["
    for k, itemId in pairs(self._avatarResourceDict:GetItems()) do
        content = content .. itemId .. ","
    end
    content = content .. ']\n'
    return content
end

function ClientResourceAvatar:RemoveLegacyAvatarTier()
    for id, expiredTime in pairs(self._avatarResourceDict:GetItems()) do
        local avatarTier = id % 10
        if id > 100000 and avatarTier == 3 then
            self:Sub(id)
            self:Add(id - 1, expiredTime, false)
        end
    end
end

--- @class ClientResourceFrame : ClientResourceAvatar
ClientResourceFrame = Class(ClientResourceFrame, ClientResourceAvatar)

function ClientResourceFrame:AddByClaim(...)
    local args = { ... }
    local resourceId = args[1]

    local expiredTime = self._avatarResourceDict:Get(resourceId)
    expiredTime = expiredTime or -1

    local avatarConfig = ResourceMgr.GetAvatarConfig()
    local frameItemConfig = avatarConfig:GetFrameItemConfig(resourceId)
    local configDuration = frameItemConfig.timeDuration * TimeUtils.SecondADay
    --expiredTime = expiredTime + configDuration + zg.timeMgr:GetServerTime()
    local currentTime = zg.timeMgr:GetServerTime()
    if (configDuration < 0) then
        expiredTime = -1
    else
        if (expiredTime < currentTime) then
            expiredTime = configDuration + zg.timeMgr:GetServerTime()
        else
            expiredTime = expiredTime + configDuration
        end
    end
    self._avatarResourceDict:Add(resourceId, expiredTime)

    RxMgr.changeResource:Next(
            { ['resourceType'] = self.type, ['resourceId'] = resourceId })
end

function ClientResourceFrame:RemoveLegacyAvatarTier()
    --- Do Nothing
end

--- @class ClientAvatar
ClientAvatar = Class(ClientAvatar)

--- @param id number
--- @param expiredTime number
function ClientAvatar:Ctor(id, expiredTime)
    self.id = id
    self.expiredTime = expiredTime
end

function ClientAvatar:IsExpired()
    return self.expiredTime > 0 and self.expiredTime < zg.timeMgr:GetServerTime()
end
