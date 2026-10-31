--- @class Hero50013_Skill4_Data
Hero50013_Skill4_Data = Class(Hero50013_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50013_Skill4_Data:CreateInstance()
    return Hero50013_Skill4_Data()
end

---- @return void
function Hero50013_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")

    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
end

---- @return void
function Hero50013_Skill4_Data:ParseCsv(parsedData)
    self.healAmount = tonumber(parsedData.heal_amount)
    self.healthTrigger = tonumber(parsedData.health_trigger)

    self.targetPositionHeal = tonumber(parsedData.heal_target_position)
    self.targetNumberHeal = tonumber(parsedData.heal_target_number)
end

return Hero50013_Skill4_Data