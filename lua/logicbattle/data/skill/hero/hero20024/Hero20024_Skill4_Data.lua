--- @class Hero20024_Skill4_Data Yasin
Hero20024_Skill4_Data = Class(Hero20024_Skill4_Data, BaseSkillData)

--- @return void
function Hero20024_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatBonus
    self.statBonus = StatBonus(StatChangerCalculationType.PERCENT_ADD)

    --- @type number
    self.effectDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20024_Skill4_Data:CreateInstance()
    return Hero20024_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero20024_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero20024_Skill4_Data:ParseCsv(parsedData)
    self.statBonus:ParseCsv(parsedData, 1)

    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero20024_Skill4_Data
