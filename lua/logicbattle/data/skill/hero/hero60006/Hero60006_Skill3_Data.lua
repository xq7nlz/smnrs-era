--- @class Hero60006_Skill3_Data Hehta
Hero60006_Skill3_Data = Class(Hero60006_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60006_Skill3_Data:CreateInstance()
    return Hero60006_Skill3_Data()
end

--- @return void
function Hero60006_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
    assert(parsedData.silence_duration ~= nil, "silence_duration = nil")
end

--- @return void
function Hero60006_Skill3_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.effectAmount = tonumber(parsedData.effect_amount)
    self.silenceDuration = tonumber(parsedData.silence_duration)
end

return Hero60006_Skill3_Data