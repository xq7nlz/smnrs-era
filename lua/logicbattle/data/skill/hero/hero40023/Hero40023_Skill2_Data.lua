--- @class Hero40023_Skill2_Data HoundMaster
Hero40023_Skill2_Data = Class(Hero40023_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40023_Skill2_Data:CreateInstance()
    return Hero40023_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero40023_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.counter_attack_chance ~= nil, "counter_attack_chance = nil")
    assert(parsedData.counter_attack_damage ~= nil, "counter_attack_damage = nil")
end

--- @return void
--- @param parsedData table
function Hero40023_Skill2_Data:ParseCsv(parsedData)
    self.counterAttackChance = tonumber(parsedData.counter_attack_chance)
    self.counterAttackDamage = tonumber(parsedData.counter_attack_damage)
end

return Hero40023_Skill2_Data
