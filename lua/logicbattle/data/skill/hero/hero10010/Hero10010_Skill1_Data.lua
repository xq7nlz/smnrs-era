--- @class Hero10010_Skill1_Data Japulan
Hero10010_Skill1_Data = Class(Hero10010_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10010_Skill1_Data:CreateInstance()
    return Hero10010_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10010_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.stat_debuff_type ~= nil, "effect_1_type = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "effect_1_duration = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "effect_1_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10010_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.damage_target_position)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)

    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
end

return Hero10010_Skill1_Data