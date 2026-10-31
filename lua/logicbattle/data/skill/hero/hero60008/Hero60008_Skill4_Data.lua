--- @class Hero60008_Skill4_Data Renaks
Hero60008_Skill4_Data = Class(Hero60008_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60008_Skill4_Data:CreateInstance()
    return Hero60008_Skill4_Data()
end

--- @return void
function Hero60008_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")

    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")

    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
    assert(parsedData.trigger_chance ~= nil, "trigger_chance = nil")
end

--- @return void
function Hero60008_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)

    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffType = tonumber(parsedData.stat_buff_type)

    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
    self.healAmount = tonumber(parsedData.heal_amount)
    self.triggerChance = tonumber(parsedData.trigger_chance)
end

return Hero60008_Skill4_Data
