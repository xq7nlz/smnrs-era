--- @class Hero30012_Skill3_Data Dzuteh
Hero30012_Skill3_Data = Class(Hero30012_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30012_Skill3_Data:CreateInstance()
    return Hero30012_Skill3_Data()
end

--- @return void
function Hero30012_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_trigger_bonus ~= nil, "effect_trigger_bonus = nil")
    assert(parsedData.bonus_damage ~= nil, "bonus_damage = nil")
end

--- @return void
function Hero30012_Skill3_Data:ParseCsv(parsedData)
    self.effectTypeTrigger = tonumber(parsedData.effect_trigger_bonus)
    self.bonusDamage = tonumber(parsedData.bonus_damage)
end

return Hero30012_Skill3_Data