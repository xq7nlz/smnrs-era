--- @class Hero50004_Skill1_Data Grimm
Hero50004_Skill1_Data = Class(Hero50004_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50004_Skill1_Data:CreateInstance()
    return Hero50004_Skill1_Data()
end

--- @return void
function Hero50004_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.ally_target_position ~= nil, "ally_target_position = nil")
    assert(parsedData.ally_target_number ~= nil, "ally_target_number = nil")

    assert(parsedData.enemy_target_position ~= nil, "enemy_target_position = nil")
    assert(parsedData.enemy_target_number ~= nil, "enemy_target_number = nil")

    assert(parsedData.effect_bonus_percent ~= nil, "effect_bonus_percent = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero50004_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.allyTargetPosition = tonumber(parsedData.ally_target_position)
    self.allyTargetNumber = tonumber(parsedData.ally_target_number)

    self.enemyTargetPosition = tonumber(parsedData.enemy_target_position)
    self.enemyTargetNumber = tonumber(parsedData.enemy_target_number)

    self.effectBonusPercent = tonumber(parsedData.effect_bonus_percent)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero50004_Skill1_Data