--- @class Hero30014_Skill2_Data Kargoth
Hero30014_Skill2_Data = Class(Hero30014_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30014_Skill2_Data:CreateInstance()
    return Hero30014_Skill2_Data()
end

--- @return void
function Hero30014_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.blood_mark_chance ~= nil, "blood_mark_chance = nil")
    assert(parsedData.blood_mark_duration ~= nil, "blood_mark_duration = nil")

    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")
    assert(parsedData.stat_buff_duration ~= nil, "health_trigger = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero30014_Skill2_Data:ParseCsv(parsedData)
    self.bloodMarkChance = tonumber(parsedData.blood_mark_chance)
    self.bloodMarkDuration = tonumber(parsedData.blood_mark_duration)

    self.healthTrigger = tonumber(parsedData.health_trigger)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero30014_Skill2_Data