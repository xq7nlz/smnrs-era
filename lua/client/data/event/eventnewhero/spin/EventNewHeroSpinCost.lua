--- @class EventNewHeroSpinCost
EventNewHeroSpinCost = Class(EventNewHeroSpinCost)

function EventNewHeroSpinCost:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)
    --- @type MoneyType
    self.moneyType = tonumber(data.money_type)
    --- @type number
    self.moneyValue = tonumber(data.money_value)
    --- @type boolean
    self.isFree = data.is_free == "TRUE"
end