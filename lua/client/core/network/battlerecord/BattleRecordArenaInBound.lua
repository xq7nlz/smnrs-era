require "lua.client.core.network.battleRecord.BattleRecordShortArenaTeam"
require "lua.client.core.network.battleRecord.BattleArenaBotRecord"

--- @class BattleRecordArenaInBound
BattleRecordArenaInBound = Class(BattleRecordArenaInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BattleRecordArenaInBound:Ctor(buffer)
    ---@type List
    self.listRecord = NetworkUtils.GetListDataInBound(buffer, BattleRecordShortArenaTeam)
    ---@type List
    self.listRecordBot = NetworkUtils.GetListDataInBound(buffer, BattleArenaBotRecord)
    ---@type boolean
    self.needRequest = false
    ---@type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function BattleRecordArenaInBound:IsAvailableToRequest()
    return self.needRequest --or self.lastTimeRequest - zg.timeMgr:GetServerTime() > 30
end