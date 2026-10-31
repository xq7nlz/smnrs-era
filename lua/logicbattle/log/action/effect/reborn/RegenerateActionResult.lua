--- @class RegenerateActionResult : BaseActionResult
RegenerateActionResult = Class(RegenerateActionResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
function RegenerateActionResult:Ctor(initiator)
    BaseActionResult.Ctor(self, initiator, initiator, ActionResultType.REGENERATE)
end

--- @return string
function RegenerateActionResult:ToString()
    assert(false, "this method should be overridden by child class")
end

