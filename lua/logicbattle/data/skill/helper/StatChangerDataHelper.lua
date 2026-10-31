--- @class StatChangerDataHelper
StatChangerDataHelper = Class(StatChangerDataHelper)

--- @return void
--- @param skillData BaseSkillData
function StatChangerDataHelper:Ctor(skillData)
    --- @type BaseSkillData
    self.skillData = skillData

    --- @type StatChangerCalculationType
    self.defaultCalculationType = StatChangerCalculationType.PERCENT_ADD
end

--- @return void
--- @param parsedData table
function StatChangerDataHelper:ValidateBeforeParseCsv(parsedData)
    local i = 1
    while true do
        if TableUtils.IsContainKey(parsedData, EffectConstants.STAT_TYPE_TAG .. i) then
            assert(parsedData[EffectConstants.STAT_TYPE_TAG .. i] ~= nil)
            assert(parsedData[EffectConstants.STAT_BONUS_TAG .. i] ~= nil)

            i = i + 1
        else
            assert(i >= 1)
            break
        end
    end
end

--- @return void
--- @param parsedData table
function StatChangerDataHelper:ParseCsv(parsedData)
    local bonuses = List()

    local i = 1
    while true do
        local keyStat = EffectConstants.STAT_TYPE_TAG .. i
        if TableUtils.IsContainKey(parsedData, keyStat) then
            local statBonus = StatBonus(self.defaultCalculationType)
            statBonus:ParseCsv(parsedData, i)

            bonuses:Add(statBonus)
        else
            break
        end
        i = i + 1
    end

    self.skillData.bonuses = bonuses
end
