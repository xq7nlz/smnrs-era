--- @class Hero60021_Skill1_Data Dark Archer
Hero60021_Skill1_Data = Class(Hero60021_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60021_Skill1_Data:CreateInstance()
    return Hero60021_Skill1_Data()
end

--- @return void
function Hero60021_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.silent_chance ~= nil, "silent_chance = nil")
    assert(parsedData.affected_hero_class ~= nil, "affected_hero_class = nil")
    assert(parsedData.silent_duration ~= nil, "silent_duration = nil")
end

--- @return void
function Hero60021_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.silentChance = tonumber(parsedData.silent_chance)
    self.affectedHeroClass = tonumber(parsedData.affected_hero_class)
    self.silentDuration = tonumber(parsedData.silent_duration)
end

return Hero60021_Skill1_Data