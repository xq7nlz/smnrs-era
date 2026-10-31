require "lua.client.core.network.battleFormation.BattleFormationOutBound"
--- @class DefenseChallengeOutBound : OutBound
DefenseChallengeOutBound = Class(DefenseChallengeOutBound, OutBound)

--- @return void
--- @param battleFormationOutBound BattleFormationOutBound
function DefenseChallengeOutBound:Ctor(battleFormationOutBound, land, stage)
    ---@type BattleFormationOutBound
    self.battleFormationOutBound = battleFormationOutBound
    self.land = land
    self.stage = stage
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function DefenseChallengeOutBound:Serialize(buffer)
    self.battleFormationOutBound:Serialize(buffer)
    buffer:PutShort(self.land)
    buffer:PutInt(self.stage)
end