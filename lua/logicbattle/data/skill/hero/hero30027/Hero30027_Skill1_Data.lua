--- @class Hero30027_Skill1_Data : BaseSkillData Kazetsu
Hero30027_Skill1_Data = Class(Hero30027_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30027_Skill1_Data:CreateInstance()
    return Hero30027_Skill1_Data()
end

--- @return void
function Hero30027_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")
    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")
    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")

    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")
    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_amount_by_damage ~= nil, "heal_amount_with_damage = nil")
end

--- @return void
function Hero30027_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)
    self.enemyTargetPosition = tonumber(parsedData.damage_target_position)
    self.enemyTargetNumber = tonumber(parsedData.damage_target_number)
    self.statDebuffType= tonumber(parsedData.stat_debuff_type)
    self.statDebuffDuration= tonumber(parsedData.stat_debuff_duration)
    self.statDebuffAmount= tonumber(parsedData.stat_debuff_amount)

    self.healthTrigger = tonumber(parsedData.health_trigger)
    self.healChance = tonumber(parsedData.heal_chance)
    self.healAmount = tonumber(parsedData.heal_amount_by_damage)
end

return Hero30027_Skill1_Data