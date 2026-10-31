--- @class Hero10014_Skill1_Data IceMaster
Hero10014_Skill1_Data = Class(Hero10014_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10014_Skill1_Data:CreateInstance()
    return Hero10014_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10014_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
--- @param parsedData table
function Hero10014_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Hero10014_Skill1_Data