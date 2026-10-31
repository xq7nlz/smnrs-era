--- @class Hero50004_Skill3_Data Grimm
Hero50004_Skill3_Data = Class(Hero50004_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50004_Skill3_Data:CreateInstance()
    return Hero50004_Skill3_Data()
end

--- @return void
function Hero50004_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_convert ~= nil, "stat_convert = nil")
    assert(parsedData.stat_percent ~= nil, "stat_percent = nil")
end

--- @return void
function Hero50004_Skill3_Data:ParseCsv(parsedData)
    self.statConvert = tonumber(parsedData.stat_convert)
    self.statPercent = tonumber(parsedData.stat_percent)
end

return Hero50004_Skill3_Data