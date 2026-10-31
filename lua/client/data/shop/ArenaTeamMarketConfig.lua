require "lua.client.data.Shop.MarketConfig"

local MARKET_CONFIG_PATH = "csv/market/arena_team/level_%s/market_config.csv"
local MARKET_ITEM_RATE_CONFIG_PATH = "csv/market/arena_team/level_%s/market_item_rate.csv"
local MARKET_ITEM_UPGRADE_PRICE = "csv/market/arena_team/market_upgrade_price.csv"

--- @class ArenaTeamMarketConfig : MarketConfig
ArenaTeamMarketConfig = Class(ArenaTeamMarketConfig, MarketConfig)

function ArenaTeamMarketConfig:Ctor()
    MarketConfig.Ctor(self)

    self:ParseUpgradeData(MARKET_ITEM_UPGRADE_PRICE)
end

function ArenaTeamMarketConfig:LoadCsv(level)
    self:ParseCsv(string.format(MARKET_CONFIG_PATH, level))

    self:ParseItemRateConfig(string.format(MARKET_ITEM_RATE_CONFIG_PATH,level))
end

return ArenaTeamMarketConfig