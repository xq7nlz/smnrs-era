--- @class EventThankGivingDiceGameData : QuestUnitInBound
EventThankGivingDiceGameData = Class(EventThankGivingDiceGameData)

function EventThankGivingDiceGameData:Ctor(buffer)
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventThankGivingDiceGameData:ReadBuffer(buffer)
    self.position = buffer:GetByte()
    self.rollNumber = buffer:GetInt()
    self.lapCompleted = buffer:GetInt()

    self.historyPositionList = List()
    local sizePos = buffer:GetByte()
    for i = 1, sizePos do
        local pos = buffer:GetByte()
        self.historyPositionList:Add(pos)
    end
end

function EventThankGivingDiceGameData:AddPositionResult(pos)
    if self.historyPositionList:IsContainValue(pos) == false then
        self.historyPositionList:Add(pos)
    end
    self.position = pos
end

function EventThankGivingDiceGameData:ResetLap()
    self.position = 0
    self.historyPositionList = List()
    self.lapCompleted = self.lapCompleted + 1
end