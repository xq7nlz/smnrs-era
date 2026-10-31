--- @class Summoner5_Skill4_3_Data Ranger
Summoner5_Skill4_3_Data = Class(Summoner5_Skill4_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner5_Skill4_3_Data:CreateInstance()
    return Summoner5_Skill4_3_Data()
end

--- @return void
function Summoner5_Skill4_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.bonus_damage_extra_turn ~= nil, "bonus_damage_extra_turn = nil")
    assert(parsedData.number_extra_turn_affect ~= nil, "number_extra_turn_affect = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Summoner5_Skill4_3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.bonusDamageExtraTurn = tonumber(parsedData.bonus_damage_extra_turn)
    self.numberExtraTurnAffect = tonumber(parsedData.number_extra_turn_affect)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Summoner5_Skill4_3_Data