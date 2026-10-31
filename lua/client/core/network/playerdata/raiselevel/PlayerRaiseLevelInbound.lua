require "lua.client.core.network.playerData.raiseLevel.PentagramData"
require "lua.client.core.network.playerData.raiseLevel.RaisedSlotData"

--- @class PlayerRaiseLevelInbound
PlayerRaiseLevelInbound = Class(PlayerRaiseLevelInbound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerRaiseLevelInbound:Ctor(buffer)
    ---@type number
    self.needRequest = nil
    ---@type number
    self.numberSlot = nil
    ---@type PentagramData
    self.pentaGram = nil
    ---@type number
    self.featureState = nil
    ---@type Dictionary
    self.raisedSlots = nil

    ---@type Dictionary
    self.inventoryIdRaisedSlotDict = nil
    ---@type Dictionary
    self.heroIdDict = nil
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end
--- @param callbackSuccess function
function PlayerRaiseLevelInbound.Validate(callbackSuccess, showWaiting)
    local raisedInbound = zg.playerData:GetRaiseLevelHero()
    if raisedInbound == nil or raisedInbound.needRequest == true then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.RAISE_HERO }, callbackSuccess, SmartPoolUtils.LogicCodeNotification, showWaiting)
    else
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
end

function PlayerRaiseLevelInbound:CheckNotificationInMain()
    local isNextSlot = self:IsNextSlot(self.numberSlot + 1)
    if isNextSlot then
        local listReward = ResourceMgr.GetRaiseHeroConfig():GetUnLockPriceWithId(self.numberSlot + 1)
        local canBuy = InventoryUtils.IsEnoughMultiResourceRequirement(listReward, false)
        return canBuy
    else
        return false
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerRaiseLevelInbound:ReadBuffer(buffer)
    self.numberSlot = buffer:GetByte()
    self.featureState = buffer:GetByte()
    self.pentaGram = PentagramData(buffer)

    local size = buffer:GetByte()
    self.raisedSlots = Dictionary()
    self.heroIdDict = Dictionary()
    self.inventoryIdRaisedSlotDict = Dictionary()
    for i = 1, size do
        local id = buffer:GetByte()
        local raiseData = RaisedSlotData(buffer)
        self.raisedSlots:Add(id, raiseData)
        if raiseData.inventoryId > 1000 then
            local heroId = InventoryUtils.GetHeroResourceByInventoryId(raiseData.inventoryId).heroId
            if not self.heroIdDict:IsContainKey(heroId) then
                self.heroIdDict:Add(heroId, 1)
            end
        end
        self.inventoryIdRaisedSlotDict:Add(raiseData.inventoryId, 1)
    end
    self.needRequest = false
end

--- @return boolean
function PlayerRaiseLevelInbound:IsInPentaGram(inventoryId)
    return self.pentaGram:IsInPentaGram(inventoryId)
end

function PlayerRaiseLevelInbound:UpdateRaiseData()
    for i = 1, self.raisedSlots:Count() do
        ---@type RaisedSlotData
        local data = self.raisedSlots:Get(i)
        if data ~= nil and data.inventoryId ~= nil and data.inventoryId > 1000 then
            ---@type HeroResource
            local heroData = InventoryUtils.GetHeroResourceByInventoryId(data.inventoryId)
            heroData.heroLevel = self.pentaGram.lowestLevel
        end
    end
end

--- @param heroResource HeroResource
function PlayerRaiseLevelInbound:UpdateLowestLevelInReset(heroResource)
    if heroResource == nil then
        return
    end
    for i = 1, self.raisedSlots:Count() do
        ---@type RaisedSlotData
        local data = self.raisedSlots:Get(i)
        if data ~= nil and data.inventoryId ~= nil and data.inventoryId > 1000 then
            ---@type HeroResource
            local heroData = InventoryUtils.GetHeroResourceByInventoryId(data.inventoryId)
            heroData.heroLevel = 0
        end
    end
    self.pentaGram:UpdateLowestLevelInReset(heroResource)
    self:UpdateRaiseData()
end

--- @param heroResource HeroResource
function PlayerRaiseLevelInbound:UpdateInEvolve()
    for i = 1, self.raisedSlots:Count() do
        ---@type RaisedSlotData
        local data = self.raisedSlots:Get(i)
        if data ~= nil and data.inventoryId ~= nil and data.inventoryId > 1000 then
            ---@type HeroResource
            local heroData = InventoryUtils.GetHeroResourceByInventoryId(data.inventoryId)
            heroData.heroLevel = 0
        end
    end
    self.pentaGram:UpdateLowestLevelInEvolve()
    self:UpdateRaiseData()
end

--- @param heroResource HeroResource
function PlayerRaiseLevelInbound:UpdateLowestLevel(heroResource)
    if heroResource == nil then
        return
    end
    local level = heroResource.heroLevel
    if self.pentaGram.lowestLevel < level then
        self.pentaGram:UpdateLowestLevelInUpgradeLevel(heroResource)
        self:UpdateRaiseData()
    end
end

--- @return boolean
function PlayerRaiseLevelInbound:IsTheSameHeroId(inventoryId)
    local heroId = InventoryUtils.GetHeroResourceByInventoryId(inventoryId).heroId
    return self.heroIdDict:IsContainKey(heroId)
end
--- @return void
function PlayerRaiseLevelInbound:AddRaisedSlot(idSlot, inventoryId)
    ---@type RaisedSlotData
    local raiseData = RaisedSlotData()
    local data = InventoryUtils.GetHeroResourceByInventoryId(inventoryId)
    raiseData.inventoryId = inventoryId
    raiseData.originLevel = data.heroLevel
    raiseData.state = RaiseHeroIconView.STATE.USED
    raiseData.updateTime = 0
    self.raisedSlots:Add(idSlot, raiseData)
    self.inventoryIdRaisedSlotDict:Add(inventoryId, 1)
    if inventoryId > 1000 then
        local heroId = InventoryUtils.GetHeroResourceByInventoryId(inventoryId).heroId
        if not self.heroIdDict:IsContainKey(heroId) then
            self.heroIdDict:Add(heroId, 1)
        end
    end
end

--- @return RaisedSlotData
function PlayerRaiseLevelInbound:GetRaisedSlot(idSlot)
    if self.raisedSlots:IsContainKey(idSlot) then
        return self.raisedSlots:Get(idSlot)
    end
    return nil
end

--- @return void
function PlayerRaiseLevelInbound:AddOpenedSlot(idSlot)
    ---@type RaisedSlotData
    local raiseData = RaisedSlotData()
    raiseData.inventoryId = 0
    raiseData.originLevel = self.pentaGram:GetLowestHero()
    raiseData.state = RaiseHeroIconView.STATE.UNLOCKED
    raiseData.updateTime = 0
    self.raisedSlots:Add(idSlot, raiseData)
end
--- @return void
function PlayerRaiseLevelInbound:IsNextSlot(idSlot)
    local dataConfig = ResourceMgr.GetRaiseHeroConfig()
    local maxSlot = dataConfig:GetBaseConfig():GetMaxSlot()
    if self.raisedSlots:Count() == maxSlot then
        return false
    elseif (self.raisedSlots:Count() + 1) == idSlot then
        return true
    else
        return false
    end
end

--- @return void
function PlayerRaiseLevelInbound:RemoveRaisedSlot(idSlot, inventoryId)
    if self.raisedSlots:IsContainKey(idSlot) then
        ---@type RaisedSlotData
        local data = self.raisedSlots:Get(idSlot)
        data.state = RaiseHeroIconView.STATE.COUNT_DOWN
        data.updateTime = ResourceMgr.GetRaiseHeroConfig():GetSlotConfig().intervalTime
        data.inventoryId = 0
        self.raisedSlots:Add(idSlot, data)
    end
    if self.inventoryIdRaisedSlotDict:IsContainKey(inventoryId) then
        self.inventoryIdRaisedSlotDict:RemoveByKey(inventoryId)
    end
    if inventoryId > 1000 then
        local heroId = InventoryUtils.GetHeroResourceByInventoryId(inventoryId).heroId
        if self.heroIdDict:IsContainKey(heroId) then
            self.heroIdDict:RemoveByKey(heroId)
        end
    end
end

--- @return void
function PlayerRaiseLevelInbound:GetRaisedSlotIdByHeroInventoryId(inventoryId)
    ---@param v RaisedSlotData
    for k, v in pairs(self.raisedSlots:GetItems()) do
        if v.inventoryId == inventoryId then
            return k
        end
    end
    return nil
end

--- @return void
function PlayerRaiseLevelInbound:RemoveRaisedSlotByHeroInventoryId(inventoryId)
    local slotId = self:GetRaisedSlotIdByHeroInventoryId(inventoryId)
    self:RemoveRaisedSlot(slotId, inventoryId)
end

--- @return void
function PlayerRaiseLevelInbound:BuyRaisedSlot(idSlot)
    local data
    if self.raisedSlots:IsContainKey(idSlot) then
        ---@type RaisedSlotData
        data = self.raisedSlots:Get(idSlot)
        data.state = RaiseHeroIconView.STATE.UNLOCKED
        data.updateTime = 0
    else
        data = RaisedSlotData()
        data.state = RaiseHeroIconView.STATE.UNLOCKED
        data.updateTime = 0
    end
    self.raisedSlots:Add(idSlot, data)
end

--- @return number
function PlayerRaiseLevelInbound:GetRaisedSlotCount()
    local num = 0
    for i, v in pairs(self.raisedSlots:GetItems()) do
        if v.inventoryId ~= nil and v.inventoryId > 1000 then
            num = num + 1
        end
    end
    return num
end

--- @return boolean
function PlayerRaiseLevelInbound:IsInRaisedSlot(inventoryId)
    return self.inventoryIdRaisedSlotDict:IsContainKey(inventoryId)
end
