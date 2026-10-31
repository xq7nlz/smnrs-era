--- @class Hero40011_Skill4_Data Neutar
Hero40011_Skill4_Data = Class(Hero40011_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40011_Skill4_Data:CreateInstance()
    return Hero40011_Skill4_Data()
end

--- @return void
function Hero40011_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")

    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")

    assert(parsedData.cc_trigger_class ~= nil, "cc_trigger_class = nil")
    assert(parsedData.cc_trigger_chance ~= nil, "cc_trigger_chance = nil")
    assert(parsedData.cc_trigger_type ~= nil, "cc_trigger_type = nil")
    assert(parsedData.cc_trigger_duration ~= nil, "cc_trigger_duration = nil")
end

--- @return void
function Hero40011_Skill4_Data:ParseCsv(parsedData)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)

    self.healAmount = tonumber(parsedData.heal_amount)

    self.ccTriggerClass = tonumber(parsedData.cc_trigger_class)
    self.ccTriggerChance = tonumber(parsedData.cc_trigger_chance)
    self.ccTriggerType = tonumber(parsedData.cc_trigger_type)
    self.ccTriggerDuration = tonumber(parsedData.cc_trigger_duration)
end

return Hero40011_Skill4_Data