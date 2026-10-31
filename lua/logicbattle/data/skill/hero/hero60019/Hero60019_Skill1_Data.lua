--- @class Hero60019_Skill1_Data Mace
Hero60019_Skill1_Data = Class(Hero60019_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60019_Skill1_Data:CreateInstance()
    return Hero60019_Skill1_Data()
end

--- @return void
function Hero60019_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")
end

--- @return void
function Hero60019_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)
end

return Hero60019_Skill1_Data