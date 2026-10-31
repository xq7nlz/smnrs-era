require "lua.client.core.network.battleRecord.TeamRecordShort"
require "lua.client.core.network.battleRecord.BattleRecord"

--- @class GuildWarRecord
GuildWarRecord = Class(GuildWarRecord)

--- @return void
function GuildWarRecord:Ctor()
    ---@type number
    self.recordId = nil
    ---@type boolean
    self.time = nil
    ---@type TeamRecordShort
    self.teamRecordAttack = nil
    ---@type TeamRecordShort
    self.teamRecordDefend = nil
    ---@type boolean
    self.isAttackWin = nil
    ---@type number
    self.battleId = nil
    ---@type number
    self.medalChange = nil
    ---@type boolean
    self.defenderTeamPosition = nil
    ---@type number
    self.battleLog = nil
end

--- @return GuildWarRecord
--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarRecord.CreateByBuffer(buffer)
    local data = GuildWarRecord()
    data.recordId = buffer:GetString()
    data.time = buffer:GetLong()
    data.teamRecordAttack = TeamRecordShort(buffer)
    data.teamRecordDefend = TeamRecordShort(buffer)
    data.isAttackWin = buffer:GetBool()
    --- @type string
    local getStringBattle = buffer:GetString(false)
    if getStringBattle ~= "" then
        --- @type string
        data.battleLog = getStringBattle
    end
    data.battleId = buffer:GetLong()
    data.medalChange = buffer:GetShort()
    data.defenderTeamPosition = buffer:GetByte()
    return data
end

---@return boolean
function GuildWarRecord:RequestGetBattleData(callbackSuccess, callbackFail)
    ---@type BattleRecord
    local battleRecord
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            battleRecord = BattleRecord(buffer)
        end
        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess(battleRecord.teamRecordAttack:CreateBattleTeamInfo(self.teamRecordAttack.playerLevel, BattleConstants.ATTACKER_TEAM_ID),
                        battleRecord.teamRecordDefend:CreateBattleTeamInfo(self.teamRecordDefend.playerLevel, BattleConstants.DEFENDER_TEAM_ID),
                        battleRecord.seedInBound, battleRecord.battleLog)
            end
        end
        local onFailed = function(logicCode)
            if callbackFail ~= nil then
                callbackFail(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.RECORD_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Byte, GameMode.GUILD_WAR,
            PutMethod.String, self.recordId, PutMethod.Long, self.teamRecordDefend.playerId), onReceived)
end