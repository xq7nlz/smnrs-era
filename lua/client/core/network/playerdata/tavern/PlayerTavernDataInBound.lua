require "lua.client.core.network.playerData.tavern.TavernQuestInBound"

--- @class PlayerTavernDataInBound
PlayerTavernDataInBound = Class(PlayerTavernDataInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerTavernDataInBound:ReadBuffer(buffer)
    ---@type number
    local size = buffer:GetShort()
    ---@type List
    self.listTavernQuest = List()
    for _ = 1, size do
        self.listTavernQuest:Add(TavernQuestInBound(buffer))
    end
end

--- @return void
function PlayerTavernDataInBound:IsContainQuestWaiting()
    ---@param quest TavernQuestInBound
    for _, quest in pairs(self.listTavernQuest:GetItems()) do
        if quest.questState == TavernQuestState.WAITING then
            return true
        end
    end
    return false
end

--- @return void
function PlayerTavernDataInBound:ToString()
    return LogUtils.ToDetail(self)
end