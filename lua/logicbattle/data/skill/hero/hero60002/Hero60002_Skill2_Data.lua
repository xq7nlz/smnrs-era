--- @class Hero60002_Skill2_Data Bloodseeker
Hero60002_Skill2_Data = Class(Hero60002_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60002_Skill2_Data:CreateInstance()
    return Hero60002_Skill2_Data()
end

--- @return void
function Hero60002_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_lower ~= nil, "hp_lower = nil")

    assert(parsedData.stat_1 ~= nil, "stat_1 = nil")
    assert(parsedData.bonus_1 ~= nil, "bonus_1 = nil")
    assert(parsedData.calculation_type_1 ~= nil, "calculation_type_1 = nil")

    assert(parsedData.stat_2 ~= nil, "stat_2 = nil")
    assert(parsedData.bonus_2 ~= nil, "bonus_2 = nil")
    assert(parsedData.calculation_type_2 ~= nil, "calculation_type_2 = nil")
end

--- @return void
function Hero60002_Skill2_Data:ParseCsv(parsedData)
    self.hpLower = tonumber(parsedData.hp_lower)

    self.stat_1 = tonumber(parsedData.stat_1)
    self.bonus_1 = tonumber(parsedData.bonus_1)
    self.calculation_type_1 = tonumber(parsedData.calculation_type_1)

    self.stat_2 = tonumber(parsedData.stat_2)
    self.bonus_2 = tonumber(parsedData.bonus_2)
    self.calculation_type_2 = tonumber(parsedData.calculation_type_2)
end

return Hero60002_Skill2_Data