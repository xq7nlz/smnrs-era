--- @class Hero40012_Skill3_Data Lothiriel
Hero40012_Skill3_Data = Class(Hero40012_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40012_Skill3_Data:CreateInstance()
    return Hero40012_Skill3_Data()
end

--- @return void
function Hero40012_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.silence_duration ~= nil, "silence_duration = nil")
    assert(parsedData.silence_chance ~= nil, "silence_chance = nil")
end

--- @return void
function Hero40012_Skill3_Data:ParseCsv(parsedData)
    self.silenceDuration = tonumber(parsedData.silence_duration)
    self.silenceChance = tonumber(parsedData.silence_chance)
end

return Hero40012_Skill3_Data