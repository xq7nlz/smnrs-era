--- @class Hero40012_Skill4_Data Lothiriel
Hero40012_Skill4_Data = Class(Hero40012_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40012_Skill4_Data:CreateInstance()
    return Hero40012_Skill4_Data()
end

--- @return void
function Hero40012_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_damage ~= nil, "bonus_damage = nil")
    assert(parsedData.effect_check_type ~= nil, "effect_check_type = nil")
end

--- @return void
function Hero40012_Skill4_Data:ParseCsv(parsedData)
    self.multiBonusDamage = tonumber(parsedData.bonus_damage)
    self.effectCheckType = tonumber(parsedData.effect_check_type)
end

return Hero40012_Skill4_Data