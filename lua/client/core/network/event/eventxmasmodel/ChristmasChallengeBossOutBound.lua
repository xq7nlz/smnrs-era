--- @class ChristmasChallengeBossOutBound : OutBound
ChristmasChallengeBossOutBound = Class(ChristmasChallengeBossOutBound, OutBound)

--- @return void
function ChristmasChallengeBossOutBound:Ctor(team, number)
    ---@type BattleFormationOutBound
    self.team = team
    ---@type number
    self.number = number
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ChristmasChallengeBossOutBound:Serialize(buffer)
    self.team:Serialize(buffer)
    buffer:PutByte(self.number)
end