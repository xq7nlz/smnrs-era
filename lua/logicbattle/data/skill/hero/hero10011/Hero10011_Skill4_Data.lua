--- @class Hero10011_Skill4_Data Jeronim
Hero10011_Skill4_Data = Class(Hero10011_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10011_Skill4_Data:CreateInstance()
    return Hero10011_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10011_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.extra_turn_chance ~= nil, "extra_turn_chance = nil")
    assert(parsedData.damage_of_extra_turn ~= nil, "damage_of_extra_turn = nil")
    assert(parsedData.extra_turn_limit ~= nil, "extra_turn_limit = nil")
end

--- @return void
--- @param parsedData table
function Hero10011_Skill4_Data:ParseCsv(parsedData)
    self.extraTurnChance = tonumber(parsedData.extra_turn_chance)
    self.damageOfExtraTurn = tonumber(parsedData.damage_of_extra_turn)
    self.extraTurnLimit = tonumber(parsedData.extra_turn_limit)
end

return Hero10011_Skill4_Data