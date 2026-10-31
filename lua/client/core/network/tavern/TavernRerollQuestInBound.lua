require "lua.client.core.network.playerData.tavern.TavernQuestInBound"

--- @class TavernRerollQuestInBound
TavernRerollQuestInBound = Class(TavernRerollQuestInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TavernRerollQuestInBound:Ctor(buffer)
    ---@type List  --<TavernQuestInBound>
    self.listTavernQuest = NetworkUtils.GetListDataInBound(buffer, TavernQuestInBound)
end

--- @return void
function TavernRerollQuestInBound:ToString()
    return LogUtils.ToDetail(self)
end