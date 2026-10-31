--- @class Hero20007_Skill2_Data Ninetales
Hero20007_Skill2_Data = Class(Hero20007_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20007_Skill2_Data:CreateInstance()
    return Hero20007_Skill2_Data()
end

--- @return void
function Hero20007_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.basic_attack_target_position ~= nil, "basic_attack_target_position = nil")
    assert(parsedData.basic_attack_target_number ~= nil, "basic_attack_target_number = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero20007_Skill2_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.basic_attack_target_position)
    self.targetNumber = tonumber(parsedData.basic_attack_target_number)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero20007_Skill2_Data