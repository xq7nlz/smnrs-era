--- @class Hero30023_Skill1_Data DrPlague
Hero30023_Skill1_Data = Class(Hero30023_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30023_Skill1_Data:CreateInstance()
    return Hero30023_Skill1_Data()
end

--- @return void
function Hero30023_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.stat_debuff_chance ~= nil, "stat_debuff_chance = nil")
    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")
end

--- @return void
function Hero30023_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.statDebuffChange = tonumber(parsedData.stat_debuff_chance)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
    self.statDebuffCalculationType = tonumber(parsedData.stat_debuff_calculation_type)
end

return Hero30023_Skill1_Data