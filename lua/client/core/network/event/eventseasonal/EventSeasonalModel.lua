--- @class EventSeasonalModel : EventPopupModel
EventSeasonalModel = Class(EventSeasonalModel, EventPopupModel)

function EventSeasonalModel:Ctor()
    ---@type EventLoginData
    self.loginData = nil
    ---@type List
    self.listOfLimitedPackStatistics = List()
    ---@type Dictionary
    self.dictExchange = Dictionary()
    ---@type EventActionType
    self.eventActionType = EventActionType.DRAGON_TOWER_EXCHANGE
    ---@type Dictionary
    self.dictHeroSelect = Dictionary()
    ---@type number
    self.numberFirework = nil
    ---@type List
    self.listCollectionQuest = List()
    ---@type RewardState
    self.finalRewardState = nil
    ---@type number
    self.numberBuyStamina = nil
    ---@type number
    self.challengeTotalDamage = nil
    ---@type EventSeasonalBossRankingInBound
    self.bossRankingInBound = nil
    EventPopupModel.Ctor(self)
end

--- @return EventSeasonalConfig
function EventSeasonalModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventSeasonalModel:ReadInnerData(buffer)
    ---@type EventSeasonalConfig
    self.config = self:GetConfig()
    self.loginData = EventLoginData(buffer)
    for _ = 1, buffer:GetByte() do
        self.listOfLimitedPackStatistics:Add(LimitedPackStatisticsInBound.CreateByBuffer(buffer))
    end
    for _ = 1, buffer:GetByte() do
        self.dictExchange:Add(buffer:GetInt(), buffer:GetInt())
    end
    for _ = 1, buffer:GetByte() do
        local slotId = buffer:GetInt()
        ---@type {heroId, thrownBall, rewardState}
        local data = {}
        data.heroId = buffer:GetInt()
        data.thrownBall = buffer:GetInt()
        data.rewardState = buffer:GetInt()
        self.dictHeroSelect:Add(slotId, data)
    end
    self.finalRewardState = buffer:GetInt()
    self.numberBuyStamina = buffer:GetInt()
    self.challengeTotalDamage = buffer:GetLong()
    self.listCollectionQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config:GetCollectionQuestConfig())
    self:CheckResourceOnSeason()
end

function EventSeasonalModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventSeasonal or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType(MoneyType.EVENT_SEASONAL_MONEY)
        self:ClearMoneyType(MoneyType.EVENT_SEASONAL_GUN_POWER)
        self:ClearMoneyType(MoneyType.EVENT_SEASONAL_GIFT_BOX)
        self:ClearMoneyType(MoneyType.EVENT_SEASONAL_BLUE_BALL)
        self:ClearMoneyType(MoneyType.EVENT_SEASONAL_GREEN_BALL)
        self:ClearMoneyType(MoneyType.EVENT_SEASONAL_GREY_BALL)
        self:ClearMoneyType(MoneyType.EVENT_SEASONAL_RED_BALL)
    end
    zg.playerData.remoteConfig.eventSeasonal = endTime
    zg.playerData:SaveRemoteConfig()
end

function EventSeasonalModel:ClearMoneyType(moneyType)
    local currentValue = InventoryUtils.GetMoney(moneyType)
    InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
end

-----------------------------------------LoginData-----------------------------------------

function EventSeasonalModel:GetLoginData()
    return self.loginData
end

function EventSeasonalModel:GetLoginLastClaimDay()
    return self.loginData.lastClaimDay
end

function EventSeasonalModel:AddLoginLastClaimDay()
    self.loginData.lastClaimDay = self.loginData.lastClaimDay + 1
    self.loginData.lastClaimLoginTime = zg.timeMgr:GetServerTime()
end

function EventSeasonalModel:IsClaimed()
    return self.loginData:IsClaimed()
end

function EventSeasonalModel:IsFreeClaim()
    return self.loginData:IsFreeClaimNew()
end

function EventSeasonalModel:GetEventCurrentDay()
    return self.loginData.eventCurrentDay
end

-----------------------------------------NumberOfBoughtLimitedPack-----------------------------------------

function EventSeasonalModel:AddNumberOfBoughtLimitedPack(id)
    ---@type LimitedPackStatisticsInBound
    local pack = self:GetPackData(id)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", id))
    end
end

function EventSeasonalModel:GetPackData(id)
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

function EventSeasonalModel:GetNumberOfBoughtLimitedPack(id)
    ---@param v LimitedPackStatisticsInBound
    for _, v in pairs(self.listOfLimitedPackStatistics:GetItems()) do
        if v.packId == id then
            return v:GetNumberOfBought()
        end
    end
    return 0
end

--- @param packId number
function EventSeasonalModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventSeasonalModel:GetLimitedPackStatisticsInBound(packId)
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


-----------------------------------------NumberOfBoughtLimitedPack-----------------------------------------

---@return Dictionary
function EventSeasonalModel:GetDictExchange()
    return self.dictExchange
end

---@return number
function EventSeasonalModel:GetExchangeNumberById(id)
    for k, v in pairs(self.dictExchange:GetItems()) do
        if k == id then
            return v
        end
    end
    self.dictExchange:Add(id, 0)
    return 0
end

function EventSeasonalModel:AddExchangeNumberByIdAndNumber(id, number)
    local current = self:GetExchangeNumberById(id)
    self.dictExchange:Add(id, current + number)
end

-----------------------------------------SummerGame-----------------------------------------

---@return Dictionary
function EventSeasonalModel:GetDictHeroSelect()
    return self.dictHeroSelect
end

---@return {heroId, thrownBall, rewardState}
function EventSeasonalModel:GetSlotDataById(slotId)
    if self.dictHeroSelect:Get(slotId) then
        return self.dictHeroSelect:Get(slotId)
    end
    ---@type {heroId, thrownBall, rewardState}
    local data = {}
    data.heroId = -1
    data.thrownBall = 0
    data.rewardState = RewardState.NOT_AVAILABLE_TO_CLAIM
    self.dictHeroSelect:Add(slotId, data)
    return data
end

---@return {heroId, thrownBall, rewardState}
function EventSeasonalModel:SetHeroToSlot(slotId, heroId)
    local data = self:GetSlotDataById(slotId)
    data.heroId = heroId
    self.dictHeroSelect:Add(slotId, data)
end

---@return {heroId, thrownBall, rewardState}
function EventSeasonalModel:AddBallThrownToSlot(slotId, ballNumber)
    local data = self:GetSlotDataById(slotId)
    data.thrownBall = data.thrownBall + ballNumber
    self.dictHeroSelect:Add(slotId, data)
end

---@return {heroId, thrownBall, rewardState}
---@param rewardState RewardState
function EventSeasonalModel:SetRewardStateSlot(slotId, rewardState)
    local data = self:GetSlotDataById(slotId)
    data.rewardState = rewardState
    self.dictHeroSelect:Add(slotId, data)
end

---@return {heroId, thrownBall, rewardState}
---@param rewardState RewardState
function EventSeasonalModel:SetSlotData(slotId, heroId, ballNumber, rewardState)
    local data = self:GetSlotDataById(slotId)
    data.heroId = heroId
    data.thrownBall = ballNumber
    data.rewardState = rewardState
    self.dictHeroSelect:Add(slotId, data)
end

---@return RewardState
function EventSeasonalModel:GetSummerGameFinalRewardState()
    return self.finalRewardState
end

---@return void
------@param rewardState RewardState
function EventSeasonalModel:SetSummerGameFinalRewardStats(rewardState)
    self.finalRewardState = rewardState
end

-----------------------------------------FireworkCreator-----------------------------------------

---@return number
function EventSeasonalModel:GetFireworkCreator()
    return self.numberFirework
end

function EventSeasonalModel:AddNumberFirework(addNumber)
    local number = addNumber or 1
    self.numberFirework = self.numberFirework + number
end

-----------------------------------------QuestFireworkCollection-----------------------------------------

function EventSeasonalModel:OnClaimQuestCollectionSuccess(questId)
    for i = 1, self:GetListCollectionQuestData():Count() do
        --- @type QuestUnitInBound
        local questData = self.listCollectionQuest:Get(i)
        if questData.questId == questId then
            questData.questState = QuestState.COMPLETED
            break
        end
    end
    self:SortQuestByData(self.listCollectionQuest)
end

function EventSeasonalModel:HasQuestCollectionDoneButNotClaim()
    --- @param questUnitInBound QuestUnitInBound
    for _, questUnitInBound in pairs(self:GetListCollectionQuestData():GetItems()) do
        local mainRequire = questUnitInBound.fixedTarget or questUnitInBound.config:GetMainRequirementTarget()
        if questUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM or
                (questUnitInBound.questState ~= QuestState.COMPLETED and questUnitInBound.number >= mainRequire) then
            return true
        end
    end
end

--- @return List
function EventSeasonalModel:GetListCollectionQuestData()
    return self.listCollectionQuest
end

function EventSeasonalModel:ListCollectionQuestAddRequireNumber(number)
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listCollectionQuest:GetItems()) do
        v.number = v.number + number
    end
end

function EventSeasonalModel:SortQuestByData(listQuest)
    return self:SortQuestByListQuestData(listQuest)
end

--- @param listQuestData List|QuestUnitInBound
function EventSeasonalModel:SortQuestByListQuestData(listQuestData)
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
-----------------------------------------Notification-----------------------------------------

function EventSeasonalModel:HasNotification()
    return self:IsTabNotified(EventSeasonalTab.DAILY_CHECKIN)
            or self:IsTabNotified(EventSeasonalTab.FIREWORK_CREATOR)
            or self:IsTabNotified(EventSeasonalTab.FIREWORK_SHOP)
            or self:IsTabNotified(EventSeasonalTab.FIREWORK_EXCHANGE)
            or self:IsTabNotified(EventSeasonalTab.ROYAL_CHALLENGE)
            or self:IsTabNotified(EventSeasonalTab.SUPPER_GIFT)
            or self:IsTabNotified(EventSeasonalTab.FIREWORK_COLLECTION)
end

function EventSeasonalModel:IsTabNotified(eventSeasonalTab)
    if eventSeasonalTab == EventSeasonalTab.DAILY_CHECKIN then
        return not self:IsClaimed()
    elseif eventSeasonalTab == EventSeasonalTab.FIREWORK_CREATOR then
        return self:CanCreateMojito() or self:HasQuestCollectionDoneButNotClaim()
    elseif eventSeasonalTab == EventSeasonalTab.FIREWORK_SHOP then
        return self:HasFreeOrAdsBundleLeft()
    elseif eventSeasonalTab == EventSeasonalTab.FIREWORK_EXCHANGE then
        return self:HasSlotCanExchange()
    elseif eventSeasonalTab == EventSeasonalTab.ROYAL_CHALLENGE then
        return self:GetNumberStamina() > 0
    elseif eventSeasonalTab == EventSeasonalTab.SUPPER_GIFT then
        return self:SummerGameHasReward() or self:SummerGameHasFreeSlot() or self:SummerGameCanThrowBall() or self:SummerGameCanClaimFinalReward()
    elseif eventSeasonalTab == EventSeasonalTab.FIREWORK_COLLECTION then
        return false
    end
    return false
end

function EventSeasonalModel:HasFreeOrAdsBundleLeft()
    local packOfProducts = ResourceMgr.GetPurchaseConfig():GetEventSeasonalBundleStore():GetCurrentPack()
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

function EventSeasonalModel:HasSlotCanExchange()
    local dict = self.config:GetExchangeGroupRewardConfig()
    ---@param listReward List
    for _, listReward in pairs(dict:GetItems()) do
        ---@param v EventSeasonalExchangeItemData
        for _, v in pairs(listReward:GetItems()) do
            if self:GetExchangeNumberById(v.id) < v.limit then
                local number = InventoryUtils.GetMoney(v.priceType)
                if number > v.price then
                    return true
                end
            end
        end
    end
    return false
end

function EventSeasonalModel:SummerGameHasReward()
    local dict = self.config:GetDictHeroSelect()
    for slotId, _ in pairs(dict:GetItems()) do
        ---@type {heroId, thrownBall, rewardState}
        local data = self:GetSlotDataById(slotId)
        if data.rewardState == RewardState.AVAILABLE_TO_CLAIM then
            return true
        end
    end
    return false
end

function EventSeasonalModel:SummerGameHasFreeSlot()
    local dict = self.config:GetDictHeroSelect()
    for slotId, _ in pairs(dict:GetItems()) do
        ---@type {heroId, thrownBall, rewardState}
        local data = self:GetSlotDataById(slotId)
        if data.heroId < 0 then
            return true
        end
    end
    return false
end

function EventSeasonalModel:SummerGameCanThrowBall()
    local dict = self.config:GetDictHeroSelect()
    ---@param config {ballId, targetBall, listHeroId}
    for slotId, config in pairs(dict:GetItems()) do
        ---@type {heroId, thrownBall, rewardState}
        local data = self:GetSlotDataById(slotId)
        if data.thrownBall < config.targetBall then
            return true
        end
    end
    return false
end

function EventSeasonalModel:SummerGameCanClaimFinalReward()
    return self.finalRewardState == RewardState.AVAILABLE_TO_CLAIM
end

function EventSeasonalModel:CanCreateMojito()
    --- @type {moneyType, moneyValue}
    local requireConfig = self.config:GetMojitoConfig()
    local number = InventoryUtils.GetMoney(requireConfig.moneyType)
    return number > requireConfig.moneyValue
end

-----------------------------------------RoyalChallenge-----------------------------------------

function EventSeasonalModel:GetServerDay()
    return self:GetEventCurrentDay()
end

function EventSeasonalModel:GetNumberBuyStamina()
    return self.numberBuyStamina
end

function EventSeasonalModel:AddNumberBuyStamina(quantity)
    local number = quantity or 1
    self.numberBuyStamina = self.numberBuyStamina + number
end

function EventSeasonalModel:GetNumberStamina()
    return InventoryUtils.GetMoney(self.config:GetChallengeConfig().moneyType)
end

-----------------------------------------CreateMojito-----------------------------------------


--- @class EventSeasonalTab
EventSeasonalTab = {
    DAILY_CHECKIN = 1,
    FIREWORK_CREATOR = 2,
    FIREWORK_SHOP = 3,
    FIREWORK_EXCHANGE = 4,
    ROYAL_CHALLENGE = 5,
    SUPPER_GIFT = 6,
    FIREWORK_COLLECTION = 7,
}