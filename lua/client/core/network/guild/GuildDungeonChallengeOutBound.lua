--- @class GuildDungeonChallengeOutBound : OutBound
GuildDungeonChallengeOutBound = Class(GuildDungeonChallengeOutBound, OutBound)

--- @param uiFormationTeamData UIFormationTeamData
--- @param bossCreateTime number
--- @param numberSmash number
function GuildDungeonChallengeOutBound:Ctor(uiFormationTeamData, bossCreateTime, numberSmash)
    ---@type BattleFormationOutBound
    self.battleFormationOutBound = BattleFormationOutBound(uiFormationTeamData)
    ---@type number
    self.bossCreateTime = bossCreateTime
    ---@type number
    self.numberSmash = numberSmash
end


--- @param buffer UnifiedNetwork_ByteBuf
function GuildDungeonChallengeOutBound:Serialize(buffer)
    self.battleFormationOutBound:Serialize(buffer)
    buffer:PutLong(self.bossCreateTime)
    buffer:PutByte(self.numberSmash)
end