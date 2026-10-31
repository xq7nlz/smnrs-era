--- @class Hero10016_Skill3_Data Croconile
Hero10016_Skill3_Data = Class(Hero10016_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10016_Skill3_Data:CreateInstance()
    return Hero10016_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero10016_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.enemy_class ~= nil, "enemy_class = nil")
end

--- @return void
--- @param parsedData table
function Hero10016_Skill3_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectAmount = tonumber(parsedData.effect_amount)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.enemyClass = tonumber(parsedData.enemy_class)
end

return Hero10016_Skill3_Data