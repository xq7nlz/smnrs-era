--- @class Hero20003_Skill2_Data Eitri
Hero20003_Skill2_Data = Class(Hero20003_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20003_Skill2_Data:CreateInstance()
    return Hero20003_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero20003_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero20003_Skill2_Data:ParseCsv(parsedData)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.healAmount = tonumber(parsedData.heal_amount)
end

return Hero20003_Skill2_Data