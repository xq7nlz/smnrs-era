--- @class Hero50003_Skill1_Data LifeKeeper
Hero50003_Skill1_Data = Class(Hero50003_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50003_Skill1_Data:CreateInstance()
    return Hero50003_Skill1_Data()
end

--- @return void
function Hero50003_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.enemy_target_position ~= nil, "enemy_target_position = nil")
    assert(parsedData.enemy_target_number ~= nil, "enemy_target_number = nil")

    assert(parsedData.ally_target_position ~= nil, "ally_target_position = nil")
    assert(parsedData.ally_target_number ~= nil, "ally_target_number = nil")

    assert(parsedData.stat_to_steal ~= nil, "stat_to_steal = nil")
    assert(parsedData.stat_steal_amount ~= nil, "stat_steal_amount = nil")
end

--- @return void
function Hero50003_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.enemyTargetPosition = tonumber(parsedData.enemy_target_position)
    self.enemyTargetNumber = tonumber(parsedData.enemy_target_number)

    self.allyTargetPosition = tonumber(parsedData.ally_target_position)
    self.allyTargetNumber = tonumber(parsedData.ally_target_number)

    self.stealStatType = tonumber(parsedData.stat_to_steal)
    self.statStealAmount = tonumber(parsedData.stat_steal_amount)
end

return Hero50003_Skill1_Data