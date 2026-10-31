--- @class Hero20006_Skill3_Data Finde
Hero20006_Skill3_Data = Class(Hero20006_Skill3_Data, BaseSkillData)

--- @return void
function Hero20006_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20006_Skill3_Data:CreateInstance()
    return Hero20006_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero20006_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.number_round_to_buff ~= nil, "number_round_to_buff = nil")
end

--- @return void
--- @param parsedData table
function Hero20006_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
    self.numberRoundToBuff = tonumber(parsedData.number_round_to_buff)
end

return Hero20006_Skill3_Data