--- @class SkillMasteryConfig
SkillMasteryConfig = Class(SkillMasteryConfig)

--- @return void
function SkillMasteryConfig:Ctor()
    ---@type Dictionary --<lv, List<StatBonus>>
    self.dicLevelStat = Dictionary()
end

--- @return void
--- @param parsedData string[]
function SkillMasteryConfig:ParseCsv(parsedData)
    for i = 1, #parsedData do
        local data = parsedData[i]
        ---@type List --<StatBonus>
        local listStat = List()
        local j = 1
        while true do
            local keyStat = EffectConstants.STAT_TYPE_TAG .. j
            if TableUtils.IsContainKey(data, keyStat) then
                local statBonus = StatBonus(StatChangerCalculationType.PERCENT_ADD)
                statBonus:ParseCsv(data, j)
                listStat:Add(statBonus)
            else
                break
            end
            j = j + 1
        end
        self.dicLevelStat:Add(i, listStat)
    end
end