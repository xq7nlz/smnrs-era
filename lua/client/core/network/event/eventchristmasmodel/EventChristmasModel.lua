require "lua.client.core.network.playerData.quest.QuestUnitInBound"
require "lua.client.core.network.event.EventLoginDataByWeek"
require "lua.client.core.network.event.eventMidAutumnModel.FeedBeastQuestInBound"
require "lua.client.core.network.event.eventMidAutumnModel.EventMidAutumnBetArenaScoreInBound"
require "lua.client.core.network.event.eventMidAutumnModel.EventMidAutumnIsClaimBetRewardInbound"

--- @class EventChristmasModel : EventPopupModel
EventChristmasModel = Class(EventChristmasModel, EventPopupModel)

function EventChristmasModel:Ctor()
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

function EventChristmasModel:ReadInnerData(buffer)
    ---@type EventChristmasConfig
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

    --self:CheckResourceOnSeason()
end

--- @param midAutumnTab MidAutumnTab
function EventChristmasModel:IsTabNotified(midAutumnTab)
    if midAutumnTab == ChristmasTab.GOLDEN_TIME then
        return self:IsGoldenTimeHasNotification()
    elseif midAutumnTab == ChristmasTab.FEED_BEAST then
        return self:IsFeedBeastHasNotification()
    elseif midAutumnTab == ChristmasTab.EXCHANGE then
        return self:IsExchangeHasNotification()
    elseif midAutumnTab == ChristmasTab.SPECIAL_OFFER then
        return self:HasFreeOrAdsBundleLeft()
    elseif midAutumnTab == ChristmasTab.GEM_BOX then
        return self:IsGemBoxNotification()
    elseif midAutumnTab == ChristmasTab.DAILY_CHECK_IN then
        return self:IsDailyCheckInHasNotification()
    elseif midAutumnTab == ChristmasTab.QUEST then
        return self:HasClaimableDailyQuest()
    end
    return false
end

--- @return List
function EventChristmasModel:IsClaimedBetReward(day)
    if self.dictClaimBetRewardDay:IsContainKey(day) then
        return self.dictClaimBetRewardDay:Get(day)
    end
    return false
end

function EventChristmasModel:AddBoolClaimedBetReward(day, isClaimed)
    self.dictClaimBetRewardDay:Add(day, isClaimed)
end

--- @return List
function EventChristmasModel:GetListBetScore()
    return self.listBetArenaScore
end

function EventChristmasModel:GetBetScoreInboundByDay(day)
    if self.dictBetArenaScore:IsContainKey(day) then
        return self.dictBetArenaScore:Get(day)
    end
end

function EventChristmasModel:AddBetScoreInboundByDay(day, teamOne, teamTwo)
    local betArenaScore = {}
    betArenaScore.teamOne = teamOne
    betArenaScore.teamTwo = teamTwo
    self.dictBetArenaScore:Add(day, betArenaScore)
end

function EventChristmasModel:GetBetScoreServerInboundByDay(day)
    if self.dictBetArenaScoreServer:IsContainKey(day) then
        return self.dictBetArenaScoreServer:Get(day)
    end
end

function EventChristmasModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventChristmasModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventChristmasModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventChristmasModel:IsClaim()
    if self.lastClaimLoginTime ~= nil then
        return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.lastClaimLoginTime
                or self.lastClaimLoginDay >= 7
    end
    return nil
end

--- @return EventChristmasConfig
function EventChristmasModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventChristmasModel:HasNotification()
    return self:IsTabNotified(ChristmasTab.GOLDEN_TIME)
            or self:IsTabNotified(ChristmasTab.FEED_BEAST)
            or self:IsTabNotified(ChristmasTab.EXCHANGE)
            or self:IsTabNotified(ChristmasTab.SPECIAL_OFFER)
            or self:IsTabNotified(ChristmasTab.GEM_BOX)
            or self:IsTabNotified(ChristmasTab.DAILY_CHECK_IN)
end

function EventChristmasModel:IsGoldenTimeHasNotification()
    return false
end

function EventChristmasModel:IsFeedBeastHasNotification(isShowPopup)
    local eventFeedBeastConfig = self:GetConfig():GetEventFeedBeastConfig()
    return InventoryUtils.IsEnoughSingleResourceRequirement(eventFeedBeastConfig.feedRewardInBound,
            isShowPopup or false)
end

function EventChristmasModel:IsExchangeHasNotification()
    return false
end

function EventChristmasModel:IsSpecialOfferHasNotification()
    return false
end

function EventChristmasModel:IsGemBoxNotification()
    return false
end

function EventChristmasModel:IsDailyCheckInHasNotification()
    return not self:IsClaim()
end

function EventChristmasModel:HasFreeOrAdsBundleLeft()
    self.listData = ResourceMgr.GetPurchaseConfig():GetChristmas():GetPack(self.timeData.dataId).packDict
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if v.priceType == IapPackPriceType.FREE or v.priceType == IapPackPriceType.WATCH_ADS then
            if self:GetNumberBuy(EventActionType.CHRISTMAS_SPECIAL_OFFER_PURCHASE,v.id) < v.stock then
                return true
            end
        end
    end
    return false
end

function EventChristmasModel:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

function EventChristmasModel:ListQuestFeedBeastAddCurrentNumber(number)
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

function EventChristmasModel:ListQuestBetAddCurrentNumber(number)
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

function EventChristmasModel:CanRootEventReward()
    --- @type {listGoldenTimeReward : List, lastDuration: number}
    local goldenTimeConfig = self:GetConfig():GetGoldenTimeConfig()
    local serverTime = zg.timeMgr:GetServerTime()
    local startTime = self.timeData.startTime
    local endTime = self.timeData.endTime - goldenTimeConfig.lastDuration
    return startTime <= serverTime and endTime >= serverTime
end

function EventChristmasModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventChristmasEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventChristmasEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function EventChristmasModel:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.EVENT_CHRISTMAS_CANDY_BAR)
    clearResource(MoneyType.EVENT_CHRISTMAS_CANDLE)
    clearResource(MoneyType.EVENT_CHRISTMAS_LIGHTENED_CANDLE)
end

--- @return List
function EventChristmasModel:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

function EventChristmasModel:OnClaimQuestDailySuccess(questId)
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
function EventChristmasModel:GetListDailyQuestData()
    return self.listDailyQuest
end

--- @param listQuestData List|QuestUnitInBound
function EventChristmasModel:SortQuestByListQuestData(listQuestData)
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

--- @class ChristmasTab
ChristmasTab = {
    ARENA = 1,
    FEED_BEAST = 2,
    QUEST = 3,
    EXCHANGE = 4,
    FESTIVAL_MARKET = 5,
    SPECIAL_OFFER = 6,
}
