--- @class Summoner5_Skill3_2_Data Ranger
Summoner5_Skill3_2_Data = Class(Summoner5_Skill3_2_Data, BaseSkillData)

--- @return void
function Summoner5_Skill3_2_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @param List<number>
    self.roundTriggerList = List()

    --- @type List<StatBonus>
    self.debuffBonuses = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner5_Skill3_2_Data:CreateInstance()
    return Summoner5_Skill3_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner5_Skill3_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.debuff_duration ~= nil, "debuff_duration = nil")

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

    assert(parsedData.round_trigger_list ~= nil, "round_trigger_list = nil")
end

--- @return void
--- @param parsedData table
function Summoner5_Skill3_2_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.debuffDuration = tonumber(parsedData.debuff_duration)

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

    local content = StringUtils.Trim(parsedData.round_trigger_list)
    content = content:Split(';')

    for _, value in pairs(content) do
        self.roundTriggerList:Add(tonumber(value))
    end
end

return Summoner5_Skill3_2_Data