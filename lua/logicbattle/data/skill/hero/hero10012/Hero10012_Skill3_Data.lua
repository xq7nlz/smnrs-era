--- @class Hero10012_Skill3_Data Assassiren
Hero10012_Skill3_Data = Class(Hero10012_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10012_Skill3_Data:CreateInstance()
    return Hero10012_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero10012_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.power_stat ~= nil, "power_stat = nil")
end

--- @return void
--- @param parsedData table
function Hero10012_Skill3_Data:ParseCsv(parsedData)
    self.powerStat = tonumber(parsedData.power_stat)
end

return Hero10012_Skill3_Data