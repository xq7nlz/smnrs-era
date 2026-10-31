require "lua.client.core.network.playerData.quest.QuestUnitInBound"
require "lua.client.core.network.event.EventLoginDataByWeek"
require "lua.client.core.network.event.eventMidAutumnModel.FeedBeastQuestInBound"
require "lua.client.core.network.event.eventMidAutumnModel.EventMidAutumnBetArenaScoreInBound"
require "lua.client.core.network.event.eventMidAutumnModel.EventMidAutumnIsClaimBetRewardInbound"

--- @class EventMidAutumnModel : EventPopupModel
EventMidAutumnModel = Class(EventMidAutumnModel, EventPopupModel)

function EventMidAutumnModel:Ctor()
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()
    --- @type number
    self.feedBeastLevel = nil
    --- @type List
    self.listQuestData = nil
    ---@type List
    self.listDailyQuest = List()
    ---@type EventLoginData
    self.loginData = nil
    EventPopupModel.Ctor(self)
end

function EventMidAutumnModel:ReadInnerData(buffer)
    ---@type EventMidAutumnConfig
    self.config = self:GetConfig()
    self.numberBuyDataDict = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        --- @type EventActionType
        local eventActionType = buffer:GetByte()
        local numberBuyData = NumberBuyData()
        numberBuyData:ReadBuffer(buffer)
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end

    --- Event Login
    self.lastClaimLoginDay = buffer:GetInt()
    self.lastClaimLoginTime = buffer:GetLong()

    self.feedBeastLevel = buffer:GetInt()

    local sizeBetArenaScore = buffer:GetByte()
    self.dictBetArenaScore = Dictionary()
    for _ = 1, sizeBetArenaScore do
        local eventDay = buffer:GetByte()
        local betArenaScore = {}
        betArenaScore.teamOne = buffer:GetLong()
        betArenaScore.teamTwo = buffer:GetLong()
        self.dictBetArenaScore:Add(eventDay, betArenaScore)

    end
    --print("Dict Bet Arena Score")
    --print(LogUtils.ToDetail(self.dictBetArenaScore:GetItems()))
    --for i = 1, self.dictBetArenaScore:Count() do
    --    print(LogUtils.ToDetail(self.dictBetArenaScore:Get(i)))
    --end

    self.loginData = EventLoginData(buffer)
    --print("Current day :" .. self.loginData.eventCurrentDay)

    local sizeBetArenaScoreServer = buffer:GetByte()
    self.dictBetArenaScoreServer = Dictionary()
    for _ = 1, sizeBetArenaScoreServer do
        local eventDay = buffer:GetByte()
        local betArenaScoreServer = {}
        betArenaScoreServer.teamOne = buffer:GetLong()
        betArenaScoreServer.teamTwo = buffer:GetLong()
        self.dictBetArenaScoreServer:Add(eventDay, betArenaScoreServer)
    end
    --print("Dict Bet Arena Score Server")
    --print(LogUtils.ToDetail(self.dictBetArenaScoreServer:GetItems()))
    --for i = 1, self.dictBetArenaScoreServer:Count() do
    --    print(LogUtils.ToDetail(self.dictBetArenaScoreServer:Get(i)))
    --end

    local sizeClaimBetRewardDay = buffer:GetByte()
    self.dictClaimBetRewardDay = Dictionary()
    for _ = 1, sizeClaimBetRewardDay do
        local eventDay = buffer:GetByte()
        local isClaimed = buffer:GetBool()
        self.dictClaimBetRewardDay:Add(eventDay, isClaimed)
    end

    --print("Dict Claim Bet Reward Day")
    --print(LogUtils.ToDetail(self.dictClaimBetRewardDay:GetItems()))
    --for i = 1, self.dictClaimBetRewardDay:Count() do
    --    print(LogUtils.ToDetail(self.dictClaimBetRewardDay:Get(i)))
    --end

    self.listQuestData = List()
    local sizeQuest = buffer:GetByte()
    for _ = 1, sizeQuest do
        local feedBeastQuestInBound = FeedBeastQuestInBound()
        feedBeastQuestInBound:ReadBuffer(buffer)
        self.listQuestData:Add(feedBeastQuestInBound)
    end
    --print("Quest Feed :" .. sizeQuest)

    local sizeDailyQuest = buffer:GetByte()
    self.listDailyQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config:GetDailyQuestConfig(),sizeDailyQuest)
    --print("Daily Quest :" .. sizeDailyQuest)

    self:CheckResourceOnSeason()
end

--- @param midAutumnTab MidAutumnTab
function EventMidAutumnModel:IsTabNotified(midAutumnTab)
    if midAutumnTab == MidAutumnTab.GOLDEN_TIME then
        return self:IsGoldenTimeHasNotification()
    elseif midAutumnTab == MidAutumnTab.FEED_BEAST then
        return self:IsFeedBeastHasNotification()
    elseif midAutumnTab == MidAutumnTab.EXCHANGE then
        return self:IsExchangeHasNotification()
    elseif midAutumnTab == MidAutumnTab.SPECIAL_OFFER then
        return self:HasFreeOrAdsBundleLeft()
    elseif midAutumnTab == MidAutumnTab.GEM_BOX then
        return self:IsGemBoxNotification()
    elseif midAutumnTab == MidAutumnTab.DAILY_CHECK_IN then
        return self:IsDailyCheckInHasNotification()
    elseif midAutumnTab == MidAutumnTab.QUEST then
        return self:HasClaimableDailyQuest()
    end
    return false
end

--- @return List
function EventMidAutumnModel:IsClaimedBetReward(day)
    if self.dictClaimBetRewardDay:IsContainKey(day) then
        return self.dictClaimBetRewardDay:Get(day)
    end
    return false
end

function EventMidAutumnModel:AddBoolClaimedBetReward(day, isClaimed)
    self.dictClaimBetRewardDay:Add(day, isClaimed)
end

--- @return List
function EventMidAutumnModel:GetListBetScore()
    return self.listBetArenaScore
end

function EventMidAutumnModel:GetBetScoreInboundByDay(day)
    if self.dictBetArenaScore:IsContainKey(day) then
        return self.dictBetArenaScore:Get(day)
    end
end

function EventMidAutumnModel:AddBetScoreInboundByDay(day, teamOne, teamTwo)
    local betArenaScore = {}
    betArenaScore.teamOne = teamOne
    betArenaScore.teamTwo = teamTwo
    self.dictBetArenaScore:Add(day, betArenaScore)
end

function EventMidAutumnModel:GetBetScoreServerInboundByDay(day)
    if self.dictBetArenaScoreServer:IsContainKey(day) then
        return self.dictBetArenaScoreServer:Get(day)
    end
end

function EventMidAutumnModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventMidAutumnModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventMidAutumnModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventMidAutumnModel:IsClaim()
    if self.lastClaimLoginTime ~= nil then
        return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.lastClaimLoginTime
                or self.lastClaimLoginDay >= 7
    end
    return nil
end

--- @return EventMidAutumnConfig
function EventMidAutumnModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventMidAutumnModel:HasNotification()
    return self:IsTabNotified(MidAutumnTab.GOLDEN_TIME)
            or self:IsTabNotified(MidAutumnTab.FEED_BEAST)
            or self:IsTabNotified(MidAutumnTab.EXCHANGE)
            or self:IsTabNotified(MidAutumnTab.SPECIAL_OFFER)
            or self:IsTabNotified(MidAutumnTab.GEM_BOX)
            or self:IsTabNotified(MidAutumnTab.DAILY_CHECK_IN)
end

function EventMidAutumnModel:IsGoldenTimeHasNotification()
    return false
end

function EventMidAutumnModel:IsFeedBeastHasNotification(isShowPopup)
    local eventFeedBeastConfig = self:GetConfig():GetEventFeedBeastConfig()
    return InventoryUtils.IsEnoughSingleResourceRequirement(eventFeedBeastConfig.feedRewardInBound,
            isShowPopup or false)
end

function EventMidAutumnModel:IsExchangeHasNotification()
    return false
end

function EventMidAutumnModel:IsSpecialOfferHasNotification()
    return false
end

function EventMidAutumnModel:IsGemBoxNotification()
    return false
end

function EventMidAutumnModel:IsDailyCheckInHasNotification()
    return not self:IsClaim()
end

function EventMidAutumnModel:HasFreeOrAdsBundleLeft()
    self.listData = ResourceMgr.GetPurchaseConfig():GetMidAutumn():GetPack(self.timeData.dataId).packDict
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if v.priceType == IapPackPriceType.FREE or v.priceType == IapPackPriceType.WATCH_ADS then
            if self:GetNumberBuy(EventActionType.MID_AUTUMN_SPECIAL_OFFER_PURCHASE,v.id) < v.stock then
                return true
            end
        end
    end
    return false
end

function EventMidAutumnModel:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

function EventMidAutumnModel:ListQuestFeedBeastAddCurrentNumber(number)
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.config._questType == 2901 then
            v.number = v.number + number
            if v.number >= v.config:GetMainRequirementTarget() and v.questState == QuestState.DOING then
                v.questState = QuestState.DONE_REWARD_NOT_CLAIM
            end
        end
    end
end

function EventMidAutumnModel:ListQuestBetAddCurrentNumber(number)
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.config._questType == 2001 and v.config:GetRequirementsByIndex(2) == 180 then
            v.number = v.number + number
            if v.number >= v.config:GetMainRequirementTarget() and v.questState == QuestState.DOING then
                v.questState = QuestState.DONE_REWARD_NOT_CLAIM
            end
        end
    end
end

function EventMidAutumnModel:CanRootEventReward()
    --- @type {listGoldenTimeReward : List, lastDuration: number}
    local goldenTimeConfig = self:GetConfig():GetGoldenTimeConfig()
    local serverTime = zg.timeMgr:GetServerTime()
    local startTime = self.timeData.startTime
    local endTime = self.timeData.endTime - goldenTimeConfig.lastDuration
    return startTime <= serverTime and endTime >= serverTime
end

function EventMidAutumnModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventMidAutumnEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventMidAutumnEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function EventMidAutumnModel:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.EVENT_MID_AUTUMN_MOON_CAKE)
    clearResource(MoneyType.EVENT_MID_AUTUMN_LANTERN)
    clearResource(MoneyType.EVENT_MID_AUTUMN_LIGHT_LANTERN)
end

--- @return List
function EventMidAutumnModel:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

function EventMidAutumnModel:OnClaimQuestDailySuccess(questId)
    --- @param v QuestUnitInBound
    for _, v in ipairs(self.listDailyQuest:GetItems()) do
        if v.questId == questId then
            v.questState = QuestState.COMPLETED
            break
        end
    end
    self:SortQuestByListQuestData(self.listDailyQuest)
end

--- @return List
function EventMidAutumnModel:GetListDailyQuestData()
    return self.listDailyQuest
end

--- @param listQuestData List|QuestUnitInBound
function EventMidAutumnModel:SortQuestByListQuestData(listQuestData)
    local count = listQuestData:Count()
    local index = 1
    local firstIndex = 1
    for _ = 1, count do
        --- @type QuestUnitInBound
        local questData = listQuestData:Get(index)
        if questData.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            listQuestData:RemoveByIndex(index)
            listQuestData:Insert(questData, firstIndex)
            firstIndex = firstIndex + 1
        elseif questData.questState == QuestState.COMPLETED then
            listQuestData:RemoveByIndex(index)
            listQuestData:Insert(questData, count)
            index = index - 1
        end
        index = index + 1
    end
    return listQuestData
end

--- @class MidAutumnTab
MidAutumnTab = {
    ARENA = 1,
    FEED_BEAST = 2,
    QUEST = 3,
    EXCHANGE = 4,
    FESTIVAL_MARKET = 5,
    SPECIAL_OFFER = 6,
    --GEM_BOX = 7,
    --GOLDEN_TIME = 8,
    --DAILY_CHECK_IN = 9,
}
