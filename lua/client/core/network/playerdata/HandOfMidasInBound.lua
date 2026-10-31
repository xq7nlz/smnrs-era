--- @class HandOfMidasInBound
HandOfMidasInBound = Class(HandOfMidasInBound)

--- @return void

function HandOfMidasInBound:Ctor()
    ---@type number
    self.lastRefresh = nil
    ---@type Dictionary
    self.dictNumberClaims = Dictionary()
    ---@type function
    self.viewCallback = nil
    ---@type function
    self.updateTime = nil
    ---@type number
    self.timeRefresh = nil

    self:InitUpdateTime()
end

--- @param buffer UnifiedNetwork_ByteBuf
function HandOfMidasInBound:ReadBuffer(buffer)
    self.lastRefresh = buffer:GetLong()
    local size = buffer:GetByte()
    for i = 1, size do
        local key = buffer:GetByte()
        local value = buffer:GetByte()
        self.dictNumberClaims:Add(key, value)
        --XDebug.Log(string.format("key: %s, value: %s", key, value))
    end
    self:SetTimeRefresh()
    if self:CanRefresh() then
        self:ResetClaimDict()
    end
end

function HandOfMidasInBound:CanRefresh()
    if self.timeRefresh == nil then
        XDebug.Error("You need set value for time_refresh first")
        self:SetTimeRefresh()
    end
    return self.timeRefresh <= 0
end

function HandOfMidasInBound:CanClaim(index)
    local value = self.dictNumberClaims:Get(index)
    local csv = ResourceMgr.GetHandOfMidasConfig()
    self.timeRefresh = csv.refreshInterval - (zg.timeMgr:GetServerTime() - self.lastRefresh)
    --XDebug.Log(string.format("index: %s, value: %s", index, value))
    if type(value) == "number" then
        return value > 0 or csv.refreshInterval < (zg.timeMgr:GetServerTime() - self.lastRefresh)
    else
        XDebug.Error(string.format("value is invalid: type[%s] value[%s]", type(value), tostring(value)))
        return false
    end
end

function HandOfMidasInBound:AddClaim(index)
    if self.dictNumberClaims:IsContainKey(index) then
        self.dictNumberClaims:Add(index, self.dictNumberClaims:Get(index) - 1)
    else
        self.dictNumberClaims:Add(index, 0)
    end
end

function HandOfMidasInBound:Refresh()
    self:SetLastRefresh()
    self:StartRefreshTime()
end

function HandOfMidasInBound:SetLastRefresh()
    self.lastRefresh = zg.timeMgr:GetServerTime()
end

function HandOfMidasInBound:SetTimeRefresh()
    local csv = ResourceMgr.GetHandOfMidasConfig()
    self.timeRefresh = csv.refreshInterval - (zg.timeMgr:GetServerTime() - self.lastRefresh)
end

function HandOfMidasInBound:ResetClaimDict()
    if self.dictNumberClaims:Count() == 0 then
        for i = 1, 3 do
            self.dictNumberClaims:Add(i, 1)
        end
    else
        for key, value in pairs(self.dictNumberClaims:GetItems()) do
            self.dictNumberClaims:Add(key, 1)
        end
    end
end

function HandOfMidasInBound:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self:CanRefresh(self.timeRefresh) then
            self:ResetClaimDict()
            self:RemoveUpdateTime()
            RxMgr.notificationHandOfMidas:Next(1)
        end
        if self.viewCallback ~= nil then
            self.viewCallback(self.timeRefresh)
        end
    end
end

--- @return void
function HandOfMidasInBound:StartRefreshTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function HandOfMidasInBound:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

--- @return void
function HandOfMidasInBound:ToString()
    return LogUtils.ToDetail(self)
end