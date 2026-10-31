--- @class Hero20026_Skill3_Data Yirlal
Hero20026_Skill3_Data = Class(Hero20026_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20026_Skill3_Data:CreateInstance()
    return Hero20026_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero20026_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
end

--- @return void
--- @param parsedData table
function Hero20026_Skill3_Data:ParseCsv(parsedData)
    self.healChance = tonumber(parsedData.heal_chance)
    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healPercent = tonumber(parsedData.heal_percent)
end

return Hero20026_Skill3_Data
