--- @class LunarChallengeBossOutBound : OutBound
LunarChallengeBossOutBound = Class(LunarChallengeBossOutBound, OutBound)

--- @return void
function LunarChallengeBossOutBound:Ctor(team, number, chapter, bossCreateTime)
    ---@type BattleFormationOutBound
    self.team = team
    ---@type number
    self.number = number
    ---@type number
    self.chapter = chapter
    ---@type number
    self.bossCreateTime = bossCreateTime
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function LunarChallengeBossOutBound:Serialize(buffer)
    self.team:Serialize(buffer)
    buffer:PutByte(self.number)
    buffer:PutInt(self.chapter)
    buffer:PutLong(self.bossCreateTime)
end