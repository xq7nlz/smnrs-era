--- @class Summoner2_Skill2_2_Data Warrior
Summoner2_Skill2_2_Data = Class(Summoner2_Skill2_2_Data, BaseSkillData)

--- @return void
function Summoner2_Skill2_2_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)

    --- @type List<StatBonus>
    self.debuffBonuses = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner2_Skill2_2_Data:CreateInstance()
    return Summoner2_Skill2_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner2_Skill2_2_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.target_class ~= nil, "target_class = nil")

    local i = 1
    while true do
        if TableUtils.IsContainKey(parsedData, "debuff_stat_" .. i) then
            assert(parsedData["debuff_stat_" .. i] ~= nil)
            assert(parsedData["debuff_amount_" .. i] ~= nil)

            i = i + 1
        else
            assert(i >= 1)
            break
        end
    end
end

--- @return void
--- @param parsedData table
function Summoner2_Skill2_2_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.targetClass = tonumber(parsedData.target_class)

    local i = 1
    while true do
        local keyStat = "debuff_stat_" .. i
        if TableUtils.IsContainKey(parsedData, keyStat) then
            local debuffBonus = StatBonus(StatChangerCalculationType.PERCENT_ADD)

            local tag = "debuff_stat_" .. i
            debuffBonus.statType = tonumber(parsedData[tag])

            tag = "debuff_amount_" .. i
            debuffBonus.amount = tonumber(parsedData[tag])

            self.debuffBonuses:Add(debuffBonus)
        else
            break
        end
        i = i + 1
    end
end

return Summoner2_Skill2_2_Data