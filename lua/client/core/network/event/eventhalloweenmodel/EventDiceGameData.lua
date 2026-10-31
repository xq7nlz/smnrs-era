--- @class EventDiceGameData : QuestUnitInBound
EventDiceGameData = Class(EventDiceGameData)

function EventDiceGameData:Ctor(buffer)
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventDiceGameData:ReadBuffer(buffer)
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

function EventDiceGameData:AddPositionResult(pos)
    if self.historyPositionList:IsContainValue(pos) == false then
        self.historyPositionList:Add(pos)
    end
    self.position = pos
end

function EventDiceGameData:ResetLap()
    self.position = 0
    self.historyPositionList = List()
    self.lapCompleted = self.lapCompleted + 1
end