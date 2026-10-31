require "lua.client.core.network.battleRecord.BattleRecordShort"

--- @class BattleRecordShortArenaTeam : BattleRecordShort
BattleRecordShortArenaTeam = Class(BattleRecordShortArenaTeam, BattleRecordShort)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BattleRecordShortArenaTeam:Ctor(buffer)
    --BattleRecordShort.Ctor(self, buffer)
    ---@type number
    self.recordId = buffer:GetString()
    ---@type boolean
    self.time = buffer:GetLong()
    ---@type TeamRecordShort
    self.teamRecordAttack = TeamRecordShort(buffer)
    ---@type TeamRecordShort
    self.teamRecordDefend = TeamRecordShort(buffer)
    --- @type string
    self.battleLog = nil
    --- @type string
    self.getStringBattle = buffer:GetString(false)
    if self.getStringBattle ~= "" then
        --- @type string
        self.battleLog = self.getStringBattle
    end
    ---@type boolean
    self.isAttackWin = buffer:GetBool()

    ---@type number
    self.eloChange = buffer:GetShort()
    ---@type number
    self.attackerElo = buffer:GetShort()
    ---@type number
    self.defenderElo = buffer:GetShort()
    ---@type boolean
    self.isRevenge = buffer:GetBool()
end

---@return boolean
function BattleRecordShortArenaTeam:RequestGetBattleData(callbackSuccess, callbackFail)
    ---@type ArenaTeamBattleRecordInBound
    local battleRecord
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            require("lua.client.core.network.battleRecord.ArenaTeamBattleRecordInBound")
            battleRecord = ArenaTeamBattleRecordInBound(buffer)
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
    NetworkUtils.Request(OpCode.RECORD_ARENA_TEAM_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.String, self.recordId, PutMethod.Long, PlayerSettingData.playerId), onReceived)
end