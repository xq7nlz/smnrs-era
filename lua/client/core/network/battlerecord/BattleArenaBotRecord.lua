require "lua.client.core.network.battleRecord.BattleRecordShortBase"
require "lua.client.core.network.otherPlayer.OtherPlayerInfoInBound"
require "lua.client.core.network.battleRecord.TeamRecordShort"

--- @class BattleArenaBotRecord : BattleRecordShortBase
BattleArenaBotRecord = Class(BattleArenaBotRecord, BattleRecordShortBase)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BattleArenaBotRecord:Ctor(buffer)
    ---@type number
    self.recordId = buffer:GetString()
    ---@type boolean
    self.time = buffer:GetLong()
    ---@type number
    self.eloChange = buffer:GetShort()
    ---@type number
    self.attackerElo = buffer:GetShort()
    ---@type number
    self.defenderElo = buffer:GetShort()
    ---@type boolean
    self.isAttackWin = buffer:GetBool()
    ---@type number
    self.defenderName = buffer:GetString()
    ---@type number
    self.defenderAvatar = buffer:GetInt()
end

---@return boolean
function BattleArenaBotRecord:GetName()
    return self.defenderName
end

---@return boolean
function BattleArenaBotRecord:IsAttacker()
    return true
end

---@return boolean
function BattleArenaBotRecord:IsRevenge()
    return false
end

---@return boolean
function BattleArenaBotRecord:IsBot()
    return true
end

---@return boolean
function BattleArenaBotRecord:GetTeamRecordShortOpponent()
    ---@type TeamRecordShort
    local teamRecordShort = TeamRecordShort()
    if self.predefineDefenderTeam ~= nil then
        local battleTeamInfo = DefenderTeamData.GetBattleTeamInfoByPredefineTeam(self.predefineDefenderTeam)
        teamRecordShort.playerLevel = battleTeamInfo.summonerBattleInfo.level
    end
    teamRecordShort.playerAvatar = self.defenderAvatar
    teamRecordShort.playerName = self.defenderName
    return teamRecordShort
end

---@return boolean
function BattleArenaBotRecord:RequestGetBattleData(callbackSuccess, callbackFail)
    ---@type ArenaTeamBattleBotRecordInBound
    local battleRecord
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            require("lua.client.core.network.battleRecord.ArenaTeamBattleBotRecordInBound")
            battleRecord = ArenaTeamBattleBotRecordInBound(buffer)
        end
        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess(battleRecord)
            end
        end
        local onFailed = function(logicCode)
            if callbackFail ~= nil then
                callbackFail(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.RECORD_ARENA_TEAM_BOT_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.String, self.recordId), onReceived)
end