--- @class Hero20022_Skill1_Data Imp
Hero20022_Skill1_Data = Class(Hero20022_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20022_Skill1_Data:CreateInstance(id, hero)
    return Hero20022_Skill1_Data(id, hero)
end

--- @return void
--- @param parsedData table
function Hero20022_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_calculation_type ~= nil, "stat_debuff_calculation_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero20022_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffCalculationType = tonumber(parsedData.stat_debuff_calculation_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
end

return Hero20022_Skill1_Data