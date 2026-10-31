--- @class Hero50011_Skill3_Data Ignatius
Hero50011_Skill3_Data = Class(Hero50011_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50011_Skill3_Data:CreateInstance()
    return Hero50011_Skill3_Data()
end

--- @return void
function Hero50011_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_basic_attack ~= nil, "bonus_basic_attack = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.hero_class_type ~= nil, "hero_class_type = nil")
end

--- @return void
function Hero50011_Skill3_Data:ParseCsv(parsedData)
    self.bonusBasicAttack = tonumber(parsedData.bonus_basic_attack)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.heroClassType = tonumber(parsedData.hero_class_type)
end

return Hero50011_Skill3_Data