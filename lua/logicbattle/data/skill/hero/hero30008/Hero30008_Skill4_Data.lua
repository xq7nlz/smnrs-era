--- @class Hero30008_Skill4_Data Kozorg
Hero30008_Skill4_Data = Class(Hero30008_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30008_Skill4_Data:CreateInstance()
    return Hero30008_Skill4_Data()
end

--- @return void
function Hero30008_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.cc_chance ~= nil, "cc_chance = nil")
    assert(parsedData.cc_type ~= nil, "cc_type = nil")
    assert(parsedData.cc_duration ~= nil, "cc_duration = nil")
end

--- @return void
function Hero30008_Skill4_Data:ParseCsv(parsedData)
    self.crowdControlChance = tonumber(parsedData.cc_chance)
    self.crowdControlType = tonumber(parsedData.cc_type)
    self.crowdControlDuration = tonumber(parsedData.cc_duration)
end

return Hero30008_Skill4_Data