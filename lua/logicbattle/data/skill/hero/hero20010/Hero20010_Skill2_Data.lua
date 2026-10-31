--- @class Hero20010_Skill2_Data Ungoliant
Hero20010_Skill2_Data = Class(Hero20010_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20010_Skill2_Data:CreateInstance()
    return Hero20010_Skill2_Data()
end

--- @return void
function Hero20010_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")

    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
end

--- @return void
function Hero20010_Skill2_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.heal_target_position)
    self.targetNumber = tonumber(parsedData.heal_target_number)

    self.healChance = tonumber(parsedData.heal_chance)
    self.healAmount = tonumber(parsedData.heal_amount)
end

return Hero20010_Skill2_Data