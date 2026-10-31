require "lua.client.core.network.battleRecord.BattleRecordShort"
require "lua.client.core.network.battleRecord.BattleBotRecord"

--- @class BattleRecordDataInBound
BattleRecordDataInBound = Class(BattleRecordDataInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BattleRecordDataInBound:Ctor(buffer)
    ---@type List
    self.listRecord = NetworkUtils.GetListDataInBound(buffer, BattleRecordShort)
    ---@type List
    self.listRecordBot = NetworkUtils.GetListDataInBound(buffer, BattleBotRecord)
    ---@type boolean
    self.needRequest = false
    ---@type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function BattleRecordDataInBound:IsAvailableToRequest()
    return self.needRequest --or self.lastTimeRequest - zg.timeMgr:GetServerTime() > 30
end