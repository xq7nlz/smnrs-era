--- @class RebornActionResult : BaseActionResult
RebornActionResult = Class(RebornActionResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
function RebornActionResult:Ctor(initiator)
    BaseActionResult.Ctor(self, initiator, initiator, ActionResultType.REBORN)
end

--- @return string
function RebornActionResult:ToString()
    return BaseActionResult.GetPrefix(self, "REBORN")
end

