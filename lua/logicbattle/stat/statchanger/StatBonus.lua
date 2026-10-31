--- @class StatBonus
StatBonus = Class(StatBonus)

--- @return void
--- @param calculationType StatChangerCalculationType
function StatBonus:Ctor(calculationType)
    --- @type StatType
    self.statType = nil

    --- @type number
    self.amount = nil

    --- @type StatChangerCalculationType
    self.calculationType = calculationType

    --- @type HeroFactionType
    self.affectedFaction = nil
end

--- @return void
--- @param data string
--- @param index number
function StatBonus:ParseCsv(data, index)
    local tag = EffectConstants.STAT_TYPE_TAG .. index
    self.statType = tonumber(data[tag])

    tag = EffectConstants.STAT_BONUS_TAG .. index
    self.amount = tonumber(data[tag])

    tag = EffectConstants.STAT_CALCULATION_TYPE_TAG .. index
    if TableUtils.IsContainKey(data, tag) then
        local type = tonumber(data[tag])
        if type ~= nil then
            self.calculationType = type
        end
    end

    self:ValidateAfterParseCsv()
end

--- @return void
--- @param data string
--- @param index number
function StatBonus:ParseLinkingCsv(data, index)
    self:ParseCsv(data, index)

    local tag = EffectConstants.STAT_AFFECTED_FACTION_TAG .. index
    if TableUtils.IsContainKey(data, tag) then
        self.affectedFaction = tonumber(data[tag])
    end

    self:ValidateAfterParseCsv()
end

--- @return void
function StatBonus:ValidateAfterParseCsv()
    assert(MathUtils.IsInteger(self.statType))
    assert(MathUtils.IsNumber(self.amount))
    assert(MathUtils.IsInteger(self.calculationType))

    assert(self.amount > 0)

    if self.calculationType == StatChangerCalculationType.PERCENT_ADD or
            self.calculationType == StatChangerCalculationType.PERCENT_MULTIPLY then
        assert(self.amount <= 2)
    end
end