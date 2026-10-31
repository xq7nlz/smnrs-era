--- @class Hero30027_Skill2_Data : BaseSkillData Kazetsu
Hero30027_Skill2_Data = Class(Hero30027_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30027_Skill2_Data:CreateInstance()
    return Hero30027_Skill2_Data()
end

--- @return void
function Hero30027_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.exchange_stat ~= nil, "exchange_stat = nil")
    assert(parsedData.exchange_percent ~= nil, "exchange_percent = nil")
    assert(parsedData.target_stat ~= nil, "target_stat = nil")
    assert(parsedData.target_percent ~= nil, "target_percent = nil")
    assert(parsedData.max_exchange ~= nil, "max_exchange = nil")
    assert(parsedData.deduct_power_amount ~= nil, "deduct_power_amount = nil")
end

--- @return void
function Hero30027_Skill2_Data:ParseCsv(parsedData)
    self.exchangeStat = tonumber(parsedData.exchange_stat)
    self.exchangePercent = tonumber(parsedData.exchange_percent)
    self.targetStat = tonumber(parsedData.target_stat)
    self.targetPercent = tonumber(parsedData.target_percent)
    self.maxExchange = tonumber(parsedData.max_exchange)
    self.deductPowerAmount = tonumber(parsedData.deduct_power_amount)
end

return Hero30027_Skill2_Data