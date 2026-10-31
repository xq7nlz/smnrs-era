require "lua.client.data.RegenTimeData"

--- @class ClientResourceDict
ClientResourceDict = Class(ClientResourceDict)

--- @return void
--- @param type ResourceType
function ClientResourceDict:Ctor(type)
    self.type = type
    --- @type Dictionary <id, number>
    self._resourceDict = Dictionary()
    --- @type Dictionary --<id, RegenTimeData>
    self._regenTimeDict = Dictionary()
end

--- @return void
--- @param data table
function ClientResourceDict:InitDatabase(data)
    if data ~= nil then
        self._resourceDict:Clear()
        for resourceId, quantity in pairs(data) do
            self:Add(tonumber(resourceId), quantity)
        end
    end
end

--- @return number
--- @param resourceId number
function ClientResourceDict:GetCountResource(resourceId)
    if resourceId == nil then
        assert(false, string.format("resourceId[%s]", resourceId))
    end
    if self._resourceDict:IsContainKey(resourceId) then
        return self._resourceDict:Get(resourceId)
    else
        return 0
    end
end

--- @return number
--- @param resourceId number
function ClientResourceDict:GetCountRegen(resourceId)
    if resourceId == nil then
        assert(false, string.format("resourceId[%s]", resourceId))
    end
    local regen = 0
    ---@type RegenTimeData
    local regenData = self._regenTimeDict:Get(resourceId)
    if regenData ~= nil and regenData.getLastRegenTime() ~= nil then
        local current = self:GetCountResource(resourceId)
        if current < regenData.max then
            regen = math.min(regenData.max - current,
                    math.floor((zg.timeMgr:GetServerTime() - regenData.getLastRegenTime()) / regenData.step))
        end
    end
    return regen
end

--- @return number
--- @param resourceId number
function ClientResourceDict:Get(resourceId)
    return self:GetCountResource(resourceId) + self:GetCountRegen(resourceId)
end

--- @return table
function ClientResourceDict:GetItems()
    return self._resourceDict:GetItems()
end

--- @return table
function ClientResourceDict:GetResourceDict()
    return self._resourceDict
end

--- @return void
--- @param resourceId number
--- @param quantity number
function ClientResourceDict:InitResource(resourceId, quantity)
    self._resourceDict:Add(resourceId, quantity)
end

--- @return void
--- @param resourceId number
--- @param regenTimeData RegenTimeData
function ClientResourceDict:AddRegenTimeData(resourceId, regenTimeData)
    self._regenTimeDict:Add(resourceId, regenTimeData)
end

--- @return void
--- @param resourceId number
--- @param quantity number
function ClientResourceDict:Add(resourceId, quantity)
    if (self.type == ResourceType.ItemEquip and ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:IsContainKey(resourceId) == false)
            or (self.type == ResourceType.Hero and ResourceMgr.GetHeroMenuConfig().listHeroCollection:IsContainValue(resourceId) == false)
            or (self.type == ResourceType.ItemStone and ResourceMgr.GetServiceConfig():GetItems().stoneDataEntries:IsContainKey(resourceId) == false)
            or (self.type == ResourceType.ItemArtifact and ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:IsContainKey(resourceId) == false) then
        return
    end
    if resourceId == nil or quantity == nil then
        assert(false, string.format("coinId[%s] quantity[%s]", resourceId, quantity))
    end
    if quantity == 0 then
        return
    end

    ---@type RegenTimeData
    local regenData = self._regenTimeDict:Get(resourceId)
    local count = self:GetCountResource(resourceId)
    if regenData ~= nil then
        local countRegen = self:GetCountRegen(resourceId)
        if countRegen > 0 then
            regenData.setLastRegenTime(regenData.getLastRegenTime() + regenData.step * countRegen)
        end
        count = count + countRegen + quantity
    else
        count = count + quantity
    end
    self._resourceDict:Add(resourceId, count)

    RxMgr.changeResource:Next(
            { ['resourceType'] = self.type, ['resourceId'] = resourceId, ['quantity'] = quantity, ['result'] = count })
end

--- @return void
--- @param resourceId number
--- @param quantity number
function ClientResourceDict:Sub(resourceId, quantity)
    if resourceId == nil or quantity == nil then
        assert(false, string.format("coinId[%s] quantity[%s]", resourceId, quantity))
    end
    if quantity == 0 then
        return
    end
    if self._resourceDict:IsContainKey(resourceId) == false and self._regenTimeDict:IsContainKey(resourceId) == false then
        XDebug.Error(string.format("Sub Resource NIL type %s, id %s", self.type, resourceId))
        return
    end

    local total = self:Get(resourceId)
    local result = math.max(total - quantity, 0)
    ---@type RegenTimeData
    local regenData = self._regenTimeDict:Get(resourceId)
    if regenData ~= nil then
        if total >= regenData.max and result < regenData.max then
            regenData.setLastRegenTime(zg.timeMgr:GetServerTime())
        else
            regenData.setLastRegenTime(regenData.getLastRegenTime() + regenData.step * self:GetCountRegen(resourceId))
        end
    end
    self._resourceDict:Add(resourceId, result)

    RxMgr.changeResource:Next(
            { ['resourceType'] = self.type, ['resourceId'] = resourceId, ['quantity'] = -quantity, ['result'] = result })
end

--- @return boolean
--- @param resourceId number
--- @param quantity number
function ClientResourceDict:IsValid(resourceId, quantity)
    if resourceId == nil or quantity == nil then
        assert(false, string.format("coinId[%s] quantity[%s]", resourceId, quantity))
    end
    if quantity == 0 then
        return true
    end

    return quantity <= self:Get(resourceId)
end

--- @return void
function ClientResourceDict:Clear()
    self._resourceDict:Clear()
    self._regenTimeDict:Clear()
end

function ClientResourceDict:ToString()
    local content = "Resource["
    for itemId, quantity in pairs(self._resourceDict:GetItems()) do
        content = content .. itemId .. ": " .. quantity .. ","
    end
    content = content .. ']\n'
    return content
end