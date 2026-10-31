--- @class Hero20025_Skill4_Data Yirlal
Hero20025_Skill4_Data = Class(Hero20025_Skill4_Data, BaseSkillData)

--- @return void
function Hero20025_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatBonus
    self.buffBonus = StatBonus(StatChangerCalculationType.PERCENT_ADD)

    --- @type StatBonus
    self.debuffBonus = StatBonus(StatChangerCalculationType.PERCENT_ADD)

    --- @type number
    self.buffDuration = nil

    --- @type number
    self.debuffDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20025_Skill4_Data:CreateInstance()
    return Hero20025_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero20025_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_duration ~= nil, "buff_duration = nil")
    assert(parsedData.debuff_duration ~= nil, "debuff_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero20025_Skill4_Data:ParseCsv(parsedData)
    self.buffBonus:ParseCsv(parsedData, 1)
    self.debuffBonus:ParseCsv(parsedData, 2)

    self.buffDuration = tonumber(parsedData.buff_duration)
    self.debuffDuration = tonumber(parsedData.debuff_duration)
end

return Hero20025_Skill4_Data
