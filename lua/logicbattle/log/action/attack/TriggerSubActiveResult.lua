--- @class TriggerSubActiveResult : BaseActionResult
TriggerSubActiveResult = Class(TriggerSubActiveResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
function TriggerSubActiveResult:Ctor(initiator)
    BaseActionResult.Ctor(self, initiator, initiator, ActionResultType.TRIGGER_SUB_ACTIVE)
end

--- @return string
function TriggerSubActiveResult:ToString()
    return BaseActionResult.GetPrefix(self, ">>> TRIGGER_SUB_ACTIVE <<<")
end