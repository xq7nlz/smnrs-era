--- @class OrbFood
OrbFood = Class(OrbFood)

--- @return void
---@param orbType MoneyType
---@param number number
function OrbFood:Ctor(orbType, number)
    --- @type MoneyType
    self.orbType = orbType
    --- @type number
    self.number = number
end
