--- @class AddStolenStatResult : BaseActionResult
AddStolenStatResult = Class(AddStolenStatResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param statType StatType
--- @param amount number
function AddStolenStatResult:Ctor(initiator, target, statType, amount)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.ADD_STOLEN_STAT)

    --- @type StatType
    self.statType = statType

    --- @type number
    self.amount = amount
end

--- @return AddStolenStatResult
function AddStolenStatResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.statType = self.statType

    data.amount = self.amount

    return data
end

--- @return string
function AddStolenStatResult:ToString()
    local result = string.format("%s, ADD %s of stat %s\n",
            BaseActionResult.GetPrefix(self, "ADD_STOLEN_STAT"), self.amount, self.statType)
    return result
end