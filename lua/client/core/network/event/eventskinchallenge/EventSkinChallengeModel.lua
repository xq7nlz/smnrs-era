require "lua.client.core.network.event.EventPopupModel"
require "lua.client.core.network.event.eventSkinChallenge.DayRewardStateInBound"
--- @class EventSkinChallengeModel : EventPopupModel
EventSkinChallengeModel = Class(EventSkinChallengeModel, EventPopupModel)

function EventSkinChallengeModel:Ctor()
    EventPopupModel.Ctor(self)
    --- @type number
    self.randomDefenderTeamId = nil
    --- @type number
    self.challengeFinishDay = nil
    --- @type Dictionary|RewardState
    self.dayRewardStateDict = Dictionary()
    --- @type Dictionary
    self.numberBuyDataMap = Dictionary()
    --- @type List -- QuestUnitInBound
    self.listQuestData = List()
    --- @type Dictionary -- dayId - List<QuestUnitInBound>
    self.dictQuestData = Dictionary()
end

--- @return EventSkinChallengeConfig
function EventSkinChallengeModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventSkinChallengeModel:ReadInnerData(buffer)
    self.randomDefenderTeamId = buffer:GetInt()
    local size = buffer:GetShort()
    self.dayRewardStateDict = DayRewardStateInBound.CreateDictionaryFromBuffer(buffer, size)
    self.numberBuyDataMap = EventPopupModel.ReadNumberBuyDataDict(buffer)
    self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer,
            self:GetConfig():GetCollectionQuestConfig())
    self.config = self:GetConfig()
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
    self:CheckResourceOnSeason()
end

function EventSkinChallengeModel:HasNotification()
    return self:IsTabNotified(EventSkinChallengeTab.QUEST)
end

function EventSkinChallengeModel:IsTabNotified(eventTab)
    if eventTab == EventSkinChallengeTab.QUEST then
        return self:HasChallengeDoneButNotClaim()
    end
    return false
end

function EventSkinChallengeModel:OnClaimChallengeSuccess(dayId)
    for i = 1, self.dayRewardStateDict:Count() do
        if i == dayId then
            self.dayRewardStateDict:Add(i, RewardState.CLAIMED)
        end
    end
end

function EventSkinChallengeModel:HasQuestDoneButNotClaim()
    --- @param questUnitInBound QuestUnitInBound
    for i, questUnitInBound in pairs(self:GetListQuestData():GetItems()) do
        if questUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

function EventSkinChallengeModel:HasChallengeDoneButNotClaim()
    --- @param rewardState RewardState
    for i, rewardState in pairs(self.dayRewardStateDict:GetItems()) do
        if rewardState == RewardState.AVAILABLE_TO_CLAIM then
            return true
        end
    end
end

--- @return List
function EventSkinChallengeModel:GetListQuestDataByDay(dayId)
    if self.dictQuestData:Count() < 1 then
        self:ReadQuestDataByDay()
    end
    return self.dictQuestData:Get(dayId)
end

--- @return List
function EventSkinChallengeModel:ReadQuestDataByDay()
    local day = 0
    local list
    for i = 1, self.config:GetDayChallengeDict():Count() do
        if self.config:GetDayChallengeDict():Get(i) ~= day then
            list = List()
            day = self.config:GetDayChallengeDict():Get(i)
            self.dictQuestData:Add(day, list)
        end
        list:Add(self.listQuestData:Get(i))
    end
end

function EventSkinChallengeModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventSkinChallengeEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventSkinChallengeEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function EventSkinChallengeModel:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.GetMoney(moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.SKIN_BADGE)
end

function EventSkinChallengeModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

--- @param eventActionType EventActionType
function EventSkinChallengeModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataMap:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataMap:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventSkinChallengeModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

--- @class EventSkinChallengeTab
EventSkinChallengeTab = {
    QUEST = 1,
    SELECT = 2,
    EXCHANGE = 3,
    BUNDLE = 4,
}
