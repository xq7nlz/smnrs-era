require "lua.client.core.network.battleRecord.ArenaTeamBattleBotRecord"

--- @class ArenaTeamBattleBotRecordInBound
ArenaTeamBattleBotRecordInBound = Class(ArenaTeamBattleBotRecordInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamBattleBotRecordInBound:Ctor(buffer)
    self.playerName = buffer:GetString()
    self.playerAvatar = buffer:GetInt()
    local size = buffer:GetByte()
    ---@type Dictionary
    self.dictBattleRecord = Dictionary()
    for i = 1, size do
        self.dictBattleRecord:Add(buffer:GetByte(), ArenaTeamBattleBotRecord(buffer))
    end
end

--- @return void
function ArenaTeamBattleBotRecordInBound:GetAttackerData()
    ---@type ArenaTeamBattleBotRecord
    local arenaTeamBattleRecord = self.dictBattleRecord:Get(1)
    return arenaTeamBattleRecord.teamRecordAttack:GetDataAvatar()
end

--- @return void
function ArenaTeamBattleBotRecordInBound:GetDefenderData()
    ---@type ArenaTeamBattleBotRecord
    local arenaTeamBattleRecord = self.dictBattleRecord:Get(1)
    ---@type BattleTeamInfo
    local battleTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(arenaTeamBattleRecord.teamRecordDefend, BattleConstants.DEFENDER_TEAM_ID)
    return {
        ["avatar"] = self.playerAvatar,
        ["level"] = battleTeam.summonerBattleInfo.level,
        ["name"] = self.playerName,
    }
end