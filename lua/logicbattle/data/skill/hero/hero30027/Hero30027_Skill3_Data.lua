--- @class Hero30027_Skill3_Data : BaseSkillData Kazetsu
Hero30027_Skill3_Data = Class(Hero30027_Skill3_Data, BaseSkillData)

--- @return void
function Hero30027_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30027_Skill3_Data:CreateInstance()
    return Hero30027_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero30027_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_1_buff_type_1 ~= nil, "stat_1_buff_type_1 = nil")
    assert(parsedData.bonus_stat_type_1 ~= nil, "bonus_stat_type_1 = nil")
    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_calculation_type ~= nil, "stat_debuff_calculation_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero30027_Skill3_Data:ParseCsv(parsedData)
    self.statType1 = tonumber(parsedData.stat_1_buff_type_1)
    self.attackPerAlly = tonumber(parsedData.bonus_stat_type_1)
    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffCalculationType = tonumber(parsedData.stat_debuff_calculation_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
end

return Hero30027_Skill3_Data
