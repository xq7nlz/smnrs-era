require "lua.client.core.network.battleRecord.TeamRecordShort"

--- @class BattleRecordShortBase
BattleRecordShortBase = Class(BattleRecordShortBase)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BattleRecordShortBase:Ctor()
    ---@type number
    self.recordId = nil
    ---@type boolean
    self.time = nil
    ---@type boolean
    self.isAttackWin = nil
    ---@type number
    self.eloChange = nil
    ---@type number
    self.attackerElo = nil
    ---@type number
    self.defenderElo = nil
    --- @type string
    self.battleLog = nil
end

---@return boolean
function BattleRecordShortBase:IsAttacker()
    assert(false)
end

---@return boolean
function BattleRecordShortBase:IsRevenge()
    assert(false)
end

---@return boolean
function BattleRecordShortBase:GetTeamRecordShortOpponent()
    assert(false)
end

---@return boolean
function BattleRecordShortBase:IsBot()
    assert(false)
end

---@return boolean
function BattleRecordShortBase:IsDefenseFailed()
    return self.isAttackWin and not self:IsAttacker()
end

---@return boolean
function BattleRecordShortBase:RequestGetBattleData(callbackSuccess, callbackFail)
    assert(false)
end

function BattleRecordShortBase:RequestBattleArenaTeam()

end

---@return boolean
function BattleRecordShortBase:PlayerData()
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    return {
        ["avatar"] = basicInfoInBound.avatarData:GetMyPlayerAvatar(),
        ["level"] = basicInfoInBound.level,
        ["name"] = basicInfoInBound.name,
    }
end

---@return boolean
function BattleRecordShortBase:GetName()
    return ""
end

--- @return number
---@param x BattleRecordShortBase
---@param y BattleRecordShortBase
function BattleRecordShortBase.Sort(x, y)
    if y.time > x.time then
        return 1
    else
        return -1
    end
end