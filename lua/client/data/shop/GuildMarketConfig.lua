require "lua.client.data.Shop.MarketConfig"

local GUILD_MARKET_CONFIG_PATH = "csv/market/guild/level_%s/market_config.csv"
local GUILD_MARKET_ITEM_RATE_CONFIG_PATH = "csv/market/guild/level_%s/market_item_rate.csv"
local GUILD_MARKET_ITEM_UPGRADE_PRICE = "csv/market/guild/market_upgrade_price.csv"

--- @class GuildMarketConfig : MarketConfig
GuildMarketConfig = Class(GuildMarketConfig, MarketConfig)

function GuildMarketConfig:Ctor()
    MarketConfig.Ctor(self)
    self:ParseUpgradeData(GUILD_MARKET_ITEM_UPGRADE_PRICE)
end
function GuildMarketConfig:LoadCsv(level)
    self:ParseCsv(string.format(GUILD_MARKET_CONFIG_PATH, level))
    self:ParseItemRateConfig(string.format(GUILD_MARKET_ITEM_RATE_CONFIG_PATH,level))
    self:ParseUpgradeData(GUILD_MARKET_ITEM_UPGRADE_PRICE)
end
return GuildMarketConfig