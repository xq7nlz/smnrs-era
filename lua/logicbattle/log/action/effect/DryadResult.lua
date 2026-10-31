--- @class DryadResult : BaseActionResult
DryadResult = Class(DryadResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param amount number
function DryadResult:Ctor(initiator, target, amount)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.DRYAD_EFFECT)

    --- @type number
    self.amount = amount
end

--- @return DryadResult
function DryadResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.amount = self.amount

    return data
end

--- @return string
function DryadResult:ToString()
    local result = string.format("%s, amount = %s\n",
            BaseActionResult.GetPrefix(self, "DRYAD_EFFECT"), self.amount)
    return result
end