--- @class Hero50010_Skill2_Data Sephion
Hero50010_Skill2_Data = Class(Hero50010_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50010_Skill2_Data:CreateInstance()
    return Hero50010_Skill2_Data()
end

--- @return void
function Hero50010_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.counter_attack_chance ~= nil, "counter_attack_chance = nil")
    assert(parsedData.counter_attack_damage ~= nil, "counter_attack_damage = nil")
end

--- @return void
function Hero50010_Skill2_Data:ParseCsv(parsedData)
    self.counterAttackChance = tonumber(parsedData.counter_attack_chance)
    self.counterAttackDamage = tonumber(parsedData.counter_attack_damage)
end

return Hero50010_Skill2_Data