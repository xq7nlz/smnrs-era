--- @class Hero30003_Skill2_Data Nero
Hero30003_Skill2_Data = Class(Hero30003_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30003_Skill2_Data:CreateInstance()
    return Hero30003_Skill2_Data()
end

--- @return void
function Hero30003_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
end

--- @return void
function Hero30003_Skill2_Data:ParseCsv(parsedData)
    self.healPercent = tonumber(parsedData.heal_percent)
end

return Hero30003_Skill2_Data