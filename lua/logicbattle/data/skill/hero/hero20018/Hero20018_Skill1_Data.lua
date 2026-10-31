--- @class Hero20018_Skill1_Data FireSpirit
Hero20019_Skill1_Data = Class(Hero20019_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20019_Skill1_Data:CreateInstance()
    return Hero20019_Skill1_Data()
end

--- @return void
function Hero20019_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "target_number = nil")
end

--- @return void
function Hero20019_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)
end

return Hero20019_Skill1_Data