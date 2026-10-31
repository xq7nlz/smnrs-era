--- @class Hero30003_Skill3_Data Nero
Hero30003_Skill3_Data = Class(Hero30003_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30003_Skill3_Data:CreateInstance()
    return Hero30003_Skill3_Data()
end

--- @return void
function Hero30003_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_resistance_chance ~= nil, "heal_resistance_chance = nil")
    assert(parsedData.heal_resistance_duration ~= nil, "heal_resistance_duration = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
function Hero30003_Skill3_Data:ParseCsv(parsedData)
    self.healResistanceChance = tonumber(parsedData.heal_resistance_chance)
    self.healResistanceDuration = tonumber(parsedData.heal_resistance_duration)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Hero30003_Skill3_Data