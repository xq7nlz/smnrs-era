--- @class StatDebuff
StatDebuff = Class(StatDebuff)

--- @return void
--- @param calculationType StatChangerCalculationType
function StatDebuff:Ctor(calculationType)
    --- @type StatType
    self.statType = nil

    --- @type number
    self.amount = nil

    --- @type StatChangerCalculationType
    self.calculationType = calculationType
end

--- @return void
--- @param data string
--- @param index number
function StatDebuff:ParseCsv(data, index)
    local tag = EffectConstants.STAT_DEBUFF_TYPE_TAG .. index
    self.statType = tonumber(data[tag])

    tag = EffectConstants.STAT_DEBUFF_AMOUNT_TAG .. index
    self.amount = tonumber(data[tag])

    tag = EffectConstants.STAT_DEBUFF_CALCULATION_TYPE_TAG .. index
    if TableUtils.IsContainKey(data, tag) then
        local type = tonumber(data[tag])
        if type ~= nil then
            self.calculationType = type
        end
    end

    self:ValidateAfterParseCsv()
end

--- @return void
function StatDebuff:ValidateAfterParseCsv()
    assert(MathUtils.IsInteger(self.statType))
    assert(MathUtils.IsNumber(self.amount))
    assert(MathUtils.IsInteger(self.calculationType))

    assert(self.amount > 0)

    if self.calculationType == StatChangerCalculationType.PERCENT_ADD or
            self.calculationType == StatChangerCalculationType.PERCENT_MULTIPLY then
        assert(self.amount <= 2)
    end
end