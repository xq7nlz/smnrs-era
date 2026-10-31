require "lua.client.core.network.iap.GrowthPack.GrowPatchLine"
require "lua.client.core.network.event.EventLoginDataByWeek"
require "lua.client.core.network.event.EventPopupModel"
--- @class EventBirthdayModel : EventPopupModel
EventBirthdayModel = Class(EventBirthdayModel, EventPopupModel)

function EventBirthdayModel:Ctor()
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()
    --- @type EventLoginDataByWeek
    self.eventLoginData = nil
    --- @type List
    self.listOfLimitedPackStatistics = List()
    --- @type Dictionary
    self.roundRewards = nil
    --- @type GrowPatchLine
    self.growPatchLine = GrowPatchLine()
    --- @type Dictionary
    self.packSelectedItemDict = Dictionary()
    --- @type number
    self.selectSideId = nil
    --- @type List
    self.listQuestData = List()
    --- @type number
    self.seasonLightRivalPoint = 0
    --- @type number
    self.seasonDarkRivalPoint = 0
    --- @type EventBirthdayConfig
    self.config = nil
    --- @type BirthdayBossRankingInBound
    self.birthdayBossRankingInBound = nil
    --- @type number
    self.numberBuyBossTurn = 0

    EventPopupModel.Ctor(self)

end

function EventBirthdayModel:AddSelectItem(selectIndex)
    self.heroSelectedIndex = selectIndex
end

function EventBirthdayModel:BuyBossTurnSuccess(boughtTurn)
    self.numberBuyBossTurn = self.numberBuyBossTurn + boughtTurn
end

function EventBirthdayModel:GetHeroIdBySideIndex(sideIndex)
    return self.config:GetSelectHeroIdFromSide(sideIndex)
end

function EventBirthdayModel:GetCurrentHeroId()
    return self.config:GetSelectHeroIdFromSide(self.selectSideId)
end

function EventBirthdayModel:GetOppositeHeroId()
    for key, value in pairs(self.config.dictSelectSideConfig:GetItems()) do
        if key ~= self.selectSideId then
            return value
        end
    end
end

function EventBirthdayModel:GetOppositeBossData()
    return self.config.bossConfig:GetDefenderTeamData(self.selectSideId)
end

function EventBirthdayModel:GetChallengePriceList()
    return self.config.bossConfig.challengePriceList
end
--- @return EventBirthdayConfig
function EventBirthdayModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventBirthdayModel:GetHeroIdBySelectIndex()
    if self.heroSelectedIndex ~= -1 then
        local heroId = self:GetConfig().rewardPool:Get(self.heroSelectedIndex).id
        return ClientConfigUtils.GetHeroIdByFragmentHeroId(heroId)
    end
    return nil
end

function EventBirthdayModel:GetLegacyPoints()
    return InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_BIRTHDAY_LEGACY_POINT)
end

--- @param milestone number
--- @param isShowPopup
function EventBirthdayModel:IsValidMilestone(milestone, isShowPopup)
    local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money,
            MoneyType.EVENT_BIRTHDAY_LEGACY_POINT, milestone)
    return InventoryUtils.IsEnoughSingleResourceRequirement(rewardInBound, isShowPopup)
end

function EventBirthdayModel:GetGrowthPackLineConfig()
    self.growthPackLineConfig = self:GetConfig():GetLegacyPathConfig(self.timeData.dataId)
    local boughtCount = self:GetNumberBuy(EventActionType.BIRTHDAY_LEGACY_PATH_PURCHASE, 1)
    self.isUnlocked = boughtCount > 0
end

function EventBirthdayModel:HasNotification()
    return self:IsTabNotified(EventBirthdayTab.CHECK_IN) or self:IsTabNotified(EventBirthdayTab.WHEEL)
end

--- @param eventBirthdayTab EventBirthdayTab
function EventBirthdayModel:IsTabNotified(eventBirthdayTab)
    if eventBirthdayTab == EventBirthdayTab.CHECK_IN then
        return self:IsDailyLoginHasNotification()
    elseif eventBirthdayTab == EventBirthdayTab.LEGACY_PATH then
        return self:IsLegacyPathHasNotification()
    elseif eventBirthdayTab == EventBirthdayTab.DARK_LIGHT then
        return self:IsDarkLightTabHasNotification()
    elseif eventBirthdayTab == EventBirthdayTab.BOSS then
        return self:IsDarkLightBossTabHasNotification()
    end
    return false
end

function EventBirthdayModel:IsLegacyPathHasNotification()
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

function EventBirthdayModel:IsDarkLightTabHasNotification()
    --- @param v QuestUnitInBound
    for i, v in ipairs(self.listQuestData:GetItems()) do
        if (v.questState == QuestState.DOING and InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_BIRTHDAY_RIVAL_POINT, v.config:GetMainRequirementTarget()), false) or v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

function EventBirthdayModel:IsDarkLightBossTabHasNotification()
    local staminaInBound = self.config.bossConfig.challengePriceList:Get(1)
    if InventoryUtils.IsEnoughSingleResourceRequirement(staminaInBound, false) then
        return true
    end
    return false
end

--- @return List
function EventBirthdayModel:_GetAllClaimableMilestone(isFree, countLocked)
    local boughtCount = self:GetNumberBuy(EventActionType.BIRTHDAY_LEGACY_PATH_PURCHASE, 1)
    self.isUnlocked = boughtCount > 0
    self.growthPackLineConfig = self:GetConfig().lineConfig:Get(self.timeData.dataId)
    if (self.growthPackLineConfig == nil) then
        local dataId = self.timeData.dataId
    end
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

--- @param listMilestone List
function EventBirthdayModel:OnSuccessClaimListMilestone(isBasic, listMilestone)
    for i = 1, listMilestone:Count() do
        local milestone = listMilestone:Get(i)
        self.growPatchLine:OnSuccessClaimMilestone(isBasic, milestone)
    end
end

--- @return boolean, boolean
function EventBirthdayModel:GetMilestoneStateByNumber(number)
    if self.growPatchLine == nil then
        return false, false
    end
    local basic, premium = self.growPatchLine:GetMilestoneState(number)
    return basic ~= nil and basic > 0, premium ~= nil and premium > 0
end

function EventBirthdayModel:ReadInnerData(buffer)
    local week = self:GetConfig():GetLoginConfig():Count()
    self.eventLoginData = EventLoginDataByWeek(buffer, week)
    self.numberBuyDataDict = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        --- @type EventActionType
        local eventActionType = buffer:GetByte()
        local numberBuyData = NumberBuyData()
        numberBuyData:ReadBuffer(buffer)
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    self.heroSelectedIndex = buffer:GetInt()
    self.selectSideId = buffer:GetInt()
    self.growPatchLine = GrowPatchLine()
    self.growPatchLine:ReadBuffer(buffer)
    self:CheckResourceOnSeason()
    self:GetGrowthPackLineConfig()

    self.seasonDarkRivalPoint = tonumber(buffer:GetLong())
    self.seasonLightRivalPoint = tonumber(buffer:GetLong())
    self.numberBuyBossTurn = buffer:GetByte()
    self.numberWatchAdsRemain = buffer:GetInt()

    self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetQuestConfigDict())
    self.config = self:GetConfig()
end

function EventBirthdayModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

--- @param eventActionType EventActionType
function EventBirthdayModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventBirthdayModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

--- @return EventBirthdayConfig
function EventBirthdayModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventBirthdayModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventBirthdayModel:IsClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsClaimed()
    end
    return nil
end

function EventBirthdayModel:IsFreeClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsFreeClaim()
    end
    return false
end

function EventBirthdayModel:GetLoginData()
    return self.eventLoginData
end

function EventBirthdayModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventBirthdayEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
        zg.playerData.remoteConfig.eventBirthdayEnd = endTime
        zg.playerData:SaveRemoteConfig()
    end
end

function EventBirthdayModel:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.GetMoney(moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.EVENT_BIRTHDAY_WHEEL)
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventBirthdayModel:GetLimitedPackStatisticsInBound(packId)
    for i = 1, self.listOfLimitedPackStatistics:Count() do
        --- @type LimitedPackStatisticsInBound
        local itemData = self.listOfLimitedPackStatistics:Get(i)
        if itemData.packId == packId then
            return itemData
        end
    end
    local default = LimitedPackStatisticsInBound()
    default.packId = packId
    self.listOfLimitedPackStatistics:Add(default)
    return default
end

--- @param packId number
function EventBirthdayModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

--- @param opCode OpCode
--- @param packId number
function EventBirthdayModel:GetNumberBuyOpCode(opCode, packId)
    if opCode == OpCode.EVENT_BIRTHDAY_BUNDLE_PURCHASE then
        return self:GetNumberBuy(EventActionType.BIRTHDAY_BUNDLE_PURCHASE, packId)
    elseif opCode == OpCode.EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE then
        return self:GetNumberBuy(EventActionType.EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE, packId)
    elseif opCode == OpCode.EVENT_BIRTHDAY_LEGACY_PATH_PURCHASE then
        return self:GetNumberBuy(EventActionType.BIRTHDAY_LEGACY_PATH_PURCHASE, packId)
    end
    return 0
end

--- @param opCode OpCode
--- @param packId number
function EventBirthdayModel:AddNumberBuyOpCode(opCode, packId, number)
    if opCode == OpCode.EVENT_BIRTHDAY_BUNDLE_PURCHASE then
        return self:AddNumberBuy(EventActionType.BIRTHDAY_BUNDLE_PURCHASE, packId, number)
    elseif opCode == OpCode.EVENT_BIRTHDAY_LEGACY_PATH_PURCHASE then
        return self:AddNumberBuy(EventActionType.BIRTHDAY_LEGACY_PATH_PURCHASE, packId, number)
    end
end

function EventBirthdayModel:GetNumberWatchAdsRemain()
    return self.numberWatchAdsRemain
end

function EventBirthdayModel:SubNumberWatchAdsRemain()
    self.numberWatchAdsRemain = self.numberWatchAdsRemain - 1
end

--- @class EventBirthdayTab
EventBirthdayTab = {
    CHECK_IN = 1,
    DARK_LIGHT = 2,
    EXCHANGE = 4,
    BUNDLE = 5,
    EXCLUSIVE_BUNDLE = 6,
    LEGACY_PATH = 7,
    BOSS = 8
}

--- @class DarkLightLayout
DarkLightLayout = {
    SELECT_SIDE = 1,
    VERSUS = 2,
}