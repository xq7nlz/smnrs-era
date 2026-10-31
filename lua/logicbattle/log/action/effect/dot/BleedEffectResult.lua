--- @class BleedEffectResult : DotEffectResult
BleedEffectResult = Class(BleedEffectResult, DotEffectResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param remainingRound number
function BleedEffectResult:Ctor(initiator, target, remainingRound)
    DotEffectResult.Ctor(self, initiator, target, ActionResultType.BLEED_EFFECT, remainingRound)
end

--- @return string
function BleedEffectResult:ToString()
    return DotEffectResult.ToString(self, "BLEED")
end