--- @class Hero30007_Skill4_Data Zygor
Hero30007_Skill4_Data = Class(Hero30007_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30007_Skill4_Data:CreateInstance()
    return Hero30007_Skill4_Data()
end

--- @return void
function Hero30007_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.revive_hp_percent ~= nil, "revive_hp_percent = nil")
end

--- @return void
function Hero30007_Skill4_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.reviveHpPercent = tonumber(parsedData.revive_hp_percent)
end

return Hero30007_Skill4_Data