--- @class Hero60007_Skill2_Data Rannantos
Hero60007_Skill2_Data = Class(Hero60007_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60007_Skill2_Data:CreateInstance()
    return Hero60007_Skill2_Data()
end

--- @return void
function Hero60007_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero60007_Skill2_Data:ParseCsv(parsedData)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero60007_Skill2_Data