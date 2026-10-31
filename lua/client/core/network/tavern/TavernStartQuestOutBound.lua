--- @class TavernStartQuestOutBound : OutBound
TavernStartQuestOutBound = Class(TavernStartQuestOutBound, OutBound)

--- @return void
function TavernStartQuestOutBound:Ctor(questId, listHeroInventoryId)
    --- @type number
    self.questId = questId
    --- @type List
    self.listQuestParticipant = listHeroInventoryId
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TavernStartQuestOutBound:Serialize(buffer)
    buffer:PutLong(self.questId)
    buffer:PutByte(self.listQuestParticipant:Count())
    ---@param v TavernQuestParticipantInBound
    for _, v in pairs(self.listQuestParticipant:GetItems()) do
        buffer:PutLong(v.inventoryId)
    end
end