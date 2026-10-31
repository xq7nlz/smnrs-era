require "lua.client.data.Shop.MarketConfig"

local ALTAR_MARKET_CONFIG_PATH = "csv/market/altar/level_%d/market_config.csv"
local ALTAR_MARKET_ITEM_RATE_CONFIG_PATH = "csv/market/altar/level_%d/market_item_rate.csv"

--- @class AltarMarketConfig : MarketConfig
AltarMarketConfig = Class(AltarMarketConfig, MarketConfig)

function AltarMarketConfig:Ctor()
    MarketConfig.Ctor(self)
    self:GetConfigByLevel(1)
end

function AltarMarketConfig:GetConfigByLevel(level)
    local altarMarketConfigPath = string.format(ALTAR_MARKET_CONFIG_PATH,  level)
    local altarMarketItemRateConfigPath = string.format(ALTAR_MARKET_ITEM_RATE_CONFIG_PATH, level)

    self:ParseCsv(altarMarketConfigPath)
    self:ParseItemRateConfig(altarMarketItemRateConfigPath)
end

return AltarMarketConfig