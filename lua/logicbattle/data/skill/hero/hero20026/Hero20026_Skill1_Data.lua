--- @class Hero20026_Skill1_Data Yirlal
Hero20026_Skill1_Data = Class(Hero20026_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20026_Skill1_Data:CreateInstance(id, hero)
    return Hero20026_Skill1_Data(id, hero)
end

--- @return void
--- @param parsedData table
function Hero20026_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
    assert(parsedData.heal_duration ~= nil, "heal_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero20026_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.target_position)
    self.damageTargetNumber = tonumber(parsedData.target_number)

    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healPercent = tonumber(parsedData.heal_percent)
    self.healDuration = tonumber(parsedData.heal_duration)
end

return Hero20026_Skill1_Data