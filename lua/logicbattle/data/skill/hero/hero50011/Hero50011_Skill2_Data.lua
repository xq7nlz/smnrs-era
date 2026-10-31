--- @class Hero50011_Skill2_Data Ignatius
Hero50011_Skill2_Data = Class(Hero50011_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50011_Skill2_Data:CreateInstance()
    return Hero50011_Skill2_Data()
end

--- @return void
function Hero50011_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_stat ~= nil, "buff_stat = nil")
    assert(parsedData.buff_amount ~= nil, "buff_amount = nil")

    assert(parsedData.max_stack ~= nil, "max_stack = nil")
end

--- @return void
function Hero50011_Skill2_Data:ParseCsv(parsedData)
    self.buffStat = tonumber(parsedData.buff_stat)
    self.buffAmount = tonumber(parsedData.buff_amount)

    self.maxStack = tonumber(parsedData.max_stack)
end

return Hero50011_Skill2_Data