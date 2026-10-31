--- @class Hero60001_Skill4_Data BlackArrow
Hero60001_Skill4_Data = Class(Hero60001_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60001_Skill4_Data:CreateInstance()
    return Hero60001_Skill4_Data()
end

--- @return void
function Hero60001_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.extra_turn_chance_per_crit ~= nil, "extra_turn_chance_per_crit = nil")
    assert(parsedData.extra_turn_limit ~= nil, "extra_turn_limit = nil")
    assert(parsedData.damage_per_extra_turn ~= nil, "damage_per_extra_turn = nil")
end

--- @return void
function Hero60001_Skill4_Data:ParseCsv(parsedData)
    self.extraTurnChance = tonumber(parsedData.extra_turn_chance_per_crit)
    self.extraTurnLimit = tonumber(parsedData.extra_turn_limit)
    self.damagePerExtraTurn = tonumber(parsedData.damage_per_extra_turn)
end

return Hero60001_Skill4_Data