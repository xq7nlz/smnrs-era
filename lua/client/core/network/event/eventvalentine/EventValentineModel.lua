require "lua.client.core.network.event.eventXmasModel.ChristmasChallengeBossInBound"
require "lua.client.core.network.event.eventValentine.ValentineOpenCardData"

--- @class EventValentineModel : EventPopupModel
EventValentineModel = Class(EventValentineModel, EventPopupModel)

function EventValentineModel:Ctor()
    --- @type Dictionary
    self.numberBuyDataDict = nil
    --- @type EventLoginData
    self.eventLoginData = nil
    ---@type ChristmasChallengeBossInBound
    self.eventBossChallengeInBound = nil
    ---@type ValentineOpenCardData
    self.valentineOpenCardData = nil

    --- @type Dictionary
    self.dictLimitedPackStatistics = Dictionary()
    EventPopupModel.Ctor(self)
end

function EventValentineModel:IsFreeClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsFreeClaim()
    end
    return false
end

function EventValentineModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventValentineModel:HasNotification()
    return self:IsTabNotified(ValentineTab.CHECK_IN) or self:IsTabNotified(ValentineTab.OPEN_CARD) or self:IsTabNotified(ValentineTab.LOVE_CHALLENGE)
end

--- @param valentineTab ValentineTab
function EventValentineModel:IsTabNotified(valentineTab)
    if valentineTab == ValentineTab.CHECK_IN then
        return self:IsDailyLoginHasNotification()
    elseif valentineTab == ValentineTab.OPEN_CARD then
        ---@type EventValentineConfig
        local eventConfig = self:GetConfig()
        return InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_VALENTINE_LUCKY_COIN) >= eventConfig:GetOpenCardConfig().coinPrice
    elseif valentineTab == ValentineTab.LOVE_CHALLENGE then
        return InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_VALENTINE_LUCKY_COIN) > 0
    end
    return false
end

function EventValentineModel:ReadInnerData(buffer)
    self.eventLoginData = EventLoginData(buffer)

    self.numberBuyDataDict = EventPopupModel.ReadNumberBuyDataDict(buffer)

    self.numberBuyBossTurn = buffer:GetByte()

    self.valentineOpenCardData = ValentineOpenCardData(buffer)

    self.dictLimitedPackStatistics = Dictionary()

    self:RegenStamina(buffer:GetInt())
end

function EventValentineModel:RegenStamina(staminaNumber)
    local clearAndAddResource = function(moneyId, number)
        local currentValue = InventoryUtils.Get(ResourceType.Money, moneyId)
        InventoryUtils.Sub(ResourceType.Money, moneyId, currentValue)
        InventoryUtils.Add(ResourceType.Money, moneyId, number)
    end
    clearAndAddResource(self:GetConfig():GetBossChallengeConfig().challengePriceList:Get(1).id, staminaNumber)
end

function EventValentineModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

--- @param eventActionType EventActionType
function EventValentineModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventValentineModel:GetNumberBuy(packId)
    ---@param LimitedPackStatisticsInBound
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    return pack.numberOfBought
end

--- @return EventValentineConfig
function EventValentineModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventValentineModel:IsClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsClaimed()
    end
    return nil
end

function EventValentineModel:IsFreeClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsFreeClaim()
    end
    return false
end

function EventValentineModel:GetLoginData()
    return self.eventLoginData
end

function EventValentineModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventValentineEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
        zg.playerData.remoteConfig.eventValentineEnd = endTime
        zg.playerData:SaveRemoteConfig()
    end
end

function EventValentineModel:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.SUMMON_ELITE_SCROLL)
    clearResource(MoneyType.EVENT_LUNAR_NEW_YEAR_SUMMON_POINT)
end

---@return LimitedPackStatisticsInBound
function EventValentineModel:GetLimitedPackStatisticsInBound(packId)
    ---@type LimitedPackStatisticsInBound
    local pack = self.dictLimitedPackStatistics:Get(packId)
    if pack == nil then
        ---@type NumberBuyData
        local numberBuyData = self.numberBuyDataDict:Get(EventActionType.VALENTINE_LOVE_CHALLENGE_BUNDLE_PURCHASE)
        if numberBuyData == nil then
            numberBuyData = NumberBuyData()
            self.numberBuyDataDict:Add(EventActionType.VALENTINE_LOVE_CHALLENGE_BUNDLE_PURCHASE, numberBuyData)
        end
        pack = LimitedPackStatisticsInBound()
        pack.numberOfBought = numberBuyData:GetNumberOfBoughtWithPackId(packId)
        self.dictLimitedPackStatistics:Add(packId, pack)
    end
    return pack
end

function EventValentineModel:BuyBossTurnSuccess(boughtTurn)
    self.numberBuyBossTurn = self.numberBuyBossTurn + boughtTurn
end

--- @class ValentineTab
ValentineTab = {
    CHECK_IN = 1,
    LOVE_CHALLENGE = 2,
    LOVE_BUNDLE = 3,
    OPEN_CARD = 4,
}
