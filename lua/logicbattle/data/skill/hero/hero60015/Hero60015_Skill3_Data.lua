--- @class Hero60015_Skill3_Data Murath
Hero60015_Skill3_Data = Class(Hero60015_Skill3_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60015_Skill3_Data:CreateInstance()
    return Hero60015_Skill3_Data()
end

--- @return void
function Hero60015_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.effect_dot_chance ~= nil, "effect_dot_chance = nil")
    assert(parsedData.effect_dot_type ~= nil, "effect_dot_type = nil")
    assert(parsedData.effect_dot_amount ~= nil, "effect_dot_amount = nil")
    assert(parsedData.effect_dot_duration ~= nil, "effect_dot_duration = nil")
end

--- @return void
function Hero60015_Skill3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.effectDotChance = tonumber(parsedData.effect_dot_chance)
    self.effectDotType = tonumber(parsedData.effect_dot_type)
    self.effectDotAmount = tonumber(parsedData.effect_dot_amount)
    self.effectDotDuration = tonumber(parsedData.effect_dot_duration)
end

return Hero60015_Skill3_Data