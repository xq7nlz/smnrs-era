--- @class Hero40008_Skill2_Data Lass
Hero40008_Skill2_Data = Class(Hero40008_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40008_Skill2_Data:CreateInstance()
    return Hero40008_Skill2_Data()
end

--- @return void
function Hero40008_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_per_faction_buff_type ~= nil, "stat_per_faction_buff_type = nil")
    assert(parsedData.stat_per_faction_buff_amount ~= nil, "stat_per_faction_buff_amount = nil")
end

--- @return void
function Hero40008_Skill2_Data:ParseCsv(parsedData)
    self.statPerFactionBuffType = tonumber(parsedData.stat_per_faction_buff_type)
    self.statPerFactionBuffAmount = tonumber(parsedData.stat_per_faction_buff_amount)
end

return Hero40008_Skill2_Data