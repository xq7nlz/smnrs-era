--- @class Hero20008_Skill1_Data Moblin
Hero20008_Skill1_Data = Class(Hero20008_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20008_Skill1_Data:CreateInstance()
    return Hero20008_Skill1_Data()
end

--- @return void
function Hero20008_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")
end

--- @return void
function Hero20008_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
end

return Hero20008_Skill1_Data