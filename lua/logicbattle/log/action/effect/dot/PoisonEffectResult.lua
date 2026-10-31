--- @class PoisonEffectResult : DotEffectResult
PoisonEffectResult = Class(PoisonEffectResult, DotEffectResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param remainingRound number
function PoisonEffectResult:Ctor(initiator, target, remainingRound)
    DotEffectResult.Ctor(self, initiator, target, ActionResultType.POISON_EFFECT, remainingRound)
end

--- @return string
function PoisonEffectResult:ToString()
    return DotEffectResult.ToString(self, "POISON_EFFECT")
end