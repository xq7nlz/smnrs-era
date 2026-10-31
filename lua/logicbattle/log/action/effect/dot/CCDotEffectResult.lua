--- @class CCDotEffectResult : DotEffectResult
CCDotEffectResult = Class(CCDotEffectResult, DotEffectResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param remainingRound number
function CCDotEffectResult:Ctor(initiator, target, remainingRound)
    DotEffectResult.Ctor(self, initiator, target, ActionResultType.CC_DOT_EFFECT, remainingRound)
end

--- @return string
function CCDotEffectResult:ToString()
    return DotEffectResult.ToString(self, "CC_DOT_EFFECT")
end