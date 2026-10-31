--- @class Hero60008_Skill2_Data Renaks
Hero60008_Skill2_Data = Class(Hero60008_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60008_Skill2_Data:CreateInstance()
    return Hero60008_Skill2_Data()
end

--- @return void
function Hero60008_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.heal_percent_with_damage ~= nil, "heal_percent_with_damage = nil")
end

--- @return void
function Hero60008_Skill2_Data:ParseCsv(parsedData)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.healPercentWithDamage = tonumber(parsedData.heal_percent_with_damage)
end

return Hero60008_Skill2_Data