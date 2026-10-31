--- @class Hero20006_Skill1_Data Finde
Hero20006_Skill1_Data = Class(Hero20006_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20006_Skill1_Data:CreateInstance()
    return Hero20006_Skill1_Data()
end

function Hero20006_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.power_receive_amount ~= nil, "effect_duration = nil")
end

function Hero20006_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.target_number = tonumber(parsedData.damage_target_number)
    self.target_position = tonumber(parsedData.damage_target_position)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.powerReceiveAmount = tonumber(parsedData.power_receive_amount)
end

return Hero20006_Skill1_Data