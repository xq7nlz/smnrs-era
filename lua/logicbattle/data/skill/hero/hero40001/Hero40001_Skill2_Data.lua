--- @class Hero40001_Skill2_Data Tilion
Hero40001_Skill2_Data = Class(Hero40001_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40001_Skill2_Data:CreateInstance()
    return Hero40001_Skill2_Data()
end

--- @return void
function Hero40001_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
    assert(parsedData.heal_duration ~= nil, "heal_duration = nil")
end

--- @return void
function Hero40001_Skill2_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.healChance = tonumber(parsedData.heal_chance)
    self.healPercent = tonumber(parsedData.heal_percent)
    self.healDuration = tonumber(parsedData.heal_duration)
end

return Hero40001_Skill2_Data