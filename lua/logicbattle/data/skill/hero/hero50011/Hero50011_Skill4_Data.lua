--- @class Hero50011_Skill4_Data Ignatius
Hero50011_Skill4_Data = Class(Hero50011_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50011_Skill4_Data:CreateInstance()
    return Hero50011_Skill4_Data()
end

--- @return void
function Hero50011_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.trigger_chance ~= nil, "trigger_chance = nil")

    assert(parsedData.buff_stat ~= nil, "buff_stat = nil")
    assert(parsedData.buff_amount ~= nil, "buff_amount = nil")
    assert(parsedData.buff_duration ~= nil, "buff_duration = nil")

    assert(parsedData.max_stack ~= nil, "max_stack = nil")
end

--- @return void
function Hero50011_Skill4_Data:ParseCsv(parsedData)
    self.triggerChance = tonumber(parsedData.trigger_chance)

    self.buffStat = tonumber(parsedData.buff_stat)
    self.buffAmount = tonumber(parsedData.buff_amount)
    self.buffDuration = tonumber(parsedData.buff_duration)

    self.maxStack = tonumber(parsedData.max_stack)
end

return Hero50011_Skill4_Data