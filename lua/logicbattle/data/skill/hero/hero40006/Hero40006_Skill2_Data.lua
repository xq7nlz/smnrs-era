--- @class Hero40006_Skill2_Data Oropher
Hero40006_Skill2_Data = Class(Hero40006_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40006_Skill2_Data:CreateInstance()
    return Hero40006_Skill2_Data()
end

--- @return void
function Hero40006_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_bonus_percent ~= nil, "effect_bonus_percent = nil")

    assert(parsedData.target_number ~= nil, "target_number = nil")
    assert(parsedData.target_position ~= nil, "target_position = nil")
end

--- @return void
function Hero40006_Skill2_Data:ParseCsv(parsedData)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectBonusPercent = tonumber(parsedData.effect_bonus_percent)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Hero40006_Skill2_Data