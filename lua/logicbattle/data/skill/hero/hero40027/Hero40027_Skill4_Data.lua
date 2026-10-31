--- @class Hero40027_Skill4_Data : BaseSkillData Airyuu
Hero40027_Skill4_Data = Class(Hero40027_Skill4_Data, BaseSkillData)

--- @return void
function Hero40027_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)
end

--- @return BaseSkillData
function Hero40027_Skill4_Data:CreateInstance()
    return Hero40027_Skill4_Data()
end

--- @return void
function Hero40027_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.new_hp_percent ~= nil, "new_hp_percent = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.trigger_hp ~= nil, "trigger_hp = nil")

end

--- @return void
function Hero40027_Skill4_Data:ParseCsv(parsedData)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.newHpPercent = tonumber(parsedData.new_hp_percent)
    self.triggerHp = tonumber(parsedData.trigger_hp)
end

return Hero40027_Skill4_Data