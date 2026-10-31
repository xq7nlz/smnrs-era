--- @class Hero30014_Skill4_Data Kargoth
Hero30014_Skill4_Data = Class(Hero30014_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30014_Skill4_Data:CreateInstance()
    return Hero30014_Skill4_Data()
end

--- @return void
function Hero30014_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.counter_attack_effect ~= nil, "counter_attack_effect = nil")
    assert(parsedData.counter_attack_chance ~= nil, "counter_attack_chance = nil")
    assert(parsedData.counter_attack_damage ~= nil, "counter_attack_damage = nil")
end

--- @return void
function Hero30014_Skill4_Data:ParseCsv(parsedData)
    self.counterAttackEffect = tonumber(parsedData.counter_attack_effect)
    self.counterAttackChance = tonumber(parsedData.counter_attack_chance)
    self.counterAttackDamage = tonumber(parsedData.counter_attack_damage)
end

return Hero30014_Skill4_Data