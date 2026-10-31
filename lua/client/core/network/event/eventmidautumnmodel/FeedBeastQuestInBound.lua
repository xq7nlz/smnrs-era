--- @class FeedBeastQuestInBound : QuestUnitInBound
FeedBeastQuestInBound = Class(FeedBeastQuestInBound, QuestUnitInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function FeedBeastQuestInBound:ReadBuffer(buffer)
    QuestUnitInBound.ReadBuffer(self, buffer)
    self.feedNumber = buffer:GetInt()
end
