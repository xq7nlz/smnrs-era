--- @class Hero50004_Skill4_Data Grimm
Hero50004_Skill4_Data = Class(Hero50004_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50004_Skill4_Data:CreateInstance()
    return Hero50004_Skill4_Data()
end

--- @return void
function Hero50004_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.round_step ~= nil, "round_step = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero50004_Skill4_Data:ParseCsv(parsedData)
    self.roundStep = tonumber(parsedData.round_step)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.effectType = tonumber(parsedData.effect_type)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero50004_Skill4_Data