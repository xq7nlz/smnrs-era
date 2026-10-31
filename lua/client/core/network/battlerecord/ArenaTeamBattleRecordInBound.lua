require "lua.client.core.network.battleRecord.ArenaTeamBattleRecord"

--- @class ArenaTeamBattleRecordInBound
ArenaTeamBattleRecordInBound = Class(ArenaTeamBattleRecordInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamBattleRecordInBound:Ctor(buffer)
    local size = buffer:GetByte()
    ---@type Dictionary
    self.dictBattleRecord = Dictionary()
    for i = 1, size do
        self.dictBattleRecord:Add(buffer:GetByte(), ArenaTeamBattleRecord(buffer))
    end
end

--- @return void
function ArenaTeamBattleRecordInBound:GetAttackerData()
    ---@type ArenaTeamBattleRecord
    local arenaTeamBattleRecord = self.dictBattleRecord:Get(1)
    return arenaTeamBattleRecord.teamRecordAttack:GetDataAvatar()
end

--- @return void
function ArenaTeamBattleRecordInBound:GetDefenderData()
    ---@type ArenaTeamBattleRecord
    local arenaTeamBattleRecord = self.dictBattleRecord:Get(1)
    return arenaTeamBattleRecord.teamRecordDefend:GetDataAvatar()
end