--- @class BattleFriendRaidBossInBound
BattleFriendRaidBossInBound = Class(BattleFriendRaidBossInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function BattleFriendRaidBossInBound:Ctor(buffer)
    ---@type BattleResultInBound
    self.battleResult = BattleResultInBound.CreateByBuffer(buffer)
    ---@type number
    self.numberRaid = buffer:GetByte()
    ---@type List
    self.listReward = NetworkUtils.GetRewardInBoundList(buffer)
end