--- @class Hero60002_Skill3_Data Bloodseeker
Hero60002_Skill3_Data = Class(Hero60002_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60002_Skill3_Data:CreateInstance()
    return Hero60002_Skill3_Data()
end

--- @return void
function Hero60002_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
end

--- @return void
function Hero60002_Skill3_Data:ParseCsv(parsedData)
    self.healPercent = tonumber(parsedData.heal_percent)
end

return Hero60002_Skill3_Data