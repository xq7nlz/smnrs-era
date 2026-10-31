require "lua.client.core.network.battleRecord.BattleRecordShortBase"
require "lua.client.core.network.battleRecord.TeamRecordShort"

--- @class BattleRecordShort : BattleRecordShortBase
BattleRecordShort = Class(BattleRecordShort, BattleRecordShortBase)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BattleRecordShort:Ctor(buffer)
    ---@type number
    self.recordId = buffer:GetString()
    ---@type boolean
    self.time = buffer:GetLong()
    ---@type TeamRecordShort
    self.teamRecordAttack = TeamRecordShort(buffer)
    ---@type TeamRecordShort
    self.teamRecordDefend = TeamRecordShort(buffer)
    ---@type boolean
    self.isAttackWin = buffer:GetBool()
    --- @type string
    self.battleLog = nil
    --- @type string
    self.getStringBattle = buffer:GetString(false)
    if self.getStringBattle ~= "" then
        --- @type string
        self.battleLog = self.getStringBattle
    end
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
function BattleRecordShort:IsAttacker()
    return self.teamRecordAttack.playerId == PlayerSettingData.playerId
end

---@return boolean
function BattleRecordShort:IsRevenge()
    return self.isRevenge
end

---@return boolean
function BattleRecordShort:IsBot()
    return false
end

---@return boolean
function BattleRecordShort:RequestGetBattleData(callbackSuccess, callbackFail)
    ---@type BattleRecord
    local battleRecord
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            battleRecord = BattleRecord(buffer)
        end
        local onSuccess = function()
            if callbackSuccess ~= nil then
                local attackerData, defenderData
                local playerData = self:PlayerData()
                ---@type TeamRecordShort
                local teamOpponent = self:GetTeamRecordShortOpponent()
                local enemyData = {
                    ["avatar"] = teamOpponent.playerAvatar,
                    ["level"] = teamOpponent.playerLevel,
                    ["name"] = teamOpponent.playerName,
                }

                if self.teamRecordAttack.playerId == PlayerSettingData.playerId then
                    attackerData = playerData
                    defenderData = enemyData
                else
                    attackerData = enemyData
                    defenderData = playerData
                end
                callbackSuccess(attackerData, defenderData,
                        battleRecord.teamRecordAttack:CreateBattleTeamInfo(self.teamRecordAttack.playerLevel, BattleConstants.ATTACKER_TEAM_ID),
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
    NetworkUtils.Request(OpCode.RECORD_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Byte, GameMode.ARENA,
            PutMethod.String, self.recordId, PutMethod.Long, PlayerSettingData.playerId), onReceived)
end

---@return boolean
function BattleRecordShort:RequestBattleArenaTeam()
    local canClackBattle = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.ARENA_TEAM_TICKET, 1))
    if canClackBattle then
        ArenaRequest.RequestBattleArenaTeamById(self.teamRecordAttack.playerId, self.teamRecordAttack.playerAvatar,
                self.teamRecordAttack.playerLevel, self.teamRecordAttack.playerName,
                function ()
                    ArenaRequest.RequestRevenge(GameMode.ARENA_TEAM, self.recordId)
                    self.isRevenge = true
                end)
    end
end

---@return TeamRecordShort
function BattleRecordShort:GetTeamRecordShortOpponent()
    if self:IsAttacker() then
        return self.teamRecordDefend
    else
        return self.teamRecordAttack
    end
end

---@return boolean
function BattleRecordShort:GetName()
    return self:GetTeamRecordShortOpponent().playerName
end