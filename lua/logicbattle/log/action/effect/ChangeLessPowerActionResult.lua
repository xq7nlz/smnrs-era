--- @class ChangeLessPowerActionResult : BaseActionResult
ChangeLessPowerActionResult = Class(ChangePowerActionResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ChangeLessPowerActionResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.CHANGE_LESS_POWER)
end

--- @return string
function ChangeLessPowerActionResult:ToString()
    return string.format("%s", BaseActionResult.GetPrefix(self, "CHANGE_LESS_POWER"))
end