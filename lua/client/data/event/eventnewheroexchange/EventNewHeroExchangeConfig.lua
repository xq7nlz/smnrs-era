--- @class EventNewHeroExchangeConfig
EventNewHeroExchangeConfig = Class(EventNewHeroExchangeConfig)

function EventNewHeroExchangeConfig:Ctor(path)
    self.path = path
end

--- @return List
function EventNewHeroExchangeConfig:GetListExchangeConfig()
    if self.listExchange == nil then
        local path = string.format("%s/exchange_reward.csv", self.path, "exchange_reward.csv")
        require "lua.client.data.Event.ExchangeEventConfig"
        self.listExchange = ExchangeEventConfig.GetListExchangeConfigPath(path)
    end
    return self.listExchange
end