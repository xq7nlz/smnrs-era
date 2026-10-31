--- @class Summoner3_Skill1_2_Data Priest
Summoner3_Skill1_2_Data = Class(Summoner3_Skill1_2_Data, BaseSkillData)

----------------------------------- Initialization -------------------------------------------
--- @return BaseSkillData
function Summoner3_Skill1_2_Data:CreateInstance()
    return Summoner3_Skill1_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner3_Skill1_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Summoner3_Skill1_2_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Summoner3_Skill1_2_Data