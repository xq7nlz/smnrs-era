--- @class Hero10006_Skill2_Data Aqualord
Hero10006_Skill2_Data = Class(Hero10006_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10006_Skill2_Data:CreateInstance()
    return Hero10006_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero10006_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.damage_share_percent ~= nil, "damage_share_percent = nil")
    assert(parsedData.bond_duration ~= nil, "bond_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10006_Skill2_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.damageSharePercent = tonumber(parsedData.damage_share_percent)
    self.bondDuration = tonumber(parsedData.bond_duration)
end

return Hero10006_Skill2_Data