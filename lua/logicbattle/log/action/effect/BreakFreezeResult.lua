--- @class BreakFreezeResult : BaseActionResult
BreakFreezeResult = Class(BreakFreezeResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function BreakFreezeResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.FREEZE_BREAK)

    --- @type number
    self.damage = nil
end

--- @return void
--- @param damage number
function BreakFreezeResult:SetDamage(damage)
    self.damage = damage
end

--- @return BreakFreezeResult
function BreakFreezeResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.damage = self.damage

    return data
end

--- @return string
function BreakFreezeResult:ToString()
    local result = string.format("%s, TAKE %s damage\n",
            BaseActionResult.GetPrefix(self, "BREAK_FREEZE"), self.damage)
    return result
end