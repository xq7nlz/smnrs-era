--- @class ReviveActionResult : BaseActionResult
ReviveActionResult = Class(ReviveActionResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ReviveActionResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.REVIVE)
end

--- @return string
function ReviveActionResult:ToString()
    return BaseActionResult.GetPrefix(self, "REVIVE")
end