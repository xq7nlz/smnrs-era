--- @class Hero20020_Skill4_Data Ira
Hero20020_Skill4_Data = Class(Hero20020_Skill4_Data, BaseSkillData)

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20020_Skill4_Data:CreateInstance(id, hero)
    return Hero20020_Skill4_Data(id, hero)
end

--- @return void
--- @param parsedData table
function Hero20020_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_dot_chance ~= nil, "effect_dot_chance = nil")
    assert(parsedData.effect_dot_type ~= nil, "effect_dot_type = nil")
    assert(parsedData.effect_dot_amount ~= nil, "effect_dot_amount = nil")
    assert(parsedData.effect_dot_duration ~= nil, "effect_dot_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero20020_Skill4_Data:ParseCsv(parsedData)
    self.effectDotChance = tonumber(parsedData.effect_dot_chance)
    self.effectDotType = tonumber(parsedData.effect_dot_type)
    self.effectDotAmount = tonumber(parsedData.effect_dot_amount)
    self.effectDotDuration = tonumber(parsedData.effect_dot_duration)
end

return Hero20020_Skill4_Data