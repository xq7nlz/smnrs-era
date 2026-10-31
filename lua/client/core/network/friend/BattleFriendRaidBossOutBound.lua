require "lua.client.core.network.battleFormation.BattleFormationOutBound"
--- @class BattleFriendRaidBossOutBound : OutBound
BattleFriendRaidBossOutBound = Class(BattleFriendRaidBossOutBound, OutBound)

--- @return void
--- @param friendId number
--- @param bossCreateTime number
--- @param numberRaid number
--- @param uiFormationTeamData UIFormationTeamData
function BattleFriendRaidBossOutBound:Ctor(friendId, bossCreateTime, numberRaid, uiFormationTeamData)
    ---@type BattleFormationOutBound
    self.battleFormationOutBound = BattleFormationOutBound(uiFormationTeamData)
    ---@type number
    self.bossCreateTime = bossCreateTime
    ---@type number
    self.friendId = friendId
    ---@type number
    self.numberRaid = numberRaid
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BattleFriendRaidBossOutBound:Serialize(buffer)
    self.battleFormationOutBound:Serialize(buffer)
    buffer:PutLong(self.bossCreateTime)
    buffer:PutLong(self.friendId)
    buffer:PutByte(self.numberRaid)
end