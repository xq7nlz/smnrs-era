--- @class Hero60018_Skill1_Data Mace
Hero60018_Skill1_Data = Class(Hero60018_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60018_Skill1_Data:CreateInstance()
    return Hero60018_Skill1_Data()
end

--- @return void
function Hero60018_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
    assert(parsedData.heal_duration ~= nil, "heal_duration = nil")
end

--- @return void
function Hero60018_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.healChance = tonumber(parsedData.heal_chance)
    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healPercent = tonumber(parsedData.heal_percent)
    self.healDuration = tonumber(parsedData.heal_duration)
end

return Hero60018_Skill1_Data