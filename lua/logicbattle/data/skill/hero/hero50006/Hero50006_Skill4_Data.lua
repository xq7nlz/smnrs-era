--- @class Hero50006_Skill4_Data Enule
Hero50006_Skill4_Data = Class(Hero50006_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50006_Skill4_Data:CreateInstance()
    return Hero50006_Skill4_Data()
end

--- @return void
function Hero50006_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.number_take_damage_required ~= nil, "number_take_damage_required = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")

end

--- @return void
function Hero50006_Skill4_Data:ParseCsv(parsedData)
    self.numberTakeDamageRequired = tonumber(parsedData.number_take_damage_required)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero50006_Skill4_Data