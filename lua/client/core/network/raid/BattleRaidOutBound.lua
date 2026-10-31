
--- @class BattleRaidOutBound : BattleFormationOutBound
BattleRaidOutBound = Class(BattleRaidOutBound, BattleFormationOutBound)

--- @return void
--- @param raidType RaidModeType
--- @param stage number
--- @param uiFormationTeamData UIFormationTeamData
function BattleRaidOutBound:Ctor(raidType, stage, uiFormationTeamData, isSweep)
    self.raidType = raidType
    self.stage = stage
    self.uiFormationTeamData = uiFormationTeamData
    self.isSweep = isSweep
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BattleRaidOutBound:Serialize(buffer)
    buffer:PutBool(self.isSweep)
    buffer:PutByte(self.raidType)
    buffer:PutShort(self.stage)
    BattleFormationOutBound.Serialize(self, buffer)
end