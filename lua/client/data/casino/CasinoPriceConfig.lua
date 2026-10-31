--- @class CasinoPriceConfig
CasinoPriceConfig = Class(CasinoPriceConfig)

--- @return void
function CasinoPriceConfig:Ctor()
    ---@type SpinType
    self.spinType = nil
    ---@type number
    self.spinNumber = nil
    ---@type number
    self.spinPrice = nil
    ---@type number
    self.moneyType = nil
    ---@type number
    self.casinoPoint = nil
end

--- @return void
--- @param data string
function CasinoPriceConfig:ParseCsv(data, i)
    self.spinType = tonumber(data["spin_type"])
    self.spinNumber = tonumber(data["spin_number"])
    self.spinPrice = tonumber(data["spin_price"])
    self.moneyType = tonumber(data["money_type"])
    self.casinoPoint = tonumber(data["casino_point"])
end