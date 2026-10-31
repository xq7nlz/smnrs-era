--- @class EventMidAutumnBetArenaScoreInBound
EventMidAutumnBetArenaScoreInBound = Class(EventMidAutumnBetArenaScoreInBound)

function EventMidAutumnBetArenaScoreInBound:Ctor()
    --- @type number
    self.eventDay = nil
    --- @type number
    self.teamOne = nil
    --- @type number
    self.teamTwo = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventMidAutumnBetArenaScoreInBound:ReadBuffer(buffer)
    self.eventDay = buffer:GetByte()
    self.teamOne = buffer:GetInt()
    self.teamTwo = buffer:GetInt()
end