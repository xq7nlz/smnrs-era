--- @class Hero50023_Skill4_Data Dancer
Hero50023_Skill4_Data = Class(Hero50023_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50023_Skill4_Data:CreateInstance()
    return Hero50023_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero50023_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
end

--- @return void
--- @param parsedData table
function Hero50023_Skill4_Data:ParseCsv(parsedData)
    self.healPercent = tonumber(parsedData.heal_percent)
end

return Hero50023_Skill4_Data
