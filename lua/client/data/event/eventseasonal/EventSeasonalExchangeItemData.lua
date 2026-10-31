require "lua.client.core.network.playerData.common.RewardInBound"
--- @class EventSeasonalExchangeItemData
EventSeasonalExchangeItemData = Class(EventSeasonalExchangeItemData)

function EventSeasonalExchangeItemData:Ctor()
    --- @type number
    self.id = 0
    --- @type MoneyType
    self.priceType = 0
    --- @type number
    self.price = 0
    --- @type RewardInBound
    self.rewardInBound = nil
    --- @type number
    self.limit = 0
end
--- @return EventSeasonalExchangeItemData
function EventSeasonalExchangeItemData.CreateByParams(data)
    local item = EventSeasonalExchangeItemData()
    item.id = tonumber(data.id)
    item.priceType = tonumber(data.money_type)
    item.price = tonumber(data.money_value)
    item.rewardInBound = RewardInBound.CreateByParams(data)
    item.limit = tonumber(data.limit)
    return item
end

