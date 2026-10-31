--- @class Hero10012_Skill1_Data Assassiren
Hero10012_Skill1_Data = Class(Hero10012_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10012_Skill1_Data:CreateInstance()
    return Hero10012_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10012_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.effect_drowning_chance ~= nil, "effect_drowning_chance = nil")
    assert(parsedData.effect_drowning_duration ~= nil, "effect_drowning_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10012_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.effectDrowningChance = tonumber(parsedData.effect_drowning_chance)
    self.effectDrowningDuration = tonumber(parsedData.effect_drowning_duration)
end

return Hero10012_Skill1_Data