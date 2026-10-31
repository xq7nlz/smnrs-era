require "lua.client.core.network.event.EventPopupModel"
require "lua.client.core.network.event.EventLoginDataByWeek"

--- @class EventTowerOfEitriModel : EventPopupModel
EventTowerOfEitriModel = Class(EventTowerOfEitriModel, EventPopupModel)

function EventTowerOfEitriModel:Ctor()
    ---@type number
    self.towerBuildFreeDaily = nil
    ---@type number
    self.currentFloor = nil
    ---@type List
    self.listTowerQuest = List()
    ---@type List
    self.listDailyQuest = List()
    ---@type List
    self.listOfLimitedPackStatistics = List()
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()
    ---@type number
    self.currentExchangeStage = 0
    ---@type number
    self.hammerBonusNumber = 0
    ---@type number
    self.currentServerProgress = 0
    ---@type List
    self.listRewardServerBuildingProgress = List()
    ---@type number
    self.currentServerBuildingProgress = nil
    ---@type EventActionType
    self.eventActionType = EventActionType.DRAGON_TOWER_EXCHANGE
    EventPopupModel.Ctor(self)
end

--- @return EventTowerOfEitriConfig
function EventTowerOfEitriModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventTowerOfEitriModel:ReadInnerData(buffer)
    ---@type EventTowerOfEitriConfig
    self.config = self:GetConfig()
    self.towerBuildFreeDaily = buffer:GetByte()
    self.currentFloor = buffer:GetInt()
    for _ = 1, buffer:GetByte() do
        self.listOfLimitedPackStatistics:Add(LimitedPackStatisticsInBound.CreateByBuffer(buffer))
    end
    for _ = 1, buffer:GetByte() do
        --- @type EventActionType
        local eventActionType = buffer:GetByte()
        local numberBuyData = NumberBuyData()
        numberBuyData:ReadBuffer(buffer)
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    self.currentExchangeStage = buffer:GetInt()
    self.hammerBonusNumber = buffer:GetInt()
    for _ = 1, buffer:GetByte() do
        self.listRewardServerBuildingProgress:Add(buffer:GetLong())
    end
    self.currentServerProgress = buffer:GetLong()
    self.listTowerQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config:GetTowerQuestConfig())
    self.listDailyQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config:GetDailyQuestConfig())
    self:CheckResourceOnSeason()
end

function EventTowerOfEitriModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventTowerOfEitri or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventTowerOfEitri = endTime
    zg.playerData:SaveRemoteConfig()
end

function EventTowerOfEitriModel:ClearMoneyType()
    local currentValue = InventoryUtils.GetMoney(MoneyType.EVENT_DRAGON_TOWER_COIN)
    InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_DRAGON_TOWER_COIN, currentValue)
end

-----------------------------------------TowerData-----------------------------------------

function EventTowerOfEitriModel:GetTowerCurrentFloor()
    return self.currentFloor
end

function EventTowerOfEitriModel:AddTowerCurrentFloor(number)
    self.currentFloor = self.currentFloor + number
end

function EventTowerOfEitriModel:GeTowerBuildFreeDaily()
    return self.towerBuildFreeDaily or 0
end

function EventTowerOfEitriModel:AddTowerBuildFreeDaily()
    self.towerBuildFreeDaily = self.towerBuildFreeDaily + 1
    return self.towerBuildFreeDaily
end

function EventTowerOfEitriModel:GetCurrentServerBuildingNumber()
    return self.currentServerProgress
end

function EventTowerOfEitriModel:GetListServerBuildingCollected()
    return self.listRewardServerBuildingProgress
end

function EventTowerOfEitriModel:AddListServerBuildingCollected()
    local _, listFloor = self.config:GetServerBuildingRewardConfig()
    for _, v in pairs(listFloor:GetItems()) do
        if self.currentServerProgress > v and not self.listRewardServerBuildingProgress:IsContainValue(v) then
            self.listRewardServerBuildingProgress:Add(v)
        end
    end
end

-----------------------------------------NumberOfBoughtLimitedPack-----------------------------------------

function EventTowerOfEitriModel:AddNumberOfBoughtLimitedPack(id)
    ---@type LimitedPackStatisticsInBound
    local pack = self:GetPackData(id)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", id))
    end
end

function EventTowerOfEitriModel:GetPackData(id)
    ---@param v LimitedPackStatisticsInBound
    for _, v in pairs(self.listOfLimitedPackStatistics:GetItems()) do
        if v.packId == id then
            return v
        end
    end
    local default = LimitedPackStatisticsInBound()
    default.packId = id
    self.listOfLimitedPackStatistics:Add(default)
    return default
end

function EventTowerOfEitriModel:GetNumberOfBoughtLimitedPack(id)
    ---@param v LimitedPackStatisticsInBound
    for _, v in pairs(self.listOfLimitedPackStatistics:GetItems()) do
        if v.packId == id then
            return v:GetNumberOfBought()
        end
    end
    return 0
end

--- @param packId number
function EventTowerOfEitriModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventTowerOfEitriModel:GetLimitedPackStatisticsInBound(packId)
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

-----------------------------------------Notification-----------------------------------------

function EventTowerOfEitriModel:HasNotification()
    return self:IsTabNotified(EventTowerOfEitriTab.TOWER_BUILD)
            or self:IsTabNotified(EventTowerOfEitriTab.TOWER_EXCHANGE)
            or self:IsTabNotified(EventTowerOfEitriTab.TOWER_BUNDLE)
            or self:IsTabNotified(EventTowerOfEitriTab.TOWER_QUEST)
end

function EventTowerOfEitriModel:HasFreeBuildTower()
    return self.towerBuildFreeDaily < self.config:GetEventTowerConfig().dailyFree
end

function EventTowerOfEitriModel:HasClaimableTowerQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listTowerQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
    return false
end

function EventTowerOfEitriModel:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

function EventTowerOfEitriModel:HasHammer()
    local currentValue = InventoryUtils.GetMoney(MoneyType.EVENT_DRAGON_TOWER_HAMMER)
    return currentValue > 0
end

function EventTowerOfEitriModel:HasHammerInPool()
    return self.hammerBonusNumber > 0
end

function EventTowerOfEitriModel:CanExchangeAtLeastOneItem()
    local currentCoin = InventoryUtils.GetMoney(MoneyType.EVENT_DRAGON_TOWER_COIN)
    ---@type Dictionary
    local dictStageReward = self.config:GetExchangeRewardConfig()
    for i = 1, self:GetCurrentExchangeStage() do
        ---@param v EventTowerOfEitriExchangeItemData
        for _, v in pairs(dictStageReward:Get(i):GetItems()) do
            if self:GetNumberExchange(v.id) < v.limit and currentCoin >= v.price then
                return true
            end
        end
    end
    return false
end

function EventTowerOfEitriModel:HasFreeOrAdsBundleLeft()
    local packOfProducts = ResourceMgr.GetPurchaseConfig():GetEventTowerOfEitriBundleStore():GetCurrentPack()
    --- @param v ProductConfig
    for _, v in pairs(packOfProducts.packDict:GetItems()) do
        if v.priceType == IapPackPriceType.FREE or v.priceType == IapPackPriceType.WATCH_ADS then
            if self:GetNumberOfBoughtLimitedPack(v.id) < v.stock then
                return true
            end
        end
    end
    return false
end

function EventTowerOfEitriModel:IsTabNotified(eventTowerOfEitriTab)
    if eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_BUILD then
        return self:HasHammer() or self:HasFreeBuildTower() or self:HasClaimableTowerQuest()
    elseif eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_EXCHANGE then
        return self:HasHammerInPool() or self:CanExchangeAtLeastOneItem()
    elseif eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_BUNDLE then
        return self:HasFreeOrAdsBundleLeft()
    elseif eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_QUEST then
        return self:HasClaimableDailyQuest()
    end
    return false
end

-----------------------------------------Quest-----------------------------------------

--- @return List
function EventTowerOfEitriModel:GetListTowerQuestData()
    return self.listTowerQuest
end

--- @return List
function EventTowerOfEitriModel:GetListDailyQuestData()
    return self.listDailyQuest
end

--- @return List
function EventTowerOfEitriModel:GetListSortedTowerQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listTowerQuest)
    return self:SortQuestByListQuestData(self.listTowerQuest)
end

function EventTowerOfEitriModel:OnClaimQuestTowerSuccess(questId)
    --- @param v QuestUnitInBound
    for _, v in ipairs(self.listTowerQuest:GetItems()) do
        if v.questId == questId then
            v.questState = QuestState.COMPLETED
            break
        end
    end
    self:SortQuestByListQuestData(self.listTowerQuest)
end

--- @return List
function EventTowerOfEitriModel:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

function EventTowerOfEitriModel:OnClaimQuestDailySuccess(questId)
    --- @param v QuestUnitInBound
    for _, v in ipairs(self.listDailyQuest:GetItems()) do
        if v.questId == questId then
            v.questState = QuestState.COMPLETED
            break
        end
    end
    self:SortQuestByListQuestData(self.listDailyQuest)
end

function EventTowerOfEitriModel:ListTowerQuestAddCurrentNumber(number)
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listTowerQuest:GetItems()) do
        v.number = v.number + number
        if v.number >= v.config:GetMainRequirementTarget() and v.questState == QuestState.DOING then
            v.questState = QuestState.DONE_REWARD_NOT_CLAIM
        end
    end
end

--- @param listQuestData List|QuestUnitInBound
function EventTowerOfEitriModel:SortQuestByListQuestData(listQuestData)
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

-----------------------------------------Exchange-----------------------------------------

--- @return number
function EventTowerOfEitriModel:GetCurrentHammerInPool()
    return self.hammerBonusNumber
end

function EventTowerOfEitriModel:AddHammerInPool(number)
    self.hammerBonusNumber = self.hammerBonusNumber + number
end

function EventTowerOfEitriModel:SetHammerInPool(number)
    self.hammerBonusNumber = number
end

--- @return number
function EventTowerOfEitriModel:GetCurrentExchangeStage()
    return self.currentExchangeStage
end

function EventTowerOfEitriModel:SetExchangeStage(stageId)
    self.currentExchangeStage = stageId
end

--- @return number
function EventTowerOfEitriModel:GetNumberExchange(id)
    if self.numberBuyDataDict:IsContainKey(self.eventActionType) then
        ---@type NumberBuyData
        local numberBuyData = self.numberBuyDataDict:Get(self.eventActionType)
        return numberBuyData.buyStatsDict:GetOrDefault(id, 0)
    else
        local numberBuyData = NumberBuyData()
        numberBuyData.buyStatsDict:Add(id, 0)
        self.numberBuyDataDict:Add(self.eventActionType, numberBuyData)
        return 0
    end
end

function EventTowerOfEitriModel:AddNumberExchange(id)
    if self.numberBuyDataDict:IsContainKey(self.eventActionType) then
        ---@type NumberBuyData
        local numberBuyData = self.numberBuyDataDict:Get(self.eventActionType)
        numberBuyData:AddNumberBoughtWithPackId(id)
    end
end

--- @class EventTowerOfEitriTab
EventTowerOfEitriTab = {
    TOWER_BUILD = 1,
    TOWER_EXCHANGE = 2,
    TOWER_BUNDLE = 4,
    TOWER_QUEST = 3,
}