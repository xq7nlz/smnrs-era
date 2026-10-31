--- @class Hero40020_Skill3_Data Athelas
Hero40020_Skill3_Data = Class(Hero40020_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40020_Skill3_Data:CreateInstance()
    return Hero40020_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero40020_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
--- @param parsedData table
function Hero40020_Skill3_Data:ParseCsv(parsedData)
    self.healChance = tonumber(parsedData.heal_chance)
    self.healPercent = tonumber(parsedData.heal_percent)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Hero40020_Skill3_Data
