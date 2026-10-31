--- @class Summoner3_Skill4_3_Data Priest
Summoner3_Skill4_3_Data = Class(Summoner3_Skill4_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner3_Skill4_3_Data:CreateInstance()
    return Summoner3_Skill4_3_Data()
end

--- @return void
function Summoner3_Skill4_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_trigger ~= nil, "heal_trigger = nil")
    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
end

--- @return void
function Summoner3_Skill4_3_Data:ParseCsv(parsedData)
    self.healTrigger = tonumber(parsedData.heal_trigger)
    self.healChance = tonumber(parsedData.heal_chance)
    self.healAmount = tonumber(parsedData.heal_amount)
end

return Summoner3_Skill4_3_Data