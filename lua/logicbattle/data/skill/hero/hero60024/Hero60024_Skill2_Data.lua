--- @class Hero60024_Skill2_Data Dead Servant
Hero60024_Skill2_Data = Class(Hero60024_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60024_Skill2_Data:CreateInstance()
    return Hero60024_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero60024_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero60024_Skill2_Data:ParseCsv(parsedData)
    self.healChance = tonumber(parsedData.heal_chance)
    self.healAmount = tonumber(parsedData.heal_amount)
end

return Hero60024_Skill2_Data
