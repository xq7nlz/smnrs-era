require "lua.client.core.network.playerData.common.RewardInBound"
--- @class EventTowerOfEitriExchangeItemData
EventTowerOfEitriExchangeItemData = Class(EventTowerOfEitriExchangeItemData)

function EventTowerOfEitriExchangeItemData:Ctor()
    --- @type RewardInBound
    self.itemData = nil
    --- @type number
    self.limit = 0
    --- @type number
    self.price = 0
    --- @type number
    self.buyTime = 0
    --- @type MoneyType
    self.moneyType = 0
    --- @type number
    self.id = 0
    --- @type number
    self.hammer = 0
end
--- @return EventTowerOfEitriExchangeItemData
function EventTowerOfEitriExchangeItemData.CreateByParams(data)
    local item = EventTowerOfEitriExchangeItemData()
    item.itemData = RewardInBound.CreateByParams(data)
    item.limit = tonumber(data.limit)
    item.price = tonumber(data.money_value)
    item.moneyType = tonumber(data.money_type)
    item.id = tonumber(data.id)
    item.hammer = tonumber(data.hammer_bonus_number)
    return item
end

