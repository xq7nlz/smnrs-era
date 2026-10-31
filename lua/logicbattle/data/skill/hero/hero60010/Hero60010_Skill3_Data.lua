--- @class Hero60010_Skill3_Data ShadowBlade
Hero60010_Skill3_Data = Class(Hero60010_Skill3_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60010_Skill3_Data:CreateInstance()
    return Hero60010_Skill3_Data()
end

--- @return void
function Hero60010_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_trigger ~= nil, "effect_trigger = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
end

--- @return void
function Hero60010_Skill3_Data:ParseCsv(parsedData)
    self.effectTrigger = tonumber(parsedData.effect_trigger)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.effectAmount = tonumber(parsedData.effect_amount)
end

return Hero60010_Skill3_Data