require "lua.client.core.network.iap.SubscriptionPackCollectionInBound"

--- @class EventEasterEggModel : EventPopupModel
EventEasterEggModel = Class(EventEasterEggModel, EventPopupModel)

function EventEasterEggModel:Ctor()
    --- @type EventLoginData
    self.eventLoginData = nil
    --- @type List
    self.listOfLimitedPackStatistics = nil
    --- @type Dictionary
    self.numberBuyDataDict = nil

    --- @type Dictionary
    self.packSelectedItemDict = Dictionary()
    --- @type Dictionary
    self.subscriptionDataDict = nil

    EventPopupModel.Ctor(self)
end

function EventEasterEggModel:HasNotification()
    return self:IsTabNotified(EasterEggTab.CHECK_IN)
            or self:IsTabNotified(EasterEggTab.DICE)
            or self:IsTabNotified(EasterEggTab.BUNNY_CARD)
            or self:IsTabNotified(EasterEggTab.LIMITED_OFFER)
            or self:IsTabNotified(EasterEggTab.BREAK)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventEasterEggModel:ReadData(buffer)
    EventPopupModel.ReadData(self, buffer)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventEasterEggModel:ReadInnerData(buffer)
    self.eventLoginData = EventLoginData(buffer)

    self.numberBuyDataDict = EventPopupModel.ReadNumberBuyDataDict(buffer)

    local size = buffer:GetByte()
    for _ = 1, size do
        self.packSelectedItemDict:Add(buffer:GetInt(), buffer:GetInt() + 1)
    end
    require "lua.client.core.network.event.eventHalloweenModel.EventDiceGameData"
    self.eventDiceGameData = EventDiceGameData(buffer)
end

function EventEasterEggModel:ReadSubscriptionPack(buffer)
    self.subscriptionDataDict = Dictionary()
    local size = buffer:GetByte()
    for _ = 1, size do
        local dataId = buffer:GetByte()
        local subscriptionPackCollectionInBound = SubscriptionPackCollectionInBound(buffer)
        self.subscriptionDataDict:Add(dataId, subscriptionPackCollectionInBound)
    end
end

function EventEasterEggModel:GetDiceData()
    return self.eventDiceGameData
end

function EventEasterEggModel:GetPositionDiceList()
    return self.eventDiceGameData.historyPositionList
end

--- @return EventMergeServerConfig
function EventEasterEggModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @return EventEasterEggConfig
function EventEasterEggModel:IsTabNotified(mergeServerTab)
    if mergeServerTab == EasterEggTab.CHECK_IN then
        return self:IsDailyLoginHasNotification()
    elseif mergeServerTab == EasterEggTab.DICE then
        return self:isNotificationExchangeReward()
    elseif mergeServerTab == EasterEggTab.BUNNY_CARD then
        return false
    elseif mergeServerTab == EasterEggTab.BREAK then
        local dictEgg = Dictionary()
        dictEgg:Add(1, MoneyType.EVENT_EASTER_WOOD_HAMMER)
        dictEgg:Add(2, MoneyType.EVENT_EASTER_YELLOW_HAMMER)
        dictEgg:Add(3, MoneyType.EVENT_EASTER_RAINBOW_HAMMER)
        for i = 1, 3 do
           local number = InventoryUtils.Get(ResourceType.Money, dictEgg:Get(i))
            if number > 0 then
                return true
            end
        end
    end
    return false
end

function EventEasterEggModel:RequestClaimQuest(questId, callback)
    local onSuccess = function(rewardList)
        PopupUtils.ClaimAndShowRewardList(rewardList)
        self:OnClaimQuestSuccess(questId)
        if callback then
            callback()
        end
    end
    QuestDataInBound.RequestClaimQuest(OpCode.EVENT_SERVER_MERGE_DAILY_QUEST_CLAIM, questId, onSuccess)
end

function EventEasterEggModel:OnClaimQuestSuccess(questId)
    for i = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(i)
        if questUnitInBound.questId == questId then
            questUnitInBound.questState = QuestState.COMPLETED
            break
        end
    end
    self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end

function EventEasterEggModel:IsFreeClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsFreeClaim()
    end
    return false
end

function EventEasterEggModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventEasterEggModel:IsClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsClaimed()
    end
    return nil
end

function EventEasterEggModel:IsFreeClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsFreeClaim()
    end
    return false
end

--- @return boolean
function EventEasterEggModel:isNotificationExchangeReward()
    if self.listExchangeReward == nil then
        self.listExchangeReward = self:GetConfig():GetListRewardExchangeConfig()
    end
    local firstReward = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_EASTER_POINT, self.listExchangeReward:Get(1).price)
    return InventoryUtils.IsEnoughSingleResourceRequirement(firstReward, false)
end

function EventEasterEggModel:GetLoginData()
    return self.eventLoginData
end

--- @param eventActionType EventActionType
function EventEasterEggModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

--- @param eventActionType EventActionType
function EventEasterEggModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

--- @param eventActionType EventActionType
function EventEasterEggModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventEasterEggModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventEasterEggEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventEasterEggEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function EventEasterEggModel:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.GetMoney(moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.EVENT_EASTER_SILVER_EGG)
    clearResource(MoneyType.EVENT_EASTER_YELLOW_EGG)
    clearResource(MoneyType.EVENT_EASTER_RAINBOW_EGG)
    clearResource(MoneyType.EVENT_EASTER_YELLOW_HAMMER)
    clearResource(MoneyType.EVENT_EASTER_RAINBOW_HAMMER)
    clearResource(MoneyType.EVENT_EASTER_WOOD_HAMMER)
    clearResource(MoneyType.EVENT_EASTER_SUPER_DICE)
    clearResource(MoneyType.EVENT_EASTER_POINT)
    clearResource(MoneyType.EVENT_EASTER_DICE)
end

function EventEasterEggModel:AddSelectItem(id,selectIndex)
    self.packSelectedItemDict:Add(id,selectIndex)
end

--- @return SubscriptionPackCollectionInBound
function EventEasterEggModel:GetSubscriptionDurationData(dataId)
    local subscriptionPackCollectionInBound = self.subscriptionDataDict:Get(dataId)
    if subscriptionPackCollectionInBound == nil then
        subscriptionPackCollectionInBound = SubscriptionPackCollectionInBound()
        self.subscriptionDataDict:Add(dataId, subscriptionPackCollectionInBound)
    end
    return subscriptionPackCollectionInBound
end


--- @return EasterEggExchangeRewardConfig
function EventEasterEggModel:GetPoolReward(id)
    return  self:GetConfig():GetPoolReward(id)
end


--- @class EasterEggTab
EasterEggTab = {
    CHECK_IN = 1,
    DICE = 2,
    BUNNY_CARD = 3,
    EXCLUSIVE_BUNDLE = 4,
    HUNT = 5,
    BREAK = 6,
    EASTER_BUNDLE = 7
}