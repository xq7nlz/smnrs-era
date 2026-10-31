--- @class Hero50006_Skill3_Data Enule
Hero50006_Skill3_Data = Class(Hero50006_Skill3_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50006_Skill3_Data:CreateInstance()
    return Hero50006_Skill3_Data()
end

--- @return void
function Hero50006_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.extra_turn_chance ~= nil, "extra_turn_chance = nil")
    assert(parsedData.damage_of_extra_turn ~= nil, "damage_of_extra_turn = nil")
    assert(parsedData.extra_turn_limit ~= nil, "extra_turn_limit = nil")
end

--- @return void
function Hero50006_Skill3_Data:ParseCsv(parsedData)
    self.extraTurnChance = tonumber(parsedData.extra_turn_chance)
    self.damageOfExtraTurn = tonumber(parsedData.damage_of_extra_turn)
    self.extraTurnLimit = tonumber(parsedData.extra_turn_limit)
end

return Hero50006_Skill3_Data