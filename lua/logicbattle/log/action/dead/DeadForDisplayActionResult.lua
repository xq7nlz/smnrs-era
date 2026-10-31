--- @class DeadForDisplayActionResult : BaseActionResult
DeadForDisplayActionResult = Class(DeadForDisplayActionResult, BaseActionResult)

--- @return void
--- @param eventData table
function DeadForDisplayActionResult:Ctor(eventData)
    BaseActionResult.Ctor(self, eventData.initiator, eventData.target, ActionResultType.DEAD_FOR_DISPLAY)

    --- @type TakeDamageReason
    self.reason = eventData.reason

    --- @type boolean
    self.isReviveSoon = false
end

--- @return DeadForDisplayActionResult
function DeadForDisplayActionResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.reason = self.reason

    data.isReviveSoon = self.isReviveSoon

    return data
end

--- @return string
function DeadForDisplayActionResult:ToString()
    local result = string.format("%s, reason = %s\n",
            BaseActionResult.GetPrefix(self, "DEAD_FOR_DISPLAY"), self.reason)
    return result
end