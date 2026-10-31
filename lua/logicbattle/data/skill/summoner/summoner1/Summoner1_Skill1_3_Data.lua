--- @class Summoner1_Skill1_3_Data Mage
Summoner1_Skill1_3_Data = Class(Summoner1_Skill1_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner1_Skill1_3_Data:CreateInstance()
    return Summoner1_Skill1_3_Data()
end

--- @return void
--- @param parsedData table
function Summoner1_Skill1_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.damage_bonus_per_die ~= nil, "damage_bonus_per_die = nil")
    assert(parsedData.dispel_chance ~= nil, "dispel_chance = nil")
end

--- @return void
--- @param parsedData table
function Summoner1_Skill1_3_Data:ParseCsv(parsedData)
    self.baseDamage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.bonusDamageEnemyDie = tonumber(parsedData.damage_bonus_per_die)
    self.dispelChance = tonumber(parsedData.dispel_chance)
end

return Summoner1_Skill1_3_Data