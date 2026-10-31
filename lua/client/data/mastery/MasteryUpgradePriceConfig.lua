--- @class MasteryUpgradePriceConfig
MasteryUpgradePriceConfig = Class(MasteryUpgradePriceConfig)

--- @return void
function MasteryUpgradePriceConfig:Ctor()
    ---@type number
    self.level = nil
    ---@type MoneyType
    self.moneyType1 = nil
    ---@type number
    self.number1 = 0
    ---@type MoneyType
    self.moneyType2 = nil
    ---@type number
    self.number2 = 0
end

--- @return void
--- @param data string
function MasteryUpgradePriceConfig:ParseCsv(data)
    self.level = tonumber(data.level)
    self.moneyType1 = tonumber(data.money_type_1)
    self.number1 = tonumber(data.money_value_1)
    self.moneyType2 = tonumber(data.money_type_2)
    self.number2 = tonumber(data.money_value_2)
end