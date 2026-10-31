--- @class Hero40005_Skill2_Data Yang
Hero40005_Skill2_Data = Class(Hero40005_Skill2_Data, BaseSkillData)

--- @return void
function Hero40005_Skill2_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40005_Skill2_Data:CreateInstance()
    return Hero40005_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero40005_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.power_gain_per_basic_attack ~= nil, "power_gain_per_basic_attack = nil")
end

--- @return void
--- @param parsedData table
function Hero40005_Skill2_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.powerGainPerBasicAttack = tonumber(parsedData.power_gain_per_basic_attack)
end

return Hero40005_Skill2_Data
