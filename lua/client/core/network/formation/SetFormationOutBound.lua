require("lua.client.core.network.battleFormation.BattleFormationOutBound")

--- @class SetFormationOutBound : OutBound
SetFormationOutBound = Class(SetFormationOutBound, OutBound)

--- @return void
--- @param battleFormationOutBound BattleFormationOutBound
--- @param gameMode GameMode
function SetFormationOutBound:Ctor(battleFormationOutBound, gameMode)
    ---@type BattleFormationOutBound
    self.battleFormationOutBound = battleFormationOutBound
    ---@type GameMode
    self.gameMode = gameMode
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SetFormationOutBound:Serialize(buffer)
    self.battleFormationOutBound:Serialize(buffer)
    buffer:PutByte(self.gameMode)
end 