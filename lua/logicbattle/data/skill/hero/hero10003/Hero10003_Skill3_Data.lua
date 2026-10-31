--- @class Hero10003_Skill3_Data Sharpwater
Hero10003_Skill3_Data = Class(Hero10003_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10003_Skill3_Data:CreateInstance()
    return Hero10003_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero10003_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")

    assert(parsedData.heal_mark_type ~= nil, "heal_mark_type = nil")
    assert(parsedData.heal_mark_bonus_percent ~= nil, "heal_mark_bonus_percent = nil")
end

--- @return void
--- @param parsedData table
function Hero10003_Skill3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.effectChance = tonumber(parsedData.effect_chance)

    self.effectAmount = tonumber(parsedData.effect_amount)
    self.healMarkType = tonumber(parsedData.heal_mark_type)
    self.healMarkBonusPercent = tonumber(parsedData.heal_mark_bonus_percent)
end

return Hero10003_Skill3_Data