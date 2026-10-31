--- @class Hero60013_Skill1_Data DarkKnight
Hero60013_Skill1_Data = Class(Hero60013_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60013_Skill1_Data:CreateInstance()
    return Hero60013_Skill1_Data()
end

--- @return void
function Hero60013_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.steal_stat_type ~= nil, "steal_stat_type = nil")
    assert(parsedData.steal_stat_amount ~= nil, "steal_stat_amount = nil")
end

--- @return void
function Hero60013_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.enemyTargetPosition = tonumber(parsedData.damage_target_position)
    self.enemyTargetNumber = tonumber(parsedData.damage_target_number)

    self.stealStatType = tonumber(parsedData.steal_stat_type)
    self.stealStatAmount = tonumber(parsedData.steal_stat_amount)
end

return Hero60013_Skill1_Data