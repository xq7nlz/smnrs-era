--- @class Hero10013_Skill2_Data Oceanee
Hero10013_Skill2_Data = Class(Hero10013_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10013_Skill2_Data:CreateInstance()
    return Hero10013_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero10013_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_basic_attack ~= nil, "bonus_basic_attack = nil")
    assert(parsedData.effect_trigger_class ~= nil, "effect_trigger_class = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10013_Skill2_Data:ParseCsv(parsedData)
    self.bonusBasicAttack = tonumber(parsedData.bonus_basic_attack)
    self.effectTriggerClass = tonumber(parsedData.effect_trigger_class)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero10013_Skill2_Data