--- @class EventMarketConfig : MarketConfig
EventMarketConfig = Class(EventMarketConfig, MarketConfig)

--- @param marketConfigPath string
--- @param itemRateConfigPath string
--- @param dataId number
function EventMarketConfig:Ctor(marketConfigPath, itemRateConfigPath, dataId)
    MarketConfig.Ctor(self)
    self:ParseCsv(string.format(marketConfigPath, dataId))
    self:ParseItemRateConfig(string.format(itemRateConfigPath, dataId))
end