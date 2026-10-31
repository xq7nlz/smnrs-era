require("lua.logicBattle.stat.statChanger.StatBonus")

--- @class BonusLinkingTierConfig
BonusLinkingTierConfig = Class(BonusLinkingTierConfig)

function BonusLinkingTierConfig:Ctor()
    ---@type number
    self.star = nil
    ---@type number
    self.level = nil
    ---@type List
    self.listBonus = List()
end

function BonusLinkingTierConfig:ParsedData(parsedData)
    self.star = tonumber(parsedData.star)
    self.level = tonumber(parsedData.level)
    self.listBonus = List()
    local j = 1
    while true do
        local keyStat = EffectConstants.STAT_TYPE_TAG .. j
        if TableUtils.IsContainKey(parsedData, keyStat) then
            local statBonus = StatBonus(StatChangerCalculationType.PERCENT_ADD)
            statBonus:ParseCsv(parsedData, j)
            self.listBonus:Add(statBonus)
        else
            break
        end
        j = j + 1
    end
end