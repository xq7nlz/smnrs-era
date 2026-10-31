--- @class EventMidAutumnIsClaimBetRewardInBound
EventMidAutumnIsClaimBetRewardInBound = Class(EventMidAutumnIsClaimBetRewardInBound)

function EventMidAutumnIsClaimBetRewardInBound:Ctor()
    --- @type number
    self.eventDay = nil
    --- @type boolean
    self.isClaimed = false
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventMidAutumnIsClaimBetRewardInBound:ReadBuffer(buffer)
    self.eventDay = buffer:GetByte()
    self.isClaimed = buffer:GetBool()
end