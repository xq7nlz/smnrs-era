--- @class Hero10003_Skill2_Data Glacious_Fairy
Hero10003_Skill2_Data = Class(Hero10003_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10003_Skill2_Data:CreateInstance()
    return Hero10003_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero10003_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_1_type ~= nil, "effect_1_type = nil")
    assert(parsedData.effect_1_duration ~= nil, "effect1_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10003_Skill2_Data:ParseCsv(parsedData)
    self.effect1_type = tonumber(parsedData.effect_1_type)
    self.effect1_duration = tonumber(parsedData.effect_1_duration)
end

return Hero10003_Skill2_Data