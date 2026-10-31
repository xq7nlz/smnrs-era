--- @class Hero10018_Skill4_Data Sabertusk
Hero10018_Skill4_Data = Class(Hero10018_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10018_Skill4_Data:CreateInstance()
    return Hero10018_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10018_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_amount ~= nil, "silence_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10018_Skill4_Data:ParseCsv(parsedData)
    self.healAmount = tonumber(parsedData.heal_amount)
end

return Hero10018_Skill4_Data