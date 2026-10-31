--- @class TransformResult : BaseActionResult
TransformResult = Class(TransformResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TransformResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.TRANSFORM)
end