--- @class Hero40024_Skill3_Data Wugushi
Hero40024_Skill3_Data = Class(Hero40024_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40024_Skill3_Data:CreateInstance()
    return Hero40024_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero40024_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_chance_normal ~= nil, "effect_chance_normal = nil")
    assert(parsedData.effect_chance_special ~= nil, "effect_chance_special = nil")
    assert(parsedData.affected_hero_class ~= nil, "affected_hero_class = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero40024_Skill3_Data:ParseCsv(parsedData)
    self.effectChanceNormal = tonumber(parsedData.effect_chance_normal)
    self.effectChanceSpecial = tonumber(parsedData.effect_chance_special)
    self.affectedHeroClass = tonumber(parsedData.affected_hero_class)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectAmount = tonumber(parsedData.effect_amount)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero40024_Skill3_Data
