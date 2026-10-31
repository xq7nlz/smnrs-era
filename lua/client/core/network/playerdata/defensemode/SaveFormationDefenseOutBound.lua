
--- @class SaveFormationDefenseOutBound : OutBound
SaveFormationDefenseOutBound = Class(SaveFormationDefenseOutBound, OutBound)

--- @return void
--- @param battleFormationOutBound BattleFormationOutBound
--- @param land number
--- @param tower number
function SaveFormationDefenseOutBound:Ctor(battleFormationOutBound, land)
    ---@type BattleFormationOutBound
    self.battleFormationOutBound = battleFormationOutBound
    ---@type number
    self.land = land
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SaveFormationDefenseOutBound:Serialize(buffer)
    self.battleFormationOutBound:Serialize(buffer)
    buffer:PutShort(self.land)
end