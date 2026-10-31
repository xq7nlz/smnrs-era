--- @class SummonerMastery
SummonerMastery = Class(SummonerMastery)

--- @return void
function SummonerMastery:Ctor()
    --- @type List<StatBonus>
    self.bonuses = List()

    --- @type StatChangerCalculationType
    self.defaultCalculationType = StatChangerCalculationType.PERCENT_ADD
end

--- @return void
--- @param data table
function SummonerMastery:ValidateBeforeParseCsv(data)
    local i = 1
    while true do
        if TableUtils.IsContainKey(data, EffectConstants.STAT_TYPE_TAG .. i) then
            if data[EffectConstants.STAT_TYPE_TAG .. i] == nil then
                assert(false)
            end

            if data[EffectConstants.STAT_BONUS_TAG .. i] == nil then
                assert(false)
            end

            i = i + 1
        else
            if i < 1 then
                assert(false)
            end
            break
        end
    end
end

--- @return void
--- @param csv string
function SummonerMastery:ParseCsv(csv)
    local parsedData = CsvReader.ReadContent(csv)
    for i = 1, #parsedData do
        local data = parsedData[i]

        self:ValidateBeforeParseCsv(data)
        local j = 1
        while true do
            local keyStat = EffectConstants.STAT_TYPE_TAG .. j
            if TableUtils.IsContainKey(data, keyStat) then
                local statBonus = StatBonus(self.defaultCalculationType)
                statBonus:ParseCsv(data, j)
                self.bonuses:Add(statBonus)
            else
                break
            end
            j = j + 1
        end
    end
end

--- @return StatBonus
--- @param masteryLevel number
function SummonerMastery:GetStatBonus(masteryLevel)
    return self.bonuses:Get(masteryLevel)
end