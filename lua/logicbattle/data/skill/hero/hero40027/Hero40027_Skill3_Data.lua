--- @class Hero40027_Skill3_Data : BaseSkillData Airyuu
Hero40027_Skill3_Data = Class(Hero40027_Skill3_Data, BaseSkillData)

--- @return void
function Hero40027_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)
end

--- @return BaseSkillData
function Hero40027_Skill3_Data:CreateInstance()
    return Hero40027_Skill3_Data()
end

--- @return void
function Hero40027_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero40027_Skill3_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectAmount = tonumber(parsedData.effect_amount)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero40027_Skill3_Data