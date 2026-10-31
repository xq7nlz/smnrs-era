--- @class Hero60003_Skill4_Data ShadowBlade
Hero60003_Skill4_Data = Class(Hero60003_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60003_Skill4_Data:CreateInstance()
    return Hero60003_Skill4_Data()
end

--- @return void
function Hero60003_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")
    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_amount_by_damage ~= nil, "heal_amount_with_damage = nil")
end

--- @return void
function Hero60003_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)
    self.healChance = tonumber(parsedData.heal_chance)
    self.healAmount = tonumber(parsedData.heal_amount_by_damage)
end

return Hero60003_Skill4_Data