--- @class Hero20020_Skill1_Data Ira
Hero20020_Skill1_Data = Class(Hero20020_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20020_Skill1_Data:CreateInstance(id, hero)
    return Hero20020_Skill1_Data(id, hero)
end

--- @return void
--- @param parsedData table
function Hero20020_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.stat_debuff_chance ~= nil, "stat_debuff_chance = nil")
    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")

end

--- @return void
--- @param parsedData table
function Hero20020_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.statDebuffChange = tonumber(parsedData.stat_debuff_chance)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
    self.statDebuffCalculationType = tonumber(parsedData.stat_debuff_calculation_type)
end

return Hero20020_Skill1_Data