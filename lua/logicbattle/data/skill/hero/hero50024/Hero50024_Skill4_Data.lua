--- @class Hero50024_Skill4_Data Dancer
Hero50024_Skill4_Data = Class(Hero50024_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50024_Skill4_Data:CreateInstance()
    return Hero50024_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero50024_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
end

--- @return void
--- @param parsedData table
function Hero50024_Skill4_Data:ParseCsv(parsedData)
    self.healChance = tonumber(parsedData.heal_chance)
    self.healPercent = tonumber(parsedData.heal_percent)
end

return Hero50024_Skill4_Data
