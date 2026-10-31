--- @class RaidConfig
RaidConfig = Class(RaidConfig)

--- @return void
function RaidConfig:Ctor()
    ---@type number
    self.turnPrice = nil
    ----@type number
    self.turnBuyDaily = nil
    ----@type number
    self.turnAdsDaily = nil
    ----@type number
    self.turnResetDaily = nil
end

--- @return void
--- @param parsedData string
function RaidConfig:ParseCsv(parsedData)
    local dataContent = parsedData[1]
    self.turnPrice = tonumber(dataContent["turn_buy_gem_price"])
    self.turnBuyDaily = tonumber(dataContent["turn_buy_daily"])
    self.turnAdsDaily = tonumber(dataContent["turn_ads_daily"])
    self.turnResetDaily = tonumber(dataContent["turn_reset_daily"])
end

--- @return Number
function RaidConfig:GetTurnBuyDailyVip()
    local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    return self.turnBuyDaily + vip.raidBonusTurnBuy
end

--- @return Number
function RaidConfig:GetTurnAdsDailyVip()
    return self.turnAdsDaily
end