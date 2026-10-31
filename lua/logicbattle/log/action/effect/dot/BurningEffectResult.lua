--- @class BurningEffectResult : DotEffectResult
BurningEffectResult = Class(BurningEffectResult, DotEffectResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param remainingRound number
function BurningEffectResult:Ctor(initiator, target, remainingRound)
    DotEffectResult.Ctor(self, initiator, target, ActionResultType.BURNING_EFFECT, remainingRound)
end

--- @return string
function BurningEffectResult:ToString()
    return DotEffectResult.ToString(self, "BURN_EFFECT")
end