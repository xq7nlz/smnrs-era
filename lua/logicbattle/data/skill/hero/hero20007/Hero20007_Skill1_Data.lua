--- @class Hero20007_Skill1_Data Ninetales
Hero20007_Skill1_Data = Class(Hero20007_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20007_Skill1_Data:CreateInstance()
    return Hero20007_Skill1_Data()
end

--- @return void
function Hero20007_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")

    assert(parsedData.buff_stat ~= nil, "buff_stat = nil")
    assert(parsedData.buff_amount ~= nil, "buff_amount = nil")
    assert(parsedData.buff_duration ~= nil, "buff_duration = nil")
end

--- @return void
function Hero20007_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.damage_target_position)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)

    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healPercent = tonumber(parsedData.heal_percent)

    self.buffStat = tonumber(parsedData.buff_stat)
    self.buffAmount = tonumber(parsedData.buff_amount)
    self.buffDuration = tonumber(parsedData.buff_duration)
end

return Hero20007_Skill1_Data