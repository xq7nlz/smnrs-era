--- @class Hero30022_Skill4_Data Dungan
Hero30022_Skill4_Data = Class(Hero30022_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30022_Skill4_Data:CreateInstance()
    return Hero30022_Skill4_Data()
end

--- @return void
function Hero30022_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
function Hero30022_Skill4_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
    self.damage = tonumber(parsedData.damage)
end

return Hero30022_Skill4_Data