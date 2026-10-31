--- @class Hero10016_Skill1_Data Croconile
Hero10016_Skill1_Data = Class(Hero10016_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10016_Skill1_Data:CreateInstance()
    return Hero10016_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10016_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.enemy_class ~= nil, "enemy_class = nil")
end

--- @return void
--- @param parsedData table
function Hero10016_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectAmount = tonumber(parsedData.effect_amount)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.enemyClass = tonumber(parsedData.enemy_class)
end

return Hero10016_Skill1_Data