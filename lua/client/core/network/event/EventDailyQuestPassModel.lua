require "lua.client.core.network.iap.GrowthPack.GrowPatchLine"

--- @class EventDailyQuestPassModel : EventPopupModel
EventDailyQuestPassModel = Class(EventDailyQuestPassModel, EventPopupModel)

function EventDailyQuestPassModel:Ctor()
    --- @type Dictionary
    self.boughtPackDict = Dictionary()
    --- @type GrowPatchLine
    self.growPatchLine = GrowPatchLine()
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventDailyQuestPassModel:ReadInnerData(buffer)
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

function EventDailyQuestPassModel:GetNumber()
    return InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_DAILY_QUEST_PASS_POINT)
end

function EventDailyQuestPassModel:GetBoughtCount(packId)
    if self.boughtPackDict:IsContainKey(packId) then
        return self.boughtPackDict:Get(packId)
    end
    return 0
end

--- @param packId number
function EventDailyQuestPassModel:IncreaseBoughtPack(packId)
    local bought = self:GetBoughtCount(packId)
    self.boughtPackDict:Add(packId, bought + 1)
end

--- @param listMilestone List
function EventDailyQuestPassModel:OnSuccessClaimListMilestone(isBasic, listMilestone)
    for i = 1, listMilestone:Count() do
        local milestone = listMilestone:Get(i)
        self.growPatchLine:OnSuccessClaimMilestone(isBasic, milestone)
    end
end

--- @return PackOfProducts
function EventDailyQuestPassModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @return PackOfProducts
function EventDailyQuestPassModel:HasNotification()
    if self:IsOpening() == false then
        return false
    end
    local packOfProducts = self:GetConfig()
    --- @type ProductConfig
    local productConfig = packOfProducts:GetAllPackBase():Get(1)
    local packId = productConfig.id
    local isUnlocked = self:GetBoughtCount(packId) > 0
    --- @type GrowthPackLineConfig
    local growthPackLineConfig = ResourceMgr.EventDailyQuestPassConfig():GetConfig(self.timeData.dataId)
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
function EventDailyQuestPassModel:IsValidMilestone(milestone, isShowPopup)
    local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_DAILY_QUEST_PASS_POINT, milestone)
    return InventoryUtils.IsEnoughSingleResourceRequirement(rewardInBound, isShowPopup)
end

--- @return boolean
function EventDailyQuestPassModel:IsAvailableToRequest()
    return self.lastTimeRequest == nil
end