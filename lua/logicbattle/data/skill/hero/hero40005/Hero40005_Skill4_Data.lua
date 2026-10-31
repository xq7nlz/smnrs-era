--- @class Hero40005_Skill4_Data Yang
Hero40005_Skill4_Data = Class(Hero40005_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40005_Skill4_Data:CreateInstance()
    return Hero40005_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero40005_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.block_limit ~= nil, "block_limit = nil")
    assert(parsedData.block_rate ~= nil, "block_rate = nil")
end

--- @return void
function Hero40005_Skill4_Data:ParseCsv(parsedData)
    self.blockLimit = tonumber(parsedData.block_limit)
    self.blockRate = tonumber(parsedData.block_rate)
end

return Hero40005_Skill4_Data