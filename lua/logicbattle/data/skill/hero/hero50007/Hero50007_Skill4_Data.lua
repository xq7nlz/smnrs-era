--- @class Hero50007_Skill4_Data Celestia
Hero50007_Skill4_Data = Class(Hero50007_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50007_Skill4_Data:CreateInstance()
    return Hero50007_Skill4_Data()
end

--- @return void
function Hero50007_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")
    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")
end

--- @return void
function Hero50007_Skill4_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)
    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)
end

return Hero50007_Skill4_Data