--- @class Hero10003_Skill1_Data Glacious_Fairy
Hero10003_Skill1_Data = Class(Hero10003_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10003_Skill1_Data:CreateInstance()
    return Hero10003_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10003_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")

    assert(parsedData.heal_mark_type ~= nil, "heal_mark_type = nil")
    assert(parsedData.heal_mark_bonus_percent ~= nil, "heal_mark_bonus_percent = nil")
end

--- @return void
--- @param parsedData table
function Hero10003_Skill1_Data:ParseCsv(parsedData)
    self.healPercent = tonumber(parsedData.heal_percent)
    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healMarkType = tonumber(parsedData.heal_mark_type)
    self.healMarkBonusPercent = tonumber(parsedData.heal_mark_bonus_percent)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.damage = tonumber(parsedData.damage)
end

return Hero10003_Skill1_Data