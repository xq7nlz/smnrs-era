--- @class BonusTier
BonusTier = Class(BonusTier)

--- @return void
function BonusTier:Ctor()

    --- @type number
    self.level = nil

    --- @type List
    self.bonuses = List()

end

--- @return void
--- @param parsedData table
function BonusTier:ParseCsv(parsedData)

    self.level = tonumber(parsedData.level)

    local i = 1
    while true do
        local keyStat = EffectConstants.STAT_TYPE_TAG .. i
        if TableUtils.IsContainKey(parsedData, keyStat) and parsedData[keyStat] ~= "" then
            local statBonus = StatBonus(StatChangerCalculationType.PERCENT_ADD)
            statBonus:ParseLinkingCsv(parsedData, i)

            self.bonuses:Add(statBonus)
        else
            break
        end
        i = i + 1
    end

end

--- @return List<StatBonus>
function BonusTier:GetBonuses()
    return self.bonuses
end

