--- @class Hero60013_Skill3_Data DarkKnight
Hero60013_Skill3_Data = Class(Hero60013_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60013_Skill3_Data:CreateInstance()
    return Hero60013_Skill3_Data()
end

--- @return void
function Hero60013_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.counter_attack_chance ~= nil, "counter_attack_chance = nil")
    assert(parsedData.counter_attack_damage ~= nil, "counter_attack_damage = nil")
end

--- @return void
function Hero60013_Skill3_Data:ParseCsv(parsedData)
    self.counterAttackChance = tonumber(parsedData.counter_attack_chance)
    self.counterAttackDamage = tonumber(parsedData.counter_attack_damage)
end

return Hero60013_Skill3_Data