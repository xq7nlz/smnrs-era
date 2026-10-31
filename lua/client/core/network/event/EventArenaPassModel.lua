require "lua.client.core.network.iap.GrowthPack.GrowPatchLine"

--- @class EventArenaPassModel : EventPopupModel
EventArenaPassModel = Class(EventArenaPassModel, EventPopupModel)

function EventArenaPassModel:Ctor()
    --- @type Dictionary
    self.boughtPackDict = Dictionary()
    self.growPatchLine = GrowPatchLine()
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventArenaPassModel:ReadInnerData(buffer)
    self.boughtPackDict = Dictionary()
    local bought = buffer:GetByte()
    for _ = 1, bought do
        local packId = buffer:GetInt()
        local boughtCount = buffer:GetInt()
        self.boughtPackDict:Add(packId, boughtCount)
    end

    self.growPatchLine = GrowPatchLine()
    self.growPatchLine:ReadBuffer(buffer)
end

function EventArenaPassModel:GetBoughtCount(packId)
    if self.boughtPackDict:IsContainKey(packId) then
        return self.boughtPackDict:Get(packId)
    end
    return 0
end

function EventArenaPassModel:GetNumber()
    return InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_ARENA_PASS_POINT)
end

--- @param packId number
function EventArenaPassModel:IncreaseBoughtPack(packId)
    local bought = self:GetBoughtCount(packId)
    self.boughtPackDict:Add(packId, bought + 1)
end

--- @param listMilestone List
function EventArenaPassModel:OnSuccessClaimListMilestone(isBasic, listMilestone)
    for i = 1, listMilestone:Count() do
        local milestone = listMilestone:Get(i)
        self.growPatchLine:OnSuccessClaimMilestone(isBasic, milestone)
    end
end

--- @return PackOfProducts
function EventArenaPassModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @return PackOfProducts
function EventArenaPassModel:HasNotification()
    if self:IsOpening() == false then
        return false
    end
    local packOfProducts = self:GetConfig()
    --- @type ProductConfig
    local productConfig = packOfProducts:GetAllPackBase():Get(1)
    local packId = productConfig.id
    local isUnlocked = self:GetBoughtCount(packId) > 0
    --- @type GrowthPackLineConfig
    local growthPackLineConfig = ResourceMgr.GetEventArenaPassConfig():GetConfig(self.timeData.dataId)
    for i = 1, growthPackLineConfig.listMilestone:Count() do
        local growthMilestoneConfig = growthPackLineConfig:GetMilestoneConfigByIndex(i)
        local claimedBasic, claimedPremium = self.growPatchLine:GetMilestoneState(growthMilestoneConfig.number)
        if self:IsValidMilestone(growthMilestoneConfig.number, false)
                and (claimedBasic == 0 or (claimedPremium == 0 and isUnlocked == true)) then
            return true
        end
    end
    return false
end

--- @param milestone number
--- @param isShowPopup
function EventArenaPassModel:IsValidMilestone(milestone, isShowPopup)
    local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_ARENA_PASS_POINT, milestone)
    return InventoryUtils.IsEnoughSingleResourceRequirement(rewardInBound, isShowPopup)
end

--- @return boolean
function EventArenaPassModel:IsAvailableToRequest()
    return self.lastTimeRequest == nil
end

