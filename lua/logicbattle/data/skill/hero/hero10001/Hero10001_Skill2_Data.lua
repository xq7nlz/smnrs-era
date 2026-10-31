--- @class Hero10001_Skill2_Data
Hero10001_Skill2_Data = Class(Hero10001_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10001_Skill2_Data:CreateInstance()
    return Hero10001_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero10001_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_damage ~= nil, "bonus_damage = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
end

--- @return void
--- @param parsedData table
function Hero10001_Skill2_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.bonusDamage = tonumber(parsedData.bonus_damage)
end

return Hero10001_Skill2_Data
