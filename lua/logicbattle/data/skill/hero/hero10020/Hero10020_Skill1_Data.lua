--- @class Hero10020_Skill1_Data Sniper
Hero10020_Skill1_Data = Class(Hero10020_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10020_Skill1_Data:CreateInstance()
    return Hero10020_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10020_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")
end

--- @return void
--- @param parsedData table
function Hero10020_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)
end

return Hero10020_Skill1_Data