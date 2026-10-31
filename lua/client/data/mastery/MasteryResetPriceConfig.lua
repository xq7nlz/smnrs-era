--- @class MasteryResetPriceConfig
MasteryResetPriceConfig = Class(MasteryResetPriceConfig)

--- @return void
function MasteryResetPriceConfig:Ctor()
    ---@type number
    self.level = nil
    ---@type MoneyType
    self.moneyType = nil
    ---@type number
    self.number = 0
    ---@type number
    self.returnRate = 0
end

--- @return void
--- @param data string
function MasteryResetPriceConfig:ParseCsv(data)
    self.level = tonumber(data.level)
    self.moneyType = tonumber(data.money_type_1)
    self.number = tonumber(data.money_value_1)
    self.returnRate = tonumber(data.return_rate)
end