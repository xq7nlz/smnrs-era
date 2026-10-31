--- @class Hero60010_Skill4_Data Zygor
Hero60010_Skill4_Data = Class(Hero60010_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60010_Skill4_Data:CreateInstance()
    return Hero60010_Skill4_Data()
end

--- @return void
function Hero60010_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_target_position ~= nil, "effect_target_position = nil")
    assert(parsedData.effect_target_number ~= nil, "effect_target_number = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")

    assert(parsedData.stat_buff_target_position ~= nil, "stat_buff_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "stat_buff_target_number = nil")

    assert(parsedData.stat_buff_chance ~= nil, "stat_buff_chance = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
    assert(parsedData.duration ~= nil, "duration = nil")
end

--- @return void
function Hero60010_Skill4_Data:ParseCsv(parsedData)
    self.targetPositionEffect = tonumber(parsedData.effect_target_position)
    self.targetNumberEffect = tonumber(parsedData.effect_target_number)
    self.effectType = tonumber(parsedData.effect_type)

    self.targetPositionBuff = tonumber(parsedData.stat_buff_target_position)
    self.targetNumberBuff = tonumber(parsedData.stat_buff_target_number)

    self.statBuffChance = tonumber(parsedData.stat_buff_chance)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
    self.duration = tonumber(parsedData.duration)
end

return Hero60010_Skill4_Data