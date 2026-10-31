--- @class Hero40010_Skill3_Data Yome
Hero40010_Skill3_Data = Class(Hero40010_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40010_Skill3_Data:CreateInstance()
    return Hero40010_Skill3_Data()
end

--- @return void
function Hero40010_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.bonus_damage_with_effect ~= nil, "bonus_damage_with_effect = nil")
end

--- @return void
function Hero40010_Skill3_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.bonusDamageWithEffect = tonumber(parsedData.bonus_damage_with_effect)
end

return Hero40010_Skill3_Data