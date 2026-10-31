--- @class Hero30003_Skill4_Data Nero
Hero30003_Skill4_Data = Class(Hero30003_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30003_Skill4_Data:CreateInstance()
    return Hero30003_Skill4_Data()
end

--- @return void
function Hero30003_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_percent ~= nil, "stat_percent = nil")
    assert(parsedData.revive_chance ~= nil, "revive_chance = nil")
end

--- @return void
function Hero30003_Skill4_Data:ParseCsv(parsedData)
    self.statPercent = tonumber(parsedData.stat_percent)
    self.reviveChance = tonumber(parsedData.revive_chance)
end

return Hero30003_Skill4_Data