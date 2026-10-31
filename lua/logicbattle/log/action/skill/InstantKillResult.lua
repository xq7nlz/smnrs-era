--- @class InstantKillResult : BaseActionResult
InstantKillResult = Class(InstantKillResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function InstantKillResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.INSTANT_KILL)
end

--- @return string
function InstantKillResult:ToString()
    return BaseActionResult.GetPrefix(self, "INSTANT_KILL")
end