--- @class Hero20015_Skill4_Data Rufus
Hero20015_Skill4_Data = Class(Hero20015_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20015_Skill4_Data:CreateInstance()
    return Hero20015_Skill4_Data()
end

---- @return void
function Hero20015_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
end

---- @return void
function Hero20015_Skill4_Data:ParseCsv(parsedData)
    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healPercent = tonumber(parsedData.heal_percent)
end

return Hero20015_Skill4_Data