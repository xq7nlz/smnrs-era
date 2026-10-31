--- @class Hero10016_Skill4_Data Croconile
Hero10016_Skill4_Data = Class(Hero10016_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10016_Skill4_Data:CreateInstance()
    return Hero10016_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10016_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.block_chance ~= nil, "block_chance = nil")
    assert(parsedData.block_amount ~= nil, "block_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10016_Skill4_Data:ParseCsv(parsedData)
    self.blockChance = tonumber(parsedData.block_chance)
    self.blockAmount = tonumber(parsedData.block_amount)
end

return Hero10016_Skill4_Data