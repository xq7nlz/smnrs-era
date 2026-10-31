--- @class FormationBuffData
FormationBuffData = Class(FormationBuffData)

--- @return void
function FormationBuffData:Ctor()
    --- @type number
    self.id = nil

    --- @type boolean
    self.isFront = nil

    --- @type List<StatBonus>
    self.bonuses = List()
end

--- @return void
--- @param parsedData table
function FormationBuffData:ParseCsv(parsedData)
    self:ValidateBeforeParseCsv(parsedData)

    self.id = tonumber(parsedData.id)
    self.isFront = MathUtils.ToBoolean(parsedData.is_front)

    local i = 1
    while true do
        local keyStat = EffectConstants.STAT_TYPE_TAG .. i
        if TableUtils.IsContainKey(parsedData, keyStat) then
            local statBonus = StatBonus(self.defaultCalculationType)
            statBonus:ParseCsv(parsedData, i)

            self.bonuses:Add(statBonus)
        else
            break
        end
        i = i + 1
    end
end

--- @return void
--- @param parsedData table
function FormationBuffData:ValidateBeforeParseCsv(parsedData)
    if parsedData.id == nil then
        assert(false)
    end

    if parsedData.is_front == nil then
        assert(false)
    end

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