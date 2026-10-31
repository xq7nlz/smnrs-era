--- @class Hero20010_Skill4_Data Ungoliant
Hero20010_Skill4_Data = Class(Hero20010_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20010_Skill4_Data:CreateInstance()
    return Hero20010_Skill4_Data()
end

--- @return void
function Hero20010_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
end

--- @return void
function Hero20010_Skill4_Data:ParseCsv(parsedData)
    self.healChance = tonumber(parsedData.heal_chance)
    self.healAmount = tonumber(parsedData.heal_amount)
end

return Hero20010_Skill4_Data