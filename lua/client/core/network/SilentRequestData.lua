--- @class SilentRequestData
local SilentRequestData = Class(SilentRequestData)

function SilentRequestData:Ctor()
    --- @type string
    self.hash = nil
    --- @type InBound
    self.inbound = nil
    --- @type boolean
    self.canRequest = true
    --- @type number
    self.inboundTime = nil
end

--- @return boolean
function SilentRequestData:HasCache()
    return self.inbound ~= nil
end

--- @return InBound
function SilentRequestData:GetCache()
    return self.inbound
end

function SilentRequestData:SetHash(hash)
    self.hash = hash
end

--- @return InBound
function SilentRequestData:SetCache(inbound)
    self.inbound = inbound
    self.inboundTime = zg.timeMgr:GetServerTime()
end

--- @param cacheTime number
function SilentRequestData:CanGetCache(cacheTime)
    return self.inboundTime ~= nil and zg.timeMgr:GetServerTime() - self.inboundTime < cacheTime
end

--- @param canRequest boolean
function SilentRequestData:SetCanRequest(canRequest)
    --XDebug.Log("Set can request: " .. tostring(canRequest) .. " " .. self.hash)
    self.canRequest = canRequest
end

--- @return boolean
function SilentRequestData:CanRequest()
    return self.canRequest
end

function SilentRequestData:Reset()
    self.hash = nil
    self.inbound = nil
    self.canRequest = true
    self.inboundTime = nil
end

return SilentRequestData