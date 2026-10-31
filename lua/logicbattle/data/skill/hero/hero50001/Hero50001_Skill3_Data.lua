--- @class Hero50001_Skill3_Data AmiableAngel
Hero50001_Skill3_Data = Class(Hero50001_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50001_Skill3_Data:CreateInstance()
    return Hero50001_Skill3_Data()
end

--- @return void
function Hero50001_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage_percent_to_heal ~= nil, "damage_percent_to_heal = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
function Hero50001_Skill3_Data:ParseCsv(parsedData)
    self.damagePercentToHeal = tonumber(parsedData.damage_percent_to_heal)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Hero50001_Skill3_Data