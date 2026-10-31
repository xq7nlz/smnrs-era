require "lua.client.core.network.event.eventHalloweenModel.EventHalloweenLoginData"
require "lua.client.core.network.event.eventLunarNewYear.EventLunarEliteSummonData"
require "lua.client.core.network.iap.LimitedPackStatisticsInBound"

--- @class EventLunarNewYearModel : EventPopupModel
EventLunarNewYearModel = Class(EventLunarNewYearModel, EventPopupModel)

function EventLunarNewYearModel:Ctor()
    ---@type EventXmasLoginData
    self.eventLunarLoginData = nil
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()
    --- @type Dictionary
    self.dictLimitedPackStatistics = Dictionary()
    EventPopupModel.Ctor(self)
    --- @type GrowPatchLine
    self.eventPassLine = nil
    --- @type Dictionary
    self.packSelectedItemDict = Dictionary()
    --- @type number
    self.heroSelectedIndex = nil
    --- @type number
    self.lastClaimFreeSpringBoxTime = nil
    --- @type Dictionary
    self.packSelectedItemDictLionDance = Dictionary()
    ---@type List
    self.listQuestData = List()

end

function EventLunarNewYearModel:IsFreeClaim()
    if self.eventLunarLoginData ~= nil then
        return self.eventLunarLoginData:IsFreeClaim()
    end
    return false
end

function EventLunarNewYearModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

--- @return List
function EventLunarNewYearModel:GetListQuestData()
    return self.listQuestData
end

--- @return List
function EventLunarNewYearModel:UpdateListQuestData(id)
    for k, v in pairs(self.listQuestData:GetItems()) do
        if v.questId < id and v.questState == QuestState.DOING then
            v.questState = QuestState.DONE_REWARD_NOT_CLAIM
        end
    end
end

function EventLunarNewYearModel:IsTigerPathHasNotification()
    --- @type List
    local listClaimableMilestone1 = self:_GetAllClaimableMilestone(true)
    --- @type List
    local listClaimableMilestone2 = self:_GetAllClaimableMilestone(false)
    if self.heroSelectedIndex < 0 then
        return true
    end

    if listClaimableMilestone2:Count() > 0 or listClaimableMilestone1:Count() > 0 then
        return true
    else
        return false
    end
end

function EventLunarNewYearModel:AddSelectItem(selectIndex)
    self.heroSelectedIndex = selectIndex
end

function EventLunarNewYearModel:AddSelectItemLionDance(questId, selectIndex)
    self.packSelectedItemDictLionDance:Add(questId, selectIndex)
end

function EventLunarNewYearModel:GetSelectItemLionDance(questId)
    return self.packSelectedItemDictLionDance:Get(questId)
end

function EventLunarNewYearModel:HasNotification()
    for i = 1, 6 do
        if self:IsTabNotified(i) then
            return true
        end
    end
    return false
end

--- @param lunarNewYearTab LunarNewYearTab
function EventLunarNewYearModel:IsTabNotified(lunarNewYearTab)
    if lunarNewYearTab == LunarNewYearTab.CHECK_IN then
        return self:IsDailyLoginHasNotification()
    elseif lunarNewYearTab == LunarNewYearTab.TIGER_PATH then
        return self:IsTigerPathHasNotification()
    elseif lunarNewYearTab == LunarNewYearTab.LION_DANCE then
        return self:QuestLionDanceHasNotClaimed()
    end
    return false
end

function EventLunarNewYearModel:ReadInnerData(buffer)
    --- Event Login
    self.eventLunarLoginData = EventHalloweenLoginData()
    self.eventLunarLoginData:ReadBuffer(buffer)
    self.lastClaimFreeSpringBoxTime = buffer:GetLong()

    ----- number bought Dictionary
    --local size2 = buffer:GetByte()
    --for i = 1, size2 do
    --    local packId = buffer:GetInt()
    --    local numberBought = buffer:GetInt()
    --    self.numberBoughtDictionary:Add(packId,numberBought)
    --end

    --- numberBuyDataMap
    self.numberBuyDataDict = EventPopupModel.ReadNumberBuyDataDict(buffer)

    --- tiger path
    self.eventPassLine = GrowPatchLine()
    self.eventPassLine:ReadBuffer(buffer)

    ----- tiger path select
    self.heroSelectedIndex = buffer:GetInt()

    local size = buffer:GetByte()
    self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer,
            self:GetConfig()._lionDanceConfig:GetListQuestConfig(),
            size)

    size = buffer:GetByte()
    for i = 1, size do
        self.packSelectedItemDictLionDance:Add(buffer:GetInt(), buffer:GetInt())
    end
    ----- tiger path select
    --local size2 = buffer:GetByte()
    --for i = 1, size2 do
    --    local packId = buffer:GetInt()
    --    local size3 = buffer:GetByte()
    --    local listItemSelect = List()
    --    for i = 1, size3 do
    --        listItemSelect:Add(buffer:GetInt())
    --    end
    --    self.packSelectedItemDict:Add(packId,listItemSelect)
    --end
    --self.heroSelectedIndex = buffer:GetInt()
    --self.LionDanceLevel = buffer:GetInt()
    --
    --self.listQuestData = List()
    --local sizeQuest = buffer:GetByte()
    --for _ = 1, sizeQuest do
    --    local LionDanceQuestInBound = LionDanceQuestInBound()
    --    LionDanceQuestInBound:ReadBuffer(buffer)
    --    self.listQuestData:Add(LionDanceQuestInBound)
    --end

    self.dictLimitedPackStatistics = Dictionary()
    self:GetGrowthPackLineConfig()
end

--- @param packId number
function EventLunarNewYearModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

--- @param eventActionType EventActionType
function EventLunarNewYearModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

--- @param eventActionType EventActionType
function EventLunarNewYearModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

--- @param opCode OpCode
--- @param packId number
function EventLunarNewYearModel:AddNumberBuyOpCode(opCode, packId, number)
    if opCode == OpCode.EVENT_LUNAR_2022_EXCLUSIVE_BUNDLE_PURCHASE then
        self:AddNumberBuy(EventActionType.EVENT_LUNAR_2022_EXCLUSIVE_BUNDLE_PURCHASE, packId, number)
    elseif opCode == OpCode.EVENT_LUNAR_2022_SPRING_BUNDLE_PURCHASE then
        self:AddNumberBuy(EventActionType.EVENT_LUNAR_2022_SPRING_BUNDLE_PURCHASE, packId, number)
    elseif opCode == OpCode.EVENT_LUNAR_2022_TIGER_PATH_BUNDLE_PURCHASE then
        self:AddNumberBuy(EventActionType.EVENT_LUNAR_2022_TIGER_PATH_BUNDLE_PURCHASE, packId, number)
    elseif opCode == OpCode.EVENT_LUNAR_2022_SPRING_BOX_EXCHANGE then
        self:AddNumberBuy(EventActionType.EVENT_LUNAR_2022_SPRING_BOX_EXCHANGE, packId, number)
    end
end

function EventLunarNewYearModel:GetNumberBuyOpCode(opCode, packId)
    -- ProductConfigId
    if opCode == OpCode.EVENT_LUNAR_2022_EXCLUSIVE_BUNDLE_PURCHASE then
        return self:GetNumberBuy(EventActionType.EVENT_LUNAR_2022_EXCLUSIVE_BUNDLE_PURCHASE, packId)
    elseif opCode == OpCode.EVENT_LUNAR_2022_SPRING_BUNDLE_PURCHASE then
        return self:GetNumberBuy(EventActionType.EVENT_LUNAR_2022_SPRING_BUNDLE_PURCHASE, packId)
    elseif opCode == OpCode.EVENT_LUNAR_2022_TIGER_PATH_BUNDLE_PURCHASE then
        return self:GetNumberBuy(EventActionType.EVENT_LUNAR_2022_TIGER_PATH_BUNDLE_PURCHASE, packId)
    elseif opCode == OpCode.EVENT_LUNAR_2022_SPRING_BOX_EXCHANGE then
        return self:GetNumberBuy(EventActionType.EVENT_LUNAR_2022_SPRING_BOX_EXCHANGE, packId)
    end
end

--- @param eventActionType EventActionType
function EventLunarNewYearModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

--- @return EventLunarNewYearConfig
function EventLunarNewYearModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventLunarNewYearModel:IsClaim()
    if self.eventLunarLoginData ~= nil then
        return self.eventLunarLoginData:IsClaim()
    end
    return nil
end

function EventLunarNewYearModel:IsFreeClaim()
    if self.eventLunarLoginData ~= nil then
        return self.eventLunarLoginData:IsFreeClaim()
    end
    return false
end

function EventLunarNewYearModel:GetLoginData()
    return self.eventLunarLoginData
end

function EventLunarNewYearModel:OnClaimQuestSuccess(questId)
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        if v.questId <= questId then
            if v.questState ~= QuestState.COMPLETED then
                v.questState = QuestState.COMPLETED
            end
        end
    end
end

function EventLunarNewYearModel:QuestLionDanceHasNotClaimed()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

function EventLunarNewYearModel:IsLionDanceHasNotification(isShowPopup)
    local eventLionDanceConfig = self:GetConfig():GetEventLionDanceConfig()
    return InventoryUtils.IsEnoughSingleResourceRequirement(eventLionDanceConfig.feedRewardInBound,
            isShowPopup or false)
end

--- @param milestone number
--- @param isShowPopup
function EventLunarNewYearModel:IsValidMilestone(milestone, isShowPopup)
    local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money,
            MoneyType.EVENT_LUNAR_2022_GROWTH_POINT, milestone)
    return InventoryUtils.IsEnoughSingleResourceRequirement(rewardInBound, isShowPopup)
end

function EventLunarNewYearModel:GetNumber()
    return InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_LUNAR_2022_GROWTH_POINT)
end

--- @param listMilestone List
function EventLunarNewYearModel:OnSuccessClaimListMilestone(isBasic, listMilestone)
    for i = 1, listMilestone:Count() do
        local milestone = listMilestone:Get(i)
        self.eventPassLine:OnSuccessClaimMilestone(isBasic, milestone)
    end
end

function EventLunarNewYearModel:GetGrowthPackLineConfig()
    self.growthPackLineConfig = self:GetConfig():GetTigerPathConfig(self.timeData.dataId)
    local boughtCount = self:GetNumberBuy(EventActionType.EVENT_LUNAR_2022_TIGER_PATH_BUNDLE_PURCHASE, 1)
    self.isUnlocked = boughtCount > 0
end

--- @return List
function EventLunarNewYearModel:_GetAllClaimableMilestone(isFree, countLocked)
    local boughtCount = self:GetNumberBuy(EventActionType.EVENT_LUNAR_2022_TIGER_PATH_BUNDLE_PURCHASE, 1)
    self.isUnlocked = boughtCount > 0
    self.growthPackLineConfig = self:GetConfig().lineConfig:Get(self.timeData.dataId)
    local listClaimableMilestone = List()
    for i = 1, self.growthPackLineConfig.listMilestone:Count() do
        --- @type GrowthMilestoneConfig
        local growthMilestoneConfig = self.growthPackLineConfig.listMilestone:Get(i)
        local milestone = growthMilestoneConfig.number
        local isClaimedBasic, isClaimedPremium = self:GetMilestoneStateByNumber(milestone)
        if self:IsValidMilestone(milestone, false)
                and ((isFree and not isClaimedBasic)
                or (not isFree and not isClaimedPremium and (self.isUnlocked))) then
            listClaimableMilestone:Add(milestone)
        end
    end
    return listClaimableMilestone
end

--- @return boolean, boolean
function EventLunarNewYearModel:GetMilestoneStateByNumber(number)
    if self.eventPassLine == nil then
        return false, false
    end
    local basic, premium = self.eventPassLine:GetMilestoneState(number)
    return basic ~= nil and basic > 0, premium ~= nil and premium > 0
end

function EventLunarNewYearModel:GetSelectItemID()
    local listSelectId = self.packSelectedItemDict:Get(self.packId)
    if (listSelectId == nil or listSelectId:Count() == 0) then
        return nil
    end
    return listSelectId:Get(1)
end

function EventLunarNewYearModel:GetHeroIdBySelectIndex()
    if self.heroSelectedIndex ~= -1 then
        local heroId = self:GetConfig().rewardPool:Get(self.heroSelectedIndex).id
        return ClientConfigUtils.GetHeroIdByFragmentHeroId(heroId)
    end
    return nil
end

--- @return boolean
--- Check whether player already claim free spring box or not?
function EventLunarNewYearModel:IsNotClaimedFreeSpringBox()
    return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) > self.lastClaimFreeSpringBoxTime
end

--- @return void
--- Set time that player claim free spring box to now
function EventLunarNewYearModel:SetClaimedFreeSpringBoxTime()
    self.lastClaimFreeSpringBoxTime = zg.timeMgr:GetServerTime()
end

--- @class LunarNewYearTab
LunarNewYearTab = {
    CHECK_IN = 1,
    SPRING_BOX = 2,
    LION_DANCE = 3,
    SPRING_BUNDLE = 4,
    LUNAR_BUNDLE = 5,
    TIGER_PATH = 6,
}
