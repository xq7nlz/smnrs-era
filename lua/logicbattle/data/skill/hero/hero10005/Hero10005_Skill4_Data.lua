--- @class Hero10005_Skill4_Data Mist
Hero10005_Skill4_Data = Class(Hero10005_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10005_Skill4_Data:CreateInstance()
    return Hero10005_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10005_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.counter_attack_chance ~= nil, "counter_attack_chance = nil")
    assert(parsedData.counter_attack_damage ~= nil, "counter_attack_damage = nil")
end

--- @return void
--- @param parsedData table
function Hero10005_Skill4_Data:ParseCsv(parsedData)
    self.counterAttackChance = tonumber(parsedData.counter_attack_chance)
    self.counterAttackDamage = tonumber(parsedData.counter_attack_damage)
end

return Hero10005_Skill4_Data