--- @class TalentInstantKillResult : BaseActionResult
TalentInstantKillResult = Class(TalentInstantKillResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentInstantKillResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.TALENT_INSTANT_KILL)
end

--- @return string
function TalentInstantKillResult:ToString()
    return BaseActionResult.GetPrefix(self, "TALENT_INSTANT_KILL")
end