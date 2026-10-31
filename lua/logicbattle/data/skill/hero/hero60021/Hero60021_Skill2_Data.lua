--- @class Hero60021_Skill2_Data Dark Archer
Hero60021_Skill2_Data = Class(Hero60021_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60021_Skill2_Data:CreateInstance()
    return Hero60021_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero60021_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.extra_turn_chance_per_crit ~= nil, "extra_turn_chance_per_crit = nil")
    assert(parsedData.extra_turn_limit ~= nil, "extra_turn_limit = nil")
    assert(parsedData.damage_per_extra_turn ~= nil, "damage_per_extra_turn = nil")
end

--- @return void
--- @param parsedData table
function Hero60021_Skill2_Data:ParseCsv(parsedData)
    self.extraTurnChance = tonumber(parsedData.extra_turn_chance_per_crit)
    self.extraTurnLimit = tonumber(parsedData.extra_turn_limit)
    self.damagePerExtraTurn = tonumber(parsedData.damage_per_extra_turn)
end

return Hero60021_Skill2_Data
