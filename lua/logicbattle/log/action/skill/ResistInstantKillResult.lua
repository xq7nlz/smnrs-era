--- @class ResistInstantKillResult
ResistInstantKillResult = Class(ResistInstantKillResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ResistInstantKillResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.RESIST_INSTANT_KILL)
end

--- @return string
function ResistInstantKillResult:ToString()
    return BaseActionResult.GetPrefix(self, "RESIST_INSTANT_KILL")
end