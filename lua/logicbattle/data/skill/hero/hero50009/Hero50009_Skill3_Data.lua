--- @class Hero50009_Skill3_Data Aris
Hero50009_Skill3_Data = Class(Hero50009_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50009_Skill3_Data:CreateInstance()
    return Hero50009_Skill3_Data()
end

--- @return void
function Hero50009_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_per_light_buff_type ~= nil, "stat_per_light_buff_type = nil")
    assert(parsedData.stat_per_light_buff_amount ~= nil, "stat_per_light_buff_amount = nil")

    assert(parsedData.stat_per_dark_buff_type ~= nil, "stat_per_dark_buff_type = nil")
    assert(parsedData.stat_per_dark_buff_amount ~= nil, "stat_per_dark_buff_amount = nil")
end

--- @return void
function Hero50009_Skill3_Data:ParseCsv(parsedData)
    self.statPerLightBuffType = tonumber(parsedData.stat_per_light_buff_type)
    self.statPerLightBuffAmount = tonumber(parsedData.stat_per_light_buff_amount)

    self.statPerDarkBuffType = tonumber(parsedData.stat_per_dark_buff_type)
    self.statPerDarkBuffAmount = tonumber(parsedData.stat_per_dark_buff_amount)
end

return Hero50009_Skill3_Data