--- @class Hero60003_Skill1_Data ShadowBlade
Hero60003_Skill1_Data = Class(Hero60003_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60003_Skill1_Data:CreateInstance()
    return Hero60003_Skill1_Data()
end

--- @return void
function Hero60003_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")
    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.first_chance ~= nil, "first_chance = nil")
    assert(parsedData.first_multi_damage ~= nil, "first_multi_damage = nil")
    assert(parsedData.second_chance ~= nil, "second_chance = nil")
    assert(parsedData.second_multi_damage ~= nil, "second_multi_damage = nil")
end

--- @return void
function Hero60003_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)
    self.targetNumber = tonumber(parsedData.damage_target_number)
    self.targetPosition = tonumber(parsedData.damage_target_position)

    self.firstChance = tonumber(parsedData.first_chance)
    self.firstMultiDamage = tonumber(parsedData.first_multi_damage)
    self.secondChance = tonumber(parsedData.second_chance)
    self.secondMultiDamage = tonumber(parsedData.second_multi_damage)
end

return Hero60003_Skill1_Data