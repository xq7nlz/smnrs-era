--- @class Hero30010_Skill2_Data Erde
Hero30010_Skill2_Data = Class(Hero30010_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30010_Skill2_Data:CreateInstance()
    return Hero30010_Skill2_Data()
end

--- @return void
function Hero30010_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.add_power_chance ~= nil, "add_power_chance = nil")
    assert(parsedData.add_power_amount ~= nil, "add_power_amount = nil")
end

--- @return void
function Hero30010_Skill2_Data:ParseCsv(parsedData)
    self.addPowerChance = tonumber(parsedData.add_power_chance)
    self.addPowerAmount = tonumber(parsedData.add_power_amount)
end

return Hero30010_Skill2_Data