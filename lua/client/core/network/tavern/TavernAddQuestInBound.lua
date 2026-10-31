require "lua.client.core.network.playerData.tavern.TavernQuestInBound"

--- @class TavernAddQuestInBound
TavernAddQuestInBound = Class(TavernAddQuestInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TavernAddQuestInBound:Ctor(buffer)
    ---@type number
    self.scrollQuestType = buffer:GetByte()
    ---@type List  --<TavernQuestInBound>
    self.listTavernQuest = NetworkUtils.GetListDataInBound(buffer, TavernQuestInBound)
end

--- @return void
function TavernAddQuestInBound:ToString()
    return LogUtils.ToDetail(self)
end