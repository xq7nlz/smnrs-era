--- @class Hero10012_Skill2_Data Assassiren
Hero10012_Skill2_Data = Class(Hero10012_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10012_Skill2_Data:CreateInstance()
    return Hero10012_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero10012_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.faction_buff ~= nil, "faction_buff = nil")
    assert(parsedData.stat_per_faction_buff_type ~= nil, "stat_per_faction_buff_type = nil")
    assert(parsedData.stat_per_faction_buff_amount ~= nil, "stat_per_faction_buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10012_Skill2_Data:ParseCsv(parsedData)
    self.statPerFactionBuffType = tonumber(parsedData.stat_per_faction_buff_type)
    self.statPerFactionBuffAmount = tonumber(parsedData.stat_per_faction_buff_amount)
    self.factionBuff = tonumber(parsedData.faction_buff)
end

return Hero10012_Skill2_Data