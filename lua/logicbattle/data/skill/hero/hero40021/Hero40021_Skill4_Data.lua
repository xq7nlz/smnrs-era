--- @class Hero40021_Skill4_Data Titi
Hero40021_Skill4_Data = Class(Hero40021_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40021_Skill4_Data:CreateInstance()
    return Hero40021_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero40021_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.counter_attack_chance ~= nil, "counter_attack_chance = nil")
    assert(parsedData.counter_attack_damage ~= nil, "counter_attack_damage = nil")
end

--- @return void
--- @param parsedData table
function Hero40021_Skill4_Data:ParseCsv(parsedData)
    self.counterAttackChance = tonumber(parsedData.counter_attack_chance)
    self.counterAttackDamage = tonumber(parsedData.counter_attack_damage)
end

return Hero40021_Skill4_Data
