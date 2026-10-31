require "lua.client.core.network.battleRecord.BattleRecordShortBase"
require "lua.client.core.network.otherPlayer.OtherPlayerInfoInBound"
require "lua.client.core.network.battleRecord.TeamRecordShort"

--- @class BattleBotRecord : BattleRecordShortBase
BattleBotRecord = Class(BattleBotRecord, BattleRecordShortBase)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BattleBotRecord:Ctor(buffer)
    ---@type number
    self.recordId = buffer:GetString()
    ---@type boolean
    self.time = buffer:GetLong()
    ---@type OtherPlayerInfoInBound
    self.compactPlayer = OtherPlayerInfoInBound()
    self.compactPlayer:Deserialize(buffer)
    ---@type PredefineTeamData
    self.predefineDefenderTeam = PredefineTeamData.CreateByBuffer(buffer)
    ---@type boolean
    self.isAttackWin = buffer:GetBool()
    ---@type SeedInBound
    self.seedInBound = SeedInBound.CreateByBuffer(buffer)
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
    ---@type number
    self.defenderName = buffer:GetString()
    ---@type number
    self.defenderAvatar = buffer:GetInt()
end

---@return boolean
function BattleBotRecord:GetName()
    return self.defenderName
end

---@return boolean
function BattleBotRecord:IsAttacker()
    return true
end

---@return boolean
function BattleBotRecord:IsRevenge()
    return false
end

---@return boolean
function BattleBotRecord:IsBot()
    return true
end

---@return boolean
function BattleBotRecord:GetTeamRecordShortOpponent()
    ---@type TeamRecordShort
    local teamRecordShort = TeamRecordShort()
    local battleTeamInfo = DefenderTeamData.GetBattleTeamInfoByPredefineTeam(self.predefineDefenderTeam)
    teamRecordShort.playerLevel = battleTeamInfo.summonerBattleInfo.level
    teamRecordShort.playerAvatar = self.defenderAvatar
    teamRecordShort.playerName = self.defenderName
    return teamRecordShort
end

---@return boolean
function BattleBotRecord:RequestGetBattleData(callbackSuccess, callbackFail)
    local attackerData = self:PlayerData()
    ---@type TeamRecordShort
    local teamOpponent = self:GetTeamRecordShortOpponent()
    local defenderData = {
        ["avatar"] = teamOpponent.playerAvatar,
        ["level"] = teamOpponent.playerLevel,
        ["name"] = teamOpponent.playerName,
    }

    local battleTeamInfo = DefenderTeamData.GetBattleTeamInfoByPredefineTeam(self.predefineDefenderTeam)
    callbackSuccess(attackerData, defenderData,
            self.compactPlayer:CreateBattleTeamInfo(self.compactPlayer.playerLevel, BattleConstants.ATTACKER_TEAM_ID),
            battleTeamInfo,
            self.seedInBound)
end