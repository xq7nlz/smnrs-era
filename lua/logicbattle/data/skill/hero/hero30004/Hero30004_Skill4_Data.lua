--- @class Hero30004_Skill4_Data Stheno
Hero30004_Skill4_Data = Class(Hero30004_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30004_Skill4_Data:CreateInstance()
    return Hero30004_Skill4_Data()
end

--- @return void
function Hero30004_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
end

--- @return void
function Hero30004_Skill4_Data:ParseCsv(parsedData)
    self.healPercent = tonumber(parsedData.heal_percent)
end

return Hero30004_Skill4_Data