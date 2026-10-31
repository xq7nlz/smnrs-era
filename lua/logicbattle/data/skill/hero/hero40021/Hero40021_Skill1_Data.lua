--- @class Hero40021_Skill1_Data Titi
Hero40021_Skill1_Data = Class(Hero40021_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40021_Skill1_Data:CreateInstance(id, hero)
    return Hero40021_Skill1_Data(id, hero)
end

--- @return void
--- @param parsedData table
function Hero40021_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.stat_buff_target_position ~= nil, "stat_buff_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "stat_buff_target_number = nil")

    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero40021_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.statBuffTargetPosition = tonumber(parsedData.stat_buff_target_position)
    self.statBuffTargetNumber = tonumber(parsedData.stat_buff_target_number)

    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero40021_Skill1_Data