--- @class Hero20025_Skill1_Data Yirlal
Hero20025_Skill1_Data = Class(Hero20025_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20025_Skill1_Data:CreateInstance(id, hero)
    return Hero20025_Skill1_Data(id, hero)
end

--- @return void
--- @param parsedData table
function Hero20025_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.hp_trigger_limit ~= nil, "hp_trigger_limit = nil")
    assert(parsedData.bonus_attack ~= nil, "bonus_attack = nil")
end

--- @return void
--- @param parsedData table
function Hero20025_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.hpTriggerLimit = tonumber(parsedData.hp_trigger_limit)
    self.bonusAttack = tonumber(parsedData.bonus_attack)
end

return Hero20025_Skill1_Data