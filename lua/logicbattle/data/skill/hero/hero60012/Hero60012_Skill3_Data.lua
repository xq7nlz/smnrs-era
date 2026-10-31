--- @class Hero60012_Skill3_Data Juan
Hero60012_Skill3_Data = Class(Hero60012_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60012_Skill3_Data:CreateInstance()
    return Hero60012_Skill3_Data()
end

--- @return void
function Hero60012_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_dot_type ~= nil, "effect_dot_type = nil")
    assert(parsedData.effect_dot_amount ~= nil, "effect_dot_amount = nil")
    assert(parsedData.effect_dot_duration ~= nil, "effect_dot_duration = nil")
end

--- @return void
function Hero60012_Skill3_Data:ParseCsv(parsedData)
    self.effectDotType = tonumber(parsedData.effect_dot_type)
    self.effectDotAmount = tonumber(parsedData.effect_dot_amount)
    self.effectDotDuration = tonumber(parsedData.effect_dot_duration)
end

return Hero60012_Skill3_Data