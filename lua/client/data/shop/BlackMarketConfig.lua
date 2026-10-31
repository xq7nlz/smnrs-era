require "lua.client.data.Shop.MarketConfig"

local MARKET_CONFIG_PATH = "csv/market/market/level_%s/market_config.csv"
local MARKET_ITEM_RATE_CONFIG_PATH = "csv/market/market/level_%s/market_item_rate.csv"
local MARKET_ITEM_UPGRADE_PRICE = "csv/market/market/market_upgrade_price.csv"
--- @class BlackMarketConfig : MarketConfig
BlackMarketConfig = Class(BlackMarketConfig, MarketConfig)

function BlackMarketConfig:Ctor()
    MarketConfig.Ctor(self)
    self:ParseUpgradeData(MARKET_ITEM_UPGRADE_PRICE)
end

function BlackMarketConfig:LoadCsv(level)
    self:ParseCsv(string.format(MARKET_CONFIG_PATH, level))
    self:ParseItemRateConfig(string.format(MARKET_ITEM_RATE_CONFIG_PATH,level))
end

return BlackMarketConfig