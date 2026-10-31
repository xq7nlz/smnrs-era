--- @class Hero50015_Skill1_Data Navro
Hero50015_Skill1_Data = Class(Hero50015_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50015_Skill1_Data:CreateInstance()
    return Hero50015_Skill1_Data()
end

--- @return void
function Hero50015_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.effect_faction ~= nil, "effect_type = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero50015_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.effectFaction = tonumber(parsedData.effect_faction)
    self.effectAmount = tonumber(parsedData.effect_amount)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero50015_Skill1_Data